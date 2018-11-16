#import <spawn.h>
#import <FrontBoardServices/FBSSystemService.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

static BOOL kEnable = NO;                   //Enable
static BOOL kSilentToggle = NO;             //Silent Mode
static BOOL kBioProtect = NO;               //Touch/Face ID
static BOOL kProtectMenu = NO;              //Protect Menu
static BOOL kProtectSlider = NO;            //Protect Slider

    @interface SBMediaController : NSObject
    +(instancetype)sharedInstance;
    -(BOOL)isRingerMuted;
    -(void)setRingerMuted:(BOOL)arg1;
    @property (assign,getter=isRingerMuted,nonatomic) BOOL ringerMuted;
        -(void)setRingerMuted:(BOOL)arg1;
    @end

    @interface FBSystemService : NSObject
    +(id)sharedInstance;
    -(void)shutdownAndReboot:(BOOL)arg1;
    -(void)exitAndRelaunch:(BOOL)arg1;
    -(void)nonExistantMethod;
    @end
    @interface _UIActionSlider : UIView
    @property (nonatomic,copy) NSString* trackText;
    @end
    
    @interface _SBInternalPowerDownView : UIView
	-(void)_cancelButtonTapped;
    @end

	static int Tap = 1;
    static _UIActionSlider* actionSlider;

%hook _UIActionSlider
-(void)didMoveToWindow {
    %orig;
    actionSlider = self;
}
%end


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

%hook SBPowerDownController                                  //Protect Menu
-(void)orderFront {
UIAlertView *ProtectAlert = [[UIAlertView alloc]initWithTitle:@"PowerGuard" message:@"This device is protected with PowerGuard." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
UIAlertView *BioAlert = [[UIAlertView alloc]initWithTitle:@"PowerGuard" message:@"Touch ID is not enabled on your device." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
LAContext *context = [[LAContext alloc] init];
NSError *error;


if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.peterdev.powerguard.list"]) {
  if(kEnable && kSilentToggle && kProtectMenu) {
    if(kBioProtect){
      if ([[objc_getClass("SBMediaController") sharedInstance] isRingerMuted] == YES) {
        if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]){
          [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"PowerGuard" reply:^(BOOL success, NSError *error){
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
    if(kEnable && kProtectMenu) {
      if(kBioProtect) {
        if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]){
          [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"PowerGuard" reply:^(BOOL success, NSError *error){
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


%hook _SBInternalPowerDownView                                //Protect Slider
-(void)_powerDownSliderDidCompleteSlide {
UIAlertView *ProtectAlert = [[UIAlertView alloc]initWithTitle:@"PowerGuard" message:@"This device is protected with PowerGuard." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
UIAlertView *BioAlert = [[UIAlertView alloc]initWithTitle:@"PowerGuard" message:@"Touch ID is not enabled on your device." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
LAContext *context = [[LAContext alloc] init];
NSError *error;


  if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.peterdev.powerguard.list"]) {
    if(Tap == 1) {
      if(kEnable && kSilentToggle && kProtectSlider) {
        if(kBioProtect){
          if ([[objc_getClass("SBMediaController") sharedInstance] isRingerMuted] == YES) {
            if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]){
              [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"PowerGuard" reply:^(BOOL success, NSError *error){
              if(success){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  %orig;
                  NSLog(@"[PowerGuard] Bio Protect Mode, PowerDownController showed");
                });
                NSLog(@"[PowerGuard] Bio Protect Mode, 0.1sec timer started");
              } else {
                [self _cancelButtonTapped];  
                NSLog(@"[PowerGuard] Bio Protect Mode, Canceled");
              }
              }];
            } else {
              [BioAlert show];
              [self _cancelButtonTapped]; 
              NSLog(@"[PowerGuard] Bio Protect Mode, Touch/Face ID is not enabled");
            }
          } else {
            %orig;
          }
        } else {
          if ([[objc_getClass("SBMediaController") sharedInstance] isRingerMuted] == YES) {
            [self _cancelButtonTapped]; 
            [ProtectAlert show];
            NSLog(@"[PowerGuard] Silent Mode, showed Alert");
          } else {
            %orig;
          }
        }
      } else {
        if(kEnable && kProtectSlider) {
          if(kBioProtect) {
            if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]){
              [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"PowerGuard" reply:^(BOOL success, NSError *error){
              if(success){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  %orig;
                  NSLog(@"[PowerGuard] Bio Protect Mode, PowerDownController showed");
                });
                NSLog(@"[PowerGuard] Bio Protect Mode, 0.1sec timer started");
              } else {
                [self _cancelButtonTapped]; 
                NSLog(@"[PowerGuard] Bio Protect Mode, Locked");
              }
              }];
            } else {
              [self _cancelButtonTapped]; 
              [BioAlert show];
              NSLog(@"[PowerGuard] Bio Protect Mode, Touch/Face ID is not enabled");
            }
          } else {
            [self _cancelButtonTapped]; 
            [ProtectAlert show];
            NSLog(@"[PowerGuard] Normal Mode, showed Alert");
          }
        } else {
          %orig;
        }
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
    kProtectMenu = ( [prefs objectForKey:@"kProtectMenu"] ? [[prefs objectForKey:@"kProtectMenu"] boolValue] : kProtectMenu );
    kProtectSlider = ( [prefs objectForKey:@"kProtectSlider"] ? [[prefs objectForKey:@"kProtectSlider"] boolValue] : kProtectSlider );
  }
  [prefs release];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.peterdev.powerguard.prefschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
}
