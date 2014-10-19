
/**
 @file
 Paged UIViewController container
 
 @author Ryan Powell
 @date 01-10-14
 @copyright Copyright (c) 2014  Ryan Powell
 @licence https://raw.github.com/Ryandev/PagedViewController/master/LICENSE
 */


#import "AppDelegate.h"
#import "PagedViewController.h"
#import "ViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [UIWindow new];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    PagedViewController *rootVC = [[PagedViewController alloc] init];
    
    rootVC.payload = @{PAGES_PAYLOAD_KEY_BACKGROUND_COLOUR:[UIColor whiteColor]};
    
    ViewController *vc1 = [ViewController new];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.text = @"View 1";
    
    ViewController *vc2 = [ViewController new];
    vc2.view.backgroundColor = [UIColor greenColor];
    vc2.text = @"View 2";
    
    ViewController *vc3 = [ViewController new];
    vc3.view.backgroundColor = [UIColor orangeColor];
    vc3.text = @"View 3";
    
    rootVC.viewControllers = @[vc1,vc2,vc3];
    
    self.window.rootViewController = rootVC;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
