//#import "PerfectSettings13.h"

static NSString *bundleIdentifier = @"com.aohuiliu.nicesettings";
static NSMutableDictionary *settings;

static BOOL enabled;
%group settings
%hook PSListController
- (void)setEdgeToEdgeCells: (BOOL)arg
{
  %orig(NO);
}

- (BOOL)_isRegularWidth
{
  return YES;
}

%end



%hook PSUIPrefsListController
- (bool)skipSelectingDefaultCategoryOnLaunch {
    return 1;
}
%end


%end

/*static void loadPrefs(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSDictionary *prefs = NULL;

	CFStringRef appID = CFSTR("com.aohuiliu.nicesettings");
	CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

	if (keyList) {
		prefs = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		CFRelease(keyList);
	}

		enabled = (prefs && [prefs objectForKey:@"enabled"]) ? [[prefs objectForKey:@"enabled"] boolValue] : NO;
}*/

static void refreshPrefs() {
	CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)bundleIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if(keyList) {
		settings = (NSMutableDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)bundleIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
		CFRelease(keyList);
	} else {
		settings = nil;
	}
	if (!settings) {
		settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", bundleIdentifier]];
	}
  enabled = ( [settings objectForKey:@"enabled"] ? [[settings objectForKey:@"enabled"] boolValue] : YES );

}
static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  refreshPrefs();
}


%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, (CFStringRef)[NSString stringWithFormat:@"%@/prefschanged", bundleIdentifier], NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  refreshPrefs();
/*	loadPrefs(NULL, NULL, NULL, NULL, NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, loadPrefs, CFSTR("com.aohuiliu.nicesettings/preferences.changed"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  */
	if (enabled == YES) %init(settings);

}
