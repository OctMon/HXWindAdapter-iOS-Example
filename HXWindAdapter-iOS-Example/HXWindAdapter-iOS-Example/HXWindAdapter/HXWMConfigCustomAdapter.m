#import "HXWMConfigCustomAdapter.h"
#import <HXSDK/HXSDK.h>

@interface HXWMConfigCustomAdapter ()
@property (nonatomic, weak) id<AWMCustomConfigAdapterBridge> bridge;
@property (nonatomic, strong) HXPrivacyConfig *hxAdConfig;
@end

@implementation HXWMConfigCustomAdapter
- (instancetype)initWithBridge:(id<AWMCustomConfigAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (AWMCustomAdapterVersion *)basedOnCustomAdapterVersion {
    return AWMCustomAdapterVersion1_0;
}
- (NSString *)adapterVersion {
    return @"1.0.0";
}
- (NSString *)networkSdkVersion {
    return @"1.0.0";
}
- (void)initializeAdapterWithConfiguration:(AWMSdkInitConfig *)initConfig {
    NSString *appId = [initConfig.extra objectForKey:@"appId"];
    
    [HXSDK initWithAppIdWithAppId:appId];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bridge initializeAdapterSuccess:self];
    });
}
- (void)didRequestAdPrivacyConfigUpdate:(NSDictionary *)config {
    [WindMillAds getPersonalizedAdvertisingState];
    HXPrivacyConfig *privacyConf = [[HXPrivacyConfig alloc] init];
    self.hxAdConfig = privacyConf;
}


@end
