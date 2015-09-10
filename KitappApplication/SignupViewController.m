//
//  SignupViewController.m
//  KitappApplication
//
//  Created by Olga Khvan on 30.06.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import <AFViewShaker.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImage+Scale.h"

@interface SignupViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) UIImageView *bgImage;
@property (nonatomic) UIButton *signupButton;
@property (nonatomic) UITextField *passwordTextField;
@property (nonatomic) UITextField *phoneNumberTextField;
@property (nonatomic) UITextField *nameTextField;
@property (nonatomic) UIImageView *avatarView;
@property (nonatomic) UIButton *avatarButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) AFViewShaker *userViewShake;
@property (nonatomic) UILabel *errorLabel;
@property (nonatomic) AFViewShaker *emptyViewShake;
@property (nonatomic) UIScrollView *scrollView;

@end


@implementation SignupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //colors
    UIColor *beigeLightColor = [UIColor colorWithRed:1.0 green:249/255.0 blue:243/255.0 alpha:1.0];
    UIColor *beigeDarkColor = [UIColor colorWithRed:215/255.0 green:201/255.0 blue:191/255.0 alpha:1.0];
    UIColor *darkBrownColor = [UIColor colorWithRed:117/255.0 green:91/255.0 blue:78/255.0 alpha:1];
    UIColor *brownColor = [UIColor colorWithRed:83/255.0 green:48/255.0 blue:29/255.0 alpha:1];

    _scrollView = [UIScrollView new];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-100);
    _scrollView.frame = self.view.bounds;
    [self.view addSubview:_scrollView];
    self.view.backgroundColor = beigeLightColor;
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor colorWithRed:117/255.0 green:91/255.0 blue:78/255.0 alpha:0.5]
                                 };
    
    //avatar image
    _avatarButton = [UIButton new];
    _avatarButton.clipsToBounds = YES;
    _avatarButton.clipsToBounds = YES;
    _avatarButton.layer.cornerRadius = 55.f;
    _avatarButton.backgroundColor = [UIColor brownColor];
    [_avatarButton setImage:[UIImage imageNamed:@"noavatar.png"] forState:UIControlStateNormal];
    _avatarButton.frame = CGRectMake(self.view.frame.size.width*0.5-55, 100, 110, 110);
    [self.scrollView addSubview:_avatarButton];
    [_avatarButton addTarget:self action:@selector(avatarUpload) forControlEvents:UIControlEventTouchDown];
    

    _nameTextField = [UITextField new];
    _nameTextField.textColor = darkBrownColor;
    [_nameTextField setFont:[UIFont fontWithName:@"Helvetica-Light" size:18]];
    _nameTextField.textAlignment = NSTextAlignmentCenter;
    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithString:@"Введите имя пользователя" attributes:attributes];
    _nameTextField.attributedPlaceholder = attributedString1;
    [self setLeftMargin:_nameTextField];
    _nameTextField.frame = CGRectMake(30, CGRectGetMaxY(_avatarButton.frame) + 30, self.view.frame.size.width - 60, 40);
    [_scrollView addSubview:_nameTextField];
    UIView *nameTextFieldSeperator = [UIView new];
    nameTextFieldSeperator.backgroundColor = darkBrownColor;
    nameTextFieldSeperator.alpha = 0.3;
    nameTextFieldSeperator.frame = CGRectMake(30, CGRectGetMaxY(_nameTextField.frame)-5, self.view.frame.size.width-60, 1);
    [_scrollView addSubview:nameTextFieldSeperator];
    
    
    _phoneNumberTextField = [UITextField new];
    _phoneNumberTextField.textColor = darkBrownColor;
    [_phoneNumberTextField setFont:[UIFont fontWithName:@"Helvetica-Light" size:18]];
    _phoneNumberTextField.textAlignment = NSTextAlignmentCenter;
    NSAttributedString *attributedString4 = [[NSAttributedString alloc] initWithString:@"+7 xxx xxx xx xx" attributes:attributes];
    _phoneNumberTextField.attributedPlaceholder = attributedString4;
    _phoneNumberTextField.frame = CGRectMake(30, CGRectGetMaxY(_nameTextField.frame)+10, self.view.frame.size.width-60, 40);
    [_scrollView addSubview:_phoneNumberTextField];
    _phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    UIView *phoneNumberTextFieldSeperator = [UIView new];
    phoneNumberTextFieldSeperator.backgroundColor = darkBrownColor;
    phoneNumberTextFieldSeperator.alpha = 0.3;
    phoneNumberTextFieldSeperator.frame = CGRectMake(30, CGRectGetMaxY(_phoneNumberTextField.frame) - 5, self.view.frame.size.width-60, 1);
    [_scrollView addSubview:phoneNumberTextFieldSeperator];
    
    _passwordTextField = [UITextField new];
    _passwordTextField.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    [_passwordTextField setFont:[UIFont fontWithName:@"Helvetica-Light" size:18]];
    _passwordTextField.textAlignment = NSTextAlignmentCenter;
    NSAttributedString *attributedString3 = [[NSAttributedString alloc] initWithString:@"Пароль" attributes:attributes];
    _passwordTextField.attributedPlaceholder = attributedString3;
    _passwordTextField.secureTextEntry = YES;
    [self setLeftMargin:_passwordTextField];
    _passwordTextField.frame = CGRectMake(30, CGRectGetMaxY(_phoneNumberTextField.frame)+10, self.view.frame.size.width-60, 40);
    [_scrollView addSubview:_passwordTextField];
    UIView *passwordTextFieldSeperator = [UIView new];
    passwordTextFieldSeperator.backgroundColor = darkBrownColor;
    passwordTextFieldSeperator.alpha = 0.3;
    passwordTextFieldSeperator.frame = CGRectMake(30, CGRectGetMaxY(_passwordTextField.frame) - 5, self.view.frame.size.width-60, 1);
    [_scrollView addSubview:passwordTextFieldSeperator];
    
    _userViewShake = [[AFViewShaker alloc] initWithView:_nameTextField];
    NSArray *allFields = @[_nameTextField, _passwordTextField, _phoneNumberTextField];
    _emptyViewShake = [[AFViewShaker alloc] initWithViewsArray:allFields];
    _errorLabel = [UILabel new];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    _errorLabel.textColor = [UIColor redColor];
    _errorLabel.frame = CGRectMake(40, CGRectGetMaxY(_passwordTextField.frame)+10, self.view.frame.size.width-80, 25);
    [_scrollView addSubview:_errorLabel];

    //signupButton
    _signupButton = [UIButton new];
    _signupButton.layer.masksToBounds = YES;
    _signupButton.layer.cornerRadius = 12.f;
    _signupButton.backgroundColor = darkBrownColor;
    _signupButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _signupButton.titleLabel.textColor = beigeLightColor;
    _signupButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    [_signupButton setTitle:@"Готово" forState:UIControlStateNormal];
    [_signupButton addTarget:self action:@selector(signupButtonPressed) forControlEvents:UIControlEventTouchDown];
    _signupButton.frame = CGRectMake(85, CGRectGetMaxY(_errorLabel.frame)+10, self.view.frame.size.width-170, 42);
    [_scrollView addSubview:_signupButton];


    UIView *upperBarBackground = [UIView new];
    upperBarBackground.backgroundColor = beigeDarkColor;
    //upperBarBackground.alpha = 0.2;
    upperBarBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, 70);
    [self.view addSubview:upperBarBackground];
    
    _cancelButton = [UIButton new];
    _cancelButton.layer.masksToBounds = YES;
    UIImage *cancelButtonImage = [UIImage imageNamed:@"closeIcon.png"];
    cancelButtonImage = [cancelButtonImage scaledToSize:CGSizeMake(25, 25)];
    [_cancelButton setImage:[UIImage imageNamed:@"closeIcon.png"] forState:UIControlStateNormal];
    _cancelButton.frame = CGRectMake(20, 30, 25, 25);
    [self.view addSubview:_cancelButton];
    [_cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    //title
    UILabel *label = [UILabel new];
    label.textColor = beigeLightColor;
    label.text = @"НОВЫЙ ПОЛЬЗОВАТЕЛЬ";
    label.font = [UIFont fontWithName:@"Helvetica-Regular" size:22];
    label.textAlignment = NSTextAlignmentLeft;
    label.alpha = 0.8f;
    label.frame = CGRectMake(80, 25, self.view.frame.size.width-20, 40);
    [self.view addSubview:label];
}


-(void) setLeftMargin: (UITextField *) textField
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textField.frame.size.height)];
    leftView.backgroundColor = textField.backgroundColor;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 400, 0);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void) signupButtonPressed{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Регистрация";
    
    PFUser *user = [PFUser user];
    user.username = self.phoneNumberTextField.text;
    user.password = self.passwordTextField.text;
    
    UIImage *imageNew = _avatarButton.imageView.image;
    NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.5);
    PFFile *imageFile = [PFFile fileWithName:@"avatar.jpeg" data:imageData];
    if (([_nameTextField.text isEqualToString:@""]) || ([_passwordTextField.text isEqualToString:@""] || [_phoneNumberTextField.text isEqualToString:@""])){
        [_errorLabel setText:@"Пожалуйста, введите все данные"];
        [hud hide:YES];
        [_emptyViewShake shake];
    }
    else{
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if(!error){
                user[@"avatar"] = imageFile;
                user[@"name"] = _nameTextField.text;
                
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [hud hide:YES];
                        [self enterApp];
                        NSLog(@"Registered");
                    } else {
                        [hud hide:YES];
                        //NSLog(@"%s, %@", __FUNCTION__, error.localizedDescription);
                        
                        if (error.code == 202){
                            [hud hide:YES];
                            [_userViewShake shake];
                            [_errorLabel setText:@"Такой телефон уже зарегистрирован."];
                        }
                    }
                }];
            }
            else {
                NSLog(@"%s, %@", __FUNCTION__, error.localizedDescription);
            }
        }];
    }

}

-(void) enterApp{
    [self performSegueWithIdentifier:@"MoveToPopularBooks" sender:self];
}

-(void) avatarUpload{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [_avatarButton setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_scrollView endEditing:YES];
}

@end














