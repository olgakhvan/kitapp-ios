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
#import "AKPickerView.h"

@interface AddNewBookViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) UIImageView *bookView;
@property (nonatomic) UIButton *uploadButton;
@property (nonatomic) UIButton *photoButton;
@property (nonatomic) UITextField *titleTextField;
@property (nonatomic) UITextField *authorTextField;
@property (nonatomic) UITextField *priceTextField;
@property (nonatomic) UITextField *genreTextField;
@property (nonatomic) UITextField *descriptionTextField;

@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *doneButton;

@property (nonatomic) UIButton *seperator1;
@property (nonatomic) UIButton *seperator2;
@property (nonatomic) UIButton *seperator3;
@property (nonatomic) UIButton *seperator4;

@property (nonatomic) UITextView *descriptionTextView;
@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) UIPickerView *genrePicker;
@property (nonatomic) NSMutableArray *pickerData;
@end

@implementation AddNewBookViewController

@synthesize bookView = _bookView;
@synthesize uploadButton = _uploadButton;
@synthesize photoButton = _photoButton;
@synthesize titleTextField = _titleTextField;
@synthesize authorTextField = _authorTextField;
@synthesize priceTextField = _priceTextField;
@synthesize cancelButton = _cancelButton;
@synthesize doneButton = _doneButton;
@synthesize seperator1 = _seperator1;
@synthesize seperator2 = _seperator2;
@synthesize seperator3 = _seperator3;
@synthesize seperator4 = _seperator4;
@synthesize descriptionTextView = _descriptionTextView;
@synthesize scrollView = _scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0];
    
    //initialization
    _bookView = [UIImageView new];
    _uploadButton = [UIButton new];
    _photoButton = [UIButton new];
    _titleTextField = [UITextField new];
    _authorTextField = [UITextField new];
    _priceTextField = [UITextField new];
    _cancelButton = [UIButton new];
    _genreTextField = [UITextField new];
    _doneButton = [UIButton new];
    _seperator1 = [UIButton new];
    _seperator2 = [UIButton new];
    _seperator3 = [UIButton new];
    _descriptionTextView = [UITextView new];
    _genreTextField = [UITextField new];
    _scrollView = [UIScrollView new];
    _seperator4 = [UIButton new];
    _genrePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    _pickerData = [[NSMutableArray new] init];
    _pickerData = @[@"Бизнес", @"Биографии и мемуары",@"Готовка и кулинария",@"Детективы и триллеры",@"Естественные науки",@"Изучения иностранных языков",@"Драматургия",@"Классика",@"Медицина и здоровье",@"Научная фантастика и фэнтези",@"Политика",@"Поэзия",@"Современная проза",@"Другое"];
    _genrePicker.dataSource = self;
    _genrePicker.delegate = self;
    
    
    _scrollView.frame = self.view.bounds;
    _scrollView.contentSize = CGSizeMake(375, 500);
    [self.view addSubview:_scrollView];
    
    //cancel and done buttons
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.cornerRadius = 15.f;
    UIImage *image = [UIImage new];
    image = [image scaledToSize:CGSizeMake(30, 30)];
    image = [UIImage imageNamed:@"backIcon.png"];
    [_cancelButton setImage:image forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    _doneButton.layer.masksToBounds = YES;
    _doneButton.layer.cornerRadius = 15.f;
    image = [UIImage imageNamed:@"doneIcon.png"];
    [_doneButton setImage:image forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchDown];

    //image view
    //_bookView.backgroundColor = [UIColor blackColor];
    _bookView.image = [UIImage imageNamed:@"noCover.jpg"];
    _bookView.layer.cornerRadius = 3.f;
    
    //title
    _titleTextField.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    _titleTextField.textAlignment = NSTextAlignmentLeft;
    _titleTextField.font = [UIFont fontWithName:@"IowanOldStyle-Bold" size:16];
    _titleTextField.placeholder = @"название книги";
    
    //author
    _authorTextField.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    _authorTextField.textAlignment = NSTextAlignmentLeft;
    _authorTextField.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:15];
    _authorTextField.placeholder = @"автор";
    
    //price
    _priceTextField.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    _priceTextField.textAlignment = NSTextAlignmentLeft;
    _priceTextField.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:15];
    _priceTextField.placeholder = @"цена";
    
    //genre
    _genreTextField.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    _genreTextField.textAlignment = NSTextAlignmentLeft;
    _genreTextField.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:15];
    _genreTextField.placeholder = @"жанр";
    _genreTextField.inputView = _genrePicker;
    //seperators
    _seperator1.backgroundColor = [UIColor brownColor];
    _seperator1.alpha = 0.1;
    
    _seperator2.backgroundColor = [UIColor brownColor];
    _seperator2.alpha = 0.1;
    
    _seperator3.backgroundColor = [UIColor brownColor];
    _seperator3.alpha = 0.1;
    
    _seperator4.backgroundColor = [UIColor brownColor];
    _seperator4.alpha = 0.1;
    
    _bookView.frame = CGRectMake(self.view.bounds.size.width/2 - 100, 70, 150, 220);
    
    _uploadButton.frame = CGRectMake(self.view.bounds.size.width/2 - 100, 260, 75, 30);
    _uploadButton.alpha = 0.7;
    [_uploadButton setImage:[UIImage imageNamed:@"uploadIcon.png"] forState:UIControlStateNormal];
    [_uploadButton addTarget:self action:@selector(uploadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _photoButton.frame = CGRectMake(self.view.bounds.size.width/2-25, 260, 75, 30);
    _photoButton.alpha = 0.7;
    [_photoButton setImage:[UIImage imageNamed:@"photoIcon.png"] forState:UIControlStateNormal];
    [_photoButton addTarget:self action:@selector(photoButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    
    _cancelButton.frame = CGRectMake(15, 35, 30, 30);
    _doneButton.frame = CGRectMake(self.view.bounds.size.width-45, 35, 30, 30);
    
    _titleTextField.frame = CGRectMake(self.view.bounds.size.width/2 - 100, 305, 200, 40);
    _seperator1.frame = CGRectMake(self.view.bounds.size.width/2 - 130, 335, 260, 1);
    
    _authorTextField.frame = CGRectMake(self.view.bounds.size.width/2 - 100, 340, 200, 40);
    _seperator2.frame = CGRectMake(self.view.bounds.size.width/2 - 130, 370, 260, 1);
    
    _priceTextField.frame = CGRectMake(self.view.bounds.size.width/2 - 100, 375, 200, 40);
    _seperator3.frame = CGRectMake(self.view.bounds.size.width/2 - 130, 405, 260, 1);
    
    _genreTextField.frame = CGRectMake(self.view.bounds.size.width/2 - 100, 410, 200, 40);
    _seperator4.frame = CGRectMake(self.view.bounds.size.width/2 - 130, 440, 260, 1);
    
    _descriptionTextView.frame = CGRectMake(self.view.bounds.size.width/2 - 130, 475, 260, 115);
    _descriptionTextView.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    _descriptionTextView.textAlignment = NSTextAlignmentLeft;
    _descriptionTextView.layer.borderWidth = 1.0;
    _descriptionTextView.layer.cornerRadius = 3.f;
    _descriptionTextView.backgroundColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:0];
    _descriptionTextView.layer.masksToBounds = YES;
    _descriptionTextView.layer.borderColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:0.1].CGColor;
    _descriptionTextView.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:15];
    _descriptionTextView.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    _descriptionTextView.text = @"Введите краткое описание о книге...";
    _genrePicker.frame =CGRectMake(self.view.bounds.size.width/2 - 100, 350, 150, 162);
    [[UIPickerView appearance] setBackgroundColor:[UIColor colorWithRed:244/255.0 green:232/255.0 blue:221/255.0 alpha:1.0]];
    
    [_scrollView addSubview:_doneButton];
    [_scrollView addSubview:_cancelButton];
    [_scrollView addSubview:_bookView];
    [_scrollView addSubview:_titleTextField];
    [_scrollView addSubview:_authorTextField];
    [_scrollView addSubview:_priceTextField];
    [_scrollView addSubview:_descriptionTextView];
    [_scrollView addSubview:_seperator1];
    [_scrollView addSubview:_seperator2];
    [_scrollView addSubview:_seperator3];
    [_scrollView addSubview:_seperator4];
    [_scrollView addSubview:_uploadButton];
    [_scrollView addSubview:_photoButton];
    [_scrollView addSubview:_genreTextField];
    
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
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
}

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
    _genreTextField.text = _pickerData[row];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 40)];
    label.textColor = [UIColor colorWithRed:145/255.0 green:113/255.0 blue:84/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:16];
    label.text = [_pickerData objectAtIndex:row];
    return label;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 30.0;
}

#pragma mark - Image picker methods

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    _bookView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
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
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)cancelButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)okButtonPressed{
    
    PFUser *user = [PFUser currentUser];
    PFObject *newBook = [PFObject objectWithClassName:@"Books"];
    
    newBook[@"title"] = _titleTextField.text;
    newBook[@"author"] = _authorTextField.text;
    newBook[@"descr"] = _descriptionTextView.text;
    newBook[@"owner"] = user;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    newBook[@"price"] = [f numberFromString:_priceTextField.text];
    newBook[@"genre"] = _genreTextField.text;
    
    UIImage *imageNew = _bookView.image;
    NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.8);
    PFFile *imageFile = [PFFile fileWithName:@"bookImage.jpeg" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded){
            
            
            newBook[@"image"] = imageFile;
            
            [newBook saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Book was saved");
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    NSLog(@"error");
                }
            }];
            
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


























