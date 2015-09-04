//
//  LoginViewController.m
//  KitappApplication
//
//  Created by Olga Khvan on 30.06.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <AFViewShaker.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface LoginViewController ()

@property (nonatomic) UITextField *usernameTextField;
@property (nonatomic) UITextField *passwordTextField;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UIImageView *bgImage;
@property (nonatomic) UIButton *separator;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UILabel *errorLabel;
@property (nonatomic) AFViewShaker *shakeView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //initialization
    _usernameTextField = [UITextField new];
    _passwordTextField = [UITextField new];
    _loginButton = [UIButton new];
    _bgImage = [UIImageView new];
    _separator = [UIButton new];
    _cancelButton = [UIButton new];
    
    //bgImage
    //if ()
    _bgImage.image = [UIImage imageNamed:@"bg1_5s.jpg"];
    [self.view addSubview:_bgImage];
    _bgImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bgImage]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_bgImage)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgImage]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_bgImage)]];
    
    //text fields
    _usernameTextField.textAlignment = NSTextAlignmentCenter;
    _usernameTextField.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    _usernameTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    _usernameTextField.placeholder = @"Телефон";
    _usernameTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_usernameTextField];
    _usernameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    _passwordTextField.textAlignment = NSTextAlignmentCenter;
    _passwordTextField.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    _passwordTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    _passwordTextField.placeholder = @"Пароль";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_passwordTextField];
    _passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    _loginButton.layer.masksToBounds = YES;
    _loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loginButton.titleLabel.textColor = [UIColor whiteColor];
    _loginButton.layer.backgroundColor =[UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0].CGColor;
    _loginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    [_loginButton setTitle:@"Войти" forState:UIControlStateNormal];
    [self.view addSubview:_loginButton];
    
    [_loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchDown];
    _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _cancelButton.titleLabel.textColor = [UIColor whiteColor];
    _cancelButton.layer.borderColor = [UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0].CGColor;
    _cancelButton.layer.borderWidth = 1.0;
    //_cancelButton.layer.backgroundColor =[UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0].CGColor;
    _cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    [_cancelButton setImage:[UIImage imageNamed:@"backArrow.png"] forState:UIControlStateNormal];
    [self.view addSubview:_cancelButton];
    
    [_cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchDown];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    _errorLabel = [UILabel new];
    [self.view addSubview:_errorLabel];
    _errorLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.textColor = [UIColor redColor];
    _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _separator.layer.masksToBounds = YES;
    _separator.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3].CGColor;
    _separator.layer.borderWidth = 1.0;
    [self.view addSubview:_separator];
    _separator.translatesAutoresizingMaskIntoConstraints = NO;

    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_errorLabel]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_errorLabel)]];
    

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[_cancelButton(45)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_cancelButton)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-178-[_cancelButton(45)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_cancelButton)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-178-[_loginButton(45)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_loginButton)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_separator]-60-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_separator)]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_usernameTextField]-60-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_usernameTextField)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_passwordTextField]-60-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_passwordTextField)]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-125-[_loginButton]-80-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_loginButton)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[_usernameTextField(40)]-3-[_separator(2)]-3-[_passwordTextField(40)]-10-[_errorLabel]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_usernameTextField, _separator, _passwordTextField, _errorLabel)]];
    

    
    

    
    
    NSArray *allFields = @[_usernameTextField, _passwordTextField];
    _shakeView = [[AFViewShaker alloc] initWithViewsArray:allFields];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


-(void)loginButtonPressed{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Проверка данных";
    
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        
                                        if (user) {
                                            [self performSegueWithIdentifier:@"loginMoveToPopularBooks" sender:self];
                                            NSLog(@"Logged in");
                                            [hud hide:YES];
                                        } else {
                                            [_shakeView shake];
                                            [_errorLabel setText:@"данные введены неправильно"];
                                            [hud hide:YES];
                                            //NSString *errorString = [error userInfo][@"error"];
                                            //NSLog(@"There is an error", errorString);
                                        }
                                    }];
}
-(void)cancelButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

@end
