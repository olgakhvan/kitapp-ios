//
//  MyBooksViewController.m
//  KitappApplication
//
//  Created by Olga Khvan on 08.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "MyBooksViewController.h"
#import "UIImage+Scale.h"
#import "CollectionViewCellClass.h"
#import <Parse/Parse.h>
#import "Book.h"
#import "TableViewCell.h"
#import "ReviewBookViewController.h"
#import "CollectionViewCellClass.h"
#import "CBStoreHouseRefreshControl/CBStoreHouseRefreshControl.h"

@interface MyBooksViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, CollectionViewCellDelegate>

@property (nonatomic) UIButton *tableViewButton;
@property (nonatomic) UIButton *collectionViewButton;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UILabel *windowTitle;
@property (nonatomic) NSMutableArray *booksArray;
@property (nonatomic) IBOutlet UICollectionView *collectionView;
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
@property (nonatomic) NSMutableArray *favoriteBooksArray;
@property (nonatomic) NSMutableArray *myBooksArray;
@property (nonatomic) UIButton *addButton;
@property (nonatomic) UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;
@property (nonatomic) NSMutableArray *books;
@property (nonatomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (nonatomic) CBStoreHouseRefreshControl *refreshControl;
@end

@implementation MyBooksViewController
@synthesize tableViewButton = _tableViewButton;
@synthesize collectionViewButton = _collectionViewButton;
@synthesize searchBar = _searchBar;
@synthesize windowTitle = _windowTitle;
@synthesize collectionView = _collectionView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:238/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:238/255.0 alpha:1.0];


    //_collectionView = [UICollectionView new];
    //[_collectionView reloadData];
    [self.view addSubview:_collectionView];
    _collectionView.tag = 1;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[CollectionViewCellClass class] forCellWithReuseIdentifier:@"Cell"];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[_collectionView]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [self.view addSubview:_collectionView2];
    _collectionView2.tag = 2;
    _collectionView2.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView2.dataSource = self;
    _collectionView2.delegate = self;
    [_collectionView2 registerClass:[CollectionViewCellClass class] forCellWithReuseIdentifier:@"Cell"];
    _collectionView2.hidden = YES;
    _collectionView2.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:238/255.0 alpha:1.0];
    _collectionView2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView2]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionView2)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[_collectionView2]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionView2)]];
    
    
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0];
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
    _favoriteBooksArray = [NSMutableArray new];
    _myBooksArray = [NSMutableArray new];
    
    _tableViewButton = [UIButton new];
    _collectionViewButton = [UIButton new];
    _searchBar = [UISearchBar new];
    _windowTitle = [UILabel new];
    self.lastBook = -1;
    
    _tableView.tag = 1;
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
    _tableView2.tag = 2;
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0];
    _tableView2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_tableView2]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableView2)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[_tableView2]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableView2)]];
    
    _tableView.hidden = YES;
    _tableView2.hidden = YES;
    
    //buttons
    _tableViewButton.frame = CGRectMake(10, 100, 20, 20);
    UIImage *imgTableViewLight = [UIImage imageNamed:@"tableViewLightIcon.png"];
    imgTableViewLight = [imgTableViewLight scaledToSize:CGSizeMake(20, 20)];
    [_tableViewButton setImage:imgTableViewLight forState:UIControlStateNormal];
    
    _tableViewButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_tableViewButton];
    
    _tableViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_tableViewButton]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableViewButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-55-[_tableViewButton]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableViewButton)]];
    [_tableViewButton addTarget:self
                         action:@selector(tableViewButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    
    _collectionViewButton.frame = CGRectMake(10, 100, 20, 20);
    UIImage *imgCollectionViewDark = [UIImage imageNamed:@"collectionViewDarkIcon.png"];
    imgCollectionViewDark = [imgCollectionViewDark scaledToSize:CGSizeMake(20, 20)];
    [_collectionViewButton setImage:imgCollectionViewDark forState:UIControlStateNormal];
    
    _collectionViewButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_collectionViewButton];
    
    _collectionViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_collectionViewButton]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionViewButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-55-[_collectionViewButton]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionViewButton)]];
    [_collectionViewButton addTarget:self
                              action:@selector(collectionViewButtonPressed)
                    forControlEvents:UIControlEventTouchUpInside];
    
    _addButton = [UIButton new];
    _addButton.frame = CGRectMake(10, 100, 20, 20);
    //UIImage *imgAddButton = [UIImage imageNamed:@"addIcon.png"];
    //imgAddButton = [imgAddButton scaledToSize:CGSizeMake(20, 20)];
    //[_addButton setImage:imgAddButton forState:UIControlStateNormal];
    [_addButton setTitle:@"добавить книгу" forState:UIControlStateNormal];
    _addButton.alpha = 0.7;
    [_addButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    _addButton.titleLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:14.0];
    _addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _addButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _addButton.layer.borderWidth = 1.0;
    _addButton.layer.borderColor = [UIColor brownColor].CGColor;
    [self.view addSubview:_addButton];
    
    _addButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_addButton]-80-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_addButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[_addButton(30)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_addButton)]];
    [_addButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    if (_segmentedControl.selectedSegmentIndex == 0){
        _addButton.hidden = YES;
    }
    
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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-105-[_searchBar]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_searchBar)]];
    _searchBar.hidden = YES;
    //segmented control
    NSDictionary *metrics = @{@"segmentedControlHorizontalConstraint" : @(self.view.frame.size.width/2 + 20)
                              };
    _segmentedControl = [UISegmentedControl new];
    NSArray *segmentedControlContent = [[NSArray alloc] initWithObjects:@"Понравившиеся",@"На продажу", nil];
    _segmentedControl = [_segmentedControl initWithItems:segmentedControlContent];
    [self.view addSubview:_segmentedControl];
    _segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    _segmentedControl.selectedSegmentIndex = 0;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_segmentedControl]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_segmentedControl)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_segmentedControl(25)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_segmentedControl)]];
    [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged) forControlEvents:UIControlEventValueChanged];
    
    _tableViewButton.hidden = YES;
    _collectionViewButton.hidden = YES;
    
    /* _refreshControl = [CBStoreHouseRefreshControl attachToScrollView:_collectionView
                                                              target:self
                                                       refreshAction:@selector(refreshTriggered:)
                                                               plist:@"plist"
                                                               color:[UIColor redColor]
                                                           lineWidth:1.5
                                                          dropHeight:80
                                                               scale:1
                                                horizontalRandomness:50
                                             reverseLoadingAnimation:NO
                                             internalAnimationFactor:0.5];
    
    _refreshControl = [CBStoreHouseRefreshControl attachToScrollView:_collectionView2
                                                              target:self
                                                       refreshAction:@selector(refreshTriggered:)
                                                               plist:@"plist"
                                                               color:[UIColor redColor]
                                                           lineWidth:1.5
                                                          dropHeight:80
                                                               scale:1
                                                horizontalRandomness:50
                                             reverseLoadingAnimation:NO
                                             internalAnimationFactor:0.5];*/
    
    
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _myBooksArray = [NSMutableArray new];
    _favoriteBooksArray = [NSMutableArray new];
    [self getDataFromParse];
    //NSLog(@"got data from parse");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getDataFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Bookmarks"];
    [query includeKey:@"user"];
    [query includeKey:@"book"];
    PFUser *user = [PFUser currentUser];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error){
             for (PFObject *object in objects){
                 PFUser *user2 = object[@"user"];
                 if ([user2.objectId isEqualToString:user.objectId]){
                     if (object[@"book"]){
                         [_favoriteBooksArray addObject:object[@"book"]];
                         [_collectionView reloadData];
                     }

                 }
                 else{
                     NSLog(@"Error in getting objects");
                     
                 }
             }
             [self.collectionView reloadData];
             [self.tableView reloadData];
         }
         else {
         }
         
     }];
    
   PFQuery *query2 = [PFQuery queryWithClassName:@"Books"];
    [query2 includeKey:@"owner"];
    [query2 orderByDescending:@"createdAt"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error){
            for (PFObject *object in objects){
                PFUser *newUser = object[@"owner"];
                if ([newUser.objectId isEqual:user.objectId]){
                    if (object[@"book"]){
                        [_favoriteBooksArray addObject:object[@"book"]];
                        [_collectionView2 reloadData];
                    }
                    [_myBooksArray addObject:object];
                    //NSLog(@"my books array count %ld", [_myBooksArray count]);
                    //NSLog(@"my book was added");
                }
            }
           [_collectionView2 reloadData];
        
        }
        else{
            NSLog(@"error in query2");
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
    NSLog(@"collectionview tag %ld", collectionView.tag);
    if (collectionView.tag == 2){
        NSLog(@"logged in books array");
        return [_myBooksArray count];
        
    }
    else{
        if (collectionView.tag == 1){
            NSLog(@"logged in books array");
            return [_favoriteBooksArray count];
        }
    }
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.height*0.3);
    return size;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(150, 100);
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(100, 10);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCellClass *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Book *object = [Book new];
    if(collectionView.tag == 2){
            object = [_myBooksArray objectAtIndex:indexPath.row];
    }
        else{
            object = [_favoriteBooksArray objectAtIndex:indexPath.row];
    }
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
    return cell;

    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ReviewBookViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewBookViewController"];
    if (_segmentedControl.selectedSegmentIndex == 0){
        nextVC.book = _favoriteBooksArray[indexPath.row];
        
    }
    else{
        nextVC.book = _myBooksArray[indexPath.row];
        
        
    }

    [self presentViewController:nextVC animated:YES completion:nil];
    self.lastSelectedItem = indexPath;
    
    
}

#pragma mark - Buttons pressed methods
-(void) tableViewButtonPressed
{
    if (_segmentedControl.selectedSegmentIndex == 0){
        self.tableView.hidden = NO;
        UIImage *img1 = [UIImage imageNamed:@"tableViewDarkIcon.png"];
        img1 = [img1 scaledToSize:CGSizeMake(20, 20)];
        [_tableViewButton setImage:img1 forState:UIControlStateNormal];
        
        UIImage *img2 = [UIImage imageNamed:@"collectionViewLightIcon.png"];
        img2 = [img2 scaledToSize:CGSizeMake(20, 20)];
        [_collectionViewButton setImage:img2 forState:UIControlStateNormal];
        self.collectionView.hidden = YES;
    }
    else{
        _tableView2.hidden = NO;
        UIImage *img1 = [UIImage imageNamed:@"tableViewDarkIcon.png"];
        img1 = [img1 scaledToSize:CGSizeMake(20, 20)];
        [_tableViewButton setImage:img1 forState:UIControlStateNormal];
        
        UIImage *img2 = [UIImage imageNamed:@"collectionViewLightIcon.png"];
        img2 = [img2 scaledToSize:CGSizeMake(20, 20)];
        [_collectionViewButton setImage:img2 forState:UIControlStateNormal];
        self.collectionView2.hidden = YES;
    }


}

-(void) collectionViewButtonPressed
{
  /*  if (_segmentedControl.selectedSegmentIndex == 0){
        self.collectionView.hidden = NO;
        self.tableView.hidden = YES;
        UIImage *img1 = [UIImage imageNamed:@"tableViewLightIcon.png"];
        img1 = [img1 scaledToSize:CGSizeMake(20, 20)];
        [_tableViewButton setImage:img1 forState:UIControlStateNormal];
        
        UIImage *img2 = [UIImage imageNamed:@"collectionViewDarkIcon.png"];
        img2 = [img2 scaledToSize:CGSizeMake(20, 20)];
        [_collectionViewButton setImage:img2 forState:UIControlStateNormal];
    }
    else{
        self.collectionView2.hidden = NO;
        self.tableView.hidden = YES;
        UIImage *img1 = [UIImage imageNamed:@"tableViewLightIcon.png"];
        img1 = [img1 scaledToSize:CGSizeMake(20, 20)];
        [_tableViewButton setImage:img1 forState:UIControlStateNormal];
        
        UIImage *img2 = [UIImage imageNamed:@"collectionViewDarkIcon.png"];
        img2 = [img2 scaledToSize:CGSizeMake(20, 20)];
        [_collectionViewButton setImage:img2 forState:UIControlStateNormal];
    }*/

}

-(void)addButtonPressed{
    [self performSegueWithIdentifier:@"toAddBookVC" sender:self];
}






#pragma  mark - Table view methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_segmentedControl.selectedSegmentIndex == 0){
        return [_favoriteBooksArray count];
    }
    else{
     return [_myBooksArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    
    Book *object = [Book new];
    if (_segmentedControl.selectedSegmentIndex == 0){
        object = [_favoriteBooksArray objectAtIndex:indexPath.row];
    }
    else{
        object = [_myBooksArray objectAtIndex:indexPath.row];
    }
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
    ReviewBookViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewBookViewController"];
    if (_segmentedControl.selectedSegmentIndex == 0){
        nextVC.book = _favoriteBooksArray[indexPath.row];
        
    }
    else{
        nextVC.book = _myBooksArray[indexPath.row];
        
        
    }
    
    [self presentViewController:nextVC animated:YES completion:nil];
    self.lastSelectedItem = indexPath;
    
}

#pragma mark - Other methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ReviewBookViewController class]]) {
        ReviewBookViewController *nextVC = segue.destinationViewController;
        nextVC.book = _favoriteBooksArray[self.lastSelectedItem.row];
    }
}

-(void)segmentedControlValueChanged{
    if (_segmentedControl.selectedSegmentIndex == 0){
        _collectionView2.hidden = YES;
        _collectionView.hidden = NO;
        _addButton.hidden = YES;
        [_collectionView2 reloadData];
    }
    else{
        _collectionView2.hidden = NO;
        _collectionView.hidden = YES;
        _addButton.hidden = NO;
        [_collectionView reloadData];
    }
}

#pragma mark - CollectionViewCell Delegate

- (void)cell: (CollectionViewCellClass *)cell deleteButtonDidPress:(UIButton *)button{
    //NSLog(@"Logged in delete");
    if (_segmentedControl.selectedSegmentIndex == 0){
        
        PFQuery *query = [PFQuery queryWithClassName:@"Bookmarks"];
        PFObject *book = [_favoriteBooksArray objectAtIndex:cell.index.row];
        [query whereKey:@"book" equalTo:book];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (!error){
                for (PFObject *object in objects){
                    PFUser *user = object[@"user"];
                    if ([user.objectId isEqualToString:[PFUser currentUser].objectId]){
                        PFObject *newBook = object[@"book"];
                        NSLog(@"user is equal to user! ura!");
                        if ([newBook.objectId isEqualToString:book.objectId]){
                            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                if (succeeded){
                                    NSLog(@"object was deleted");
                                    _favoriteBooksArray = [NSMutableArray new];
                                    _myBooksArray = [NSMutableArray new];
                                    [self getDataFromParse];
                                    [_collectionView reloadData];
                                }
                            }];
                        }
                    }
                }
            }
        }];

    }
    else{
        Book *book = [_myBooksArray objectAtIndex:cell.index.row];
        [book deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded){
                NSLog(@"Deleted");
                _myBooksArray = [NSMutableArray new];
                _favoriteBooksArray = [NSMutableArray new];
                [self getDataFromParse];
            }
            else{
                
            }
        }];
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


@end























