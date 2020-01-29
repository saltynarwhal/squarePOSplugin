#import "squarePOSPlugin.h"
#import <Cordova/CDVPlugin.h>

@interface squarePOSplugin ()

@property (strong, nonatomic) NSString *extractedImage;

@end

@implementation squarePOSplugin

- (void)startTransaction:(CDVInvokedUrlCommand*)command {
    callbackID = command.callbackId;
    options = [command.arguments objectAtIndex:0];
    NSString *jobID = [options objectForKey:@"jobid"];
    int amountOptions = [(NSNumber *)[options objectForKey:@"amount"] intValue];
    NSString *customerId = [options objectForKey:@"customerid"];
    NSError *error = nil;
    NSString *squarePOSpluginURL = @"squarePOSplugin://";

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

    //send the transaction to the Square Point of Sale app
    BOOL success = [SCCAPIConnection performRequest:request error:&error];
    if (!success) {

    }

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    //Maintain callback
    [pluginResult setKeepCallbackAsBool:YES];
    //Send plugin result
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];

}

@end
