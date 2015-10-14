//
//  ReviewBookViewController.m
//  KitappApplication
//
//  Created by Olga Khvan on 03.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "ReviewBookViewController.h"
#import "Book.h"
#import "UIImage+Scale.h"

@interface ReviewBookViewController ()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) UIButton *bkmrkButton;
@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIButton *deleteButton;
@property (nonatomic) UIButton *callButton;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *authorLabel;
@property (nonatomic) UILabel *sellerLabel;
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UILabel *genreLabel;
@property (nonatomic) UILabel *telephoneLabel;

@end

@implementation ReviewBookViewController

@synthesize titleLabel = _titleLabel;
@synthesize authorLabel = _authorLabel;
@synthesize sellerLabel = _sellerLabel;
@synthesize priceLabel = _priceLabel;
@synthesize genreLabel = _genreLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize bkmrkButton = _bkmrkButton;
@synthesize telephoneLabel = _telephoneLabel;
@synthesize backButton = _backButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0];
    _scrollView = [UIScrollView new];
    _scrollView.frame = self.view.bounds;
    [self.view addSubview:_scrollView];

    _imageView = [UIImageView new];
    [self.view addSubview:_imageView];
    PFFile *imageFile = self.book.image;
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        UIImage *image = [UIImage imageWithData:data];
        image = [image scaledToSize:CGSizeMake(self.view.frame.size.width-140, self.view.frame.size.height*0.45)];
        self.imageView.image = image;
    }];
    [_scrollView addSubview:_imageView];
    _imageView.frame = CGRectMake(80, 60, self.view.frame.size.width-160, self.view.frame.size.height*0.45);
    //initialization
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont fontWithName:@"IowanOldStyle-Bold" size:23];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor colorWithRed:131/255.0 green:81/255.0 blue:54/255.0 alpha:1];
    _titleLabel.text = self.book.title;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 3;
    [_scrollView addSubview:_titleLabel];
    _titleLabel.frame = CGRectMake(30, _imageView.frame.size.height+60, _scrollView.frame.size.width-60, 100);
    //NSLog(@"title label frame %f %f", (_imageView.frame.size.height+60), (_scrollView.frame.size.width-60));
    
    //author label
    _authorLabel = [UILabel new];
    _authorLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:18];
    _authorLabel.textColor = [UIColor colorWithRed:131/255.0 green:81/255.0 blue:54/255.0 alpha:1];
    _authorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _authorLabel.text = [NSString stringWithFormat:@"Автор: %@", self.book.author ];
    _authorLabel.textAlignment = NSTextAlignmentCenter;
    _authorLabel.numberOfLines = 3;
    [_scrollView addSubview:_authorLabel];
   _authorLabel.frame = CGRectMake(25, CGRectGetMaxY(_titleLabel.frame), self.view.frame.size.width-50, 50);
    //[_authorLabel sizeToFit];

    //seperator1
    UIButton *seperator1 = [UIButton new];
    [seperator1 setBackgroundColor:[UIColor brownColor]];
    [_scrollView addSubview:seperator1];
    seperator1.alpha = 0.5;
    seperator1.frame = CGRectMake(100, CGRectGetMaxY(_authorLabel.frame)+15, self.view.frame.size.width-200, 1);
    
    //seller label
    _sellerLabel = [UILabel new];
    _sellerLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:14];
    _sellerLabel.textColor = [UIColor colorWithRed:131/255.0 green:81/255.0 blue:54/255.0 alpha:1];
    _sellerLabel.adjustsFontSizeToFitWidth = YES;
    PFUser *user = _book[@"owner"];
    _sellerLabel.text = [NSString stringWithFormat:@"Продавец: %@", user.username];
    _sellerLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_sellerLabel];
    _sellerLabel.frame = CGRectMake(30, CGRectGetMaxY(seperator1.frame)+10, self.view.frame.size.width-60, 40);

    
    //call button
    _callButton = [UIButton new];
    [_callButton setTitle:@"позвонить" forState:UIControlStateNormal];
    [_callButton setTitleColor:[UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0] forState:UIControlStateNormal];
    //_callButton.layer.borderColor = [UIColor brownColor].CGColor;
    //_callButton.layer.borderWidth = 1.0;
    _callButton.layer.cornerRadius = 7.0;
    _callButton.backgroundColor = [UIColor brownColor];
    _callButton.titleLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:16];
    _callButton.frame = CGRectMake(100, CGRectGetMaxY(_sellerLabel.frame)+5, self.view.frame.size.width-200, 32);
    [_scrollView addSubview:_callButton];
    [_callButton addTarget:self action:@selector(callButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //genre label
    _genreLabel = [UILabel new];
    _genreLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:18];
    _genreLabel.textColor = [UIColor colorWithRed:131/255.0 green:81/255.0 blue:54/255.0 alpha:1];
    _genreLabel.adjustsFontSizeToFitWidth = YES;
    _genreLabel.text = [NSString stringWithFormat:@"Жанр: %@", self.book.genre[@"title"]];
    _genreLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:_genreLabel];
    _genreLabel.frame = CGRectMake(30, CGRectGetMaxY(_callButton.frame)+20, 200, 40);
    
    //price label
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:16];
    _priceLabel.textColor = [UIColor colorWithRed:131/255.0 green:81/255.0 blue:54/255.0 alpha:1];
    _priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _priceLabel.numberOfLines = 2;
    _priceLabel.backgroundColor = [UIColor whiteColor];
    _priceLabel.alpha = 0.7;
    _priceLabel.text = [NSString stringWithFormat:@"KZT: %@", self.book.price ];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_priceLabel];
    _priceLabel.frame = CGRectMake(80, _imageView.frame.size.height+40, _imageView.frame.size.width, 20);

    //description
    _descriptionLabel = [UILabel new];
    _descriptionLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:18];
    _descriptionLabel.textColor = [UIColor colorWithRed:131/255.0 green:81/255.0 blue:54/255.0 alpha:1];
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.text = _book.descr;
    _descriptionLabel.textAlignment = NSTextAlignmentJustified;
    [_scrollView addSubview:_descriptionLabel];
    _descriptionLabel.frame = CGRectMake(30, CGRectGetMaxY(_genreLabel.frame)+10, self.view.frame.size.width-60, 100);
    [_descriptionLabel sizeToFit];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(_descriptionLabel.frame)+20);
    
    //back button
    _backButton = [UIButton new];
    _backButton.layer.masksToBounds = YES;
    _backButton.frame = CGRectMake(75, 140, 35, 35);
    /*_backButton.titleLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:16];
    [_backButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [_backButton setTitle:@"назад" forState:UIControlStateNormal];*/
    UIImage *backImage = [UIImage new];
    backImage = [UIImage imageNamed:@"backIcon.png"];
    backImage = [backImage scaledToSize:CGSizeMake(35, 35)];
    [_backButton setImage:backImage forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_backButton];
    _backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_backButton]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_backButton)]];
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_backButton]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_backButton)]];
    
    //bookmark button
    _bkmrkButton = [UIButton new];
    _bkmrkButton.layer.masksToBounds = YES;
    UIImage *bkmrkImage = [UIImage new];
    bkmrkImage = [UIImage imageNamed:@"bookmarkPageIcon.png"];
    bkmrkImage = [bkmrkImage scaledToSize:CGSizeMake(30, 30)];
    [_bkmrkButton setImage:bkmrkImage forState:UIControlStateNormal];
    [_bkmrkButton addTarget:self action:@selector(bookmarkButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_bkmrkButton];
    
    _bkmrkButton.frame = CGRectMake(self.view.frame.size.width-45, 25, 30, 30);
    

   
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object,  NSError *error){
        if(!error){
            _sellerLabel.text = [NSString stringWithFormat:@"Владелец: %@", object[@"username"]];
            _telephoneLabel.text = [NSString stringWithFormat:@"Телефон: %@", user[@"telephone"]];
        }
        else{
            NSLog(@"error in data fetch");
        }
    }];
    NSLog(@"telephone number %@ ", user[@"telephone"]);
    

    //[self.titleLabel sizeToFit];
    //[self.descriptionLabel sizeToFit];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button pressed functions
-(void)backButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)bookmarkButtonPressed{
    PFObject *object = [PFObject objectWithClassName:@"Bookmarks"];
    PFUser *user = [PFUser currentUser];
    object[@"user"] = user;
    object[@"book"] = self.book;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded){
            NSLog(@"Bookmarked!");
        }
        else{
            NSLog(@"Some error");
        }
    }];
}

-(void)deleteButtonPressed{

}

-(void)call:(NSString *) phoneNumber{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNumber]]];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Не удалось совершить звонок" message:@"Попробуйте позднее" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}
-(void)callButtonPressed{
    PFUser *user = _book[@"owner"];
    NSString *number = user[@"telephone"];
    [self call:number];
}


@end





