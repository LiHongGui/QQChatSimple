//
//  ViewController.m
//  QQChatSimple
//
//  Created by MichaelLi on 2016/11/3.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import "ViewController.h"
#import "QQChatModel.h"
#import "QQChatFrameModel.h"
#import "QQChatCellTableViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) NSMutableArray *dataMutb;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.textField.delegate  = self;
    //添加监听---监听键盘的动作:(位置,动画,高度)
    //键盘将要出现
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIKeyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIKeyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    //软件启动后,界面停留在消息的最后一行
    [self scrollViewPositionBottom];
}

#warning 记住,添加监听时,一定要移除监听
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark
#pragma mark -  键盘将要出现
-(void)UIKeyboardWillAppear:(NSNotification *)noti
{
    NSLog(@"noti%@",noti);
    /*
     动画频率
     UIKeyboardAnimationCurveUserInfoKey = 7;
     动画持续时间
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     键盘高度
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {414, 271}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {207, 871.5}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {207, 600.5}";
     键盘没出现位置
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 736}, {414, 271}}";
     键盘出现位置
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 465}, {414, 271}}";
     UIKeyboardIsLocalUserInfoKey = 1;
     */
    /*
     键盘时间间隔
     */
    //取出通知中心的信息
    NSDictionary *dict = noti.userInfo;
    NSTimeInterval timer = [dict[UIKeyboardAnimationDurationUserInfoKey] integerValue];
    /*
     键盘的高度
     */
    //没弹出时的高度
    CGRect willKeyboardAppear = [dict[UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    //弹出后的位置
    CGRect DidKeyboardAppear = [dict[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //键盘的高度
    CGFloat keyBoardY = (DidKeyboardAppear.origin.y - willKeyboardAppear.origin.y);
    
    [UIView animateWithDuration:timer animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, keyBoardY);
    }];
}
#pragma mark
#pragma mark -  键盘将要消失
-(void)UIKeyboardWillDisappear:(NSNotification *)noti
{
    //取出通知中心的信息
    NSDictionary *dict = noti.userInfo;
    NSTimeInterval timer = [dict[UIKeyboardAnimationDurationUserInfoKey] integerValue];
    [UIView animateWithDuration:timer animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark
#pragma mark -  设置点击键盘return建
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    /*
     点击return 后,键盘收起,tableView返回到以前
     添加数据,
     */
    //判断发送空消息

    //我发送信息
    [self senderMessageWith:textField.text andWithType:QQUserTypeMe];
    //对方发送信息
    [self senderMessageWith:@"李宏贵是个伟大的人" andWithType:QQUserTypeOthers];
    
    //取消第一响应
    [self.textField resignFirstResponder];
    //平移返回
    self.view.transform = CGAffineTransformIdentity;
    
    [self scrollViewPositionBottom];
    
    return YES;
}

/*
 滚动到最后一行
 */
-(void)scrollViewPositionBottom
{
    //滚动到最后一行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataMutb.count -1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)senderMessageWith:(NSString *)textField andWithType:(QQUserType)type
{
    //设置发送的文本
    if (textField.length == 0) {
        return;
    }else{
        
        QQChatModel *model = [[QQChatModel alloc]init];
        model.text = textField;
        model.type = type;
        //设置时间
        NSDate *currentData = [NSDate date];//当前时间
        //时间格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"HH:mm";
        NSString *dateString = [formatter stringFromDate:currentData];
        model.time = dateString;
        
        QQChatFrameModel *lastModel = self.dataMutb.lastObject;
        if ([model.time isEqualToString:lastModel.qqChatModel.time]) {
            model.hiddenTimeLabel = YES;
        }
        
        //添加到数据中
        QQChatFrameModel *frameModel = [[QQChatFrameModel alloc]init];
        frameModel.qqChatModel = model;
        [self.dataMutb addObject:frameModel];
        //清空
        self.textField.text = @"";
        [_tableView reloadData];
    }
}


#pragma mark
#pragma mark -  点击tableView时键盘消失
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
    NSLog(@"lihongui ");
}
#pragma mark
#pragma mark -  懒加载
-(NSMutableArray *)dataMutb
{
    if (_dataMutb == nil) {

        _dataMutb = [NSMutableArray array];
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"messages.plist" ofType:nil];
        NSArray *temp = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *dict in temp) {

            QQChatModel *qqChatModel = [QQChatModel qqChatModelWithDict:dict];
            //在这里可以拿到时间数据(数据都在self.dataMutb里,而且只架子啊一次)
                        QQChatFrameModel *lastTimeLabel = self.dataMutb.lastObject;
                        if ([qqChatModel.time isEqualToString:lastTimeLabel.qqChatModel.time]) {
                            //隐藏时间(不能设置时间frame为0,因为控件布局都彼此相关)
                            qqChatModel.hiddenTimeLabel = YES;
                        }
            //赋值给QQChatFrameModel
            QQChatFrameModel *qqChatFrameModel = [[QQChatFrameModel alloc]init];
            qqChatFrameModel.qqChatModel = qqChatModel;
            [_dataMutb addObject:qqChatFrameModel];
        }
    }
    return _dataMutb;
}

//-(NSMutableArray *)dataMutb
//{
//    if (_dataMutb == nil) {
//
//        NSMutableArray *mutb = [NSMutableArray array];
//        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"messages.plist" ofType:nil];
//        NSArray *temp = [NSArray arrayWithContentsOfFile:filePath];
//        for (NSDictionary *dict in temp) {
//
//            QQChatModel *qqChatModel = [QQChatModel qqChatModelWithDict:dict];
//            //在这里可以拿到时间数据(数据都在self.dataMutb里,而且只架子啊一次)
//            QQChatFrameModel *lastTimeLabel = self.dataMutb.lastObject;
//            if ([qqChatModel.time isEqualToString:lastTimeLabel.qqChatModel.time]) {
//                //隐藏时间(不能设置时间frame为0,因为控件布局都彼此相关)
//                qqChatModel.hiddenTimeLabel = YES;
//            }
//            //赋值给QQChatFrameModel
//            QQChatFrameModel *qqChatFrameModel = [[QQChatFrameModel alloc]init];
//            qqChatFrameModel.qqChatModel = qqChatModel;
//            [mutb addObject:qqChatFrameModel];
//        }
//        _dataMutb = mutb;
//    }
//    return _dataMutb;
//}

#pragma mark
#pragma mark -  组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark
#pragma mark -  行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataMutb.count;
}

#pragma mark
#pragma mark -  cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"QQChat";
    QQChatCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
        cell = [[QQChatCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    QQChatModel *qqChatModel = self.dataMutb[indexPath.row];
    QQChatFrameModel *qqChatFrame = self.dataMutb[indexPath.row];
    cell.qqChatFrameModel = qqChatFrame;
    
    //设置cell选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark
#pragma mark -  cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QQChatFrameModel *qqChatFrame = self.dataMutb[indexPath.row];
    NSLog(@"cellHeight%f",qqChatFrame.cellHeight);
    return qqChatFrame.cellHeight;
}
@end
