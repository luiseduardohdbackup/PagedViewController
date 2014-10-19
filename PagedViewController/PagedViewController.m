
/**
 @file
 Paged UIViewController container
 
 @author Ryan Powell
 @date 01-10-14
 @copyright Copyright (c) 2014  Ryan Powell 
 @licence https://raw.github.com/Ryandev/PagedViewController/master/LICENSE
 */


#import "PagedViewController.h"
#import "PagedViewController+Payload.m"
#import "PagedViewController+Action.h"
#import "PagedViewControllerCommon.h"
#import <QuartzCore/QuartzCore.h>


@interface PagedViewController () <UIScrollViewDelegate>
{
@private
    CGPoint _startPointGesture;
    CGPoint _startPointContentOffset;
}
@end


@implementation PagedViewController


@dynamic viewControllers;

-(void) setViewControllers:(NSMutableArray *)controllers
{
    for ( UIViewController *viewController in _viewControllers )
    {
        [viewController.view removeFromSuperview];
    }
    
    _viewControllers = nil;
    _viewControllers = controllers;
    
    for ( UIViewController *vc in _viewControllers )
    {
        [self addChildViewController:vc];
    }
    
    _selectedIndex = 0;
    
    if ( self.isViewLoaded )
    {
        [self loadSubviews];
    }
}

-(NSArray*) viewControllers
{
    return _viewControllers;
}

@dynamic selectedIndex;

-(void) setSelectedIndex:(NSUInteger)selectedIndex
{
    [self moveToIndex:selectedIndex];
}

-(NSUInteger) selectedIndex
{
    return _selectedIndex;
}

@synthesize swipeDirection = _swipeDirection;

@dynamic payload;

-(void) setPayload:(NSDictionary *)payload
{
    _payload = payload;
    
    [self loadPayloadStyling];
}

-(NSDictionary*) payload
{
    return _payload;
}

-(id) init
{
    if (( self = [super init] ))
    {
        _swipeDirection = PageSwipeDirection_UpDown;
    }
    
    return self;
}

-(id) initWithPayload:(NSDictionary *)dictionary
{
    if (( self = [super init] ))
    {
        _payload = dictionary;
        [self loadPayloadStyling];

        _selectedIndex = 0;        

        _navBarImage = [UIImage imageNamed:@"/TabBarIcons/grid.png"];
    }
    
    return self;
}

- (void)loadView
{
	[super loadView];
	
    _scrollView = [UIScrollView new];
    _scrollView.scrollEnabled = FALSE;
    _scrollView.backgroundColor = [UIColor blackColor];
    
    _scrollView.alwaysBounceHorizontal = FALSE;
    _scrollView.showsVerticalScrollIndicator = FALSE;
    _scrollView.showsHorizontalScrollIndicator = FALSE;
	_scrollView.delegate = self;
	_scrollView.pagingEnabled = TRUE;
    
	[self.view addSubview:_scrollView];
    
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0f
                                                             constant:0.0f]];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_didPan:)];
    [_scrollView addGestureRecognizer:pan];

    [self loadSubviews];
    
    [self moveToIndex:_selectedIndex overDuration:0.0f];

    _state = PageState_Fullscreen;
}

-(void) _didPan:(UIPanGestureRecognizer*)gesture
{
    CGPoint newPoint = [gesture locationInView:self.view];
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _startPointGesture = newPoint;
            _startPointContentOffset = _scrollView.contentOffset;
        }
        break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat deltaX = newPoint.x - _startPointGesture.x;
            CGFloat deltaY = newPoint.y - _startPointGesture.y;

            CGPoint newScrollDelta = CGPointZero;
            CGFloat percentageTravelled = 0.0f;
            
            switch (_swipeDirection)
            {
                case PageSwipeDirection_UpDown:
                {
                    CGFloat newDelta = powf((deltaY * 0.025f), 3);
                    
                    newDelta = MAX(MIN(newDelta, self.view.frame.size.height), -self.view.frame.size.height);
                    
                    newDelta = -newDelta;
                    
                    newScrollDelta.y = newDelta;
                    
                    percentageTravelled = fabsf(newDelta) / self.view.frame.size.height;
                }
                break;
                    
                case PageSwipeDirection_LeftRight:
                {
                    CGFloat newDelta = powf((deltaX * 0.025f), 3);
                    
                    newDelta = MAX(MIN(newDelta, self.view.frame.size.width), -self.view.frame.size.width);
                    
                    newDelta = -newDelta;
                    
                    newScrollDelta.x = newDelta;
                    
                    percentageTravelled = fabsf(newDelta) / self.view.frame.size.width;
                }
                break;
                    
                default:
                    break;
            }
            
            UIViewController *prevVC = [self previousViewController];
            UIViewController *nextVC = [self nextViewController];
            
            CGFloat alphaVCPrevious = percentageTravelled;
            CGFloat alphaVCCurrent = 1.0f - percentageTravelled;
            CGFloat alphaVCNext = percentageTravelled;

            if ( !nextVC || !prevVC )
            {
                alphaVCCurrent = MAX(0.5f,alphaVCCurrent);
            }
            
            [self previousViewController].view.alpha = alphaVCPrevious;
            [self currentViewController].view.alpha = alphaVCCurrent;
            [self nextViewController].view.alpha = alphaVCNext;
            
            CGPoint newPoint = CGPointMake(_startPointContentOffset.x + newScrollDelta.x,
                                           _startPointContentOffset.y + newScrollDelta.y);
            
            newPoint.x = MAX(MIN(newPoint.x,_scrollView.contentSize.width-(_scrollView.frame.size.width/2)), -_scrollView.frame.size.width/2);
            newPoint.y = MAX(MIN(newPoint.y,_scrollView.contentSize.height-(_scrollView.frame.size.height/2)), -_scrollView.frame.size.height/2);
            
            _scrollView.contentOffset = newPoint;
        }
        break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            NSUInteger newViewControllerIndex = _selectedIndex;
            
            switch (_swipeDirection)
            {
                case PageSwipeDirection_UpDown:
                {
                    newViewControllerIndex = ( (_scrollView.contentOffset.y + (self.view.frame.size.height/2)) / self.view.frame.size.height );
                }
                break;
                    
                case PageSwipeDirection_LeftRight:
                {
                    newViewControllerIndex = ( (_scrollView.contentOffset.x + (self.view.frame.size.width/2)) / self.view.frame.size.width );
                }
                break;
                    
                default:
                    break;
            }

            [self moveToIndex:newViewControllerIndex];
            
            [UIView animateWithDuration:0.3f animations:^
            {
                UIViewController *currentVc = nil;
                
                if ( newViewControllerIndex < _viewControllers.count )
                {
                    currentVc = _viewControllers[newViewControllerIndex];
                }
                else
                {
                    currentVc = _viewControllers[newViewControllerIndex-1];
                }

                [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop)
                {
                    if ( vc != currentVc )
                    {
                        vc.view.alpha = 0.0f;
                    }
                }];

                currentVc.view.alpha = 1.0f;
            }];
        }
        break;
            
        default:
            break;
    }
}


-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    switch (_swipeDirection)
    {
        case PageSwipeDirection_UpDown:
        {
            _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, _selectedIndex * self.view.bounds.size.height);
        }
        break;
            
        case PageSwipeDirection_LeftRight:
        {
            _scrollView.contentOffset = CGPointMake(_selectedIndex * self.view.bounds.size.width, _scrollView.contentOffset.y);
        }
        break;
            
        default:
            break;
    }
}

#pragma mark asdf


-(BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
    return YES;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return YES;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return YES;
}

/* Im only interested in the current selected tab bar view's orientation support */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL isSupported = FALSE;
    
    if ( _selectedIndex < _viewControllers.count )
    {
        UIViewController* vc = _viewControllers[_selectedIndex];
        
        isSupported = [vc shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
    
    return isSupported;
}

-(NSUInteger) supportedInterfaceOrientations
{
    NSInteger orientations = 0;
    
    if ( _selectedIndex < _viewControllers.count )
    {
        UIViewController* vc = _viewControllers[_selectedIndex];
        
        orientations = [vc supportedInterfaceOrientations];
    }
    
    return orientations;
}

-(BOOL) shouldAutorotate
{
    bool shouldRotate = NO;
    
    if ( _selectedIndex < _viewControllers.count )
    {
        if ( [_viewControllers[_selectedIndex] respondsToSelector:@selector(shouldAutorotate)] )
        {
            shouldRotate = [_viewControllers[_selectedIndex] shouldAutorotate];
        }
    }

    return shouldRotate;
}

-(UIStatusBarStyle) preferredStatusBarStyle
{
    UIStatusBarStyle style = UIStatusBarStyleDefault;
    
    if ( _selectedIndex < _viewControllers.count )
    {
        if ( [_viewControllers[_selectedIndex] respondsToSelector:@selector(preferredStatusBarStyle)] )
        {
            style = [_viewControllers[_selectedIndex] preferredStatusBarStyle];
        }
    }

    return style;
}

-(BOOL) prefersStatusBarHidden
{
    BOOL hide = NO;
    
    if ( _selectedIndex < _viewControllers.count )
    {
        if ( [_viewControllers[_selectedIndex] respondsToSelector:@selector(prefersStatusBarHidden)] )
        {
            hide = [_viewControllers[_selectedIndex] prefersStatusBarHidden];
        }
    }

    return hide;
}


@end

