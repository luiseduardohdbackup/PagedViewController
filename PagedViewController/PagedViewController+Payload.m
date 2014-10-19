
/**
 @file
 Paged UIViewController container
 
 @author Ryan Powell
 @date 01-10-14
 @copyright Copyright (c) 2014  Ryan Powell 
 @licence https://raw.github.com/Ryandev/PagedViewController/master/LICENSE
 */

 
#import "PagedViewController+Payload.h"
#import "PagedViewController+Util.h"
#import "PagedViewController+Action.h"
#import "PagedViewControllerCommon.h"


@implementation PagedViewController (Payload)


-(void) loadPayloadStyling
{
    if ( _payload[PAGES_PAYLOAD_KEY_BACKGROUND_COLOUR] )
    {
        id colObj = _payload[PAGES_PAYLOAD_KEY_BACKGROUND_COLOUR];
        UIColor *newColor = [UIColor blackColor];

        if ( [colObj isKindOfClass:[UIColor class]] )
        {
            newColor = colObj;
        }
        else if ( [colObj isKindOfClass:[NSString class]] )
        {
            newColor = [UIColor colorWithHexString:colObj];
        }

        _scrollView.backgroundColor = newColor;
    }

    if ( _payload[PAGES_PAYLOAD_KEY_DEFAULTCONTROLLERINDEX] )
    {
        NSUInteger selIndex = [_payload[PAGES_PAYLOAD_KEY_DEFAULTCONTROLLERINDEX] intValue];
        
        if ( selIndex > _viewControllers.count )
        {
            selIndex = _viewControllers.count - 1U;
        }
        
        if ( self.isViewLoaded )
        {
            [self moveToIndex:selIndex];
        }
        else
        {
            _selectedIndex = selIndex;
        }
    }

}


@end
