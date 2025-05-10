#import "ViewController.h"
#import <WindMillSDK/WindMillSDK.h>

@interface ViewController ()<WindMillSplashAdDelegate>

@property (nonatomic, strong) WindMillSplashAd *splashAd;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAdAndShow];
}

- (NSString *)getPlacementId {
    return @"8551576866216473";
}

- (BOOL)hasLogo {
    return NO;
}

#pragma mark -Actions
- (void)loadAdAndShow {
    if (!self.splashAd) {
        WindMillAdRequest *request = [WindMillAdRequest request];
        request.placementId = [self getPlacementId];
        request.userId = @"your user id";
        self.splashAd = [[WindMillSplashAd alloc] initWithRequest:request extra:nil];
        self.splashAd.delegate = self;
        self.splashAd.rootViewController = self;
    }
    if ([self hasLogo]) {
        [self.splashAd loadADAndShowWithTitle:@"对应的标题" description:@"对应的描述信息"];
    }else {
        [self.splashAd loadAdAndShow];
    }
}
- (void)loadAd {
    CGFloat logoHeight = 0;
    if ([self hasLogo]) {
        logoHeight = 150;
    }
    CGSize adSize = CGSizeMake(self.navigationController.view.bounds.size.width, self.navigationController.view.bounds.size.height-logoHeight);
    UIView *bottomView;
    if ([self hasLogo]) {
        bottomView = [self getLogoView];
    }
    NSDictionary *extra = @{kWindMillSplashExtraAdSize: NSStringFromCGSize(adSize),
                            kWindMillSplashExtraBottomViewSize:NSStringFromCGSize(CGSizeMake(adSize.width, logoHeight)),
                            kWindMillSplashExtraBottomView: bottomView
    };
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = [self getPlacementId];
    request.userId = @"your user id";
    self.splashAd = [[WindMillSplashAd alloc] initWithRequest:request extra:extra];
    self.splashAd.delegate = self;
    self.splashAd.rootViewController = self;
    [self.splashAd loadAd];
    
}
- (void)showAd{
    if (!self.splashAd.isAdReady) {
        return;
    }
    if ([self hasLogo]) {
        UIView *logoView = [self getLogoView];
        [self.splashAd showAdInWindow:self.view.window withBottomView:logoView];
    }else {
        [self.splashAd showAdInWindow:self.view.window withBottomView:nil];
    }
}


- (UIView *)getLogoView {
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    CGFloat w = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    bottomView.frame = CGRectMake(0, 0, w, 150);
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.frame = bottomView.bounds;
    imgView.image = [UIImage imageNamed:icon];
    [bottomView addSubview:imgView];
    return bottomView;
}


#pragma mark - WindMillSplashAdDelegate
- (void)onSplashAdDidLoad:(WindMillSplashAd *)splashAd {
    NSLog(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
}

- (void)onSplashAdLoadFail:(WindMillSplashAd *)splashAd error:(NSError *)error {
    NSLog(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    NSLog(@"%@", error);
    self.splashAd.delegate = nil;
    self.splashAd = nil;
    
}

- (void)onSplashAdSuccessPresentScreen:(WindMillSplashAd *)splashAd {
    NSLog(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
}

- (void)onSplashAdFailToPresent:(WindMillSplashAd *)splashAd withError:(NSError *)error {
    NSLog(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    NSLog(@"%@", error);
    self.splashAd.delegate = nil;
    self.splashAd = nil;
}

- (void)onSplashAdClicked:(WindMillSplashAd *)splashAd {
    NSLog(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
}

- (void)onSplashAdSkiped:(WindMillSplashAd *)splashAd {
    NSLog(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
}

- (void)onSplashAdWillClosed:(WindMillSplashAd *)splashAd {
    NSLog(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
}

- (void)onSplashAdClosed:(WindMillSplashAd *)splashAd {
    NSLog(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    //如果配置了开屏点睛时，在close时释放WindMillSplashAd，
    //则onSplashZoomOutViewAdDidClick和onSplashZoomOutViewAdDidClose回调无法正常回调
    self.splashAd.delegate = nil;
    self.splashAd = nil;
}

- (void)onSplashZoomOutViewAdDidClick:(WindMillSplashAd *)splashAd {
    NSLog(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
}

- (void)onSplashZoomOutViewAdDidClose:(WindMillSplashAd *)splashAd {
    NSLog(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    self.splashAd.delegate = nil;
    self.splashAd = nil;
}

@end
