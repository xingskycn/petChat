//
//  PETableView.m
//  Pet
//
//  Created by Wu Evan on 6/19/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PETableView.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import "CBEmotionView.h"
#import "CBRegularExpressionManager.h"
#import "NSString+CBExtension.h"

@implementation PETableView

@synthesize toRoomJID, chatType;

@synthesize toJID;
@synthesize toName;
@synthesize xmpp;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveChatMessage:) name:CHAT_RECEIVE object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveGroupMessage:) name:GROUP_RECEIVE object:nil];
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentArray = [[NSMutableArray alloc] init];
        arrayHeight =[[NSMutableArray alloc] init];
        arrayLabel =[[NSMutableArray alloc] init];
        
        toJID =[[NSString alloc] init];
        toName =[[NSString alloc] init];
        toRoomJID =[[NSString alloc] init];
        
        xmpp =[PEXMPP sharedInstance];
        xmpp.peXmppDelegate =self;
        
        NSMutableArray *wk_paceImageNumArray =[[NSMutableArray alloc]init];
        NSMutableArray *wk_paceImageNameArray =[[NSMutableArray alloc]init];
        for (int i =0; i<5; i++) {
            for (int j =0; j <20; j++) {
                [wk_paceImageNameArray addObject:[NSString stringWithFormat:@"</f%d%02d>", i, j]];
                [wk_paceImageNumArray addObject:[NSString stringWithFormat:@"%d%02d.png", i, j]];
            }
        }
        emoArray =[NSDictionary dictionaryWithObject:wk_paceImageNumArray forKey:wk_paceImageNumArray];
    }
    return self;
}



- (void)addTextContent:(NSString*)str WithIsRoomChat:(BOOL)isRoom{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSMutableDictionary *msgDict =[NSMutableDictionary dictionaryWithObject:str forKey:@"textContent"];
//    [msgDict setObject:TEXT_MESSAGE forKey:@"type"];
//    NSString *msg =[JsonManager setJsonWithMutableDictionary:msgDict];
    [dic setObject:str forKey:@"content"];
    
    NSNumber* num = [NSNumber numberWithBool:YES];
    [dic setObject:num forKey:@"isSelf"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_NAME] forKey:@"nickName"];
    [contentArray addObject:dic];
//    [self creatLabelArray];
    [self reloadData];
    [self scrollToBottom];
    
    //发送消息
    [self sendMessage:str isRoom:isRoom type:TEXT_MESSAGE];
    
}

- (void)addImageContent:(NSString*)urlStr WithIsRoomChat:(BOOL)isRoom{
//    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSMutableDictionary *msgDict =[NSMutableDictionary dictionaryWithObject:urlStr forKey:@"content"];
    [msgDict setObject:IMAGE_MESSAGE forKey:@"type"];
    NSNumber* num = [NSNumber numberWithBool:YES];
    [msgDict setObject:num forKey:@"isSelf"];
    [msgDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_NAME] forKey:@"nickName"];
    [contentArray addObject:msgDict];
    [self reloadData];
    [self scrollToBottom];
    
    //发送消息
    [self sendMessage:urlStr isRoom:isRoom type:IMAGE_MESSAGE];
    
//    //设置自动回复
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(returnTalk) userInfo:nil repeats:NO];
}

- (void)returnTalk:(NSDictionary *)dataDict {
//    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:0];
//    
//    NSNumber* num = [NSNumber numberWithBool:NO];
//    [dic setObject:@"您好，稍后为您服务" forKey:@"content"];
//    [dic setObject:num forKey:@"isSelf"];
    [contentArray addObject:dataDict];
//    [self creatLabelArray];
    [self reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[contentArray count] -1 inSection:0];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//- (void)creatLabelArray
//{
//    if (arrayHeight.count > 0) {
//        [arrayHeight removeAllObjects];
//    }
//    for (int i = 0; i < [contentArray count]; i++) {
//        OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
//        NSString *text = [[contentArray objectAtIndex:i] objectForKey:@"content"];
//        [self creatAttributedLabel:text Label:label];
//        NSNumber *heightNum = [[NSNumber alloc] initWithFloat:label.frame.size.height];
//        [arrayLabel addObject:label];
//        [CustomMethod drawImage:label];
//        [arrayHeight addObject:heightNum];
//    }
//}
//
//- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label
//{
//    [label setNeedsDisplay];
//    NSMutableArray *httpArr = [CustomMethod addHttpArr:o_text];
//    NSMutableArray *phoneNumArr = [CustomMethod addPhoneNumArr:o_text];
//    NSMutableArray *emailArr = [CustomMethod addEmailArr:o_text];
//    
//    NSString *text = [CustomMethod transformString:o_text emojiDic:emoArray];
//    text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
//    
//    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
//    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
//    [attString setFont:[UIFont systemFontOfSize:16]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setAttString:attString withImages:wk_markupParser.images];
//    
//    NSString *string = attString.string;
//    
//    if ([emailArr count]) {
//        for (NSString *emailStr in emailArr) {
//            [label addCustomLink:[NSURL URLWithString:emailStr] inRange:[string rangeOfString:emailStr]];
//        }
//    }
//    
//    if ([phoneNumArr count]) {
//        for (NSString *phoneNum in phoneNumArr) {
//            [label addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
//        }
//    }
//    
//    if ([httpArr count]) {
//        for (NSString *httpStr in httpArr) {
//            [label addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
//        }
//    }
//    
//    label.delegate = self;
//    CGRect labelRect = label.frame;
//    labelRect.size.width = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
//    labelRect.size.height = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
//    label.frame = labelRect;
//    label.underlineLinks = YES;//链接是否带下划线
//    [label.layer display];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [contentArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [arrayHeight[indexPath.row] intValue] + 35 + 20 +10;
    NSString *type =[[contentArray objectAtIndex:indexPath.row] objectForKey:@"type"];
    if ([type isEqualToString:IMAGE_MESSAGE]) {
        CGSize size = CGSizeMake(100.0f, 100.0f);
        return size.height + 35 + 20 +10;
    } else {
        NSString* content = [[contentArray objectAtIndex:indexPath.row] objectForKey:@"content"];
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        return size.height + 35 + 20 +10;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* strID = @"ID";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *topLabel =[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 3.0f, 300.0f, 20.0f)];
        topLabel.tag =909;
        topLabel.textColor =[UIColor lightGrayColor];
        topLabel.font =[UIFont systemFontOfSize:12.0f];
        topLabel.textAlignment =NSTextAlignmentCenter;
        [cell addSubview:topLabel];
        
        UIImage *iconImage =[UIHelper imageName:@"chat_icon"];
        UIImageView* icon = [[UIImageView alloc] initWithImage:iconImage];
        icon.tag = 300;
        icon.frame = CGRectMake(10, 10, 30, 30);
        [cell addSubview:icon];
        
        //建立左边的bubble
        UIImage* leftImage = [UIHelper imageName:@"chat_pop_left"];
        UIImageView* leftBubble = [[UIImageView alloc] initWithImage:[leftImage stretchableImageWithLeftCapWidth:20 topCapHeight:18]];
        leftBubble.hidden = YES;
        leftBubble.tag = 100;
        leftBubble.frame = CGRectMake(10, 10, 100, 30);
        [cell addSubview:leftBubble];
        //左边的标签
        UILabel* leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 18, 20, 14)];
        leftLabel.tag = 101;
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.numberOfLines = 0;
        leftLabel.lineBreakMode = NSLineBreakByCharWrapping;
        leftLabel.font = [UIFont systemFontOfSize:14.0];
        [leftBubble addSubview:leftLabel];
        //左边的imageView
        UIImageView *leftImageV =[[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 116, 96)];
        leftImageV.tag =102;
        [leftBubble addSubview:leftImageV];
        //左边的view
        CBEmotionView *leftEmo =[[CBEmotionView alloc] init];
        leftEmo.tag =401;
        [leftLabel addSubview:leftEmo];
        //右边的bubble
        UIImage* rightImage = [UIHelper imageName:@"chat_pop_right"];
        UIImageView* rightBubble = [[UIImageView alloc] initWithImage:[rightImage stretchableImageWithLeftCapWidth:20 topCapHeight:18]];
        rightBubble.hidden = YES;
        rightBubble.tag = 200;
        rightBubble.frame = CGRectMake(320 - 30, 10, 20, 20);
        [cell addSubview:rightBubble];
        //右边的label
        UILabel* rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 18, 20, 14)];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.tag = 201;
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.numberOfLines = 0;
        rightLabel.lineBreakMode = NSLineBreakByCharWrapping;
        rightLabel.font = [UIFont systemFontOfSize:14.0];
        [rightBubble addSubview:rightLabel];
        //右边的imageView
        UIImageView *rightImageV =[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 116, 96)];
        rightImageV.tag =202;
        [rightBubble addSubview:rightImageV];
        
        //右边的view
        CBEmotionView *rightEmo =[[CBEmotionView alloc] init];
        rightEmo.tag =402;
        [rightLabel addSubview:rightEmo];
        
        leftImageV.layer.cornerRadius =16.0f;
        leftImageV.clipsToBounds =YES;
        rightImageV.layer.cornerRadius =16.0f;
        rightImageV.clipsToBounds =YES;
    }
    UILabel *topLabel =(UILabel*)[cell viewWithTag:909];
    UIImageView* leftBubble = (UIImageView*)[cell viewWithTag:100];
    UILabel* leftLabel = (UILabel*)[cell viewWithTag:101];
    UIImageView *leftImageV =(UIImageView *)[cell viewWithTag:102];
    UIImageView* rightBubble = (UIImageView*)[cell viewWithTag:200];
    UILabel* rightLabel = (UILabel*)[cell viewWithTag:201];
    UIImageView *rightImageV =(UIImageView *)[cell viewWithTag:202];
    UIImageView *icon =(UIImageView *)[cell viewWithTag:300];
    
    CBEmotionView *leftEmo =(CBEmotionView *)[cell viewWithTag:401];
    CBEmotionView *rightEmo =(CBEmotionView *)[cell viewWithTag:402];
    
    BOOL isSelf = [[[contentArray objectAtIndex:indexPath.row] objectForKey:@"isSelf"] boolValue];
    NSString* content = [[contentArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    if (!content) {
        content = [[contentArray objectAtIndex:indexPath.row] objectForKey:@"textContent"];
    }
    NSString *type = [[contentArray objectAtIndex:indexPath.row] objectForKey:@"type"];
    
//    NSString *distance =@"0.51km";
//    NSString *time =@"05-10 12:30";
    NSString *nickName =[[contentArray objectAtIndex:indexPath.row] objectForKey:@"nickName"];
    [rightLabel addSubview:rightEmo];
    [leftLabel addSubview:leftEmo];
    topLabel.text = [NSString stringWithFormat:@"%@", nickName];
    CGSize size;
    if ([type isEqualToString:IMAGE_MESSAGE]) {
         size=CGSizeMake(120.0f, 100.0f);
        if (isSelf == YES) {
            
            topLabel.textAlignment =NSTextAlignmentRight;
            rightImageV.hidden =NO;
            rightLabel.hidden =YES;
            leftLabel.hidden =YES;
            rightBubble.hidden = NO;
            leftBubble.hidden = YES;
            [rightImageV setImageWithURL:[NSURL URLWithString:content] placeholderImage:[UIHelper imageName:@"cacheImage"]];
            rightBubble.frame = CGRectMake(320 - 22 - size.width - 45, 20, size.width+ 8, size.height+1);
            /*************************/
            icon.image =[UIImage imageNamed:@"owner1.png"];
            /*************************/
            icon.frame =CGRectMake(320-40, 26, 34, 34);
        } else {
            
            topLabel.textAlignment =NSTextAlignmentLeft;
            leftImageV.hidden =NO;
            rightLabel.hidden =YES;
            leftLabel.hidden =YES;
            rightBubble.hidden = YES;
            leftBubble.hidden = NO;
            leftLabel.hidden =YES;
            [leftImageV setImageWithURL:[NSURL URLWithString:content] placeholderImage:[UIHelper imageName:@"cacheImage"]];
            leftBubble.frame = CGRectMake(45, 20, size.width+ 8, size.height+1);
            /*************************/
            icon.image =[UIImage imageNamed:@"owner2.png"];
            /*************************/
            icon.frame =CGRectMake(10, 26, 34, 34);
        }
    } else {
        
        NSArray *itemIndexes = [CBRegularExpressionManager itemIndexesWithPattern:
                                @"</f(\\w+)>" inString:content];
        // 将 emotionString 中的特殊字符串替换为空格
        NSString *newString = [content replaceCharactersAtIndexes:itemIndexes
                                                       withString:@"占a"];
        size = [newString sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        if (isSelf == YES) {
            
            topLabel.textAlignment =NSTextAlignmentRight;
            rightLabel.hidden =NO;
            leftLabel.hidden =YES;
            rightBubble.hidden = NO;
            leftBubble.hidden = YES;
            leftImageV.hidden =YES;
            rightImageV.hidden =YES;
//            rightLabel.text = content
            rightLabel.frame = CGRectMake(8, 0, size.width, size.height +10);
            rightBubble.frame = CGRectMake(320 - 22 - size.width - 45, 25, size.width + 22, size.height + 15);
            
            //表情+文字
            rightEmo.emotionString =content;
            rightEmo.frame =CGRectInset(rightLabel.bounds, 0.0f, -1.0f);
            rightEmo.backgroundColor =ClearColor;
            [rightEmo cookEmotionString];
            /*************************/
            icon.image =[UIImage imageNamed:@"owner1.png"];
            /*************************/
            icon.frame =CGRectMake(320-40, 26, 34, 34);
        } else {
            topLabel.textAlignment =NSTextAlignmentLeft;
            
            leftLabel.hidden =NO;
            rightLabel.hidden =YES;
            rightBubble.hidden = YES;
            leftBubble.hidden = NO;
            leftImageV.hidden =YES;
            rightImageV.hidden =YES;
//            leftLabel.text = content;
            leftLabel.frame = CGRectMake(15, 0, size.width, size.height +10);
            leftBubble.frame = CGRectMake(45, 25, size.width + 22, size.height + 15);
            
            
            //表情+文字
            leftEmo.emotionString =content;
            leftEmo.frame =CGRectInset(leftLabel.bounds, 0.0f, -1.0f);
            leftEmo.backgroundColor =ClearColor;
            [leftEmo cookEmotionString];
            /*************************/
            icon.image =[UIImage imageNamed:@"owner2.png"];
            /*************************/
            icon.frame =CGRectMake(10, 26, 34, 34);
        }
    }
    
    cell.backgroundColor =[UIColor clearColor];
    
    
    return cell;
}

- (void)scrollToBottom {
    if (contentArray.count !=0) {
        
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:contentArray.count-1 inSection:0];
        [self scrollToRowAtIndexPath:scrollIndexPath
                    atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark --------xmpp 操作---------
- (void)sendMessage:(NSString *)str isRoom:(BOOL)isRoom type:(NSString *)type {
    NSMutableDictionary* msgDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //    NSMutableDictionary *msgDict =[NSMutableDictionary dictionaryWithObject:str forKey:@"textContent"];
    //    NSString *msg =[JsonManager setJsonWithMutableDictionary:msgDict];
    [msgDict setObject:str forKey:@"content"];
    NSNumber* num = [NSNumber numberWithBool:YES];
    [msgDict setObject:type forKey:@"type"];
    [msgDict setObject:num forKey:@"isSelf"];
    NSString *msgStr =[msgDict JSONString];
    
    //通过xmpp发送消息
    if (chatType ==chatType_Single) {
        [xmpp sendMessage:msgStr toUser:toJID];
    } else {
        [xmpp sendMessage:msgStr toRoom:toRoomJID];
    }
}

#pragma mark --------xmpp 通知---------
- (void)receiveChatMessage:(NSNotification*) notification {
    if (chatType ==chatType_Single) {
        NSDictionary * msgDict = [notification object];
        
        if (chatType ==chatType_Single) {
            NSString *to =[NSString stringWithFormat:@"%@", toJID];
            if ([to isEqualToString:[msgDict objectForKey:@"fromStr"]]) {
                
                [self returnTalk:msgDict];
            }
        } else {
            NSString *to =[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID];
            if (![to isEqualToString:[msgDict objectForKey:@"nickName"]]) {
                
                [self returnTalk:msgDict];
            }
            
        }
    }
    
}

- (void)receiveGroupMessage:(NSNotification*) notification {
    if (chatType ==chatType_Room) {
        NSDictionary * msgDict = [notification object];
        
        if (chatType ==chatType_Single) {
            NSString *to =[NSString stringWithFormat:@"%@", toJID];
            if ([to isEqualToString:[msgDict objectForKey:@"fromStr"]]) {
                
                [self returnTalk:msgDict];
            }
        } else {
            NSString *to =[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID];
            if (![to isEqualToString:[msgDict objectForKey:@"nickName"]]) {
                
                [self returnTalk:msgDict];
            }
            
        }
    }
    
}

#pragma mark --------fmdb 操作---------
- (void)setupData {
    NSString *tableName =[NSString stringWithFormat:@"%@%@", DB_MSG_NAME, [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID]];
    
    PEFMDBManager *dbManager =[PEFMDBManager sharedManager];
    dbManager.peFMDBDelegate = self;
    [dbManager check];
    if (![dbManager isTableExisted:tableName]) {
        //创建表
        NSArray *cArray =@[DB_COLUMN_MSG_DATE,
                           DB_COLUMN_MSG_FROM,
                           DB_COLUMN_MSG_TO,
                           DB_COLUMN_MSG_CONTENT,
                           DB_COLUMN_MSG_NICKNAME
                           ];
        [dbManager creatNewTableWithTableName:tableName AndColumns:cArray];
    }
    
    if (chatType ==chatType_Room) {
        
        //取数据
        [dbManager selectNeweatMessageFromTableWithToFrom:tableName :toRoomJID :toRoomJID];
    }else {
        //取数据
        [dbManager selectNeweatMessageFromTableWithToFrom:tableName :toJID :toJID];
    }
}
#pragma mark --------fmdb 委托---------
- (void)selectMessageDataSucc:(NSArray *)data {
    contentArray =nil;
    contentArray =[[NSMutableArray alloc] init];
    for (int i = data.count-1; i>=0;i--) {
        NSString *dataStr =data[i];
        NSDictionary *dict =[dataStr objectFromJSONString];
        [contentArray addObject:dict];
    }
    
    [self reloadData];
    [self scrollToBottom];
}

@end
