//
//  PopularBooksViewController.m
//  KitappApplication
//
//  Created by Olga Khvan on 01.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "PopularBooksViewController.h"
#import "UIImage+Scale.h"
#import "CollectionViewCellClass.h"
#import <Parse/Parse.h>
#import "Book.h"
#import "TableViewCell.h"
#import "ReviewBookViewController.h"
#import "CollectionViewCellClass.h"
#import "CBStoreHouseRefreshControl/CBStoreHouseRefreshControl.h"

@interface PopularBooksViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, CollectionViewCellDelegate, UIScrollViewDelegate>

@property (nonatomic) UIButton *tableViewButton;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UILabel *windowTitle;

@property (nonatomic) NSMutableArray *booksArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CollectionViewCellClass *lastCell;

@property (nonatomic) NSArray *books;
@property (nonatomic) NSArray *searchResults;

@property (nonatomic) NSIndexPath *lastSelectedItem;



@property (nonatomic) UIRefreshControl *refreshControl;
@end

@implementation PopularBooksViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewButton = [UIButton new];
    
    //colors
    UIColor *brownColor = [UIColor colorWithRed:116/255.0 green:92/255.0 blue:78/255.0 alpha:1.0];
    UIColor *beigeLightColor = [UIColor colorWithRed:1.0 green:249/255.0 blue:243/255.0 alpha:1.0];
    UIColor *beigeDarkColor = [UIColor colorWithRed:238/255.0 green:225/255.0 blue:208/255.0 alpha:1.0];
    UIColor *darkBrownColor = [UIColor colorWithRed:117/255.0 green:91/255.0 blue:78/255.0 alpha:1];
    UIColor *brownReddishColor = [UIColor colorWithRed:138/255.0 green:82/255.0 blue:51/255.0 alpha:1];
 
    UIView *barView = [UIView new];
    barView.backgroundColor = beigeLightColor;
    UIBezierPath *barShadowPath = [UIBezierPath bezierPathWithRect:barView.bounds];
    barView.layer.shadowColor = [UIColor blackColor].CGColor;
    barView.layer.shadowOffset = CGSizeMake(1,1);
    barView.layer.shadowOpacity = 0.5f;
    barView.layer.shadowPath = barShadowPath.CGPath;
    [self.view addSubview:barView];
    barView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    
    UIView *seperatorView = [UIView new];
    seperatorView.backgroundColor = darkBrownColor;
    seperatorView.alpha = 0.5;
    [self.view addSubview:seperatorView];
    seperatorView.frame = CGRectMake(0, 60, self.view.frame.size.width, 1);
    
    
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:238/255.0 alpha:1.0];


    _searchBar = [UISearchBar new];

    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableView)]];
    
    //title label
    _windowTitle = [UILabel new];
    [_windowTitle setFont:[UIFont fontWithName:@"Helvetica-Light" size:22]];
    _windowTitle.textAlignment = NSTextAlignmentCenter;
    _windowTitle.textColor = brownColor;
    _windowTitle.text = @"Все книги";
    [self.view addSubview:_windowTitle];
    _windowTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_windowTitle]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_windowTitle)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_windowTitle]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_windowTitle)]];
    
    //buttons
    _tableViewButton.frame = CGRectMake(10, 100, 25, 25);
    UIImage *imgTableViewLight = [UIImage imageNamed:@"tableViewLightIcon.png"];
    imgTableViewLight = [imgTableViewLight scaledToSize:CGSizeMake(25, 25)];
    [_tableViewButton setImage:imgTableViewLight forState:UIControlStateNormal];
    
    _tableViewButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_tableViewButton];
    
    _tableViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_tableViewButton]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableViewButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[_tableViewButton]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableViewButton)]];
    [_tableViewButton addTarget:self
                         action:@selector(tableViewButtonPressed)
       forControlEvents:UIControlEventTouchUpInside];
    
    _tableViewButton.hidden = YES;
    
    //search bar
    _searchBar.layer.masksToBounds = YES;
    [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    _searchBar.backgroundImage = [UIImage imageNamed:@"searchBarBg.png"];
    _searchBar.alpha = 0.5f;
    [self.view addSubview:_searchBar];
    _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_searchBar]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_searchBar)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-90-[_searchBar]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_searchBar)]];
    _searchBar.hidden = YES;
    //search arrays
    _searchResults = [NSArray new];
    _books = [NSArray new];
    /*_refreshControl = [CBStoreHouseRefreshControl new];
    _refreshControl = [CBStoreHouseRefreshControl attachToScrollView:_collectionView
                                                    target:self
                                                       refreshAction:@selector(refreshTriggered:)
                                                    plist:@"plist"
                                                    color:[UIColor redColor]
                                                    lineWidth:1.5
                                                    dropHeight:0
                                                    scale:1
                                                    horizontalRandomness:50
                                                    reverseLoadingAnimation:NO
                                                    internalAnimationFactor:0.5];*/
    
    _refreshControl = [UIRefreshControl new];
    [_refreshControl addTarget:self action:@selector(refreshTriggered:) forControlEvents:UIControlEventValueChanged];
    _tableView.hidden = NO;
    [self getDataFromParse];


}

-(void)viewWillAppear:(BOOL)animated{
    //[self getDataFromParse];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)getDataFromParse
{
    self.booksArray = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Book"];
    [query includeKey:@"owner"];
    [query includeKey:@"genre"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error){
             for (Book *object in objects){
                 [self.booksArray addObject:object];
                // NSLog(@"Title of book: %@", object.title);
             }
             [_tableView reloadData];
             //[self.tableView reloadData];
             [_refreshControl endRefreshing];
         }
         else {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         
     }];
}
#pragma mark - Table view methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.booksArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:1.0 green:249/255.0 blue:243/255.0 alpha:1.0];
    Book *object = [_booksArray objectAtIndex:indexPath.row];
    NSLog(@"object is %@", object);
    
    [object fetchIfNeededInBackgroundWithBlock:^(PFObject * object, NSError * _Nullable error) {
        PFFile *imageFile = [object objectForKey:@"image"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            UIImage *image = [UIImage imageWithData:data];
            image = [image scaledToSize:CGSizeMake(150, 210)];
            [cell.bookImage setImage:image];
        }];
        cell.titleLabel.text = object[@"title"];
        NSLog(@"title label:   %@", cell.titleLabel);
        //cell.imageView.image = [[UIImage imageNamed:@"bg2_4s.jpg"] scaledToSize:CGSizeMake(150/2, 200/2)];
        cell.authorLabel.text = object[@"author"];
        cell.priceLabel.text = [NSString stringWithFormat:@"KZT %@", object[@"price"]];
        [cell layoutIfNeeded];
        cell.delegate = self;
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _lastSelectedItem = indexPath;
    [self performSegueWithIdentifier:@"toReviewBookVC" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewBookViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewBookViewController"];
    nextVC.book = self.booksArray[indexPath.row];
    
    [self presentViewController:nextVC animated:YES completion:nil];
}



#pragma mark - Segue methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[ReviewBookViewController class]]) {
        ReviewBookViewController *nextVC = segue.destinationViewController;
        nextVC.book = self.booksArray[self.lastSelectedItem.row];
    }
    
}
@end






















