//
//  ViewController.m
//  TableView双级联动
//
//  Created by 王双龙 on 2018/3/30.
//  Copyright © 2018年 王双龙. All rights reserved.
//

#import "ViewController.h"
#import "PrefixHeader.pch"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView * leftTableView;

@property (nonatomic, strong) UITableView * rightTableView;

/**
 滑到了第几组
 */
@property (nonatomic, strong) NSIndexPath * currentIndexPath;

//用来处理leftTableView的cell的点击事件引起的rightTableView的滑动和用户拖拽rightTableView的事件冲突
@property (nonatomic, assign) BOOL isSelected;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.view  addSubview:self.leftTableView];
    [self.view  addSubview:self.rightTableView];
    
}

#pragma mark -- Getter

- (UITableView *)leftTableView{
    
    if (_leftTableView == nil) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, SCREEN_WIDTH / 3.0, SCREEN_HEIGHT - StatusBarHeight) style:UITableViewStyleGrouped];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    
    if (_rightTableView == nil) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3.0, StatusBarHeight, SCREEN_WIDTH / 3.0 * 2, SCREEN_HEIGHT - StatusBarHeight) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
    }
    return _rightTableView;
}

#pragma mark -- UITableViewDelegate  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return 1;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        return 44;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return 0.01;
    }
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return nil;
    }
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    label.text = [NSString stringWithFormat:@"第%ld组",section];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    
    if (tableView == _leftTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组",indexPath.section];
        if (indexPath == _currentIndexPath) {
            cell.textLabel.textColor = [UIColor greenColor];
        }else{
            cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld组内的商品",(long)indexPath.section];
    return cell;
}

- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == _leftTableView) {
        _currentIndexPath = indexPath;
        [tableView reloadData];
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        _isSelected = YES;
    }
    
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //方案一
    //    if (scrollView == _rightTableView && _isSelected == NO) {
    //返回tableView可见的cell数组
    //        NSArray * array = [_rightTableView visibleCells];
    //返回cell的IndexPath
    //        NSIndexPath * indexPath = [_rightTableView indexPathForCell:array.firstObject];
    //        NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
    //        _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    //        [_leftTableView reloadData];
    //        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    //    }
    
    //方案二
    if (scrollView == _rightTableView && _isSelected == NO) {
        //系统方法返回处于tableView某坐标处的cell的indexPath
        NSIndexPath * indexPath = [_rightTableView indexPathForRowAtPoint:scrollView.contentOffset];
        NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
        _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [_leftTableView reloadData];
        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
    
    //获取处于UITableView中心的cell
    //系统方法返回处于tableView某坐标处的cell的indexPath
    NSIndexPath * middleIndexPath = [_rightTableView  indexPathForRowAtPoint:CGPointMake(0, scrollView.contentOffset.y + _rightTableView.frame.size.height/2)];
    NSLog(@"中间的cell：第 %ld 组 %ld个",middleIndexPath.section, middleIndexPath.row);
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isSelected = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
