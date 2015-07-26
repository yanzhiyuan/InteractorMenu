//
//  ViewController.m
//  InteractorMenu
//
//  Created by Zhi Yuan Yan on 2015-07-24.
//

#import "ViewController.h"
#import "VPSMenuViewController.h"

@interface ViewController ()

@property (strong, nonatomic) VPSMenuViewController* backgroundMenu;
@property (strong, nonatomic) UIImageView* backgroundMenuIcon;
@property VPSMenuInteractor* interactiveTransition;

@property (strong, nonatomic) IBOutlet UIImageView *bgImgeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.interactiveTransition = [[VPSMenuInteractor alloc]init];
    [self.interactiveTransition attachToPresentingVC:self];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.backgroundMenuIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.backgroundMenuIcon setImage:[UIImage imageNamed:@"arrow"]];
    [self.view addSubview:self.backgroundMenuIcon];
    
    self.backgroundMenu = [storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];
    self.backgroundMenu.transitioningDelegate = self.interactiveTransition;
    self.backgroundMenu.modalPresentationStyle = UIModalPresentationCustom;
    self.backgroundMenu.view.frame = CGRectZero;
    self.backgroundMenu.menuCallBackDelegate = self;
    self.backgroundMenu.menuId = @"BACKGROUND";
    
    [self.interactiveTransition attachMenu:self.backgroundMenu Icon:self.backgroundMenuIcon];
    self.backgroundMenuIcon.frame= CGRectMake(CGRectGetMinX(self.view.bounds)+60, CGRectGetMaxY(self.view.bounds) - 50,50,50);
    
    NSMutableDictionary* bgDic = [[NSMutableDictionary alloc]init];
    
    NSString* templateJsonPath = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"json"];
    NSError* error = nil;
    NSData* jsonData = [NSData dataWithContentsOfFile:templateJsonPath options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSArray* pages = [jsonObject valueForKeyPath:@"pages"];
    
    NSDictionary* page;
    NSString* pageJsonPath;
    NSData* pageJsonData;
    NSDictionary* pageJsonObject;
    
    for(int i =0 ; i< pages.count; i++){
        page = (NSDictionary*) pages[i];
        //NSLog(@"page name: %@", [page valueForKeyPath:@"pageName"]);
        pageJsonPath = [[NSBundle mainBundle] pathForResource:[page valueForKeyPath:@"pageName"] ofType:@"json"];
        pageJsonData = [NSData dataWithContentsOfFile:pageJsonPath options:NSDataReadingMappedIfSafe error:&error];
        pageJsonObject = [NSJSONSerialization JSONObjectWithData:pageJsonData options:NSJSONReadingAllowFragments error:&error];
        
        NSString* catName = [pageJsonObject valueForKeyPath:@"category"];
        if([bgDic valueForKey:catName] == nil){
            [bgDic setValue:[[NSMutableArray alloc]init] forKey:catName];
        }
        
        NSMutableArray* catBgArray = [bgDic valueForKey:catName];
        [catBgArray addObject:@{@"name": [pageJsonObject valueForKeyPath:@"image"], @"title":@""}];
    }
    
    self.backgroundMenu.images = [[NSMutableArray alloc]init];
    
    for(NSString* key in bgDic){
        [self.backgroundMenu.images addObject:@{@"category":key, @"images":[bgDic valueForKey:key]}];
    }
    
    [self.backgroundMenu refreshMenuItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUserInteractiveExceptView:(UIView*) subview interactive:(BOOL)interactive{
    for (UIView* v in self.view.subviews) {
        if(v != subview){
            v.userInteractionEnabled = interactive;
        }
    }
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.interactiveTransition initMenuInteractor];
}



#pragma mark - VPSMenuCallBackDelegate

- (void)selectMenuItem:(NSString *)menuID didSelectItemID:(NSString*)itemID
{
    NSLog(@"menuID:%@ itemID:%@", menuID, itemID);

    if ([menuID isEqualToString:@"BACKGROUND"]){
        [self.bgImgeView setImage:[UIImage imageNamed:itemID ]];
    }
    [self.interactiveTransition dismissMenu:self.backgroundMenu Icon:self.backgroundMenuIcon];

}

#pragma end


@end
