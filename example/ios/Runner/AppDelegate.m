#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
    //首次启动app
    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    if(shortcutItem){
        if([shortcutItem.type isEqualToString: @"com.ke.add"]){
            NSLog(@"click add");
        }
    }
    
    
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    if(shortcutItem){
        if([shortcutItem.type isEqualToString: @"com.ke.add"]){
            NSLog(@"click add");
        }
    }
    
    if(completionHandler){
        completionHandler(YES);
    }
}

@end
