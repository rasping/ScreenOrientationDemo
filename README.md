#iOS 播放视图的横竖屏切换实现
横竖屏切换，只要是在视频播放类app中就一定会遇到的问题。之前一直以为很简单，但当自己真的遇到这个问题的时候，才发现然来是之前的我很简单。

这里我将我在实现过程中遇到的问题和需要注意的地方做了一个总结，并写了一个小demo，并分享出来。demo最终运行效果图如下：
![效果图.gif](http://upload-images.jianshu.io/upload_images/1344789-4341cad227bb7212.gif?imageMogr2/auto-orient/strip)

##工程配置
在开始代码之前必须先让我们的工程支持横竖屏，这就需要在xcode设置中General里面进行勾选配置：

![工程配置.jpeg](http://upload-images.jianshu.io/upload_images/1344789-c9d4cbb80e8e2a2c.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

当然支持横竖屏在工程中是默认勾选。为了方便控制statusBar(状态栏)，我在info.plist文件中添加View controller-based status bar appearance=NO字段，让statusBar的状态由application控制，而不是控制器。配置完工程之后，就是该如何具体实现了。但在开始代码之前，先应该清楚自己要用什么样的方法去实现这个效果呢？
##思路
第一次看到这个问题，我的想法是：对视频播放的view做一个旋转放大的动画，然后改变statusBar的方向就行了。结果发现：第一步很容易实现，到第二步就尴尬了。

```
@property(readwrite, nonatomic) UIInterfaceOrientation statusBarOrientation NS_DEPRECATED_IOS(2_0, 9_0, "Explicit setting of the status bar orientation is more limited in iOS 6.0 and later") __TVOS_PROHIBITED;
- (void)setStatusBarOrientation:(UIInterfaceOrientation)interfaceOrientation animated:(BOOL)animated NS_DEPRECATED_IOS(2_0, 9_0, "Explicit setting of the status bar orientation is more limited in iOS 6.0 and later") __TVOS_PROHIBITED;
```

利用application控制statusBar方向的方法都被禁用了，即使硬着头皮写了，发现还是不行。既然这样不行，那我先让当前控制器切换成横屏，然后再对视频播放的View做动画。如果这样做，我首先面对的问题就是：如何主动触发屏幕旋转？查阅文档后发现，只有UIDevice这个类与屏幕方向有关。

```
@property(nonatomic,readonly) UIDeviceOrientation orientation __TVOS_PROHIBITED;
```

如上所示，我还没开心的太久，就发现UIDevice这个类能设置屏幕方向的只有orientation这个属性，但这个属性是只读的。这就意味着如果我想主动触发屏幕旋转就必须使用系统私有的方法，所以让当前控制器主动切换屏幕方向也行不通。

在经历了两次失败之后，我才知道：在当前控制器里改变statusBar的方向是行不通的。所以要想做到statusBar的切换就必须切换控制器，具体操作如下：
1. 当用户点击切换屏幕按钮后，Modal出一个新的控制器
2. Modal控制器只能试横屏向左或向右
3. 对Modal控制器做一个旋转动画，使其看起来像一个Modal过渡动画
4. 切换到竖屏时，只需要Dismiss掉Modal控制器
5. 对播放视图做一个旋转动画，同样使其看起来像一个Dismiss过渡动画

##代码实现

当前控制器只支持竖屏，Modal控制器只支持横屏，所以需要重写UIVIewController的UIViewControllerRotation分类方法，具体代码如下：

```
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
```
说明：
1. 在Modal控制器中只需将UIInterfaceOrientationMaskPortrait换成对应的UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight就行了
2. 因为屏幕方向是由当前窗口下的根控制器控制，所以在根控制器中也需要重写上面三个方法，这样每个子控制器才能控制自己的方向。详情参考[iOS Rotation](http://www.jianshu.com/p/62431e148e68)

确定了控制器方向之后，在切换全屏时只用Modal出一个新控制就行了，具体代码如下：

```
SecondViewController *secondVC = [[SecondViewController alloc] init];
secondVC.delegate = self;
secondVC.orientation = orientation;
[self presentViewController:secondVC animated:NO completion:nil];
```
说明：
1. 传orientation参数，是为了通知Modal控制器显示的方向是横屏向左还是向右
2. Modal时不能带动画，这里会用旋转动画模拟过渡动画

实现了这些，再添加上旋转动画(动画代码具体实现可以参考demo)，就可以实现点击按钮切换全屏效果。

##完善

实现了点击按钮切换全屏，那用户转动手机方向就自动切换到全屏，这个如何实现呢？要实现这个功能，首先我们需要知道用户转动手机这个事件。系统利用UIDeviceOrientationDidChangeNotification通知将事件传出，监听通知代码如下：

```
 [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
```

监听到事件，就是具体的逻辑处理，代码如下：

```
if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self orientationChange:UIInterfaceOrientationPortrait];
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self orientationChange:UIInterfaceOrientationLandscapeLeft];
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self orientationChange:UIInterfaceOrientationLandscapeRight];
    }
```
说明：
1. orientationChange:方法实质就是根据屏幕方向Dismiss或Modal一个控制器，具体代码实现，可参考demo

至此，整个效果就已完成。

##结尾

希望这篇文章能帮助大家了解到iOS屏幕旋转机制与如何控制，如果你觉得这篇文章对你有帮助，希望能赞一下或是上GItHub start一下，毕竟你们的认同才是我继续分享下去的动力。

最后奉上[demo地址](https://github.com/rasping/ScreenOrientationDemo)
