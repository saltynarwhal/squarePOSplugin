/********* squarePOSplugin.m Cordova Plugin Implementation *******/

#import "squarePOSplugin.h"

@interface squarePOSplugin ()

typedef enum {
    ERROR_INVALID_ARGS = 0,
    ERROR_USER_CANCEL = 1,
    ERROR_CANT_READ_CARD = 2
} OSSquareError;

@property (strong, nonatomic) NSString* callbackId;

@end

@implementation squarePOSplugin

- (void)startTransaction:(CDVInvokedUrlCommand*)command {
  CDVPluginResult* pluginResult = nil;
  self.callbackId = command.callbackId;

  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"worked"];

  [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId;
}

@end
