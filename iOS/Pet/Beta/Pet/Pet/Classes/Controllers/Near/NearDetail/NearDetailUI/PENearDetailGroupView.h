//
//  PENearDetailGroupView.h
//  Pet
//
//  Created by Wu Evan on 6/16/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NearDetailGroupDelegate <NSObject>

- (void)didSelectAtGroup:(int)gID;

@end

@interface PENearDetailGroupView : UIView

@property (retain, nonatomic) NSString *titleName;

@property (retain, nonatomic) NSArray *dataArray;
@property (retain, nonatomic) NSString *groupID;
@property int count;

@property (nonatomic, assign) id<NearDetailGroupDelegate> nearDetailGroupDelegate;
@end
