/********* squarePOSplugin.h Cordova Plugin Header *******/

#import <Cordova/CDVPlugin.h>

@interface squarePOSplugin : CDVPlugin

- (void)startTransaction:(CDVInvokedUrlCommand*)command;

@end

/********* squarePOSplugin.m Cordova Plugin Implementation *******/

#import "squarePOSplugin.h"
#import <Cordova/CDVPlugin.h>

@implementation Echo

- (void)startTransaction:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }


    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
