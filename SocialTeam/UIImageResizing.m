//
//  UIImageResizing.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImageResizing.h"

@implementation UIImage (Resize)

    
-(UIImage *)scaledToSize:(CGSize) newSize{
    UIGraphicsBeginImageContext(newSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, newSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, newSize.width, newSize.height), self.CGImage);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
