//
//  TableViewCell.h
//  KitappApplication
//
//  Created by Olga Khvan on 02.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewCell;

@protocol TableViewCellDelegate <NSObject>

@required
-(void)cell: (TableViewCell *)cell deleteButtonPressed: (UIButton *)button;
-(void)cell: (TableViewCell *)cell likeButtonPressed: (UIButton *)button;
@end

@interface TableViewCell : UITableViewCell

@property (nonatomic) UIImageView *bookImage;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *authorLabel;
@property (nonatomic) UILabel *priceLabel;

@property (nonatomic) UIButton *deleteButton;
@property (nonatomic) UIButton *likeButton;
@property (nonatomic) UIButton *logoutButton;

@property (nonatomic, weak) id <TableViewCellDelegate> delegate;

@end

