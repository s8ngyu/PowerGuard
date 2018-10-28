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
    NSLog(@"[PowerGuard] Official detected");
}
else
{
    NSLog(@"[PowerGuard] Unofficial detected.");
      UIAlertView *drmalert = [[UIAlertView alloc]initWithTitle:@"PowerGuard" message:@"You're using Unofficial copy of PowerGuard, Use the Official version" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];

      [drmalert show];
}
}
%end

%hook SBPowerDownController                                  //Main Code
-(void)orderFront {
UIAlertView *ProtectAlert = [[UIAlertView alloc]initWithTitle:@"PowerGuard" message:@"This device is protecting with PowerGuard." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
UIAlertView *BioAlert = [[UIAlertView alloc]initWithTitle:@"PowerGuard" message:@"Touch ID is not enabled on your device." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
LAContext *context = [[LAContext alloc] init];
NSError *error;


if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.peterdev.powerguard.list"]) {
  if(kEnable && kSilentToggle) {
    if(kBioProtect){
      if ([[objc_getClass("SBMediaController") sharedInstance] isRingerMuted] == YES) {
        if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
          [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"PowerGuard" reply:^(BOOL success, NSError *error){
          if(success){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              %orig;
              NSLog(@"[PowerGuard] Bio Protect Mode, PowerDownController showed");
            });
            NSLog(@"[PowerGuard] Bio Protect Mode, 0.1sec timer started");
          } else {
            NSLog(@"[PowerGuard] Bio Protect Mode, Locked");
          }
          }];
        } else {
          [BioAlert show];
          NSLog(@"[PowerGuard] Bio Protect Mode, Touch/Face ID is not enabled");
        }
      } else {
        %orig;
      }
    } else {
      if ([[objc_getClass("SBMediaController") sharedInstance] isRingerMuted] == YES) {
        [ProtectAlert show];
        NSLog(@"[PowerGuard] Silent Mode, showed Alert");
      } else {
        %orig;
      }
    }
  } else {
    if(kEnable) {
      if(kBioProtect) {
        if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
          [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"PowerGuard" reply:^(BOOL success, NSError *error){
          if(success){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              %orig;
              NSLog(@"[PowerGuard] Bio Protect Mode, PowerDownController showed");
            });
            NSLog(@"[PowerGuard] Bio Protect Mode, 0.1sec timer started");
          } else {
            NSLog(@"[PowerGuard] Bio Protect Mode, Locked");
          }
          }];
        } else {
          [BioAlert show];
          NSLog(@"[PowerGuard] Bio Protect Mode, Touch/Face ID is not enabled");
        }
      } else {
        [ProtectAlert show];
        NSLog(@"[PowerGuard] Normal Mode, showed Alert");
      }
    } else {
      %orig;
    }
}
} else {
  %orig;
  NSLog(@"[PowerGuard] Unofficial detected.");
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
