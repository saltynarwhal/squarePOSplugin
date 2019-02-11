/********* squarePOSplugin.m Cordova Plugin Implementation *******/

#import "squarePOSplugin.h"
#import <Cordova/CDVPlugin.h>

@implementation squarePOSplugin


- (void)startTransaction:(CDVInvokedUrlCommand*)command {
  CDVPluginResult* pluginResult = nil;

  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
