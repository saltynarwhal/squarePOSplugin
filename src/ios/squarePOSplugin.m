/********* squarePOSplugin.m Cordova Plugin Implementation *******/

#import "squarePOSplugin.h"
#import <Cordova/CDVPlugin.h>

@implementation Echo

- (void)startTransaction:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    // Replace with your app's callback URL.
    // Note: You can retrieve this value from Info.plist
    NSURL *const callbackURL = [NSURL URLWithString:squarePOSplugin];

    // Specify the amount of money to charge.
    SCCMoney *const amount = [SCCMoney moneyWithAmountCents:100 currencyCode:@"USD" error:NULL];

    // Your client ID is the same as your Square Application ID.
    // Note: You only need to set your client ID once, before creating your first request.
    [SCCAPIRequest setClientID:YOUR_CLIENT_ID];

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
}

@end
