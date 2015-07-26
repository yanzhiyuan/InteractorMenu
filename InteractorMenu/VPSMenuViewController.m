//
//  VPSMenuViewController.m
//  VPrintShop
//
//  Created by Zhi Yuan Yan on 1/26/2014.
//

#import "VPSMenuViewController.h"
#import "VPSImageScrollingTableViewCell.h"


@interface VPSMenuViewController() 


@property (strong, nonatomic) UITableView* tableView;

@end

@implementation VPSMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.backgroundImgView = [[GPUImageView alloc] init];
    self.backgroundImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImgView.fillMode = kGPUImageFillModePreserveAspectRatio;
    [self.view addSubview:self.backgroundImgView];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    [self.view addSubview:self.tableView];
    
    
    self.title = @"VPSImageScrollingTableView";
    
    static NSString *CellIdentifier = @"Cell";
    [self.tableView registerClass:[VPSImageScrollingTableViewCell class] forCellReuseIdentifier:CellIdentifier];
//    self.images = @[
//                    @{ @"category": @"Category A",
//                       @"images":
//                           @[
//                               @{ @"name":@"template_1.png", @"title":@"A-0"},
//                               @{ @"name":@"template_2.png", @"title":@"A-1"},
//                               @{ @"name":@"template_3.png", @"title":@"A-2"},
//                               @{ @"name":@"template_4.png", @"title":@"A-3"}
//                               ]
//                       },
//                    @{ @"category": @"Category B",
//                       @"images":
//                           @[
//                               @{ @"name":@"template_1.png", @"title":@"B-0"},
//                               @{ @"name":@"template_2.png", @"title":@"B-1"},
//                               @{ @"name":@"template_3.png", @"title":@"B-2"},
//                               @{ @"name":@"template_4.png", @"title":@"B-3"}
//                               ]
//                       },
//                    @{ @"category": @"Category C",
//                       @"images":
//                           @[
//                               @{ @"name":@"template_1.png", @"title":@"C-0"},
//                               @{ @"name":@"template_2.png", @"title":@"C-1"},
//                               @{ @"name":@"template_3.png", @"title":@"C-2"},
//                               @{ @"name":@"template_4.png", @"title":@"C-3"}
//                               ]
//                       }
//                    ];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImgView.frame = bounds;
    self.tableView.frame = bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshMenuItems{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.images count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *cellData = [self.images objectAtIndex:[indexPath section]];
    VPSImageScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [customCell setBackgroundColor:[UIColor clearColor]];
    [customCell setDelegate:self];
    [customCell setImageData:cellData];
    [customCell setCategoryLabelText:[cellData objectForKey:@"category"] withColor:[UIColor whiteColor]];
    [customCell setTag:[indexPath section]];
    [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [customCell setImageTitleLabelWitdh:90 withHeight:45];
    [customCell setCollectionViewBackgroundColor:[UIColor clearColor]];
    
    return customCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - VPSScrollingTableCallBackDelegate

- (void) selectCellItem:(NSString *)itemID
{
    [self.menuCallBackDelegate selectMenuItem:self.menuId didSelectItemID:itemID];
}

/*
#pragma mark - VPSImageScrollingTableViewCellDelegate

- (void)scrollingTableViewCell:(VPSImageScrollingTableViewCell *)scrollingTableViewCell didSelectImageAtIndexPath:(NSIndexPath*)indexPathOfImage atCategoryRowIndex:(NSInteger)categoryRowIndex
{
    
    NSDictionary *images = [self.images objectAtIndex:categoryRowIndex];
    NSArray *imageCollection = [images objectForKey:@"images"];
    NSString *imageTitle = [[imageCollection objectAtIndex:[indexPathOfImage row]]objectForKey:@"title"];
    NSString *categoryTitle = [[self.images objectAtIndex:categoryRowIndex] objectForKey:@"category"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"Image %@",imageTitle]
                                                    message:[NSString stringWithFormat: @"in %@",categoryTitle]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}
 */

@end
