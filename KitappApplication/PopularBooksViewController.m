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

@property (nonatomic) CollectionViewCellClass *lastCell;

@property (nonatomic) NSIndexPath *lastSelectedItem;
@property (nonatomic) NSArray *books;
@property (nonatomic) NSArray *searchResults;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) UIRefreshControl *refreshControl;
@end

@implementation PopularBooksViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewButton = [UIButton new];
    _collectionViewButton = [UIButton new];
    
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
    
    
    _collectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:238/255.0 alpha:1.0];
    [_collectionView reloadData];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:238/255.0 alpha:1.0];


    _searchBar = [UISearchBar new];

    self.lastBook = -1;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[CollectionViewCellClass class] forCellWithReuseIdentifier:@"Cell"];

    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"Cell"];

    
    
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
    [self.collectionView addSubview:_refreshControl];
    _collectionView.hidden = YES;
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
                 _collectionView.scrollEnabled = NO;
                // NSLog(@"Title of book: %@", object.title);
             }
             [self.collectionView reloadData];
             //[self.tableView reloadData];
             [_refreshControl endRefreshing];
             _collectionView.scrollEnabled = YES;
         }
         else {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         
     }];
    [_tableView reloadData];
    [_collectionView reloadData];
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
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*0.3);
    return size;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(self.view.frame.size.width,50);
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(self.view.frame.size.width, 0);
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

#pragma  mark - Table view methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_booksArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Book *book = [_booksArray objectAtIndex:indexPath.row];
    PFFile *imageFile = book.image;
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        UIImage *image = [UIImage imageWithData:data];
        image = [image scaledToSize:CGSizeMake(150, 210)];
        cell.imageView.image = image;
    }];
    NSLog(@"Book title and author %@ %@  ", book.title, book.author);
    cell.titleLabel.text = book.title;
    cell.authorLabel.text = book.author;
    cell.priceLabel.text = [NSString stringWithFormat:@"KZT %@", book[@"price"]];
    //cell.delegate = self;
    return cell;
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
    //[self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:0.7 inModes:@[NSRunLoopCommonModes]];
    [self getDataFromParse];
    //_refreshControl.hidden = YES;
}

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshControl scrollViewDidEndDragging];
}*/

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString*)scope{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"имя содержит[c] %@", searchText ];
    _searchResults = [_books filteredArrayUsingPredicate:resultPredicate];
}

@end






















