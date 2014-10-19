
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

#import "PagedViewControllerCommon.h"


@interface PagedViewController : UIViewController
{
@private
    UIScrollView *_scrollView;
    NSDictionary *_payload;
    NSMutableArray *_viewControllers;
    PageState _state;
    UIImage *_navBarImage;
    NSUInteger _selectedIndex;
    PageSwipeDirection _swipeDirection;
}
@property (nonatomic, readwrite) NSArray *viewControllers;
@property (nonatomic, readwrite) NSUInteger selectedIndex;
@property (nonatomic, readwrite) PageSwipeDirection swipeDirection;
@property (nonatomic, readwrite) NSDictionary *payload;

@end

