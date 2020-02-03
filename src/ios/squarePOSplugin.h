#import "APPAppEventDelegate.h"
#import <Cordova/CDVPlugin.h>
#import <SquarePointOfSaleSDK.h>

@interface squarePOSplugin : CDVPlugin <APPAppEventDelegate>

  - (void)startTransaction:(CDVInvokedUrlCommand*)command;

  - (BOOL)openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

@end
