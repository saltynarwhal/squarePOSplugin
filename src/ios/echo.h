/********* Echo.h Cordova Plugin Header *******/

#import <Cordova/CDVPlugin.h>

@interface Echo : CDVPlugin

- (void)echo:(CDVInvokedUrlCommand*)command;

@end
