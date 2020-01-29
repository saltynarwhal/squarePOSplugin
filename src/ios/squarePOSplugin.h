#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVAvailability.h>
#import <SquarePointOfSaleSDK.h>

@interface squarePOSplugin : CDVPlugin

- (void)startTransaction:(CDVInvokedUrlCommand*)command;

@end
