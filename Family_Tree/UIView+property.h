//
//  UIView+property.h
//  weddingplanner
//
//  Created by VACHHANI JAYDEEP on 8/12/15.
//  Copyright (c) 2015 VACHHANI JAYDEEP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (property)
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@end
@interface UIScrollView (property)
@property (nonatomic) IBInspectable CGSize contentSize;

@end

