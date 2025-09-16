/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBConfiguration.h"

#include <dlfcn.h>
#import <UIKit/UIKit.h>

static char const *const controllerPrefBundlePath = "/System/Library/PrivateFrameworks/TextInput.framework/TextInput";
static NSString *const controllerClassName = @"TIPreferencesController";
static NSString *const FBKeyboardAutocorrectionKey = @"KeyboardAutocorrection";
static NSString *const FBKeyboardPredictionKey = @"KeyboardPrediction";

@implementation FBConfiguration

+ (void)initialize
{
    
}

+ (void)disableAttributeKeyPathAnalysis
{
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"XCTDisableAttributeKeyPathAnalysis"];
}


// Works for Simulator and Real devices
+ (void)configureDefaultKeyboardPreferences
{
  void *handle = dlopen(controllerPrefBundlePath, RTLD_LAZY);

  Class controllerClass = NSClassFromString(controllerClassName);

  TIPreferencesController *controller = [controllerClass sharedPreferencesController];
  // Auto-Correction in Keyboards
  // 'setAutocorrectionEnabled' Was in TextInput.framework/TIKeyboardState.h over iOS 10.3
  if ([controller respondsToSelector:@selector(setAutocorrectionEnabled:)]) {
    // Under iOS 10.2
    controller.autocorrectionEnabled = NO;
  } else if ([controller respondsToSelector:@selector(setValue:forPreferenceKey:)]) {
    // Over iOS 10.3
    [controller setValue:@NO forPreferenceKey:FBKeyboardAutocorrectionKey];
  }

  // Predictive in Keyboards
  if ([controller respondsToSelector:@selector(setPredictionEnabled:)]) {
    controller.predictionEnabled = NO;
  } else if ([controller respondsToSelector:@selector(setValue:forPreferenceKey:)]) {
    [controller setValue:@NO forPreferenceKey:FBKeyboardPredictionKey];
  }

  // To dismiss keyboard tutorial on iOS 11+ (iPad)
  if ([controller respondsToSelector:@selector(setValue:forPreferenceKey:)]) {
    [controller setValue:@YES forPreferenceKey:@"DidShowGestureKeyboardIntroduction"];
    [controller setValue:@YES forPreferenceKey:@"DidShowContinuousPathIntroduction"];
    [controller synchronizePreferences];
  }

  dlclose(handle);
}

@end

