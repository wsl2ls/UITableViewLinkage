简书地址： https://www.jianshu.com/p/70cdcdcb6764

> UITableView/UICollectionView获取特定位置的cell 主要依赖于各自对象提供的的api方法，应用示例如下：

```
// returns nil if point is outside of any row in the table
//tableView
- (nullable NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point;  
//collectionView                       
- (nullable NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point;
```

## 一、tableView双级联动

![菜单栏联动.gif](https://upload-images.jianshu.io/upload_images/1708447-b44dc69659741fac.gif?imageMogr2/auto-orient/strip)

![UITableView双级联动.gif](https://upload-images.jianshu.io/upload_images/1708447-a2963052ab3aef19.gif?imageMogr2/auto-orient/strip)

> 以上两种效果比较类似，实现的关键在于都是需要获得在滑动过程中滑动到tableView顶部的cell的indexPath。

##### 方案一(不推荐原因会在后面提到)：获得当前可见的所有cell，然后取可见cell数组中的第一个cell就是目标cell，再根据cell获得indexPath。代码如下

```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

if (scrollView == _rightTableView && _isSelected == NO) {
//返回tableView可见的cell数组
NSArray * array = [_rightTableView visibleCells];
//返回cell的IndexPath
NSIndexPath * indexPath = [_rightTableView indexPathForCell:array.firstObject];
NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
_currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
[_leftTableView reloadData];
[_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

}

```

##### 方案二(推荐使用)：利用偏移量！偏移量的值实际上可以代表当时处于tableView顶部的cell在tableView上的相对位置， 那么我们就可以根据偏移量获得处于顶部的cell的indexPath。代码如下

```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

if (scrollView == _rightTableView && _isSelected == NO) {
//系统方法返回处于tableView某坐标处的cell的indexPath
NSIndexPath * indexPath = [_rightTableView indexPathForRowAtPoint:scrollView.contentOffset];
NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
_currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
[_leftTableView reloadData];
[_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

}

```

## 二、 获取处于UITableView中心的cell

![获取UITableView中心线cell.gif](https://upload-images.jianshu.io/upload_images/1708447-fb94b116b561de01.gif?imageMogr2/auto-orient/strip)

> 获取处于tableView中间cell的效果，用上述**方案一**比较麻烦：要考虑可见cell 的奇、偶个数问题，还有cell是否等高的情况；**方案二**用起来就快捷方便多了，取的cell的位置的纵坐标相当于在偏移量的基础上又增加了tableView高度的一半。代码如下：

```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

//获取处于UITableView中心的cell
//系统方法返回处于tableView某坐标处的cell的indexPath
NSIndexPath * middleIndexPath = [_rightTableView  indexPathForRowAtPoint:CGPointMake(0, scrollView.contentOffset.y + _rightTableView.frame.size.height/2)];
NSLog(@"中间的cell：第 %ld 组 %ld个",middleIndexPath.section, middleIndexPath.row);
}

```

>俺目前能想到的也就这了，各位同僚有什么好的想法欢迎在此留言交流😀😁😀👏👏👏


> 更新于2018/9/7 ：UICollectionView获取特定位置的item与UITableView相似，仅仅是获取的方法名不同，如下：

```
NSIndexPath * indexPath = [_collectionView  indexPathForItemAtPoint:scrollView.contentOffset];
NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);

```

>  获取手指在UIScrollView上的滑动速率、方向以及移动距离

```

// velocityInView： 手指在视图上移动的速度（x,y）, 正负也是代表方向，值得一体的是在绝对值上|x| > |y| 水平移动， |y|>|x| 竖直移动。
CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:scrollView];

//translationInView : 手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负。X和Y的数值都是距离手指起始位置的距离
CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];

```

![](https://upload-images.jianshu.io/upload_images/1708447-8c0b18a244d9270b.gif?imageMogr2/auto-orient/strip)

欢迎扫描下方二维码关注——iOS开发进阶之路——微信公众号：iOS2679114653 本公众号是一个iOS开发者们的分享，交流，学习平台，会不定时的发送技术干货，源码,也欢迎大家积极踊跃投稿，(择优上头条) ^_^分享自己开发攻城的过程，心得，相互学习，共同进步，成为攻城狮中的翘楚！

![iOS开发进阶之路.jpg](http://upload-images.jianshu.io/upload_images/1708447-c2471528cadd7c86.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
