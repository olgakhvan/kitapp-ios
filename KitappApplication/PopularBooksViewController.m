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
@property (nonatomic) UIButton *collectionViewButton;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UILabel *windowTitle;
@property (nonatomic) NSMutableArray *booksArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSInteger lastBook;
@property (nonatomic) NSInteger chosenBook;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *profileItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *bookmarkItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *bookItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *popularItem;
@property (nonatomic) CollectionViewCellClass *lastCell;
@property (nonatomic) NSIndexPath *lastSelectedItem;
@property (nonatomic) CBStoreHouseRefreshControl *refreshControl;
@property (nonatomic) NSArray *books;
@property (nonatomic) NSArray *searchResults;
@end

@implementation PopularBooksViewController
@synthesize tableViewButton = _tableViewButton;
@synthesize collectionViewButton = _collectionViewButton;
@synthesize searchBar = _searchBar;
@synthesize windowTitle = _windowTitle;
@synthesize collectionView = _collectionView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self getDataFromParse];
    UIButton *bgButton = [UIButton new];
    bgButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:249/255.0 blue:243/255.0 alpha:1.0];
   // bgButton.layer.shadowColor = [UIColor brownColor].CGColor;
    UIBezierPath *bgShadowPath = [UIBezierPath bezierPathWithRect:bgButton.bounds];
    bgButton.layer.masksToBounds = NO;
    bgButton.layer.shadowColor = [UIColor blackColor].CGColor;
    bgButton.layer.shadowOffset = CGSizeMake(0, 0);
    bgButton.layer.shadowOpacity = 0.05f;
    bgButton.layer.shadowPath = bgShadowPath.CGPath;
    //bgButton.layer.shadowOffset = CGSizeMake(0, -10);
    [self.view addSubview:bgButton];
    bgButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bgButton]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(bgButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bgButton(120)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(bgButton)]];
    
    _collectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:238/255.0 alpha:1.0];
    
    
    [_collectionView reloadData];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:238/255.0 alpha:1.0];
    UIImage *image = [UIImage new];
    image = [UIImage imageNamed:@"profileIcon.png"];
    image = [image scaledToSize:CGSizeMake(30, 30)];
    self.profileItem.image = image;
    
    image = [UIImage imageNamed:@"bkmrkIcon.png"];
    image = [image scaledToSize:CGSizeMake(30, 30)];
    self.bookmarkItem.image = image;
    
    image = [UIImage imageNamed:@"bookIcon.png"];
    image = [image scaledToSize:CGSizeMake(30, 30)];
    self.bookItem.image = image;
    
    image = [UIImage imageNamed:@"favoritesIcon.png"];
    image = [image scaledToSize:CGSizeMake(30, 30)];
    self.popularItem.image = image;
    
    self.tableView.hidden = YES;
    self.booksArray = [NSMutableArray new];
    
    _tableViewButton = [UIButton new];
    _collectionViewButton = [UIButton new];
    _searchBar = [UISearchBar new];
    _windowTitle = [UILabel new];
    self.lastBook = -1;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[CollectionViewCellClass class] forCellWithReuseIdentifier:@"Cell"];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-120-[_collectionView]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_tableView]-20-|"
                                                                    options:0
                                                                    metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[_tableView]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableView)]];
    
    
    //title label
    _windowTitle.textAlignment = NSTextAlignmentLeft;
    _windowTitle.textColor = [UIColor colorWithRed:83/255.0 green:48/255.0 blue:29/255.0 alpha:1];
    _windowTitle.font = [UIFont fontWithName:@"IowanOldStyle-Bold" size:25];
    _windowTitle.text = @"Все книги";
    [self.view addSubview:_windowTitle];
    _windowTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_windowTitle]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_windowTitle)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[_windowTitle]"
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
    
    _collectionViewButton.frame = CGRectMake(10, 100, 25, 25);
    UIImage *imgCollectionViewDark = [UIImage imageNamed:@"collectionViewDarkIcon.png"];
    imgCollectionViewDark = [imgCollectionViewDark scaledToSize:CGSizeMake(25, 25)];
    [_collectionViewButton setImage:imgCollectionViewDark forState:UIControlStateNormal];
    
    _collectionViewButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_collectionViewButton];
    
    _collectionViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_collectionViewButton]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionViewButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[_collectionViewButton]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionViewButton)]];
    [_collectionViewButton addTarget:self
                         action:@selector(collectionViewButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    _collectionViewButton.hidden = YES;
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
  /* _refreshControl = [CBStoreHouseRefreshControl new];
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
    
//    UIRefreshControl *refreshControl = [UIRefreshControl new];
//    [refreshControl addTarget:self action:@selector(refreshTriggered:) forControlEvents:UIControlEventValueChanged];
//    [self.collectionView addSubview:refreshControl];


}

-(void)viewWillAppear:(BOOL)animated{
    [self getDataFromParse];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)getDataFromParse
{
    self.booksArray = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    [query includeKey:@"owner"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error){
             for (Book *object in objects){
                 [self.booksArray addObject:object];
                // NSLog(@"Title of book: %@", object.title);
             }
             [self.collectionView reloadData];
             [self.tableView reloadData];
         }
         else {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         
     }];
}

#pragma mark - Collectionview methods
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.booksArray count];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.f;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.height*0.3);
    return size;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(400, 200);
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(400, 10);
    return size;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 100, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCellClass *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Book *object = [Book new];
    object = [self.booksArray objectAtIndex:indexPath.row];
    PFFile *imageFile = object.image;
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        UIImage *image = [UIImage imageWithData:data];
        cell.imageView.image = image;
    }];
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds];
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.layer.shadowOpacity = 0.05f;
    cell.layer.shadowPath = shadowPath.CGPath;
    
    cell.titleLabel.text = object.title;
    cell.authorLabel.text = object[@"author"];
    cell.priceLabel.text = [NSString stringWithFormat:@"KZT %@", object[@"price"]];
    cell.index = indexPath;
    cell.delegate = self;
    cell.deleteButton.hidden = YES;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ReviewBookViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewBookViewController"];
    nextVC.book = self.booksArray[indexPath.row];
    
    [self presentViewController:nextVC animated:YES completion:nil];
    self.lastSelectedItem = indexPath;
    
    
}

#pragma mark - Buttons pressed methods
-(void) tableViewButtonPressed
{
    self.collectionView.hidden = YES;
    self.tableView.hidden = NO;
    UIImage *img1 = [UIImage imageNamed:@"tableViewDarkIcon.png"];
    img1 = [img1 scaledToSize:CGSizeMake(20, 20)];
    [_tableViewButton setImage:img1 forState:UIControlStateNormal];

    UIImage *img2 = [UIImage imageNamed:@"collectionViewLightIcon.png"];
    img2 = [img2 scaledToSize:CGSizeMake(20, 20)];
    [_collectionViewButton setImage:img2 forState:UIControlStateNormal];
}

-(void) collectionViewButtonPressed
{
    self.collectionView.hidden = NO;
    self.tableView.hidden = YES;
    UIImage *img1 = [UIImage imageNamed:@"tableViewLightIcon.png"];
    img1 = [img1 scaledToSize:CGSizeMake(20, 20)];
    [_tableViewButton setImage:img1 forState:UIControlStateNormal];
    
    UIImage *img2 = [UIImage imageNamed:@"collectionViewDarkIcon.png"];
    img2 = [img2 scaledToSize:CGSizeMake(20, 20)];
    [_collectionViewButton setImage:img2 forState:UIControlStateNormal];
}

#pragma  mark - Table view methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.booksArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    Book *object = object = [self.booksArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:131/255.0 green:81/255.0 blue:54/255.0 alpha:1];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0];
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor whiteColor];
    selectionColor.alpha = 0.3;
    cell.selectedBackgroundView = selectionColor;
    cell.textLabel.text = object.title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastSelectedItem = indexPath;
    [self performSegueWithIdentifier:@"toReviewBooksSegue" sender:self];
    
}

#pragma mark - Other methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[ReviewBookViewController class]]) {
        ReviewBookViewController *nextVC = segue.destinationViewController;
        nextVC.book = self.booksArray[self.lastSelectedItem.row]; 
    }
    
}

- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:0.7 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [_refreshControl finishingLoading];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshControl scrollViewDidEndDragging];
}


-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString*)scope{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"имя содержит[c] %@", searchText ];
    _searchResults = [_books filteredArrayUsingPredicate:resultPredicate];
}

@end






















