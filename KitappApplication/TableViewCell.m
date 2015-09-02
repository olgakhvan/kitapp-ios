//
//  TableViewCell.m
//  KitappApplication
//
//  Created by Olga Khvan on 02.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style title:(NSString *)title andAuthor:(NSString *)author
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.author = author;
    }
   // self.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0];
    return self;
}

@end
