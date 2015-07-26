//
//  VPSInteractiveSwipe.m
//  VPrintShop
//
//  Created by Zhi Yuan Yan on 1/19/2014.
//

#import "VPSMenuInteractor.h"
#import "UIImage+ImageEffects.h"

@interface VPSMenuInteractor ()
@property (nonatomic, assign, readwrite) BOOL interactionInProgress;
@property (nonatomic) id <UIViewControllerContextTransitioning> context;

@property (nonatomic, strong) NSMutableArray* menuVCArray;
@property (nonatomic, strong) NSMutableArray* menuIconArray;
@property (nonatomic) UIView* interactingIcon;
@property (nonatomic) VPSMenuViewController* interactingMenu;

@end

@implementation VPSMenuInteractor

- (void)attachToPresentingVC:(UIViewController *)viewController {
    self.presentingVC = viewController;
}



- (void) attachMenu:(VPSMenuViewController *)view Icon:(UIView *)icon
{
    if(!self.menuVCArray){
        self.menuVCArray = [[NSMutableArray alloc]init];
    }
    if(!self.menuIconArray){
        self.menuIconArray = [[NSMutableArray alloc]init];
    }
    [self.menuVCArray addObject:view];
    [self.menuIconArray addObject:icon];
    icon.userInteractionEnabled = YES;
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [tap requireGestureRecognizerToFail:pan];
    

    [icon addGestureRecognizer:pan];
    [icon addGestureRecognizer:tap];
}

- (void) initMenuInteractor{
    for (int i = 0; i < self.menuVCArray.count; i++) {
        VPSMenuViewController* menuVC = self.menuVCArray[i];
        UIView* iconView = self.menuIconArray[i];
        [self blurModalViewBackground:menuVC Icon:iconView];
    }
}


- (void) dismissMenu:(VPSMenuViewController*)menu Icon:(UIView *)icon{
    NSLog(@"going to dismiss menu");
    self.presentingMenu = NO;
    
    self.interactingIcon = icon;
    self.interactingMenu = menu;
    
    [self.presentingVC dismissViewControllerAnimated:YES completion:^(void){self.interactingIcon = nil;self.interactingMenu=nil;
        
        //add this line due to ios8 bug
        //http://stackoverflow.com/questions/24338700/from-view-controller-disappears-using-uiviewcontrollercontexttransitioning
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.presentingVC.view];
    }];
}

- (void) onTap:(UITapGestureRecognizer*)tap
{
    
    //UIView* icon = tap.view;
    //VPSMenuViewController* menuVC = self.menuVCArray[[self.menuIconArray indexOfObject:icon]];
    self.interactingIcon = tap.view;
    self.interactingMenu = [self.menuVCArray objectAtIndex:[self.menuIconArray indexOfObject:self.interactingIcon]];

    
    if(! self.interactionInProgress)
    {
        CGPoint location = [tap locationInView:self.presentingVC.view];
        if(location.y <= CGRectGetMidY(self.presentingVC.view.bounds)*1.1){
            [self dismissMenu:self.interactingMenu Icon:self.interactingIcon];
        }else{
            NSLog(@"going to present menu");
            self.presentingMenu = YES;
            self.interactingMenu.view.frame = [self getMenuHidingFrame];
            [self.presentingVC presentViewController:self.interactingMenu animated:YES completion:^(void){self.interactingIcon = nil; self.interactingMenu = nil;}];
        }
    }
}

- (void)onPan:(UIPanGestureRecognizer *)pan {
    NSAssert(self.presentingVC != nil, @"view controller was not set");
    
    //CGPoint translation = [pan translationInView:self.presentingVC.view];
    CGPoint location = [pan locationInView:self.presentingVC.view];
    CGPoint velocity = [pan velocityInView:self.presentingVC.view];

    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"gesture begin");

            self.interactionInProgress = YES;
            self.interactingIcon= pan.view;
            self.interactingMenu = self.menuVCArray[[self.menuIconArray indexOfObject:self.interactingIcon]];
            if(location.y <= CGRectGetMidY(self.presentingVC.view.bounds)*1.1){
                NSLog(@"going to dismiss menu");
                self.presentingMenu = NO;
                [self.presentingVC dismissViewControllerAnimated:YES completion:^void{
                    //add this line due to ios8 bug
                    //http://stackoverflow.com/questions/24338700/from-view-controller-disappears-using-uiviewcontrollercontexttransitioning
                    [[[UIApplication sharedApplication] keyWindow] addSubview:self.presentingVC.view];
                }];
            }else{
                NSLog(@"going to present menu");
                self.presentingMenu = YES;
                
                self.interactingMenu.view.frame = [self getMenuHidingFrame];
                [self.presentingVC presentViewController:self.interactingMenu animated:YES completion:nil];
            }
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGFloat percent = 0.0;

            if(self.presentingMenu){
                percent = (CGRectGetMaxY(self.presentingVC.view.frame) - location.y) / (CGRectGetHeight(self.presentingVC.view.frame)/2);
                //NSLog(@"transaction y %f, bound %f", translation.y,  CGRectGetHeight(self.presentingVC.view.bounds));
                percent = fmaxf(percent, 0.0);
                percent = fminf(percent, 1.0);
            }else{
                percent = (location.y - CGRectGetMidY(self.presentingVC.view.frame)) / (CGRectGetHeight(self.presentingVC.view.frame)/2);
                    //NSLog(@"transaction y %f, bound %f", translation.y,  CGRectGetHeight(self.presentingVC.view.bounds));
                    percent = fmaxf(percent, 0.0);
                    percent = fminf(percent, 1.0);
            }
            [self updateInteractiveTransition:percent];
            break;
        }
            
        case UIGestureRecognizerStateEnded:{
            if (self.presentingMenu) {
                if (velocity.y < 0) {
                    NSLog(@"finish interactive transition");
                    [self finishInteractiveTransition];
                    [self.presentingVC setUserInteractiveExceptView:self.interactingIcon interactive:NO];
                }
                else {
                    NSLog(@"cancel interactive transition");
                    [self cancelInteractiveTransition];
                }
            }
            else {
                if (velocity.y > 0) {
                    NSLog(@"finish interactive transition");
                    [self finishInteractiveTransition];
                    [self.presentingVC setUserInteractiveExceptView:self.interactingIcon interactive:YES];
                }
                else {
                    NSLog(@"cancel interactive transition");
                    [self cancelInteractiveTransition];
                }
            }
            self.interactionInProgress = NO;
            break;
        }

        case UIGestureRecognizerStateCancelled: {
            NSLog(@"gesture end cancel");
            [self cancelInteractiveTransition];
            self.interactionInProgress = NO;
            break;
        }
            
            
        default:
            break;
    }
}

- (CGFloat)completionSpeed {
    return 1 - self.percentComplete;
}

#pragma mark - UIPercentDrivenInteractiveTransition Overridden Methods
- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    CGRect frame;
    CGRect menuBtnFrame;
    //NSLog(@"percent complete %f", percentComplete);
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    if(self.presentingMenu){
        frame = CGRectMake(screenFrame.origin.x, screenFrame.origin.y + screenFrame.size.height - (CGRectGetHeight(screenFrame)/2 * percentComplete), screenFrame.size.width, (CGRectGetHeight(screenFrame)/2 * percentComplete));
        menuBtnFrame = CGRectMake(self.interactingIcon.frame.origin.x, CGRectGetMinY(frame) - (self.interactingIcon.frame.size.height), self.interactingIcon.frame.size.width, self.interactingIcon.frame.size.height);
    }else{
        frame = CGRectMake(screenFrame.origin.x, screenFrame.origin.y + screenFrame.size.height/2 + (CGRectGetHeight(screenFrame)/2 * percentComplete), screenFrame.size.width, (CGRectGetHeight(screenFrame)/2 * (1 -percentComplete)));
        menuBtnFrame = CGRectMake(self.interactingIcon.frame.origin.x, CGRectGetMinY(frame) - (self.interactingIcon.frame.size.height), self.interactingIcon.frame.size.width, self.interactingIcon.frame.size.height);
    }
    
    self.interactingMenu.view.frame = frame;
    self.interactingIcon.frame = menuBtnFrame;
    [self updateModalViewBackground];
}

- (void)finishInteractiveTransition {
    if (self.presentingMenu)
    {
        CGRect endFrame = [self getMenuShowingFrame];
        CGRect menuBtnFrame = [self getIconShowingFrame];

        //Animate using spring animation
        [UIView animateWithDuration:[self transitionDuration:self.context] delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.interactingMenu.view.frame = endFrame;
            self.interactingIcon.frame = menuBtnFrame;
        } completion:^(BOOL finished) {
            [self.context completeTransition:YES];
            self.interactingIcon = nil;
            self.interactingMenu = nil;
            //NSLog(@"complte transition");
        }];
        [self updateModalViewBackground];
    }else {
        CGRect endFrame = [self getMenuHidingFrame];
        CGRect menuBtnFrame = [self getIconHidingFrame];
        
        //Animate using spring animation
        [UIView animateWithDuration:[self transitionDuration:self.context] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.interactingMenu.view.frame = endFrame;
            self.interactingIcon.frame = menuBtnFrame;
        } completion:^(BOOL finished) {
            [self.context completeTransition:YES];
            self.interactingIcon = nil;
            self.interactingMenu = nil;
            //NSLog(@"complte transition");
        }];
    }
}

- (void)cancelInteractiveTransition {
    if (self.presentingMenu)
    {
        CGRect endFrame = [self getMenuHidingFrame];
        CGRect menuBtnFrame = [self getIconHidingFrame];
        
        //Animate using spring animation
        [UIView animateWithDuration:[self transitionDuration:self.context] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.interactingMenu.view.frame = endFrame;
            self.interactingIcon.frame = menuBtnFrame;
        } completion:^(BOOL finished) {
            [self.context completeTransition:NO];
            self.interactingIcon = nil;
            self.interactingMenu = nil;
            //add this line due to ios8 bug
            //http://stackoverflow.com/questions/24338700/from-view-controller-disappears-using-uiviewcontrollercontexttransitioning
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.presentingVC.view];

        }];
    }else {
        CGRect endFrame = [self getMenuShowingFrame];
        CGRect menuBtnFrame = [self getIconShowingFrame];
        
        CGRect tempFrame = self.interactingMenu.view.frame;
        self.interactingMenu.view.frame = endFrame ;
        [self updateModalViewBackground];
        self.interactingMenu.view.frame = tempFrame;
        
        //Animate using spring animation
        [UIView animateWithDuration:[self transitionDuration:self.context] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.interactingMenu.view.frame = endFrame;
            self.interactingIcon.frame = menuBtnFrame;
        } completion:^(BOOL finished) {
            [self.context completeTransition:NO];
            
            //add this line due to ios8 bug
            //http://stackoverflow.com/questions/24338700/from-view-controller-disappears-using-uiviewcontrollercontexttransitioning
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.interactingMenu.view];
            
            //self.interactingIcon = nil;
            //self.interactingMenu = nil;
        }];
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning Methods
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:self.presentingVC.view];
    [containerView addSubview:self.interactingMenu.view];
    
    if (self.presentingMenu)
    {
        CGRect beginFrame = [self getMenuHidingFrame];
        CGRect iconBeginFrame = [self getIconHidingFrame];
        self.interactingMenu.view.frame = beginFrame;
        self.interactingIcon.frame = iconBeginFrame;
        
        [containerView bringSubviewToFront:self.interactingMenu.view];
        CGRect endFrame = [self getMenuShowingFrame];
        CGRect iconEndFrame = [self getIconShowingFrame];
        
        //Animate using spring animation
        [UIView animateWithDuration:[self transitionDuration:self.context] delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.interactingMenu.view.frame = endFrame;
            self.interactingIcon.frame = iconEndFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            //NSLog(@"complte transition");
        }];
        [self.presentingVC setUserInteractiveExceptView:self.interactingIcon interactive:NO];
        [self updateModalViewBackground];
    }else {
        CGRect endFrame = [self getMenuHidingFrame];
        CGRect menuBtnFrame = [self getIconHidingFrame];
        
        
        //Animate using spring animation
        [UIView animateWithDuration:[self transitionDuration:self.context] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.interactingMenu.view.frame = endFrame;
            self.interactingIcon.frame = menuBtnFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            //NSLog(@"complte transition");
        }];
        [self.presentingVC setUserInteractiveExceptView:self.interactingIcon interactive:YES];
        [self updateModalViewBackground];
    }
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

#pragma mark - UIViewControllerInteractiveTransitioning Methods
- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* presentingVC;
    VPSMenuViewController* modalVC;
    self.context = transitionContext;
    
    if([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[VPSMenuViewController class]]){
        self.presentingMenu = NO;
        modalVC = (VPSMenuViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        presentingVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }else{
        
        self.presentingMenu = YES;
        presentingVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        modalVC = (VPSMenuViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    [transitionContext.containerView addSubview:presentingVC.view];
    [transitionContext.containerView addSubview:modalVC.view];
}

#pragma mark - Transitioning Delegate (Modal)
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
    
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactionInProgress ? self : nil;

}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactionInProgress ? self : nil;
    
}

- (void) updateModalViewBackground{
    CGRect endFrame = self.interactingMenu.view.frame;
    
    
    CGRect fullFrame = [UIScreen mainScreen].bounds;
    CGRect cropFrame = CGRectMake(endFrame.origin.x/fullFrame.size.width, endFrame.origin.y/fullFrame.size.height, 1, endFrame.size.height/fullFrame.size.height);
    
    self.interactingMenu.backgroundImgView.layer.contentsRect = cropFrame;
    self.interactingMenu.backgroundImgView.fillMode = kGPUImageFillModePreserveAspectRatio;
}

- (void) blurModalViewBackground:(VPSMenuViewController*)menuVC Icon:(UIView*)iconView{
    
    CGRect fullFrame = [UIScreen mainScreen].bounds;
    
    __block UIImage *snapshot;
    //hiding the icon doesn't work here because the icon is not layout yet when this function is called
    //iconView.hidden = true;
    UIGraphicsBeginImageContextWithOptions(fullFrame.size, NO, 0);
        
    [self.presentingVC.view drawViewHierarchyInRect:fullFrame afterScreenUpdates:NO];
        
    snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    [self.presentingVC.view addSubview:iconView];
    
    //iconView.hidden = false;
    GPUImagePicture* pic = [[GPUImagePicture alloc]initWithImage:snapshot];
    GPUImageiOSBlurFilter* filter = [[GPUImageiOSBlurFilter alloc]init];
    filter.blurRadiusInPixels = 3.0f;
    [pic addTarget:filter];
    [filter addTarget:menuVC.backgroundImgView];
    [pic processImageWithCompletionHandler:^{
        [filter removeAllTargets];
    }];
    
}

- (CGRect) getMenuHidingFrame
{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    return  CGRectMake(screenFrame.origin.x, screenFrame.size.height, screenFrame.size.width, screenFrame.size.height/2 *1.2);
}

- (CGRect) getMenuShowingFrame
{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    return CGRectMake(screenFrame.origin.x, screenFrame.size.height/2, screenFrame.size.width, screenFrame.size.height/2 * 1.2);
}

- (CGRect) getIconHidingFrame
{
    CGRect menuFrame = [self getMenuHidingFrame];
    return CGRectMake(self.interactingIcon.frame.origin.x, CGRectGetMinY(menuFrame) - (self.interactingIcon.frame.size.height), self.interactingIcon.frame.size.width, self.interactingIcon.frame.size.height);
}

- (CGRect) getIconShowingFrame
{
    CGRect menuFrame = [self getMenuShowingFrame];
    return CGRectMake(self.interactingIcon.frame.origin.x, CGRectGetMinY(menuFrame) - (self.interactingIcon.frame.size.height), self.interactingIcon.frame.size.width, self.interactingIcon.frame.size.height);
}

@end


