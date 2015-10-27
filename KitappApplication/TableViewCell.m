//
//  TableViewCell.m
//  KitappApplication
//
//  Created by Olga Khvan on 02.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        NSLog(@"I am in the init with frame");
        [self customInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
      //  NSLog(@"I am in the init with coder");
        [self customInit];
    }
    return self;
}

-(void) customInit
{
    //colors
    //NSLog(@"I am in the init for cell");
    UIColor *brownRedColor = [UIColor colorWithRed:83/255.0 green:48/255.0 blue:29/255.0 alpha:1];
    UIColor *beigeLightColor = [UIColor colorWithRed:255/255.0 green:249/255.0 blue:243/255.0 alpha:1];
    UIColor *beigeColor = [UIColor colorWithRed:238/255.0 green:225/255.0 blue:208/255.0 alpha:1];
    //book image
    _bookImage = [UIImageView new];
    _bookImage.contentMode = UIViewContentModeScaleAspectFill;
    _bookImage.frame = CGRectMake(10, 65,150,100);
    [self.contentView addSubview:_bookImage];
    _bookImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    //title and author labels
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [_titleLabel setTextColor:brownRedColor];
    //_titleLabel.frame = CGRectMake(CGRectGetMaxX(_bookImage.frame)+15, 10, 300, 50);
    //NSLog(@"content view frame width is %f", self.contentView.frame.size.width);
    [self.contentView addSubview:_titleLabel];
    
    
    self.authorLabel = [UILabel new];
    //self.authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.authorLabel.numberOfLines = 2;
    self.authorLabel.adjustsFontSizeToFitWidth = YES;
    self.authorLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:14];
    self.authorLabel.textColor = [UIColor colorWithRed:83/255.0 green:48/255.0 blue:29/255.0 alpha:1];
    [_authorLabel sizeToFit];
    _authorLabel.frame = CGRectMake(CGRectGetMaxX(_bookImage.frame) +15, 60, 100, 50);
    [self.contentView addSubview:_authorLabel];
    
    
    //price label
    _priceLabel = [UILabel new];
    // self.priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.priceLabel.numberOfLines = 1;
    self.priceLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:14];
    self.priceLabel.textColor = [UIColor brownColor];
    [_priceLabel sizeToFit];
    _priceLabel.frame = CGRectMake(CGRectGetMaxX(_bookImage.frame)+15, CGRectGetMaxY(_authorLabel.frame), 80, 30);
    [self.contentView addSubview:_priceLabel];
    
    //delete button
    _deleteButton = [UIButton new];
    //_deleteButton.frame = CGRectMake(self.contentView.frame.size.width, CGRectGetMaxY(_bookImage.frame)-30, 30, 30);
    _deleteButton.layer.cornerRadius = 15.f;
    [_deleteButton setImage:[UIImage imageNamed:@"trashBinCircleIcon.png"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
    
    //like button
    _likeButton = [UIButton new];
    _likeButton.frame = CGRectMake(self.contentView.frame.size.width-40, self.contentView.frame.size.height-40, 30, 30);
    _likeButton.layer.cornerRadius = 15.f;
    [_likeButton setImage:[UIImage imageNamed:@"heartCircleIcon.png"] forState:UIControlStateNormal];
    [_likeButton addTarget:self action:@selector(likeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _likeButton.hidden = YES;
    
    //[_titleLabel sizeToFit];
}

-(void)layoutSubviews{
    [super layoutSubviews];

}

-(void) deleteButtonPressed: (UIButton *) button
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(cell:deleteButtonPressed:)])
        {
            [self.delegate cell:self deleteButtonPressed:button];
        }
    }
}

-(void) likeButtonPressed: (UIButton *)button
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(cell:likeButtonPressed:)])
        {
            [self.delegate cell:self likeButtonPressed:button];
        }
    }
}


@end







