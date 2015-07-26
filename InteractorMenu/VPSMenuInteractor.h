//
//  VPSMenuInteractor.h
//  VPrintShop
//
//  Created by Zhi Yuan Yan on 1/19/2014.
//

#import <UIKit/UIKit.h>
#import "VPSMenuViewController.h"

@protocol VPSMenuInteractorDelegate;


@interface VPSMenuInteractor : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning,UIViewControllerTransitioningDelegate>


//@property (nonatomic, strong) UIPanGestureRecognizer *pan;
//@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, assign, readonly) BOOL interactionInProgress;
@property (nonatomic) bool presentingMenu;
@property (nonatomic, weak) UIViewController<VPSMenuInteractorDelegate>* presentingVC;


- (void)attachToPresentingVC:(UIViewController *)viewController;
//- (void)attachToModalVC:(UIViewController *)viewController;
//- (void)attachToMenuIcon:(UIView*)view;
//- (void)attachGesture:(UIView*) view;
- (void)attachMenu:(VPSMenuViewController*)view Icon:(UIView*)icon;
- (void)initMenuInteractor;
- (void)dismissMenu:(VPSMenuViewController*)menu Icon:(UIView*)icon;

@end

@protocol VPSMenuInteractorDelegate <NSObject>

- (void) setUserInteractiveExceptView:(UIView*) subview interactive:(BOOL)interactive;

@end