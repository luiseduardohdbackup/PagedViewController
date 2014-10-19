
/**
 @file
 Paged UIViewController container
 
 @author Ryan Powell
 @date 01-10-14
 @copyright Copyright (c) 2014  Ryan Powell
 @licence https://raw.github.com/Ryandev/PagedViewController/master/LICENSE
 */


#import "ViewController.h"

@interface ViewController ()
{
@private
    UILabel *l;
}
@end

@implementation ViewController

@dynamic text;

-(void) setText:(NSString *)text
{
    l.text = text;
}

-(NSString*) text
{
    return l.text;
}

-(id) init
{
    if (( self = [super init] ))
    {
        l = [UILabel new];
        l.text = @"View";
        l.font = [UIFont boldSystemFontOfSize:60];
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = [UIColor whiteColor];
        l.layer.cornerRadius = 25.0f;
        l.frame = CGRectMake(20, 20, self.view.frame.size.width-40, self.view.frame.size.height-40);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:l];
}

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    l.frame = CGRectMake(20, 20, self.view.frame.size.width-40, self.view.frame.size.height-40);
}

@end