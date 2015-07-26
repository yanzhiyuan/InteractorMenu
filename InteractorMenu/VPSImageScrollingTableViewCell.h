

#import <UIKit/UIKit.h>
@class VPSImageScrollingTableViewCell;

@protocol VPSScrollingTableCallBackDelegate <NSObject>

// Notifies the delegate when user click image
- (void) selectCellItem:(NSString *)itemID;

@end

@interface VPSImageScrollingTableViewCell : UITableViewCell

@property (weak, nonatomic) id<VPSScrollingTableCallBackDelegate> delegate;
@property (nonatomic) CGFloat height;

- (void) setImageData:(NSDictionary*) image;
- (void) setCollectionViewBackgroundColor:(UIColor*) color;
- (void) setCategoryLabelText:(NSString*)text withColor:(UIColor*)color;
- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height;
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor;

@end