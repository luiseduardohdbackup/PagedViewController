
/**
 @file
 Paged UIViewController container
 
 @author Ryan Powell
 @date 01-10-14
 @copyright Copyright (c) 2014  Ryan Powell 
 @licence https://raw.github.com/Ryandev/PagedViewController/master/LICENSE
 */


#import "PagedViewController+RVCProtocol.h"
#import "PagedViewController+Action.h"
#import "PagedViewController+Payload.h"


@implementation PagedViewController (RVCProtocol)


-(id) valueForUndefinedKey:(NSString *)key
{
    id val = NULL;
    
    if ( [key isEqualToString:kRVC_Bool_HasTabbar] )
    {
        val = @FALSE;
    }
    else if ( [key isEqualToString:kRVC_Bool_HasViewAlwaysVisible] )
    {
        val = @FALSE;
    }
    else if ( [key isEqualToString:kRVC_Bool_ListenToTouchEvents] )
    {
        val = [NSNumber numberWithBool:self.view.userInteractionEnabled];
    }
    else if ( [key isEqualToString:kRVC_Bool_NeedsNavigationBarIconToShow] )
    {
        val = @TRUE;
    }
    else if ( [key isEqualToString:kRVC_Int_SelectedVCIndex] )
    {
        val = [NSNumber numberWithInt:(int)_selectedIndex];
    }
    else if ( [key isEqualToString:kRVC_String_RVCName] )
    {
        val = NSStringFromClass([self class]);
    }
    else if ( [key isEqualToString:kRVC_Obj_ConstructorPayload] )
    {
        val = _payload;
    }
    else if ( [key isEqualToString:kRVC_Obj_NavigationBarUIImage] )
    {
        val = _navBarImage;
    }
    else if ( [key isEqualToString:kRVC_Obj_ViewControllersArray] )
    {
        val = _viewControllers;
    }
    else if ( [key isEqualToString:kRVC_Obj_View] )
    {
        val = self.view;
    }
    else if ( [key isEqualToString:kRVC_Void_ActionShowAllViewControllers] )
    {
        /* do nothing */
    }
    else if ( [key isEqualToString:kRVC_Void_ActionShowActiveViewController] )
    {
        /* do nothing */
    }
    else if ( [key isEqualToString:kRVC_Void_ActionSwitchViewControllerState] )
    {
        /* do nothing */
    }
    else
    {
        val = [super valueForUndefinedKey:key];
    }
    
    return val;
}

-(void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ( [key isEqualToString:kRVC_Bool_HasTabbar] )
    {
        /* do nothing */
    }
    else if ( [key isEqualToString:kRVC_Bool_HasViewAlwaysVisible] )
    {
        /* do nothing */
    }
    else if ( [key isEqualToString:kRVC_Bool_ListenToTouchEvents] )
    {
        /* do nothing */
    }
    else if ( [key isEqualToString:kRVC_Bool_NeedsNavigationBarIconToShow] )
    {
        /* do nothing */
    }
    else if ( [key isEqualToString:kRVC_Int_SelectedVCIndex] )
    {
        if ( [value isKindOfClass:[NSNumber class]] )
        {
            [self moveToIndex:[value intValue]];
        }
    }
    else if ( [key isEqualToString:kRVC_String_RVCName] )
    {
        /* do nothing */
    }
    else if ( [key isEqualToString:kRVC_Obj_ConstructorPayload] )
    {
        if ( [value isKindOfClass:[NSDictionary class]] )
        {
            self.payload = value;
        }
    }
    else if ( [key isEqualToString:kRVC_Obj_NavigationBarUIImage] )
    {
        /* do nothing */
    }
    else if ( [key isEqualToString:kRVC_Obj_ViewControllersArray] )
    {
        if ( [key isKindOfClass:[NSArray class]] )
        {
            _viewControllers = value;
        }
    }
    else if ( [key isEqualToString:kRVC_Obj_View] )
    {
        if ( [value isKindOfClass:[UIView class]] )
        {
            self.view = value;
        }
    }
    else if ( [key isEqualToString:kRVC_Void_ActionShowAllViewControllers] )
    {
        [self showAllViewControllers];
    }
    else if ( [key isEqualToString:kRVC_Void_ActionShowActiveViewController] )
    {
        [self showActiveViewController];
    }
    else if ( [key isEqualToString:kRVC_Void_ActionSwitchViewControllerState] )
    {
        [self switchStateViewController];
    }
    else
    {
        [super setValue:value forUndefinedKey:key];
    }
}


@end
