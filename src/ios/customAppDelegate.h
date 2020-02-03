#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVAppDelegate.h>
#import <SquarePointOfSaleSDK.h>

@interface squarePOSpluginDelegate : CDVAppDelegate

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

@end
