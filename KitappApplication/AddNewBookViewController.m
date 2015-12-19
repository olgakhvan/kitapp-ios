//
//  AddNewBookViewController.m
//  KitappApplication
//
//  Created by Olga Khvan on 08.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "AddNewBookViewController.h"
#import "UIImage+Scale.h"
#import "Book.h"
#import "Parse.h"
#import "MyBooksViewController.h"
#import "Colors.h"
#import "PopularBooksViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define kOFFSET_FOR_KEYBOARD 80.0


@interface AddNewBookViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>

@property (nonatomic) UIImageView *bookView;
@property (nonatomic) UIButton *uploadButton;
@property (nonatomic) UIButton *photoButton;
@property (nonatomic) UITextField *titleTextField;
@property (nonatomic) UITextField *authorTextField;
@property (nonatomic) UITextField *priceTextField;
@property (nonatomic) UITextField *genreTextField;
@property (nonatomic) UITextField *descriptionTextField;
@property (nonatomic) UIImage *bookImage;

@property (nonatomic) UIButton *doneButton;

@property (nonatomic) UIButton *seperator1;
@property (nonatomic) UIButton *seperator2;
@property (nonatomic) UIButton *seperator3;
@property (nonatomic) UIButton *seperator4;

@property (nonatomic) UITextView *descriptionTextView;
@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) UIPickerView *genrePicker;
@property (nonatomic) NSArray *pickerData;
@property (nonatomic) int chosenGenre;

@property (nonatomic) MBProgressHUD *hud;


@end

@implementation AddNewBookViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:249/255.0 blue:243/255.0 alpha:1.0];
    //initialization

    _scrollView = [UIScrollView new];
    _genrePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    _pickerData = [[NSMutableArray new] init];
    [self getGenresFromParse];
    self.chosenGenre = -1;
    
    _genrePicker.dataSource = self;
    _genrePicker.delegate = self;
    
    
    _scrollView.frame = self.view.bounds;
    [self.view addSubview:_scrollView];

    //image view
    _bookView = [UIImageView new];
    _bookView.image = [UIImage imageNamed:@"bookPlaceHolder.png"];
    _bookView.layer.cornerRadius = 3.f;
    _bookView.frame = CGRectMake(50,70,self.view.frame.size.width-100,(self.view.frame.size.width-100)*1.34);
    _bookView.userInteractionEnabled = YES;
    [_scrollView addSubview:_bookView];

    
    
    //title
    _titleTextField = [UITextField new];
    _titleTextField.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    _titleTextField.textAlignment = NSTextAlignmentLeft;
    _titleTextField.font = [UIFont fontWithName:@"IowanOldStyle-Bold" size:22];
    _titleTextField.placeholder = @"название книги";
    _titleTextField.frame = CGRectMake(self.view.bounds.size.width/2 - 100, CGRectGetMaxY(_bookView.frame)+30, 200, 40);
    [_scrollView addSubview:_titleTextField];
    
    //author
    _authorTextField = [UITextField new];
    _authorTextField.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    _authorTextField.textAlignment = NSTextAlignmentLeft;
    _authorTextField.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:20];
    _authorTextField.placeholder = @"автор";
    _authorTextField.frame = CGRectMake(self.view.bounds.size.width/2 - 100, CGRectGetMaxY(_titleTextField.frame)+3, 200, 40);
    [_scrollView addSubview:_authorTextField];

    
    //price
    _priceTextField = [UITextField new];
    _priceTextField.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    _priceTextField.textAlignment = NSTextAlignmentLeft;
    _priceTextField.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:20];
    _priceTextField.placeholder = @"цена";
    self.priceTextField.keyboardType = UIKeyboardTypeNumberPad; 
    _priceTextField.frame = CGRectMake(self.view.bounds.size.width/2 - 100, CGRectGetMaxY(_authorTextField.frame)+3, 200, 40);
    [_scrollView addSubview:_priceTextField];

    
    //genre
    _genreTextField = [UITextField new];
    _genreTextField.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    _genreTextField.textAlignment = NSTextAlignmentLeft;
    _genreTextField.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:20];
    _genreTextField.placeholder = @"жанр";
    _genreTextField.inputView = _genrePicker;
    _genreTextField.frame = CGRectMake(self.view.bounds.size.width/2 - 100, CGRectGetMaxY(_priceTextField.frame)+3, 200, 40);

    [_scrollView addSubview:_genreTextField];
    
    //seperators
    _seperator1 = [UIButton new];
    _seperator1.backgroundColor = [UIColor brownColor];
    _seperator1.alpha = 0.1;
    _seperator1.frame = CGRectMake(self.view.bounds.size.width/2 - 130, CGRectGetMaxY(_titleTextField.frame)-10, 260, 1);
    [_scrollView addSubview:_seperator1];
    
    _seperator2 = [UIButton new];
    _seperator2.backgroundColor = [UIColor brownColor];
    _seperator2.alpha = 0.1;
    _seperator2.frame = CGRectMake(self.view.bounds.size.width/2 - 130, CGRectGetMaxY(_authorTextField.frame)-10, 260, 1);
    [_scrollView addSubview:_seperator2];

    
    _seperator3 = [UIButton new];
    _seperator3.backgroundColor = [UIColor brownColor];
    _seperator3.alpha = 0.1;
    _seperator3.frame = CGRectMake(self.view.bounds.size.width/2 - 130, CGRectGetMaxY(_priceTextField.frame)-10, 260, 1);
    [_scrollView addSubview:_seperator3];

    
    _seperator4 = [UIButton new];
    _seperator4.backgroundColor = [UIColor brownColor];
    _seperator4.alpha = 0.1;
    _seperator4.frame = CGRectMake(self.view.bounds.size.width/2 - 130, CGRectGetMaxY(_genreTextField.frame)-10, 260, 1);
    [_scrollView addSubview:_seperator4];
    
    _uploadButton = [UIButton new];
    _uploadButton.frame = CGRectMake(CGRectGetMinX(_bookView.frame), CGRectGetMaxY(_bookView.frame)-_bookView.frame.size.height*0.15, _bookView.frame.size.width/2, _bookView.frame.size.height*0.15);
    _uploadButton.alpha = 0.7;
    [_uploadButton setImage:[UIImage imageNamed:@"uploadIcon.png"] forState:UIControlStateNormal];
    [_uploadButton addTarget:self action:@selector(uploadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_uploadButton];

    _photoButton = [UIButton new];
    _photoButton.frame = CGRectMake(CGRectGetMaxX(_uploadButton.frame), CGRectGetMaxY(_bookView.frame)-_bookView.frame.size.height*0.15, _bookView.frame.size.width/2, _bookView.frame.size.height*0.15);
    _photoButton.alpha = 0.7;
    [_photoButton setImage:[UIImage imageNamed:@"photoIcon.png"] forState:UIControlStateNormal];
    [_photoButton addTarget:self action:@selector(photoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_photoButton];
    

    _descriptionTextView = [UITextView new];
    _descriptionTextView.frame = CGRectMake(self.view.bounds.size.width/2 - 130, CGRectGetMaxY(_genreTextField.frame)+10, 260, 200);
    _descriptionTextView.textAlignment = NSTextAlignmentLeft;
    _descriptionTextView.layer.borderWidth = 1.0;
    _descriptionTextView.layer.cornerRadius = 3.f;
    _descriptionTextView.backgroundColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:0];
    _descriptionTextView.layer.masksToBounds = YES;
    _descriptionTextView.layer.borderColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:0.1].CGColor;
    _descriptionTextView.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:18];
    _descriptionTextView.textColor = [UIColor lightGrayColor];
    self.descriptionTextView.delegate = self;
    _descriptionTextView.text = @"Введите краткое описание о книге...";
    [_scrollView addSubview:_descriptionTextView];
    
    _genrePicker.frame =CGRectMake(self.view.bounds.size.width/2 - 100, 350, 150, 162);
    [[UIPickerView appearance] setBackgroundColor:[UIColor colorWithRed:244/255.0 green:232/255.0 blue:221/255.0 alpha:1.0]];

    
    //cancel and done buttons
    _doneButton = [UIButton new];
    _doneButton.layer.masksToBounds = YES;
    _doneButton.layer.cornerRadius = 5.f;
    [_doneButton setTitle:@"Готово" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[Colors beigeLightColor] forState:UIControlStateNormal];
    _doneButton.backgroundColor = [Colors brownColor];
    _doneButton.frame = CGRectMake(self.view.frame.size.width-85,30,70,30);
    [self.view addSubview:_doneButton];
    [_doneButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+300);
    NSLog(@"%f", CGRectGetMaxY(_descriptionTextView.frame));
    
    // gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TextView methods 
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Введите краткое описание о книге..."]) {
        textView.text = @"";
        textView.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"placeholder text here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

#pragma mark - Keyboard scroll methods 
-(void)dismissKeyboard {
    [self.descriptionTextView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.authorTextField resignFirstResponder];
    [self.genreTextField resignFirstResponder];
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height + 10, 0);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
//    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetMaxY(self.descriptionTextView.frame)+10, 0);
}

#pragma mark - Loading methods

-(void) getGenresFromParse
{
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"Genre"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * genreObjects, NSError * error) {
        if (!error) {
            self.pickerData = genreObjects;
            NSLog(@"genres are = %@", genreObjects);
        } else {
            NSLog(@"Some error %@", error);
        }
    }];
}

#pragma mark - viewAppear,viewDissappear
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

#pragma mark - view layouts
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //[self layoutImageView];
}

-(void)layoutImageView{
    if (_bookView.image == nil)
        return;
    
    CGFloat padding = 20.0f;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.width -= (padding * 2.0f);
    viewFrame.size.height -= ((padding * 2.0f));
    
    CGRect imageFrame = CGRectZero;
    imageFrame.size = _bookView.image.size;
    
    CGFloat scale = MIN(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height);
    imageFrame.size.width *= scale;
    imageFrame.size.height *= scale;
    imageFrame.origin.x = (CGRectGetWidth(self.view.bounds) - imageFrame.size.width) * 0.5f;
    imageFrame.origin.y = (CGRectGetHeight(self.view.bounds) - imageFrame.size.height) * 0.5f;
    _bookView.frame = imageFrame;
    
}



#pragma mark - picker view
//The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerData count];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    PFObject *genreObject = self.pickerData[row];
    self.genreTextField.text = genreObject[@"title"];
    self.chosenGenre = row;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 40)];
    label.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:16];
    
    PFObject *genreObject = self.pickerData[row];
    label.text = genreObject[@"title"];
    
    return label;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 30.0;
}

#pragma mark - Image picker methods

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _bookImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    _bookView.image = _bookImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
        _bookImage = image;
        //TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
        //cropController.delegate = self;
        //[self presentViewController:cropController animated:YES completion:nil];
    }];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Buttons methods
-(void)uploadButtonPressed{
    
    NSLog(@"I am here");
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)photoButtonPressed{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void)okButtonPressed{
    
    
    if (([self.titleTextField.text isEqualToString:@""]) || ([self.authorTextField.text isEqualToString:@""]) || (self.chosenGenre == -1) || ([self.priceTextField.text isEqualToString:@""])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Заполните все поля" message:@"Не все поля заполнены" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    PFUser *user = [PFUser currentUser];
    PFObject *newBook = [PFObject objectWithClassName:@"Book"];
    
    newBook[@"title"] = _titleTextField.text;
    newBook[@"author"] = _authorTextField.text;
    newBook[@"descr"] = _descriptionTextView.text;
    newBook[@"owner"] = user;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    newBook[@"price"] = [f numberFromString:_priceTextField.text];
    newBook[@"genre"] = self.pickerData[self.chosenGenre];
    UIImage *imageNew = _bookView.image;
    NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.8);
    PFFile *imageFile = [PFFile fileWithName:@"bookImage.jpeg" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded){
            newBook[@"image"] = imageFile;
            
            [newBook saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                self.hud.hidden = YES;
                if (succeeded) {
                    NSLog(@"Book was saved");
                    
                    self.bookView.image = [UIImage imageNamed:@"noCover.jpg"];
                    self.titleTextField.text = @"";
                    self.descriptionTextView.text = @"";
                    self.priceTextField.text = @"";
                    self.authorTextField.text = @"";
                    self.genreTextField.text = @"";
                    self.chosenGenre = -1;
                    
                    [self.descriptionTextView resignFirstResponder];
                    [self.titleTextField resignFirstResponder];
                    [self.priceTextField resignFirstResponder];
                    [self.authorTextField resignFirstResponder];
                    [self.genreTextField resignFirstResponder];
                    
                    [self.scrollView setContentOffset:
                     CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
                    
                    self.tabBarController.selectedIndex = 0;
                } else {
                    NSLog(@"error");
                }
            }];
        } else {
            self.hud.hidden = NO;
            NSLog(@"ERROR!!");
        }
    }];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}



@end


























