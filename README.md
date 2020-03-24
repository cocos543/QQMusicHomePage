# 文档更新说明
* 最后更新 2020年03月22日
* 首次更新 2020年03月24日

# 前言
　　现在的iPhone性能越来越好, 正常开发一个界面都很少会遇到影响体验的卡顿. 但是如果把APP放到比较老的型号上, 卡顿就非常常见了. 利用这篇文章, 结合一下实际的案例QQ音乐首页, 聊一聊解决卡顿的基本思想和方法论.

这是QQ音乐的界面
　　<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music.jpg" width=30% /><img src="http://blog.cocosdever.com/images/qq-music2.jpg" width=30% />
　　</div>

这是Demo的界面, 部分素材找不到就临时用别的代替一下, 效果基本一致
　　<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-homepage.jpg" width=30% /><img src="http://blog.cocosdever.com/images/qq-music-homepage2.jpg" width=30% />
　　</div>

# 源码下载

[QQMusicHomePage](https://github.com/cocos543/QQMusicHomePage)

# 首页的实现思路

## 整体UI结构

先用一个**UITableView**实现界面的整体, 而每一个能够进行左右滚动的UITableViewCell, 都嵌套一个**UICollectionView**来做. 
　　
虽然说UICollectionView比较重量级, 不过我在老古董iPhone6 Plus上看, CPU占有率只有10%左右, 完全可以接受的. 
　　
至于其他的能支持横向滚动并且复用视图的组件, 这东西我个人认为, 只有系统提供的视图无法优化到满意的情况下, 再去造轮子或者用新轮子, 要看看额外做的工作和得到的收益是不是值得.
　　
<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-ui-structure.png" width=30% />
</div>

## 布局方式

先用Auto Layout + XIB文件的形式开发视图. 自动布局相比手动布局, 好处就是速度快一些, 现在第一个版本用的是自动布局, 假如后面优化之后还有明显卡顿的话, 再考虑代码布局.

## 首页类型划分

### 顶部搜索框

QQ音乐的搜索框会随着页面向上移动而移动, 但是页面向下移动的时候, 搜索框则固定不动. 所以这里采用一个独立的UIView, 存放搜索框也左边的`音乐馆`**label**, 以及右边的Logo

<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-search.png" width=30% />
</div>

并且监听了TableView的`contentOffset`属性, 根据滚动的偏移量来设置搜索视图的位置. 这里用到了我之前做过的一个支持自动释放的便捷观察者类库 `"NSObject+CCEasyKVO.h"` , 有兴趣可以看代码.

### Banner

搜索框下面是一个可以左右滚动的Banner, 网上轮子很多, 这里就不重新做了.

### 固定内容的视图

这部分界面有5个图标, 因为是固定不变也不可以滚动的, 所以可以直接用普通的UIView或者UIStackView来做, 这里我直接用UICollectionView实现. 

再用另一个UITableVIewCell存放下方的`歌单新碟`, `数字专辑` 两个普通的UIView.
<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-function.png" width=30% /><img src="http://blog.cocosdever.com/images/qq-music-function-cell.png" width=10% />
</div>

### 横向瀑布流

`#话题部分` 是一个横向瀑布流视图, 采用自定义**UICollectionViewFlowLayout**实现.
<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-topic.gif" width=30% />
</div>

创建**TopicWalterfallFlowLayout**类, 继承自**UICollectionViewFlowLayout**, 重写`prepareLayout`方法, 算好每一个Topic的文本宽度并且缓存起来, 这样**TopicWalterfallFlowLayout**就可以算出全部**CollectionCell**的位置了. 效果如上图.

### 各种不同的CollectionViewCell

往下的可以横向滚动的视图都用UICollectionView实现, 其中分为多种不同的Cell. QQ音乐首页的Cell种类是后台配置的, 我这里只挑选其中几种实现, 其他的都是一样的道理.

<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-song-list.png" width=30% /><img src="http://blog.cocosdever.com/images/qq-music-movie.png" width=30% /><img src="http://blog.cocosdever.com/images/qq-music-vip.png" width=30% />
</div>

其中歌单的Cell, 因为要在图片上显示白色的收听数字, 所以我在图片上加了一个灰色渐变蒙版, 这样底部的数字看起来才会清晰. 不然遇到白色图片文字就看不清了. 另外两个Cell也是同理 不过截图没体现出来. 这些圆角都使用下面两行代码搞定

``` objc
self.maskV.layer.masksToBounds = YES;
self.maskV.layer.cornerRadius = 10.f;
```

到这里基本就把首页的UI结构介绍完毕了. 这个版本的代码可以从`tag v1`获取.

# 代码优化

兴匆匆地运行了一下`tag v1`代码, 在iPhone xs max上挺流畅的, 有点失望, 这不是没得优化吗😂.

换个手机, 在iPhone6p上跑了一下, 问题来了. 好卡, 略兴奋, 卡顿还挺严重的, 这种会影响到用户体验, 没优化好肯定不能上线的.

不过有一点让我觉得奇怪的是, 屏幕上显示的FPS一直是60, CPU占有率只有15%, 这种卡顿很容易让人猜出来是GPU处理不过来. 因为FPS指示器用的是`CADisplayLink`加一个整形变量实现的, 计算出`CADisplayLink`每秒调用的次数就是帧率. 既然这个FPS一直是60, 那么意味着CPU还是能处理的过来的.

借助性能调试工具Instruments中的Core animation, 可以看到真实的帧率.

<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-gup-v1.png" width=40% />
</div>

帧率在40帧左右, GPU使用率高达90%.

下面分别从两个角度来谈代码优化问题.

## GPU 优化

GPU使用率过高, 常见的原因有下面几个

1. 渲染的图片是否有阴影, 圆角
2. 图片是否由多个图层动态合成显示.
3. 渲染出的图片的缓存命中率.

这几个点都比较容易想到. iOS对阴影和圆角会造成离屏渲染. 这里需要重点理解离屏渲染为什么会造成GPU的大量消耗! 

未完待续!

## CPU 优化

# 参考文章
[关于iOS离屏渲染的深入研究](https://zhuanlan.zhihu.com/p/72653360)
