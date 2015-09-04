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

@end


@implementation SignupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //initialization
    _bgImage = [UIImageView new];
    _signupButton = [UIButton new];
    _nameTextField = [UITextField new];
    _passwordTextField = [UITextField new];
    _phoneNumberTextField = [UITextField new];
    _avatarView = [UIImageView new];
    _avatarButton = [UIButton new];
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

    
    _nameTextField.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    _nameTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    _nameTextField.textAlignment = NSTextAlignmentLeft;
    _nameTextField.backgroundColor = [UIColor whiteColor];
    
    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithString:@"Введите имя пользователя" attributes:attributes];
    _nameTextField.attributedPlaceholder = attributedString1;
    [self.view addSubview:_nameTextField];
    _nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self setLeftMargin:_nameTextField];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_nameTextField]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_nameTextField)]];
    
    _passwordTextField.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    _passwordTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    NSAttributedString *attributedString3 = [[NSAttributedString alloc] initWithString:@"Пароль" attributes:attributes];
    _passwordTextField.attributedPlaceholder = attributedString3;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.secureTextEntry = YES;
    
    [self setLeftMargin:_passwordTextField];
    
    [self.view addSubview:_passwordTextField];
    
    _passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_passwordTextField]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_passwordTextField)]];
    
    _phoneNumberTextField.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    _phoneNumberTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    NSAttributedString *attributedString4 = [[NSAttributedString alloc] initWithString:@"+7 xxx xxx xx xx" attributes:attributes];
    _phoneNumberTextField.attributedPlaceholder = attributedString4;
    _phoneNumberTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_phoneNumberTextField];
    
    _phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    _phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setLeftMargin:_phoneNumberTextField];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_phoneNumberTextField]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_phoneNumberTextField)]];
    
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
    
    _userViewShake = [[AFViewShaker alloc] initWithView:_nameTextField];
    NSArray *allFields = @[_nameTextField, _passwordTextField, _phoneNumberTextField];
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
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[_nameTextField(30)]-5-[_phoneNumberTextField(30)]-5-[_passwordTextField(30)]-10-[_errorLabel]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_nameTextField,_phoneNumberTextField, _passwordTextField,_errorLabel)]];
    
    
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
        [_emptyViewShake shake];
    }
    else{
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if(!error){
                user[@"avatar"] = imageFile;
                user[@"name"] = _nameTextField.text;
                
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [hud hide:YES];
                    if (!error) {
                        [self enterApp];
                        NSLog(@"Registered");
                    } else {
                        
                        //NSLog(@"%s, %@", __FUNCTION__, error.localizedDescription);
                        
                        if (error.code == 202){
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
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

@end














