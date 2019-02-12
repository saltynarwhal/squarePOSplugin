/********* squarePOSplugin.m Cordova Plugin Implementation *******/

#import "squarePOSplugin.h"

@interface squarePOSplugin ()

@property (strong, nonatomic) NSString* callbackId;

@end

@implementation squarePOSplugin

- (void) startTransaction:(CDVInvokedUrlCommand*) command {
  CDVPluginResult* pluginResult = nil;
  self.callbackId = command.callbackId;

  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"worked"];

  [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

@end
