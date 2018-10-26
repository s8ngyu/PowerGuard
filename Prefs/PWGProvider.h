// move this header and its implementation into the root of your project
// add this line to your Makefile `com.peterdev.powerguard_LDFLAGS += -lCSPreferencesProvider`

#include <CSPreferencesProvider.h>
#define prefs [PWGProvider sharedProvider]

@interface PWGProvider : NSObject

+ (CSPreferencesProvider *)sharedProvider;

@end