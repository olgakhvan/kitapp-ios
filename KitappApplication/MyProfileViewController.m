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
#import "Book.h"
#import "ReviewBookViewController.h"
#import "Colors.h"
#import "UIImage+Scale.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MyProfileViewController ()<TableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic) UITableView *tableView;

@property (nonatomic) NSMutableArray *myBooksArray;
@property (nonatomic) NSMutableArray *likedBooksArray;

@property (nonatomic) NSIndexPath *lastSelectedItem;
@property (nonatomic) NSInteger segmentedControlIndex;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIButton *editButton;
@property (nonatomic) UIButton *logoutButton;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *telephoneLabel;
@property (nonatomic) UIImageView *avatarImageView;
@property (nonatomic) UIView *tableViewHeaderView;
@property (nonatomic) MBProgressHUD *hud;


@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //COLORS
    
    self.view.backgroundColor = [Colors beigeLightColor];
    
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [Colors beigeLightColor];
    
    
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableView)]];
    _tableView.backgroundColor = [Colors beigeLightColor];
    self.segmentedControlIndex = 0;
    [self tableViewHeaderDesign];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getMyBooksFromParse];
}

-(void) getLikedBooksFromParse
{
    NSLog(@"I am here 2");
    self.likedBooksArray = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Bookmark"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"book"];
    [query includeKey:@"book.genre"];
    [query includeKey:@"book.owner"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        NSLog(@"I am here 2.5");
        if (!error) {
            NSLog(@"I am here 2.6 with objects = %@", objects);
            for (PFObject *object in objects) {
                PFObject *bookObject = object[@"book"];
                if (bookObject) [self.likedBooksArray addObject:bookObject];
            }
            NSLog(@"I am here 3");
            [self.hud hide:YES];
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
}

-(void)getMyBooksFromParse
{
    self.myBooksArray = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Book"];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
    [query includeKey:@"owner"];
    [query includeKey:@"genre"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error){
             for (Book *object in objects){
                 [self.myBooksArray addObject:object];
                 // NSLog(@"Title of book: %@", object.title);
             }
             NSLog(@"I am here");
             [self getLikedBooksFromParse];
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

-(void) segmentedControlPressed: (UISegmentedControl *) sControl
{
    if (sControl.selectedSegmentIndex == 0) {
        if (self.segmentedControlIndex != 0) {
            self.segmentedControlIndex = 0;
            [self.tableView reloadData];
        }
    } else {
        if (self.segmentedControlIndex != 1) {
            self.segmentedControlIndex = 1;
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Table view methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentedControlIndex == 0) {
        return [self.myBooksArray count];
    } else {
        return [self.likedBooksArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:1.0 green:249/255.0 blue:243/255.0 alpha:1.0];
    Book *object = nil;
    
    if (self.segmentedControlIndex == 0) {
        object = self.myBooksArray[indexPath.row];
    } else {
        object = self.likedBooksArray[indexPath.row];
    }

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
       cell.titleLabel.frame = CGRectMake(cell.bookImage.frame.size.width+15, 10, self.view.frame.size.width-cell.bookImage.frame.size.width-25, 50);
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
    if (self.segmentedControlIndex == 0) {
        nextVC.book = self.myBooksArray[indexPath.row];
    } else {
        nextVC.book = self.likedBooksArray[indexPath.row];
    }
    
    [self presentViewController:nextVC animated:YES completion:nil];
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40);
    view.backgroundColor = [Colors beigeLightColor];
    
    UIView *border = [UIView new];
    border.backgroundColor = [Colors brownColor];
    border.frame = CGRectMake(0,view.frame.size.height-1, self.view.frame.size.width, 1);
    border.alpha = 0.5;
    [view addSubview:border];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Мои книги", @"Понравившиеся книги"]];
    segmentedControl.frame = CGRectMake (10,5,CGRectGetWidth(self.view.frame)-20, 30);
    [segmentedControl addTarget:self action:@selector(segmentedControlPressed:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = self.segmentedControlIndex;
    [view addSubview:segmentedControl];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

-(void) tableViewHeaderDesign{
    PFUser *currentUser = [PFUser currentUser];
    
    _tableViewHeaderView = [UIView new];
    _tableViewHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 170);
    _tableViewHeaderView.backgroundColor = [Colors beigeLightColor];
    _tableView.tableHeaderView = _tableViewHeaderView;
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.frame = CGRectMake(20,40,100,100);
    _avatarImageView.layer.cornerRadius = 50;
    _avatarImageView.layer.masksToBounds = YES;
    [_tableViewHeaderView addSubview:_avatarImageView];
    PFFile *imageFile = currentUser[@"avatar"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if (!error)
        {
            UIImage *image = [UIImage imageWithData:data];
            image = [image scaledToSize:CGSizeMake(100, 100)];
            _avatarImageView.image = image;
        }
        else{
            NSLog(@"some error");
        }
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = currentUser[@"name"];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame)+10, 40,self.view.frame.size.width-140,40);
    [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:22]];
    [_nameLabel setTextColor:[Colors brownColor]];
    [_tableViewHeaderView addSubview:_nameLabel];
    
    _telephoneLabel = [UILabel new];
    _telephoneLabel.text = currentUser.username;
    _telephoneLabel.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame)+10, CGRectGetMaxY(_nameLabel.frame),self.view.frame.size.width-140,40);
    [_telephoneLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Regular" size:18]];
    [_telephoneLabel setTextColor:[Colors brownColor]];
    [_tableViewHeaderView addSubview:_telephoneLabel];
    
    _logoutButton = [UIButton new];
    _logoutButton.frame = CGRectMake(self.view.frame.size.width-80, 10, 70, 25);
//    UIImage *image = [UIImage imageNamed:@"logoutIcon.png"];
//    [_logoutButton setImage:image forState:UIControlStateNormal];
    [_logoutButton setTitle:@"выйти" forState:UIControlStateNormal];
    [_logoutButton setTitleColor:[Colors beigeLightColor] forState:UIControlStateNormal];
    _logoutButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _logoutButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    _logoutButton.backgroundColor = [Colors brownColor];
    _logoutButton.layer.cornerRadius = 5.f;
    [_logoutButton addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_tableViewHeaderView addSubview:_logoutButton];
}

#pragma mark - Segue methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[ReviewBookViewController class]]) {
        ReviewBookViewController *nextVC = segue.destinationViewController;
        if (self.segmentedControlIndex == 0) {
            nextVC.book = self.myBooksArray[self.lastSelectedItem.row];
        } else {
            nextVC.book = self.likedBooksArray[self.lastSelectedItem.row];
        }
    }
    
}

@end
































