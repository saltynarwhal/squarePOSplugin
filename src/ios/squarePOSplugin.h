#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVAvailability.h>
#import <SquarePointOfSaleSDK.h>
#import <UIKit/UIKit.h>

@interface squarePOSplugin : CDVPlugin <UIApplicationDelegate>

  - (void)pluginInitialize;
  - (void)finishLaunching:(NSNotification *)notification;

  - (void)startTransaction:(CDVInvokedUrlCommand*)command;

  - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

@end
