#import <Cordova/CDVPlugin.h>\
#import <SquarePointOfSaleSDK.h>

@interface squarePOSplugin : CDVPlugin

- (void)startTransaction:(CDVInvokedUrlCommand*)command;

@end
