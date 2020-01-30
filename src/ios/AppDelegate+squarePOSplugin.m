#import "AppDelegate+squarePOSplugin.h"
#import "squarePOSplugin.h"

@implementation CDVAppDelegate (squarePOSplugin)

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSString *const sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    // Make sure the URL comes from Square Point of Sale; fail if it doesn't.
    if (![sourceApplication hasPrefix:@"com.squareup.square"]) {
        return NO;
    }

    // The response data is encoded in the URL and can be decoded as an SCCAPIResponse.
    NSError *decodeError = nil;
    SCCAPIResponse *const response = [SCCAPIResponse responseWithResponseURL:url error:&decodeError];

    if (response.isSuccessResponse) {
        CDVPluginResult *successPlugin = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
            messageAsString:response.transactionID];
        [self.commandDelegate sendPluginResult:successPlugin callbackId:callbackID];

    } else if (decodeError) {
        //Print decode error
        NSLog(@"Decode Error: %@", decodeError);

        CDVPluginResult *errorPlugin = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
            messageAsString:[decodeError localizedDescription]];
        [self.commandDelegate sendPluginResult:errorPlugin callbackId:callbackID];
    }
    else {
        //Print the error code
        NSLog(@"Request failed: %@", response.error);
        CDVPluginResult *errorPlugin = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
            messageAsString:[response.error localizedDescription]];
        [self.commandDelegate sendPluginResult:errorPlugin callbackId:callbackID];

    }

    return YES;
}
