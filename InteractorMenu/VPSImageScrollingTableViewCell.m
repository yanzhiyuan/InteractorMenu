
#import "VPSImageScrollingTableViewCell.h"
#import "VPSImageScrollingCellView.h"

#define kScrollingViewHieght 80
#define kCategoryLabelWidth 200
#define kCategoryLabelHieght 20
#define kStartPointY 15

@interface VPSImageScrollingTableViewCell() <VPSImageScrollingViewDelegate>

@property (strong,nonatomic) UIColor *categoryTitleColor;
@property(strong, nonatomic) VPSImageScrollingCellView *imageScrollingView;
@property (strong, nonatomic) NSString *categoryLabelText;

@end

@implementation VPSImageScrollingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    // Set ScrollImageTableCellView
    _imageScrollingView = [[VPSImageScrollingCellView alloc] initWithFrame:CGRectMake(0., kStartPointY, [UIScreen mainScreen].bounds.size.width, kScrollingViewHieght)];
    _imageScrollingView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
    // Configure the view for the selected state
}

- (void)setImageData:(NSDictionary*)collectionImageData
{
    [_imageScrollingView setImageData:[collectionImageData objectForKey:@"images"]];
    _categoryLabelText = [collectionImageData objectForKey:@"category"];
}

- (void)setCategoryLabelText:(NSString*)text withColor:(UIColor*)color{
    if(text.length > 0){
    
    if ([self.contentView subviews]){
        for (UIView *subview in [self.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    UILabel *categoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kCategoryLabelWidth, kCategoryLabelHieght)];
    categoryTitle.textAlignment = NSTextAlignmentLeft;
    categoryTitle.text = text;
    categoryTitle.textColor = color;
    categoryTitle.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:categoryTitle];
    }
}

- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height {

    [_imageScrollingView setImageTitleLabelWitdh:width withHeight:height];
}

- (void) setImageTitleTextColor:(UIColor *)textColor withBackgroundColor:(UIColor *)bgColor{

    [_imageScrollingView setImageTitleTextColor:textColor withBackgroundColor:bgColor];
}

- (void)setCollectionViewBackgroundColor:(UIColor *)color{
    
    _imageScrollingView.backgroundColor = color;
    [self.contentView addSubview:_imageScrollingView];
}

#pragma mark - VPSImageScrollingViewDelegate

- (void)collectionView:(VPSImageScrollingCellView *)collectionView didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath ImageTitle:(NSString *)title {

    [self.delegate selectCellItem:title];
}

@end
