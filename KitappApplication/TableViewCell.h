//
//  TableViewCell.h
//  KitappApplication
//
//  Created by Olga Khvan on 02.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *author;


-(instancetype) initWithStyle:(UITableViewCellStyle)style title:(NSString *)title andAuthor:(NSString *)author;

@end

