//
//  CollectionViewCellClass.m
//  KitappApplication
//
//  Created by Olga Khvan on 01.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "CollectionViewCellClass.h"
#import "UIImage+Scale.h"

@implementation CollectionViewCellClass

@synthesize chosen = _chosen;

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        UIImage *bkmrkImage = [UIImage imageNamed:@"heartIcon.png"];
        UIImage *eyeIcon = [UIImage imageNamed:@"eyeIcon.png"];
        UIImage *deleteImage = [UIImage imageNamed:@"trashBinIcon.png"];
        
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:239/255.0 alpha:1.0];
        //self.backgroundColor = [UIColor whiteColor];
        self.imageView = [UIImageView new];
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [UILabel new];
    
        self.deleteButton = [UIButton new];
        [self.deleteButton addTarget:self
                              action:@selector(deleteButtonDidPress:)
                    forControlEvents:UIControlEventTouchUpInside];
        self.bookmarkButton = [UIButton new];
        [self.bookmarkButton addTarget:self
                              action:@selector(bookmarkButtonDidPress:)
                    forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton = [UIButton new];
        self.priceLabel = [UILabel new];
        self.seperator = [UIButton new];
        self.authorLabel = [UILabel new];
        _index = [NSIndexPath new];
        
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.bookmarkButton];
        [self.contentView addSubview:self.deleteButton];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:_authorLabel];
        [self.contentView addSubview:_seperator];
        
        
        //titleLabel
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        //self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        self.titleLabel.textColor = [UIColor colorWithRed:83/255.0 green:48/255.0 blue:29/255.0 alpha:1];
        NSDictionary *metrics = @{@"titleHorizontalConstraint" : @(self.contentView.frame.size.width*0.3 + 50),
                                  @"imageHorizontalConstraint" : @(self.contentView.frame.size.width/2),
                                  //@"buttonHorizontalConstraint" : @(self.contentView.frame.size.width/2 + 30)
                                  };
        [_titleLabel sizeToFit];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleHorizontalConstraint-[_titleLabel]-10-|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:NSDictionaryOfVariableBindings(_titleLabel)]];

        
        //titleLabel
        self.authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        //self.authorLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.authorLabel.numberOfLines = 2;
        self.authorLabel.adjustsFontSizeToFitWidth = YES;
        self.authorLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:14];
        self.authorLabel.textColor = [UIColor colorWithRed:83/255.0 green:48/255.0 blue:29/255.0 alpha:1];
        [_authorLabel sizeToFit];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleHorizontalConstraint-[_authorLabel(100)]-10-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:NSDictionaryOfVariableBindings(_authorLabel)]];
        
        
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.priceLabel.numberOfLines = 1;
        self.priceLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:14];
        self.priceLabel.textColor = [UIColor brownColor];
        [_priceLabel sizeToFit];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_priceLabel]-10-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_priceLabel)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_priceLabel]-10-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_priceLabel)]];
        
        [_deleteButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.layer.borderWidth = 1.0;
        _deleteButton.layer.borderColor = [UIColor brownColor].CGColor;
        UIImage *deleteIcon = [UIImage imageNamed:@"deleteIcon"];
        deleteIcon = [deleteIcon scaledToSize:CGSizeMake(30.0, 30.0)];
        [_deleteButton setImage:deleteIcon forState:UIControlStateNormal];
        self.deleteButton.titleLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:12];
        _deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_deleteButton addTarget:self action:@selector(deleteButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        _seperator.backgroundColor = [UIColor brownColor];
        _seperator.alpha = 0;
        _seperator.frame = CGRectMake(0, self.contentView.frame.size.height, self.contentView.frame.size.width, 1);
        _deleteButton.enabled = YES;
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleHorizontalConstraint-[_deleteButton(30)]"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:NSDictionaryOfVariableBindings(_deleteButton)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_deleteButton(30)]-10-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:NSDictionaryOfVariableBindings(_deleteButton)]];
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_titleLabel]-3-[_authorLabel]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_titleLabel, _authorLabel)]];
        
        //self.contentView.layer.borderWidth = 1.0;
        self.contentView.layer.borderColor = [UIColor colorWithRed:194/255.0 green:180/255.0 blue:167/255.0 alpha:0.5].CGColor;
        self.contentView.layer.cornerRadius =3.0;
        self.layer.cornerRadius = 3.f;
        self.layer.masksToBounds = YES;
        self.contentView.layer.masksToBounds = 3.f;
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 10,
                                      CGRectGetWidth(self.contentView.bounds)*0.37,
                                      CGRectGetHeight(self.contentView.bounds)-20);
    _imageView.alpha = 0.9;
}

- (void) bookmarkButtonDidPress: (UIButton *) button{
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(cell:bookmarkButtonDidPress:)]){
            [self.delegate cell:self bookmarkButtonDidPress:button];
        }
    }
}
- (void) deleteButtonDidPress: (UIButton *) button{
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(cell:deleteButtonDidPress:)]){
            [self.delegate cell:self deleteButtonDidPress:button];
        }
    }
}
@end
