#import <objc/runtime.h>
#import <LocalAuthentication/LocalAuthentication.h>

static BOOL kEnable = NO;                   //Enable
static BOOL kSilentToggle = NO;             //Silent Mode
static BOOL kBioProtect = NO;               //Touch/Face ID

    @interface SBMediaController : NSObject
    +(instancetype)sharedInstance;
    -(BOOL)isRingerMuted;
    -(void)setRingerMuted:(BOOL)arg1;
    @property (assign,getter=isRingerMuted,nonatomic) BOOL ringerMuted;
        -(void)setRingerMuted:(BOOL)arg1;
    @end

%hook SpringBoard                                          //DRM
-(void)applicationDidFinishLaunching:(id)arg1 {
  if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.peterdev.powerguard.list"])
{
    %orig;
    NSLog(@"[Power Guard] Official detected");
}
else
{
    NSLog(@"[Power Guard] Unofficial detected.");
      UIAlertView *drmalert = [[UIAlertView alloc]initWithTitle:@"Power Guard" message:@"You're using Unofficial copy of Power Guard, Use the Official version" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];

      [drmalert show];
}
}
%end

%hook SBPowerDownController                                  //Main Code
-(void)orderFront {
UIAlertView *ProtectAlert = [[UIAlertView alloc]initWithTitle:@"Power Guard" message:@"This device is protecting with Power Guard." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
UIAlertView *BioAlert = [[UIAlertView alloc]initWithTitle:@"Power Guard" message:@"Touch/Face ID is not enabled on your device." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];

if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.peterdev.powerguard.list"]) {
  if(kEnable && kSilentToggle) {
    if(kBioProtect){
      if ([[objc_getClass("SBMediaController") sharedInstance] isRingerMuted] == YES) {
        LAContext *context = [[LAContext alloc] init];
        NSError *error;
        if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
          [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Power Guard" reply:^(BOOL success, NSError *error){
          if(success){
            %orig;            //This cause respring.
            NSLog(@"[Power Guard] Bio Protect Mode, showed PowerDownController");
          } else {
            NSLog(@"[Power Guard] Bio Protect Mode, Locked");
          }
          }];
        } else {
          [BioAlert show];
          NSLog(@"[Power Guard] Bio Protect Mode, Touch/Face ID is not enabled.");
        }
      } else {
        %orig;
      }
    } else {
      if ([[objc_getClass("SBMediaController") sharedInstance] isRingerMuted] == YES) {
        [ProtectAlert show];
        NSLog(@"[Power Guard] Silent Mode, showed Alert");
      } else {
        %orig;
      }
    }
  } else {
    if(kEnable) {
          [ProtectAlert show];
          NSLog(@"[Power Guard] Normal Mode, Showed Alert");
    } else {
      %orig;
    }
  }
} else {
  %orig;
  NSLog(@"[Power Guard] Unofficial detected.");
}
}
%end

static void loadPrefs()
{
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.peterdev.powerguard.plist"];
  if(prefs)
  {
    kEnable = ( [prefs objectForKey:@"kEnable"] ? [[prefs objectForKey:@"kEnable"] boolValue] : kEnable );
	  kSilentToggle = ( [prefs objectForKey:@"kSilentToggle"] ? [[prefs objectForKey:@"kSilentToggle"] boolValue] : kSilentToggle );
	  kBioProtect = ( [prefs objectForKey:@"kBioProtect"] ? [[prefs objectForKey:@"kBioProtect"] boolValue] : kBioProtect );

  }
  [prefs release];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.peterdev.powerguard.prefschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
}
