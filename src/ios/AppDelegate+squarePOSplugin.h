#import "AppDelegate.h"

/**
 *  Category for the AppDelegate that overrides application:continueUserActivity:restorationHandler method,
 *  so we could handle application launch when user clicks on the link in the browser.
 */
@interface AppDelegate (squarePOSplugin)

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

@end
