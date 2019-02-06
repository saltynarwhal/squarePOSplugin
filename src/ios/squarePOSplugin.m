/********* squarePOSplugin.m Cordova Plugin Implementation *******/

#import "squarePOSplugin.h"
#import <Cordova/CDVPlugin.h>

@implementation Echo

- (void)startTransaction:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    // Replace with your app's callback URL.
    // Note: You can retrieve this value from Info.plist
    NSString *squarePOSpluginURL = @"squarePOSplugin://";

    NSURL *const callbackURL = [NSURL URLWithString:squarePOSpluginURL];

    // Specify the amount of money to charge.
    SCCMoney *const amount = [SCCMoney moneyWithAmountCents:100 currencyCode:@"USD" error:NULL];

    // Your client ID is the same as your Square Application ID.
    // Note: You only need to set your client ID once, before creating your first request.
    [SCCAPIRequest setClientID:"sq0idp-LtAn6a920ToNj7R4TcKrFA"];

    SCCAPIRequest *request = [SCCAPIRequest requestWithCallbackURL:callbackURL
                                        amount:amount
                                        userInfoString:nil
                                        merchantID:nil
                                        notes:@"Coffee"
                                        customerID:nil
                                        supportedTenderTypes:SCCAPIRequestTenderTypeAll
                                        clearsDefaultFees:NO
                                        returnAutomaticallyAfterPayment:NO
                                        error:&error];

    //send the transaction to the Square Point of Sale app
    BOOL success = [SCCAPIConnection performRequest:request error:&error];

}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options; {
    NSString *const sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    // Make sure the URL comes from Square Point of Sale; fail if it doesn't.
    if (![sourceApplication hasPrefix:@"com.squareup.square"]) {
        return NO;
    }

    // The response data is encoded in the URL and can be decoded as an SCCAPIResponse.
    NSError *decodeError = nil;
    SCCAPIResponse[] *const response = [SCCAPIResponse responseWithResponseURL:url error:&decodeError];

    if (response.isSuccessResponse) {
      //Print checkout object
      NSLog(@"Transaction successful: %@", response);

    } else if (decodeError) {
      //Print decode error
        NSLog(@"Decode Error: %@", decodeError);
    }
    else {
      //Print the error code
        NSLog(@"Request failed: %@", response.error);
    }

    return YES;
}

@end