
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


@interface UIColor (HexColor)

+(UIColor*) colorWithHexString:(NSString*)string;

@end

@interface PagedViewController (Util)

-(UIViewController*) currentViewController;
-(UIViewController*) nextViewController;
-(UIViewController*) previousViewController;

-(void) loadSubviews;

@end
