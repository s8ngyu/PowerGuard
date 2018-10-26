#include "PWGProvider.h"

@implementation PWGProvider

#pragma mark Initialization

+ (CSPreferencesProvider *)sharedProvider {
    static dispatch_once_t once;
    static CSPreferencesProvider *sharedProvider;
    dispatch_once(&once, ^{

        NSString *tweakId = @"com.peterdev.powerguard";
        NSString *prefsNotification = [tweakId stringByAppendingString:@".prefschanged"];
        NSString *defaultsPath = @"/Library/PreferenceBundles/PowerGuardPrefs.bundle/defaults.plist";

        sharedProvider = [[CSPreferencesProvider alloc] initWithTweakID:tweakId defaultsPath:defaultsPath postNotification:prefsNotification notificationCallback:^void (CSPreferencesProvider *provider) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PWGSettingsChanged" object:nil userInfo:nil];
        }];

    });
    return sharedProvider;
}

@end
