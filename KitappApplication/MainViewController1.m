//
//  MainViewController1.m
//  KitappApplication
//
//  Created by Olga Khvan on 06.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "MainViewController1.h"
#import <Parse/Parse.h>

@interface MainViewController1 ()


@property (nonatomic) UIImageView *logoImage;
@property (nonatomic) UILabel *bg1Label;
@property (nonatomic) UIImageView *bg1;

@end

@implementation MainViewController1
/*@synthesize signupButton = _signupButton;
@synthesize loginButton = _loginButton;
@synthesize bg1 = _bg1;
@synthesize logoImage = _logoImage;
@synthesize bg1Label = _bg1Label;*/

- (void)viewDidLoad {
    [super viewDidLoad];
    _bg1 = [UIImageView new];
    _logoImage = [UIImageView new];
    _bg1Label = [UILabel new];
    
    //Colors
    UIColor *redColor = [UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];
    
    
    //bg1
    _bg1.image = [UIImage imageNamed:self.imageFile];
    [self.view addSubview:_bg1];
    _bg1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bg1]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_bg1)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bg1]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_bg1)]];
    // main text
    self.bg1Label.text = self.pageText;
    self.bg1Label.textColor = redColor;
    _bg1Label.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    _bg1Label.textAlignment = NSTextAlignmentCenter;
    _bg1Label.translatesAutoresizingMaskIntoConstraints = NO;
    self.bg1Label.numberOfLines = 0;
    [self.view addSubview:_bg1Label];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_bg1Label]-30-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_bg1Label)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bg1Label(50)]-100-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_bg1Label)]];
    
    //kitapp logo
    _logoImage.image = [UIImage imageNamed:@"logo.png"];
    _logoImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_logoImage];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-117-[_logoImage(110)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_logoImage)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-180-[_logoImage(102)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_logoImage)]];
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.delegate viewIsShown:self.pageIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
