
/**
 @file
 Paged UIViewController container
 
 @author Ryan Powell
 @date 01-10-14
 @copyright Copyright (c) 2014  Ryan Powell 
 @licence https://raw.github.com/Ryandev/PagedViewController/master/LICENSE
 */

 
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PagedViewController+Util.h"


#define UIColorFromRGBA(rgbaValue) [UIColor \
    colorWithRed:((float)((rgbaValue & 0xFF000000) >> 24)) /255.0 \
           green:((float)((rgbaValue & 0x00FF0000) >> 16)) /255.0 \
            blue:((float)((rgbaValue & 0x0000FF00) >> 8))  /255.0 \
            alpha:((float)(rgbaValue & 0x0000FF))          /255.0]


@implementation UIColor (HexColor)


+(UIColor*) colorWithHexString:(NSString*)hexString
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                                 withString:@""];

    if ( cleanString.length == 3 )
    {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if ( cleanString.length == 6 )
    {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    NSUInteger baseValue = 0U;
    [[NSScanner scannerWithString:cleanString] scanHexInt:(unsigned int*)&baseValue];
    UIColor *color = UIColorFromRGBA(baseValue);
    return color;
}

@end


@implementation PagedViewController (Util)

-(UIViewController*) currentViewController
{
    UIViewController *vc = nil;
    
    if ( _selectedIndex < _viewControllers.count )
    {
        vc = _viewControllers[_selectedIndex];
    }
    
    return vc;
}

-(UIViewController*) nextViewController
{
    UIViewController *nextVC = nil;
    
    if ( _selectedIndex < _viewControllers.count-1 )
    {
        nextVC = _viewControllers[_selectedIndex+1];
    }
    
    return nextVC;
}

-(UIViewController*) previousViewController
{
    UIViewController *prevVC = nil;
    
    if ( ( _selectedIndex > 0 ) &&
         ( _viewControllers.count > _selectedIndex ) )
    {
        prevVC = _viewControllers[_selectedIndex-1];
    }
    
    return prevVC;
}

-(void) loadSubviews
{
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop)
    {
        [self addChildViewController:viewController];
        
        [_scrollView addSubview:viewController.view];

        viewController.view.translatesAutoresizingMaskIntoConstraints = NO;

        __block UIViewController *previousViewController = nil;

        if ( idx > 0 )
        {
            previousViewController = _viewControllers[idx-1];
        }

        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                 attribute:NSLayoutAttributeWidth
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:_scrollView
                                                 attribute:NSLayoutAttributeWidth
                                                multiplier:1.0f
                                                  constant:0.0f]];

        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                 attribute:NSLayoutAttributeHeight
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:_scrollView
                                                 attribute:NSLayoutAttributeHeight
                                                multiplier:1.0f
                                                  constant:0.0f]];

        switch (_swipeDirection)
        {
            case PageSwipeDirection_UpDown:
            {
                [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_scrollView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:0.0f]];

                [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_scrollView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:0.0f]];

            if ( previousViewController )
            {
                [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:previousViewController.view
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f
                                                                      constant:0.0f]];
            }
            else
            {
                /* first controller */
                [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_scrollView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f
                                                                      constant:0.0f]];
            }

            if ( idx == _viewControllers.count - 1 )
            {
                [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_scrollView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f
                                                                      constant:0.0f]];
            }
        }
        break;

            case PageSwipeDirection_LeftRight:
            {
                [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_scrollView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f]];

                [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_scrollView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:0.0f]];

                if ( previousViewController )
                {
                    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:previousViewController.view
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f
                                                                          constant:0.0f]];
                }
                else
                {
                    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_scrollView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f
                                                                          constant:0.0f]];
                }

                if ( idx == _viewControllers.count - 1 )
                {
                    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_scrollView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f
                                                                          constant:0.0f]];
                }
            }
            break;

            default:
                break;
        }
    }];
}


@end
