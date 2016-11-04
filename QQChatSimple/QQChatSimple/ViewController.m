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
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray *dataMutb;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

#pragma mark
#pragma mark -  懒加载
-(NSMutableArray *)dataMutb
{
    if (_dataMutb == nil) {

        NSMutableArray *mutb = [NSMutableArray array];
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"messages.plist" ofType:nil];
        NSArray *temp = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *dict in temp) {

            QQChatModel *qqChatModel = [QQChatModel qqChatModelWithDict:dict];
            //赋值给QQChatFrameModel
            QQChatFrameModel *qqChatFrameModel = [[QQChatFrameModel alloc]init];
            qqChatFrameModel.qqChatModel = qqChatModel;

            //在这里可以拿到时间数据(数据都在self.dataMutb里,而且只架子啊一次)
            QQChatFrameModel *lastTimeLabel = self.dataMutb.lastObject;
            if ([qqChatModel.time isEqualToString:lastTimeLabel.qqChatModel.time]) {
                //隐藏时间(不能设置时间frame为0,因为控件布局都彼此相关)
//                qqChatModel.isHiddenTime = YES;
            }
        }
        _dataMutb = mutb;
    }
    return _dataMutb;
}
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
