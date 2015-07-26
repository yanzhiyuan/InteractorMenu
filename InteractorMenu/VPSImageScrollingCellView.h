#import <UIKit/UIKit.h>

@class VPSImageScrollingCellView;

@protocol VPSImageScrollingViewDelegate <NSObject>

- (void)collectionView:(VPSImageScrollingCellView *)collectionView didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath ImageTitle:(NSString*)title;

@end


@interface VPSImageScrollingCellView : UIView

@property (weak, nonatomic) id<VPSImageScrollingViewDelegate> delegate;

- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height;
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor;
- (void) setImageData:(NSArray*)collectionImageData;
- (void) setBackgroundColor:(UIColor*)color;

@end
