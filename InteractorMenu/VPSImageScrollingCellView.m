

#import "VPSImageScrollingCellView.h"
#import "VPSCollectionViewCell.h"

@interface  VPSImageScrollingCellView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) VPSCollectionViewCell *myCollectionViewCell;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) NSArray *collectionImageData;
@property (nonatomic) CGFloat imagetitleWidth;
@property (nonatomic) CGFloat imagetitleHeight;
@property (strong, nonatomic) UIColor *imageTilteBackgroundColor;
@property (strong, nonatomic) UIColor *imageTilteTextColor;


@end

@implementation VPSImageScrollingCellView

- (id)initWithFrame:(CGRect)frame
{
     self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code

        /* Set flowLayout for CollectionView*/
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(70, 70);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.minimumLineSpacing = 5;

        /* Init and Set CollectionView */
        self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.myCollectionView.delegate = self;
        self.myCollectionView.dataSource = self;
        self.myCollectionView.showsHorizontalScrollIndicator = NO;

        [self.myCollectionView registerClass:[VPSCollectionViewCell class] forCellWithReuseIdentifier:@"VPSCollectionCell"];
        [self addSubview:_myCollectionView];
    }
    return self;
}

- (void) setImageData:(NSArray*)collectionImageData{

    _collectionImageData = collectionImageData;
    [_myCollectionView reloadData];
}

- (void) setBackgroundColor:(UIColor*)color{

    self.myCollectionView.backgroundColor = color;
    [_myCollectionView reloadData];
}

- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height{
    _imagetitleWidth = width;
    _imagetitleHeight = height;
}
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor{
    
    _imageTilteTextColor = textColor;
    _imageTilteBackgroundColor = bgColor;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionImageData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    VPSCollectionViewCell *cell = (VPSCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"VPSCollectionCell" forIndexPath:indexPath];
    NSDictionary *imageDic = [self.collectionImageData objectAtIndex:[indexPath item]];
    
    //NSString* imgNamem = [imageDic objectForKey:@"name"];
    //UIImage* img = [UIImage imageNamed:imgNamem];
    
    [cell setImage:[UIImage imageNamed:[imageDic objectForKey:@"name"]]];
    [cell setImageTitleLabelWitdh:_imagetitleWidth withHeight:_imagetitleHeight];
    [cell setImageTitleTextColor:_imageTilteTextColor withBackgroundColor:_imageTilteBackgroundColor];
    NSString* title = [imageDic objectForKey:@"title"];
    [cell setTitle:title];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *imageDic = [self.collectionImageData objectAtIndex:[indexPath item]];
    NSString* imgTitle = [imageDic objectForKey:@"name"];
    [self.delegate collectionView:self didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath ImageTitle:imgTitle];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
