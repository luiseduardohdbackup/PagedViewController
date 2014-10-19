
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

#import "PagedViewController.h"


@interface PagedViewController (Action)


-(void) expandViewControllers;

-(void) shrinkViewControllers;

-(void) showActiveViewController;

-(void) showAllViewControllers;

-(void) switchStateViewController;

-(void) moveToIndex:(NSInteger)index;

-(void) moveToIndex:(NSInteger)index overDuration:(NSTimeInterval)duration;


@end
