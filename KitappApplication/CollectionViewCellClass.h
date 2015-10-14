//
//  CollectionViewCellClass.h
//  KitappApplication
//
//  Created by Olga Khvan on 01.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionViewCellClass;

@protocol CollectionViewCellDelegate <NSObject>

@required

- (void)cell: (CollectionViewCellClass *)cell bookmarkButtonDidPress:(UIButton *)button;
- (void)cell: (CollectionViewCellClass *)cell deleteButtonDidPress:(UIButton *)button;

@end

@interface CollectionViewCellClass : UICollectionViewCell
@property (nonatomic) UIImageView *imageView;

@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) UIButton *deleteButton;

@property (nonatomic) UIButton *likeButton;
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UILabel *authorLabel;
@property (nonatomic) BOOL chosen;
@property (nonatomic) NSIndexPath *index;
@property (nonatomic) UIButton *seperator;

@property (nonatomic, weak) id<CollectionViewCellDelegate> delegate;

@end
