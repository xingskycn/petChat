//
//  CBEmotionView.h
//  CBEmotionView
//
//  Created by ly on 8/21/13.
//  Copyright (c) 2013 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "CBRegularExpressionManager.h"
#import "NSString+CBExtension.h"
#import "NSArray+CBExtension.h"

@interface CBEmotionView : UIView

// 原始的字符串
StrongProperty NSString *emotionString;

// 处理过后的用户绘图的富文本字符串
StrongProperty_r NSAttributedString *attrEmotionString; 

// 按顺序保存的 emotionString 中包含的表情名字
StrongProperty_r NSArray *emotionNames;

StrongProperty_r NSArray *emotionRanges;


@property (nonatomic) CTTypesetterRef typesetter;


- (id)initWithFrame:(CGRect)frame emotionString:(NSString *)emotionString;

/// 将 emotionString 中的特殊字符串替换为空格
// @discussion 不要直接调用此方法
- (void)cookEmotionString;

@end