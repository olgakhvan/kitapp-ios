//
//  UIImage+Scale.m
//  KitappApplication
//
//  Created by Olga Khvan on 01.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)


- (UIImage *) scaledToSize: (CGSize) size{
    if(CGSizeEqualToSize(self.size, size)){
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
