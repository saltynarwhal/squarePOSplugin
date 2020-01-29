#import "squarePOSPlugin.h"
#import <Cordova/CDVPlugin.h>

@interface squarePOSplugin ()

@property (strong, nonatomic) NSString *extractedImage;

@end

@implementation squarePOSplugin

NSString *callbackID;
NSMutableDictionary *options;

- (void)startTransaction:(CDVInvokedUrlCommand*)command {
    callbackID = command.callbackId;
    options = [command.arguments objectAtIndex:0];
    NSString *jobID = [options objectForKey:@"jobid"];
    int amountOptions = [(NSNumber *)[options objectForKey:@"amount"] intValue];
    NSString *customerId = [options objectForKey:@"customerid"];
    NSError *error = nil;
    //NSString *squarePOSpluginURL = @"squarePOSplugin://";
    NSString *squarePOSpluginURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:CFBundleURLName];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    //Maintain callback
    [pluginResult setKeepCallbackAsBool:YES];
    //Send plugin result
    //[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];

    // Replace with your app's callback URL.
    // Note: You can retrieve this value from Info.plist


    // Replace with your app's callback URL.
    // Note: You can retrieve this value from Info.plist
    NSURL *const callbackURL = [NSURL URLWithString:squarePOSpluginURL];

    // Specify the amount of money to charge.
    SCCMoney *const amount = [SCCMoney moneyWithAmountCents:amountOptions currencyCode:@"USD" error:NULL];
    // Your client ID is the same as your Square Application ID.
    // Note: You only need to set your client ID once, before creating your first request.
    [SCCAPIRequest setClientID:@"sq0idp-LtAn6a920ToNj7R4TcKrFA"];
    SCCAPIRequest *request = [SCCAPIRequest requestWithCallbackURL:callbackURL
                                                            amount:amount
                                                    userInfoString:nil
                                                        locationID:nil
                                                             notes:jobID
                                                        customerID:nil
                                              supportedTenderTypes:SCCAPIRequestTenderTypeAll
                                                 clearsDefaultFees:NO
                                   returnAutomaticallyAfterPayment:NO
                                                             error:&error];


    //Send plugin result
    //[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
    //send the transaction to the Square Point of Sale app
    BOOL success = [SCCAPIConnection performRequest:request error:&error];
    if (!success) {
      CDVPluginResult *errorPlugin = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
        messageAsString:[error localizedDescription]];
      [self.commandDelegate sendPluginResult:errorPlugin callbackId:callbackID];
    }

    //CDVPluginResult *errorPlugin = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    //[self.commandDelegate sendPluginResult:errorPlugin callbackId:callbackID];

}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;
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

@end
