//
//  VPSMenuViewController.h
//  VPrintShop
//
//  Created by Zhi Yuan Yan on 1/26/2014.
//

#import <UIKit/UIKit.h>
#import "VPSImageScrollingTableViewCell.h"
#import "GPUImage.h"


@protocol VPSMenuCallBackDelegate <NSObject>

// Notifies the delegate when user click image
- (void)selectMenuItem:(NSString *)menuID didSelectItemID:(NSString*)itemID;

@end
 

@interface VPSMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, VPSScrollingTableCallBackDelegate>

@property (strong, nonatomic) GPUImageView* backgroundImgView;
@property (weak, nonatomic)id<VPSMenuCallBackDelegate> menuCallBackDelegate;
@property (strong, nonatomic) NSString* menuId;
@property (strong, nonatomic) NSMutableArray *images;

- (void) refreshMenuItems;

@end


