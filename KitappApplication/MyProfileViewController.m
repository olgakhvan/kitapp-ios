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
    [_tableView initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _booksArray = [NSMutableArray new];
   // [_tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"tableCell"];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getDataFromParse];
}

-(void)getDataFromParse
{
    _booksArray = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    [query includeKey:@"owner"];
    [query orderByAscending:@"createdAt"];
    _tableView.scrollEnabled = NO;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            for (Book *object in objects)
            {
                [_booksArray addObject:object];
            }
            [_tableView reloadData];
            _tableView.scrollEnabled = YES;
        }
        else
        {
            NSLog(@"Error %@ %@", error, [error userInfo]);
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
    Book *object = [_booksArray objectAtIndex:indexPath.row];
    PFFile *imageFile = object.image;
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        UIImage *image = [UIImage imageWithData:data];
        image = [image scaledToSize:CGSizeMake(150, 210)];
        cell.imageView.image = image;
    }];
    
    cell.titleLabel.text = object.title;
    NSLog(@"title label:   %@", cell.titleLabel);
    cell.imageView.image = [UIImage imageNamed:@"bg2_4s.jpg"]; 
    cell.authorLabel.text = object[@"author"];
    cell.priceLabel.text = [NSString stringWithFormat:@"KZT %@", object[@"price"]];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _lastSelectedItem = indexPath;
    [self performSegueWithIdentifier:@"toReviewBookVC" sender:self];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[ReviewBookViewController class]]) {
        ReviewBookViewController *nextVC = segue.destinationViewController;
        nextVC.book = self.booksArray[self.lastSelectedItem.row];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220.0;
}

@end
































