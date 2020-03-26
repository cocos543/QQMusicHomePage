# 文档更新说明
* 最后更新 2020年03月22日
* 首次更新 2020年03月26日

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
　　
演示的机器是iPhone 6 Plus, iOS 10.2, Xcode 11.3

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

`#话题部分` Topic是一个横向瀑布流视图, 采用自定义**UICollectionViewFlowLayout**实现.
<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-topic.gif" width=30% />
</div>

创建**TopicWalterfallFlowLayout**类, 继承自**UICollectionViewFlowLayout**, 重写`prepareLayout`方法, 算好每一个Topic的文本宽度并且缓存起来, 这样**TopicWalterfallFlowLayout**就可以算出全部**CollectionCell**的位置了. 效果如上图.

### 各种不同的CollectionViewCell

往下的可以横向滚动的视图都用UICollectionView实现, 其中分为多种不同的Cell. QQ音乐首页的Cell种类是后台配置的, 我这里只挑选其中几种实现, 其他的都是一样的道理.

<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-song-list.png" width=30% /><img src="http://blog.cocosdever.com/images/qq-music-movie.png" width=30% /><img src="http://blog.cocosdever.com/images/qq-music-vip.png" width=30% />
</div>

其中歌单的Cell, 因为要在图片上显示白色的文本, 所以我在图片上加了一个灰色渐变蒙版, 这样底部的数字看起来才会清晰. 不然遇到白色图片文字就看不清了. 另外两个Cell也是同理 不过截图没体现出来. 这些圆角都使用下面两行代码搞定

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

帧率在40帧左右, GPU使用率高达90%, 说明我猜的没错, 下面要做的事情就是平衡GPU和CPU的工作量.

下面分别从这两个角度来谈代码优化问题.

## GPU 优化

一说到优化, 很多人都知道圆角这些会影响性能, 可以用带圆角的图片啊, 用CGContext画带圆角图片之类的来取代对视图圆角的设置, 但是并不知道为什么要这么解决. 这会导致无法对出现的卡顿现象做比较深入的分析, 无法精准解决问题.

比如一开始我就对Topic部分带圆角的视图设置了`masksToBounds=YES` , 然后胡乱打开了光栅化等, 没有指导思想碰运气式地解决问题, 效率并不高.

GPU使用率过高, 常见的原因有下面几个
1. 太多纹理(texture)要处理, 比如一个View有太多子Layer.
2. 渲染的视图有阴影, 圆角.
3. Layer上有Mask.
4. View采用模糊显示, 比如用了UIVisualEffectView.
4. 栅格化(shouldRasterize)图层缓存命中率过低.

上面这几个比较常见. 

其中阴影,圆角, Mask, Effect, shouldRasterize这几个会触发GPU离屏渲染, 优化GPU的大部分方式, 就是如何处理好离屏渲染. 离屏渲染是GPU的性能杀手, 这里有必要去了解一下.

### iOS的渲染过程

从CPU计算好视图内容, 到显示在屏幕上给用户观看, iOS的UI渲染一共经历了下面几个过程.

<div align=center>
　　<img src="https://pic3.zhimg.com/80/v2-98077db5cb31318ec437f00762870142_1440w.jpg" width=50% />
</div>

我们的代码运行在Application层, CPU计算好视图信息(座标尺寸, 视图文本信息, 图层关系等), 会把数据提交到`Render Server`层, 接着进入GPU渲染, 再显示到屏幕上.  

> 实际过程比这个复杂, 可以找一下资料看看这个具体过程

### 什么是渲染? 光栅化?

一定要先搞明白什么叫**渲染**, 不然对这个渲染知识点只会是似懂非懂. 这里只讨论2D领域.

所谓的渲染, 粗鲁地说, 就是把几何图形, 图片数据, 文本等一大堆用来表达视图内容的东西, 计算成像素图(位图), 并且把像素图放到frame buffer中, 这个过程就叫渲染! 显示器就可以读取frame buffer的数据, 显示到屏幕上.

渲染里面经常看到光栅化这个词, 它指的是把几何图形像素化, 粗浅理解, 光栅化可以等同于渲染. 

这部分知识点应该足够我们做UI性能优化了...

> 看到一个很有意思的比喻, 如果把渲染比作做菜,  那么你起锅摆盘就是光栅化。

### 什么是GPU渲染, 什么是CPU渲染?

上面说的视图信息其实就是用的CALayer来表示, 由`Core Animation`这个框架负责传给GPU渲染(**硬件渲染**), 这就是为啥说用CALayer及其子类(CAShapeLayer等)来展示视图信息效率高, 因为它最后会由GPU渲染. 

而平时我们可能会自己用`CoreGraphics`这个框架, 创建一个图形上下文CGContext, 画啊画, 再得到一个UIImage, 赋值给layer.contents, 这个步骤其实就是我们自己手动用CPU渲染(**软件渲染**)出像素数据, 这样`Core Animation`就会直接把这个contents的内容放入到frame buffer中, 显示器直接读取frame buffer, 就可以把它里面一个一个像素打到屏幕上了.

<div align=center>
　　<img src="https://pic2.zhimg.com/80/v2-24394bcd0b84005553320df018e06999_1440w.jpg" width=50% />
</div>

当然渲染并不是一次完成, 比如一个视图有很多个子视图, 渲染的时候就要从最下层开始, 一层一层把视图内容渲染到frame buffer中, 这种方式, 称为**画家算法**.


> PS. 有关资料显示, iOS采用双缓冲技术, 实际上是有两个frame buffer, 用来加快渲染效率, 不管它有多少个, 原理都是一样. frame buffer(缓冲区), 就是一块内存区域, 用来存放即将显示到屏幕上的像素数据.

### 为什么会出现离屏渲染?

上面说到渲染就像在画画一样, 一层一层画, 前面画上去的东西就不能修改了. 

这就导致有些视图是无法直接渲染到frame buffer中, 比如有圆角, Mask, 阴影这些. 

**带圆角**需要裁剪的视图, 它的所有子视图也需要跟着裁剪, 要提高裁剪效率, 最好的做法就是把全部图层依次画到frame buffer中, 然后再裁剪. 不过前面已经说了, 画进去的东西就不能改了, 所以GPU只能在另一个地方开辟一个新的frame buffer用来存放临时的渲染结果, 然后再把最终结果复制到frame buffer. 这块新的frame buffer也叫离屏缓冲区, 自然这个过程就叫做离屏渲染了. 

可以看到, 离屏渲染需要GPU不停地切换工作环境, 从一个frame buffer切换到另一个frame buffer, GPU的工作环境称为上下文, 不停切换上下文, 会严重降低GPU的工作效率. 这块涉及到GPU的工作原理, 不是我的专业范围就不多说了.

<div align=center>
　　<img src="https://pic2.zhimg.com/80/v2-487022d244a9bdefbf03636f5c15ee89_1440w.jpg" width=40% />
</div>

**Mask**和**阴影**这些也是同个道理, 只有把全部视图都画好了, 才能知道裁剪的形状或者阴影的路径, 所以这个渲染的方式会转化成离屏渲染. 


<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-shadow-path.jpg" width=30% />
</div>

CALayer有个`shadowPath`, 设置好它GPU就可以事先知道阴影路径, 就不需要离屏渲染了. 可以看上图, 红色阴影就是用`shadowPath`实现的; 而圆角的设置, 如果不需要裁剪子视图的话, 把`masksToBounds`设置成NO, 也不会造成离屏渲染. 下文会讲到这个.

**注意, 不同版本iOS系统对渲染的处理会有差异, 如果能找到一次性渲染好视图的算法, 就不需要离屏了,  所以判断是不是离屏必须用专门的工具, 而不能单凭直觉**

### 开始优化 tag v1

上面这部分知识点, 是优化的核心指导思想.

开启离屏检测, 看看首页的渲染情况

    Debug->View Debugging->Rendering->Color Offscreen-Rendered Yellow

<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-offscreen-v1.jpg" width=30% />
</div>

和预期的一样, 所有圆角区域都是离屏渲染. 

尝试开启光栅化, 设置`CALayer.shouldRasterize=YES`, 这样视图只需要离屏渲染一次, 就会把内容缓存起来供下次使用, 提升性能.
<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-rasterize.jpg" width=30% />
</div>

开启光栅化后CollectionView里面的视图都是红色的, 说明光栅化后无法得到有效缓存,  这样实际上机器性能消耗, 并没有好处.

UITableView和UICollectionView这些视图, 都是在反复利用那几个Cell, 同时刷新Cell的内容, 这种会复用视图的, 就会不停更新Layer内容导致缓存命中率超低, 不适合开启光栅化.

所以通过光栅化并没法解决问题, 反而界面的帧率只剩下30了.

<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-gup-fps30.jpg" width=30% />
</div>

代码改回去, 继续优化,  先针对Topic Collection View优化.

观察一下, Topic 的每一个cell里面虽然也有圆角, 但是只包含了文本, 并没有图片,  显示圆角的背景色并不需要设置masksToBounds. 

官方说了这个问题, 指针对contents的圆角, 才需要设置masksToBounds.

>  Setting the radius to a value greater than 0.0 causes the layer to begin drawing rounded corners on its background. By default, the corner radius does not apply to the image in the layer’s contents property; it applies only to the background color and border of the layer. However, setting the masksToBounds property to true causes the content to be clipped to the rounded corners.
 
把Topic视图相关的`masksToBounds =YES`代码移除掉, 重新运行一下, 滚动到topic这个区间帧数明显提升, 代码可以看`tag v1.1`

### 开始优化 tag v1.1

开始优化各种带圆角图片的Cell. 这里的指导思想, 就是平衡CPU和GPU的使用率. 

**GPU不够, CPU来凑**.

iPhone6 Plus的GPU确实不怎么好, 圆角一多占有率飙升到90%了. 结合上面的知识点, 要做的事情就是把部分GPU的工作交给CPU处理. 

利用`CoreGraphics`框架, 使用CPU渲染带圆角的图片, 在设置给layer.contents, 同时关闭`masksToBounds`, 这样即可减轻GPU的工作量. 

这里我利用`YYAsyncLayer`来实现CPU异步渲染, `YYAsyncLayer`的原理很简单, 当layer需要display的时候, 开启一个异步线程, 创建**CGContextRef**画布, 用户可以在这个异步线程里把视图内容画到**CGContextRef**里, 然后`YYAsyncLayer`会在主线程帮你把渲染好的内容赋值给layer.contents.

`YYAsyncLayer`内部根据CPU核数定义了若干串行队列, 放到队列池里, 每次要渲染的时候就从池里一次按顺序取出一个串行队列, 异步执行`CoreGraphics`渲染代码, 这样做的好处就是能控制并发线程数. 不过我觉得用NSOperationQueue来实现就可以了, 没必要搞这么复杂. 

这个库还提供了一个事务类`YYTransaction`, 这个类在Runloop上注册了观察者, 当Runloop处于`kCFRunLoopBeforeWaiting`状态时触发, 优先级非常低, 适合在程序有空闲的时候处理业务逻辑, 后面CPU优化部分会用到.

这里我封装了一个支持异步CPU渲染圆角图片和灰色渐变的类**AsyncImageView** , 核心代码如下

``` objc
- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
    // 在主线程访问bounds属性
    CGRect bounds = self.bounds;
    
    
    YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
    
    task.willDisplay = ^(CALayer *layer) {};

    task.display     = ^(CGContextRef context, CGSize size, BOOL (^isCancelled)(void)) {
        if (isCancelled()) return;

        CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.asyncCornerRadius].CGPath);

        // 注意必须在把图片绘制到上下文之前就切割好绘制区域. 否则切割只对后续的绘制生效, 对已经绘制好的图片不生效.
        CGContextClip(context);

        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, bounds, self.image.CGImage);
        CGContextRestoreGState(context);

        if (self.drawMask) {
            CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();

            CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, self->_colors, NULL, self.maskColors.count);
            CGContextDrawLinearGradient(context, gradient, CGPointMake(size.width / 2, 0), CGPointMake(size.width / 2, size.height), 0);
            CGGradientRelease(gradient);
            CGColorSpaceRelease(rgb);
        }
    };

    task.didDisplay = ^(CALayer *layer, BOOL finished) {};

    return task;
}
```

前面提到说QQ音乐首页会在图片上放一些白色的文本, 一开始的做法是添加一个灰色渐变的视图盖在图片上, 然后文本放灰色视图上.

这里我顺便给**AsyncImageView**类增加了绘制渐变蒙版的功能, 这样就不需要额外叠加灰色图层了, 能提高效率.

利用**AsyncImageView**替换掉UICollectionViewCell上的UIImageView.

<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-gup-fps58.jpg" width=30% />
</div>

现在竖向滚动的时候, GPU从45帧提高到55~59帧了, 肉眼只能偶尔看到轻微卡顿, 完全可以接受的. 已经到达上线标准了.

滚动时的CPU使用率从之前的15%提升30~50%, GPU从90%下降到28%左右. 

由此可见, 通过正确的指导思想, 确实让CPU核GPU的使用率更加平衡, 用户体验也会更好. 这个版本的代码可以在`tag v2.0`获得.

### GPU的其他优化

上面的优化主要是处理离屏渲染, 我觉得离屏渲染是GPU优化的重点, 工作量最少, 提升最大. 其他的优化, 可以从减少纹理的角度出发.

比如减少透明图层的使用. 能合并的图层, 可以先合并到一起. 比如下面这个界面, 是可以从图片的角度上, 直接提供一张图片即可
<div align=center>
　　<img src="http://blog.cocosdever.com/images/qq-music-layer-merge.jpg" width=30% />
</div>

但是这种操作工作量比较大, 首先要修改UICollectionViewCell的视图结构, 然后还要让服务器把两个图片合成一张, 或者在APP里, 找个主线程空闲时间把两个图合成一张再保存起来, 篇幅有限我就不做了, 如果你的程序优化了离屏渲染还是很卡, 那就有必要做了.

下面开始着手CPU优化, CPU优化也有很多指导思想.

## CPU 优化

### CPU的几种常见优化思路

### 开始优化 v2.0


# 参考文章
[关于iOS离屏渲染的深入研究](https://zhuanlan.zhihu.com/p/72653360)
