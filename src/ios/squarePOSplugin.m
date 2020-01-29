#import "squarePOSPlugin.h"
#import <Cordova/CDVPlugin.h>


@interface squarePOSplugin ()

@property (strong, nonatomic) NSString *extractedImage;

@end

@implementation squarePOSplugin

NSString *callbackID;
NSMutableDictionary *options;

- (void)pluginInitialize
{
    // You can listen to more app notifications, see:
    // http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UIApplication_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40006728-CH3-DontLinkElementID_4

    // note: if you want to use these, make sure you uncomment the corresponding notification handler

    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrientationWillChange) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrientationDidChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

    // Added in 2.5.0
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageDidLoad:) name:CDVPageDidLoadNotification object:self.webView];
    //Added in 4.3.0
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:CDVViewWillAppearNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:CDVViewDidAppearNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillDisappear:) name:CDVViewWillDisappearNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidDisappear:) name:CDVViewDidDisappearNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillLayoutSubviews:) name:CDVViewWillLayoutSubviewsNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidLayoutSubviews:) name:CDVViewDidLayoutSubviewsNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillTransitionToSize:) name:CDVViewWillTransitionToSizeNotification object:nil];
}

- (void)startTransaction:(CDVInvokedUrlCommand*)command {
    callbackID = command.callbackId;
    options = [command.arguments objectAtIndex:0];
    NSString *jobID = [options objectForKey:@"jobid"];
    int amountOptions = [(NSNumber *)[options objectForKey:@"amount"] intValue];
    NSString *customerId = [options objectForKey:@"customerid"];
    NSError *error = nil;
    NSString *squarePOSpluginURL = @"squarePOSplugin://";

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

    }

    //CDVPluginResult *errorPlugin = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    //[self.commandDelegate sendPluginResult:errorPlugin callbackId:callbackID];

}

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

@end
