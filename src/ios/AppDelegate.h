#import <Cordova/CDVPlugin.h>
#import <SquarePointOfSaleSDK.h>

@interface AppDelegate : CDVPlugin

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

@end
