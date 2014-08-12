//
//  UIHelper.h
//  Pet
//
//  Created by Evan Wu on 6/10/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelper : NSObject

+ (UIImage *)imageName:(NSString *)imageName;

+ (UIImage *)setImageFromColor:(UIColor *)color;
+ (UIColor *)colorWithHexString: (NSString *)color;
@end
