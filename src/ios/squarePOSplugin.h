#import <Cordova/CDVPlugin.h>

#import <SquarePointOfSaleSDK.h>

@interface squarePOSplugin : CDVPlugin

- (void)startTransaction:(CDVInvokedUrlCommand*)command;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

+ (void)didFinishLaunching:(NSNotification*)notification;

+(void)load; 
@end
