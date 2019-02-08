/********* squarePOSplugin.h Cordova Plugin Header *******/

#import <Cordova/CDVPlugin.h>

@interface squarePOSplugin : CDVPlugin

- (void)startTransaction:(CDVInvokedUrlCommand*)command;
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

@end
