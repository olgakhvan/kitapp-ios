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
#import "Colors.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PopularBooksViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchDisplayDelegate>

@property (nonatomic) UIButton *tableViewButton;
@property (nonatomic) UILabel *windowTitle;

@property (nonatomic) NSMutableArray *booksArray, *searchResults;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CollectionViewCellClass *lastCell;

@property (nonatomic) NSIndexPath *lastSelectedItem;

@property (nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic) UISearchController *searchController;


@end

@implementation PopularBooksViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Colors beigeLightColor];
    UIView *barView = [UIView new];
    barView.backgroundColor = [Colors beigeLightColor];
    UIBezierPath *barShadowPath = [UIBezierPath bezierPathWithRect:barView.bounds];
    barView.layer.shadowColor = [UIColor blackColor].CGColor;
    barView.layer.shadowOffset = CGSizeMake(1,1);
    barView.layer.shadowOpacity = 0.5f;
    barView.layer.shadowPath = barShadowPath.CGPath;
    [self.view addSubview:barView];
    barView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    
    UIView *seperatorView = [UIView new];
    seperatorView.backgroundColor = [Colors darkBrownColor];
    seperatorView.alpha = 0.5;
    [self.view addSubview:seperatorView];
    seperatorView.frame = CGRectMake(0, 60, self.view.frame.size.width, 1);
    
    //setup the search controller
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    
    //add search bar to the tableview header
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchController.searchBar.backgroundColor = [Colors beigeLightColor];
    self.definesPresentationContext = YES;
    
    
    
    //table view
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [Colors beigeLightColor];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableView)]];
    
    
    //title label
    _windowTitle = [UILabel new];
    [_windowTitle setFont:[UIFont fontWithName:@"Helvetica-Light" size:22]];
    _windowTitle.textAlignment = NSTextAlignmentCenter;
    _windowTitle.textColor = [Colors brownColor];
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

    _tableView.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [self getDataFromParse];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)getDataFromParse
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"Загружаем книги";
    self.booksArray = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Book"];
    [query includeKey:@"owner"];
    [query includeKey:@"genre"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {

        self.tableView.scrollEnabled = NO;
         if (!error){
             for (Book *object in objects){
                 [self.booksArray addObject:object];
             }
             [_tableView reloadData];
             self.tableView.scrollEnabled = YES;
             [hud hide:YES];
         }
         else {
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    else
    {
        return [self.booksArray count];
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:1.0 green:249/255.0 blue:243/255.0 alpha:1.0];
    
    UIImage *image = [[UIImage imageNamed:@"bookPlaceHolder.png"] scaledToSize:CGSizeMake(150, 210)];
    [cell.bookImage setImage:image];
    
    Book *object = [_booksArray objectAtIndex:indexPath.row];
    [object fetchIfNeededInBackgroundWithBlock:^(PFObject * object, NSError * _Nullable error) {
        PFFile *imageFile = [object objectForKey:@"image"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            UIImage *image = [UIImage imageWithData:data];
            cell.bookImage.contentMode = UIViewContentModeScaleAspectFill;
            //image = [image scaledToSize:CGSizeMake(150, 210)];
            [cell.bookImage setImage:image];
        }];
        cell.titleLabel.text = object[@"title"];
        cell.authorLabel.text = object[@"author"];
        cell.priceLabel.text = [NSString stringWithFormat:@"KZT %@", object[@"price"]];
        cell.titleLabel.frame = CGRectMake(cell.bookImage.frame.size.width+15, 10, self.view.frame.size.width-cell.bookImage.frame.size.width-25, 50);
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

/*-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _searchController.searchBar;
}*/

#pragma mark - Segue methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[ReviewBookViewController class]]) {
        ReviewBookViewController *nextVC = segue.destinationViewController;
        nextVC.book = self.booksArray[self.lastSelectedItem.row];
    }
    
}

#pragma mark - Search methods


@end






















