#import "HXWMSplashCustomAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <HXSDK/HXSDK.h>

@interface HXWMSplashCustomAdapter ()<HXSplashAdDelegate>
@property (nonatomic, weak) id<AWMCustomSplashAdapterBridge> bridge;
@property (nonatomic, strong) HXSplashAd *splashAd;
@property (nonatomic, strong) AWMParameter *parameter;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation HXWMSplashCustomAdapter
- (instancetype)initWithBridge:(id<AWMCustomSplashAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (BOOL)mediatedAdStatus {
    return self.isReady;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    self.parameter = parameter;
    UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
    UIView *bottomView = [parameter.extra objectForKey:AWMAdLoadingParamSPCustomBottomView];
    UIView *supView = viewController.navigationController ? viewController.navigationController.view : viewController.view;
    NSValue *sizeValue = [parameter.extra objectForKey:AWMAdLoadingParamSPExpectSize];
    CGSize adSize = [sizeValue CGSizeValue];
    if (adSize.width * adSize.height == 0) {
        CGFloat h = CGRectGetHeight(bottomView.frame);
        adSize = CGSizeMake(supView.frame.size.width, supView.frame.size.height - h);
    }
//    NSInteger splashType = [[parameter.customInfo objectForKey:@"splashType"] intValue];
//    int fetchDelay = [[parameter.extra objectForKey:AWMAdLoadingParamSPTolerateTimeout] intValue];
    self.splashAd = [[HXSplashAd alloc] initWithPlacementId:placementId];
    self.splashAd.delegate = self;
//    self.splashAd.bottomView = bottomView;
    
    [self.splashAd loadAd];
}
- (void)showSplashAdInWindow:(UIWindow *)window parameter:(AWMParameter *)parameter {
    UIView *bottomView = [parameter.extra objectForKey:AWMAdLoadingParamSPCustomBottomView];
    UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
    UIView *supView = viewController.navigationController ? viewController.navigationController.view : viewController.view;
    CGRect supFrame = supView.bounds;
//    CGRect adFrame = CGRectMake(0, 0, supFrame.size.width, supFrame.size.height - bottomView.bounds.size.height);
    if (bottomView) {
//        [supView addSubview:bottomView];
        bottomView.frame = CGRectMake(0,
                                      supFrame.size.height - CGRectGetHeight(bottomView.frame),
                                      CGRectGetWidth(bottomView.frame),
                                      CGRectGetHeight(bottomView.frame)
                                      );
    }
    self.splashAd.rootViewController = viewController;
    [self.splashAd showAdToWindow:window bottomView:bottomView];
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    
}
- (void)destory {
    [self removeSplashAdView];
}
- (void)removeSplashAdView {
//    [self.splashAd destroyAd];
    self.splashAd = nil;
}
#pragma mark - HXSplashAdDelegate
/**
 *  广告请求成功，并且素材加载完成，在此选择调用showAd来展示广告
 */
- (void)hxSplashAdDidLoad:(HXSplashAd *)splashAd {
    WindmillLogDebug(@"[HXWA]", @"%@", NSStringFromSelector(_cmd));
    NSString *price = [NSString stringWithFormat:@"%ld", (long)splashAd.eCPM];
    [self.bridge splashAd:self didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
    self.isReady = YES;
    [self.bridge splashAdDidLoad:self];
}

/**
 *  广告请求失败
 *  @param error 失败原因
 */
- (void)hxSplashAdFailedToLoad:(HXSplashAd *)splashAd withError:(NSError *)error {
    WindmillLogDebug(@"[HXWA]", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge splashAd:self didLoadFailWithError:error ext:nil];
}

/**
 *  广告即将展示
 */
- (void)hxSplashAdWillShow:(HXSplashAd *)splashAd {
    WindmillLogDebug(@"[HXWA]", @"%@", NSStringFromSelector(_cmd));
}

/**
 *  广告展示完毕
 */
- (void)hxSplashAdDidShow:(HXSplashAd *)splashAd {
    WindmillLogDebug(@"[HXWA]", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge splashAdWillVisible:self];
}

/**
 *  广告展示失败，未能正确显示在屏幕上: 如调用showAd时，window不是keywindow
 *  @param error 失败原因
 */
- (void)hxSplashAdFailedToShow:(HXSplashAd *)splashAd withError:(NSError *)error {
    WindmillLogDebug(@"[HXWA]", @"%@", NSStringFromSelector(_cmd));
}

/**
 *  广告点击回调
 */
- (void)hxSplashAdDidClick:(HXSplashAd *)splashAd {
    WindmillLogDebug(@"[HXWA]", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAdDidClick:self];
}

/**
 * 广告点击跳过的回调
 */
- (void)hxSplashAdDidClickSkip:(HXSplashAd *)splashAd {
    WindmillLogDebug(@"[HXWA]", @"%@", NSStringFromSelector(_cmd));
}

/**
 *  广告关闭回调：跳过/倒计时结束/点击广告后广告view被移除
 */
- (void)hxSplashAdDidClose:(HXSplashAd *)splashAd {
    WindmillLogDebug(@"[HXWA]", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAdDidClose:self];
    [self removeSplashAdView];
}

/**
 *  广告转化完成：关闭落地页或者跳转到其他应用
 */
- (void)hxSplashAdDidFinishConversion:(HXSplashAd *)splashAd {
    WindmillLogDebug(@"[HXWA]", @"%@", NSStringFromSelector(_cmd));
}

@end
