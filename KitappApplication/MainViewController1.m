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

@end

@implementation MainViewController1
/*@synthesize signupButton = _signupButton;
@synthesize loginButton = _loginButton;
@synthesize bg1 = _bg1;
@synthesize logoImage = _logoImage;
@synthesize bg1Label = _bg1Label;*/

- (void)viewDidLoad {
    [super viewDidLoad];
    _signupButton = [UIButton new];
    _loginButton = [UIButton new];
    _bg1 = [UIImageView new];
    _logoImage = [UIImageView new];
    _bg1Label = [UILabel new];
    
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
    //label1
    //_bg1Label.text = @"подари старым книгам вторую жизнь";
    _bg1Label.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    _bg1Label.textAlignment = NSTextAlignmentCenter;
    _bg1Label.translatesAutoresizingMaskIntoConstraints = NO;
    _bg1Label.textColor = [UIColor whiteColor];
    [self.view addSubview:_bg1Label];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_bg1Label]-30-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_bg1Label)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bg1Label]-100-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_bg1Label)]];
    
    //signup button
    _signupButton.layer.masksToBounds = YES;
    //_signupButton.layer.cornerRadius = 5.f;
    _signupButton.layer.borderWidth = 1.f;
    [_signupButton setTitle:@"Регистрация" forState:UIControlStateNormal];
    _signupButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    _signupButton.layer.borderColor = [UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0].CGColor;
    [self.view addSubview:_signupButton];
    
    _signupButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_signupButton(130)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_signupButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_signupButton(45)]-15-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_signupButton)]];
    [_signupButton addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    
    //login button
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setTitle:@"Войти" forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    _loginButton.layer.backgroundColor = [UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0].CGColor;
    [_loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_loginButton];
    
    _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_loginButton(130)]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_loginButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_loginButton(45)]-15-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_loginButton)]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) signupButtonPressed:(UIButton *)button
{
    [self performSegueWithIdentifier:@"MVC1ToSignupVC" sender:self];
}

-(void) loginButtonPressed: (UIButton *) button{
    [self performSegueWithIdentifier:@"MVC1ToLoginVC" sender:self];
}
@end
