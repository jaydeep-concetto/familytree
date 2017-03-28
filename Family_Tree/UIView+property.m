//
//  UIView+property.m
//  weddingplanner
//
//  Created by VACHHANI JAYDEEP on 8/12/15.
//  Copyright (c) 2015 VACHHANI JAYDEEP. All rights reserved.
//

#import "UIView+property.h"

@implementation UIView (property)
@dynamic borderColor,borderWidth,cornerRadius;

-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}
@end

@implementation UIScrollView (property)
@dynamic contentSize;
@end