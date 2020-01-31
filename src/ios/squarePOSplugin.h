#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVAvailability.h>
#import <SquarePointOfSaleSDK.h>

@protocol UIApplicationDelegate

  - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

@end

@interface squarePOSplugin : CDVPlugin <UIApplicationDelegate>

  - (void)startTransaction:(CDVInvokedUrlCommand*)command;

@end
