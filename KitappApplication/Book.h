//
//  Books.h
//  KitappApplication
//
//  Created by Olga Khvan on 01.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Book : PFObject <PFSubclassing>

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *descr;
@property (nonatomic) NSNumber *price;
@property (nonatomic) PFFile *image;
@property (nonatomic) NSString *genre;
@property (nonatomic) NSString *location;

+ (NSString *)parseClassName;
@end
