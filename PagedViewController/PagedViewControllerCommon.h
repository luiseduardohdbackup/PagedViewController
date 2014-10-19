
/**
 @file
 Paged UIViewController container
 
 @author Ryan Powell
 @date 01-10-14
 @copyright Copyright (c) 2014  Ryan Powell 
 @licence https://raw.github.com/Ryandev/PagedViewController/master/LICENSE
 */

 
#ifndef __PAGESLIDESCOMMON_H
#define __PAGESLIDESCOMMON_H


typedef enum _PageState
{
    PageState_Undef,
    PageState_Fullscreen,
    PageState_PagesShowing,
    PageState_LastValue,
} PageState;


typedef enum _PageSwipeDirection
{
    PageSwipeDirection_Undef = 0,
    PageSwipeDirection_LeftRight,
    PageSwipeDirection_UpDown,
    PageSwipeDirection_LastValue,
} PageSwipeDirection;


#define PAGES_PAYLOAD_KEY_BACKGROUND_COLOUR @"BackgroundColour"
#define PAGES_PAYLOAD_KEY_DEFAULTCONTROLLERINDEX @"DefaultControllerIndex"
#define PAGES_PAYLOAD_KEY_PAGESCALEFACTOR @"PageScaleFactor"
#define PAGES_PAYLOAD_KEY_PAGESANIMATESPEEDS @"PagesAnimateSpeedS"


static NSString *const kRVC_Bool_HasTabbar = @"RVCBoolHasTabBar";
static NSString *const kRVC_Bool_HasViewAlwaysVisible = @"RVCBoolHasViewAlwaysVisible";
static NSString *const kRVC_Bool_ListenToTouchEvents = @"RVCBoolListenToTouchEvents";
static NSString *const kRVC_Bool_NeedsNavigationBarIconToShow = @"RVCBoolNeedsNavigationBarIconToShow";
static NSString *const kRVC_Bool_IsShowingInternalView = @"RVCBoolIsShowingInternalView";

static NSString *const kRVC_Int_SelectedVCIndex = @"RVCIntSelectedIndex";

static NSString *const kRVC_String_RVCName = @"RVCStringRVCName";

static NSString *const kRVC_Obj_ConstructorPayload = @"RVCObjConstructor";
static NSString *const kRVC_Obj_NavigationBarUIImage = @"RVCObjNavigationBarUIImage";
static NSString *const kRVC_Obj_ViewControllersArray = @"RVCObjViewControllersArray";
static NSString *const kRVC_Obj_View = @"RVCObjView";

static NSString *const kRVC_Void_ActionShowAllViewControllers = @"RVCVoidActionShowAllViewControllers";
static NSString *const kRVC_Void_ActionShowActiveViewController = @"RVCVoidActionShowActiveViewController";
static NSString *const kRVC_Void_ActionSwitchViewControllerState = @"RVCVoidActionSwitchViewControllerState";

static NSString *const kClient_Bool_SnapshotMode = @"ClientBoolSnapshotMode";
static NSString *const kClient_Void_DidTapSelfIcon = @"ClientVoidDidTabSelfIcon";
static NSString *const kClient_Obj_DiagnosticDictionary = @"ClientObjDiagnosticDictionary";
static NSString *const kRVC_Void_ActionDidStartAnimatingView = @"RVCVoidActionDidStartAnimatingView";
static NSString *const kRVC_Void_ActionDidFinishAnimatingView = @"RVCVoidActionDidFinishAnimatingView";

#endif /* __PAGESLIDESCOMMON_H */
