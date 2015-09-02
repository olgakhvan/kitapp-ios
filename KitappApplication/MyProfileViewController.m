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

@interface MyProfileViewController ()

@property (nonatomic) UIImageView *avatarView;
@property (nonatomic) UILabel *usernameLabel;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UILabel *emailLabel;
@property (nonatomic) UILabel *telephoneLabel;
@property (nonatomic) UILabel *locationLabel;
@property (nonatomic) UILabel *genreLabel;
@property (nonatomic) UILabel *numberOfBooksLabel;
@property (nonatomic) UIButton *editButton;
@property (nonatomic) UIImageView *backgroundView;
@property (nonatomic) UIButton *logoutButton;

@end

@implementation MyProfileViewController
@synthesize avatarView = _avatarView;
@synthesize usernameLabel = _usernameLabel;
@synthesize dateLabel = _dateLabel;
@synthesize emailLabel = _emailLabel;
@synthesize telephoneLabel = _telephoneLabel;
@synthesize locationLabel = _locationLabel;
@synthesize numberOfBooksLabel = _numberOfBooksLabel;
@synthesize genreLabel = _genreLabel;
@synthesize editButton = _editButton;
@synthesize backgroundView = _backgroundButton;
@synthesize logoutButton = _logoutButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _avatarView = [UIImageView new];
    _usernameLabel = [UILabel new];
    _dateLabel = [UILabel new];
    _emailLabel = [UILabel new];
    _telephoneLabel = [UILabel new];
    _locationLabel = [UILabel new];
    _numberOfBooksLabel = [UILabel new];
    _genreLabel = [UILabel new];
    _editButton = [UIButton new];
    _backgroundButton = [UIButton new];
    _logoutButton = [UIButton new];
    
    PFUser *user = [PFUser currentUser];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0];
    /*_backgroundButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0];
    _backgroundButton.translatesAutoresizingMaskIntoConstraints = NO;
    _backgroundButton.frame = CGRectMake(0, 330, self.view.frame.size.width, 150);
    [self.view addSubview:_backgroundButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backgroundButton]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_backgroundButton)]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_backgroundButton]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_backgroundButton)]];*/
    //logout button
    //_logoutButton.backgroundColor = [UIColor redColor];
    //UIImage *logoutImage = [UIImage imageNamed:@"logoutIcon.png"];
    //logoutImage = [logoutImage scaledToSize:CGSizeMake(25, 25)];
    //[_logoutButton setImage:logoutImage forState:UIControlStateNormal];
    [_logoutButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [_logoutButton setTitle:@"выйти" forState:UIControlStateNormal];
    _logoutButton.layer.borderColor = [UIColor brownColor].CGColor;
    _logoutButton.layer.borderWidth = 1.0;
    [self.view addSubview:_logoutButton];
    _logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_logoutButton addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_logoutButton]-80-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_logoutButton)]];

    
    //avatar view
    PFFile *imageFile = user[@"avatar"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        UIImage *image = [UIImage imageWithData:data];
        image = [image scaledToSize:CGSizeMake(self.view.frame.size.width, 350)];
        _avatarView.image = image;
        //_avatarView.frame = CGRectMake(self.view.frame.size.width/2, 0, 200, 350);
    }];
    [self.view addSubview:_avatarView];
    _avatarView.layer.masksToBounds = YES;
    _avatarView.layer.cornerRadius = 60.f;
    //_avatarView.layer.borderWidth = 5.f;
    //_avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarView.alpha = 0.8;
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *metrics = @{@"avatarViewLeftMargin" : @(self.view.frame.size.width/2 - 60)};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-avatarViewLeftMargin-[_avatarView(120)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:NSDictionaryOfVariableBindings(_avatarView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_avatarView(120)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_avatarView)]];
    
    
    //username label
    _usernameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    _usernameLabel.textColor = [UIColor brownColor];
    _usernameLabel.textAlignment = NSTextAlignmentCenter;
    _usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _usernameLabel.text = user.username;
    [self.view addSubview:_usernameLabel];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_usernameLabel]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_usernameLabel)]];
    
    //email label
    _emailLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    _emailLabel.textColor = [UIColor brownColor];
    _emailLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_emailLabel];
    _emailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _emailLabel.text = [NSString stringWithFormat:@"E-mail: %@", user.email];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_emailLabel]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_emailLabel)]];
    
    //telephone label
    _telephoneLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    _telephoneLabel.textColor = [UIColor brownColor];
    _telephoneLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_telephoneLabel];
    _telephoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
    if (user[@"telephone"]){
        _telephoneLabel.text = [NSString stringWithFormat:@"Телефон: %@", user[@"telephone"]];
    }
    else{
            _telephoneLabel.text = [NSString stringWithFormat:@"Телефон: не указан"];
    }

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_telephoneLabel]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_telephoneLabel)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-170-[_usernameLabel]-30-[_emailLabel]-10-[_telephoneLabel]-100-[_logoutButton]"
                                                                      options:0
                                                                      metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_usernameLabel, _emailLabel, _telephoneLabel, _logoutButton)]];
    
    //date label
    /*_dateLabel.font = [UIFont fontWithName:@"Helvetica-Thin" size:9];
    _dateLabel.textColor = [UIColor brownColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_dateLabel];
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dateLabel.text = [NSString stringWithFormat:@"Здесь с: %@", user.createdAt];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_dateLabel]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_dateLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[_dateLabel]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_dateLabel)]];*/
    
    //seperator button
    _backgroundButton.backgroundColor = [UIColor brownColor];
    _backgroundButton.alpha = 0.4;
    _backgroundButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_backgroundButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_backgroundButton]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_backgroundButton)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-210-[_backgroundButton(1)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_backgroundButton)]];
    
    //initialize
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) logoutButtonPressed{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logoutVCtoMain" sender:nil];

}


@end
