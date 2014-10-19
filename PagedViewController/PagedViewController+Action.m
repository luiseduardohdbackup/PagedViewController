
/**
 @file
 Paged UIViewController container
 
 @author Ryan Powell
 @date 01-10-14
 @copyright Copyright (c) 2014  Ryan Powell 
 @licence https://raw.github.com/Ryandev/PagedViewController/master/LICENSE
 */


#import "PagedViewController+Action.h"
#import "PagedViewControllerCommon.h"
#import <QuartzCore/QuartzCore.h>


@implementation PagedViewController (Action)


-(void) shrinkViewControllers
{
    for ( NSUInteger i=0U; i<_viewControllers.count; i++ )
    {
        float scaleFactor = 0.7f;
        
        if ( _payload[PAGES_PAYLOAD_KEY_PAGESCALEFACTOR] )
        {
            scaleFactor = [_payload[PAGES_PAYLOAD_KEY_PAGESCALEFACTOR] floatValue];
        }
        
        float speedS = 0.25f;
        
        if ( _payload[PAGES_PAYLOAD_KEY_PAGESANIMATESPEEDS] )
        {
            speedS = [_payload[PAGES_PAYLOAD_KEY_PAGESANIMATESPEEDS] floatValue];
        }
        
        UIViewController *currentViewController = _viewControllers[i];
        
        currentViewController.view.userInteractionEnabled = FALSE;
        
        [UIView animateWithDuration:speedS
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             currentViewController.view.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
         }
                         completion:^(BOOL completed)
         {
             currentViewController.view.layer.masksToBounds = NO;
             currentViewController.view.layer.shadowRadius = 10;
             currentViewController.view.layer.shadowOpacity = 0.5;
             currentViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:currentViewController.view.bounds].CGPath;
             currentViewController.view.layer.shadowOffset = CGSizeMake(5.0, 5.0);
         }];
        
    }
}

-(void) expandViewControllers
{
    for ( NSUInteger i=0U; i<_viewControllers.count; i++ )
    {
        UIViewController *currentViewController = _viewControllers[i];
        
        float speedS = 0.25f;
        
        if ( _payload[PAGES_PAYLOAD_KEY_PAGESANIMATESPEEDS] )
        {
            speedS = [_payload[PAGES_PAYLOAD_KEY_PAGESANIMATESPEEDS] floatValue];
        }
        
        [UIView animateWithDuration:speedS
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             currentViewController.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
         }
                         completion:^(BOOL completed)
         {
             currentViewController.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
             
             /* remove shadow next view controller */
             currentViewController.view.layer.masksToBounds = YES;
             currentViewController.view.layer.shadowRadius = 0.0f;
             currentViewController.view.layer.shadowOpacity = 0.0f;
             currentViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:currentViewController.view.bounds].CGPath;
             currentViewController.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
             
             currentViewController.view.userInteractionEnabled = TRUE;
             
             [currentViewController viewDidAppear:YES];
         }];
    }
}

-(void) showActiveViewController
{
    [self expandViewControllers];
    
    _scrollView.scrollEnabled = FALSE;
    
    _state = PageState_Fullscreen;
    
    @try
    {
        [_viewControllers[_selectedIndex] setValue:NULL forKey:kClient_Void_DidTapSelfIcon];
    }
    @catch (NSException *exception)
    {
        /* viewController does not listen to event */
    }
}

-(void) showAllViewControllers
{
    [self shrinkViewControllers];
    
    _scrollView.scrollEnabled = TRUE;
    
    _state = PageState_PagesShowing;
}

-(void) switchStateViewController
{
    switch (_state)
    {
        case PageState_Fullscreen:
            [self showAllViewControllers];
            break;
            
        case PageState_PagesShowing:
            [self showActiveViewController];
            break;
            
        default:
            break;
    }
}

-(void) moveToIndex:(NSInteger)index
{
    [self moveToIndex:index overDuration:0.5f];
}

-(void) moveToIndex:(NSInteger)index overDuration:(NSTimeInterval)duration
{
    if ( index > (_viewControllers.count-1) )
    {
        index = _viewControllers.count - 1;
    }
    
    CGPoint newOffset = CGPointZero;
    
    switch (_swipeDirection)
    {
        case PageSwipeDirection_UpDown:
            newOffset = CGPointMake(0.0f, index*self.view.frame.size.height);
            break;
            
        case PageSwipeDirection_LeftRight:
            newOffset = CGPointMake(index*self.view.frame.size.width, 0.0f);
            break;
            
        default:
            break;
    }

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         _scrollView.contentOffset = newOffset;
     }
                     completion:^(BOOL finished)
     {
         _selectedIndex = index;
     }];
}

@end
