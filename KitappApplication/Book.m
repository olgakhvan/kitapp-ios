//
//  Books.m
//  KitappApplication
//
//  Created by Olga Khvan on 01.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "Book.h"


@interface Book()


@end

@implementation Book

@dynamic title;
@dynamic author;
@dynamic descr;
@dynamic price;
@dynamic image;
@dynamic genre;
@dynamic location;

+(void) load{
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Books";
}
@end
