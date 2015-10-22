//
//  MyProfileViewController.m
//  KitappApplication
//
//  Created by Olga Khvan on 07.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "MyProfileViewController.h"
#import "UIImage+Scale.h"
#import "Parse/Parse.h"
#import "TableViewCell.h"
#import "MBTwitterScroll.h"
#import "Book.h"
#import "ReviewBookViewController.h"

@interface MyProfileViewController ()<TableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *booksArray;
@property (nonatomic) NSIndexPath *lastSelectedItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //COLORS
    UIColor *brownColor = [UIColor colorWithRed:116/255.0 green:92/255.0 blue:78/255.0 alpha:1.0];
    UIColor *beigeLightColor = [UIColor colorWithRed:1.0 green:249/255.0 blue:243/255.0 alpha:1.0];
    UIColor *beigeDarkColor = [UIColor colorWithRed:238/255.0 green:225/255.0 blue:208/255.0 alpha:1.0];
    UIColor *darkBrownColor = [UIColor colorWithRed:117/255.0 green:91/255.0 blue:78/255.0 alpha:1];
    UIColor *brownReddishColor = [UIColor colorWithRed:138/255.0 green:82/255.0 blue:51/255.0 alpha:1];
    self.view.backgroundColor = beigeLightColor;
    //[_tableView initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = beigeLightColor;
    _booksArray = [NSMutableArray new];
    //_tableView.translatesAutoresizingMaskIntoConstraints = NO;



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getDataFromParse];
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
             //[_refreshControl endRefreshing];
         }
         else {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         
     }];
}

#pragma mark - Buttons methods
-(void) logoutButtonPressed{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logoutVCtoMain" sender:nil];

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
































