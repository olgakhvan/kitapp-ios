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

@interface SignupViewController ()

@property (nonatomic) UIImageView *bgImage;
@property (nonatomic) UIButton *signupButton;
@property (nonatomic) UITextField *emailTextField;
@property (nonatomic) UITextField *usernameTextField;
@property (nonatomic) UITextField *passwordTextField;
@property (nonatomic) UIImageView *avatarView;
@property (nonatomic) UIButton *avatarButton;
@property (nonatomic) UITextField *telephoneTextField;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) AFViewShaker *userViewShake;
@property (nonatomic) UILabel *errorLabel;
@property (nonatomic) AFViewShaker *emptyViewShake;

@end


@implementation SignupViewController

@synthesize bgImage = _bgImage;
@synthesize signupButton = _signupButton;
@synthesize emailTextField = _emailTextField;
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize avatarView = _avatarView;
@synthesize avatarButton = _avatarButton;
@synthesize telephoneTextField = _telephoneTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    //initialization
    _bgImage = [UIImageView new];
    _signupButton = [UIButton new];
    _emailTextField = [UITextField new];
    _usernameTextField = [UITextField new];
    _passwordTextField = [UITextField new];
    _avatarView = [UIImageView new];
    _avatarButton = [UIButton new];
    _telephoneTextField = [UITextField new];
    _cancelButton = [UIButton new];

    //bgImage
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

    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor colorWithRed:18/255.0 green:18/255.0 blue:18/255.0 alpha:0.2]
                                 };

    
    _usernameTextField.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    _usernameTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    _usernameTextField.placeholder = @"имя";
    _usernameTextField.textAlignment = NSTextAlignmentLeft;
    _usernameTextField.backgroundColor = [UIColor whiteColor];
    
    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithString:@"имя пользователя" attributes:attributes];
    _usernameTextField.attributedPlaceholder = attributedString1;
    [self.view addSubview:_usernameTextField];
    
    _usernameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_usernameTextField]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_usernameTextField)]];
    
    /*_emailTextField.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    _emailTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    _emailTextField.placeholder = @"e-mail";
    _emailTextField.textAlignment = NSTextAlignmentLeft;
    _emailTextField.adjustsFontSizeToFitWidth = NO;
    _emailTextField.layer.masksToBounds = YES;
    [self.view addSubview:_emailTextField];
    
    NSAttributedString *attributedString2 = [[NSAttributedString alloc] initWithString:@"e-mail" attributes:attributes];
    _emailTextField.attributedPlaceholder = attributedString2;
    
    _emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_emailTextField]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_emailTextField)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_emailTextField]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_emailTextField)]];*/
    
    _passwordTextField.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    _passwordTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    //_passwordTextField.placeholder = @"пароль";
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    NSAttributedString *attributedString3 = [[NSAttributedString alloc] initWithString:@"пароль" attributes:attributes];
    _passwordTextField.attributedPlaceholder = attributedString3;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.secureTextEntry = YES;
    
    
    [self.view addSubview:_passwordTextField];
    
    _passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_passwordTextField]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_passwordTextField)]];
    
    _telephoneTextField.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    _telephoneTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    //_passwordTextField.placeholder = @"пароль";
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    NSAttributedString *attributedString4 = [[NSAttributedString alloc] initWithString:@"+7 xxx xxx xx xx" attributes:attributes];
    _telephoneTextField.attributedPlaceholder = attributedString4;
    _telephoneTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_telephoneTextField];
    
    _telephoneTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_telephoneTextField]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_telephoneTextField)]];
    
    //avatar image
    _avatarButton.clipsToBounds = YES;
    _avatarButton.clipsToBounds = YES;
    _avatarButton.layer.cornerRadius = 45.f;
    [_avatarButton setImage:[UIImage imageNamed:@"noavatar.png"] forState:UIControlStateNormal];
    [self.view addSubview:_avatarButton];
    _avatarButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_avatarButton(90)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_avatarButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[_avatarButton(90)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_avatarButton)]];
        [_avatarButton addTarget:self action:@selector(avatarUpload) forControlEvents:UIControlEventTouchDown];
    
    
    //signupButton
    _signupButton.layer.masksToBounds = YES;
    //_signupButton.layer.borderWidth = 1.f;
    //_signupButton.layer.cornerRadius = 5.f;
    _signupButton.backgroundColor = [UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0]
    ;
    _signupButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _signupButton.titleLabel.textColor = [UIColor whiteColor];
    _signupButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    [_signupButton setTitle:@"Готово" forState:UIControlStateNormal];
    [self.view addSubview:_signupButton];
    
    [_signupButton addTarget:self action:@selector(signupButtonPressed) forControlEvents:UIControlEventTouchDown];

    
    _signupButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-130-[_signupButton]-90-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_signupButton)]];

    
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
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-90-[_cancelButton(35)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_cancelButton)]];
    
    _userViewShake = [[AFViewShaker alloc] initWithView:_usernameTextField];
    NSArray *allFields = @[_usernameTextField, _passwordTextField, _telephoneTextField];
    _emptyViewShake = [[AFViewShaker alloc] initWithViewsArray:allFields];
    _errorLabel = [UILabel new];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12];
    _errorLabel.textColor = [UIColor redColor];
    [self.view addSubview:_errorLabel];
    _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_errorLabel]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_errorLabel)]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[_usernameTextField(30)]-5-[_passwordTextField(30)]-5-[_telephoneTextField(30)]-10-[_errorLabel]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_usernameTextField,_passwordTextField, _telephoneTextField,_errorLabel)]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-190-[_signupButton(35)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_signupButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-190-[_cancelButton(35)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_cancelButton)]];
    //title
    UILabel *label = [UILabel new];
    //label.textColor = [UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];
    label.textColor = [UIColor whiteColor];
    label.text = @"НОВЫЙ ПОЛЬЗОВАТЕЛЬ";
    label.font = [UIFont fontWithName:@"Helvetica-Regular" size:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.alpha = 0.8f;
    [self.view addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[label]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(label)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[label]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(label)]];
    
    

    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) signupButtonPressed{
    
    
    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
//    user.email = self.emailTextField.text;
    
    UIImage *imageNew = _avatarButton.imageView.image;
    NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.5);
    PFFile *imageFile = [PFFile fileWithName:@"avatar.jpeg" data:imageData];
    if (([_usernameTextField.text isEqualToString:@""]) || ([_passwordTextField.text isEqualToString:@""] || [_telephoneTextField.text isEqualToString:@""])){
        [_errorLabel setText:@"пожалуйста, введите все данные"];
        [_emptyViewShake shake];
    }
    else{
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if(!error){
                user[@"avatar"] = imageFile;
                user[@"telephone"] = _telephoneTextField.text;
                
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [self enterApp];
                        NSLog(@"Registered");
                    } else {
                        
                        //NSLog(@"%s, %@", __FUNCTION__, error.localizedDescription);
                        
                        if (error.code == 202){
                            [_userViewShake shake];
                            [_errorLabel setText:@"имя пользователя уже занято"];
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
    [self presentModalViewController:imagePickerController animated:YES];
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
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

@end














