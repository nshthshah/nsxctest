/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

#import "UIKeyboardImpl.h"
#import "TIPreferencesController.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const FBSnapshotMaxDepthKey;

/**
 Accessors for Global Constants.
 */
@interface FBConfiguration : NSObject

/*! Disables attribute key path analysis, which will cause XCTest on Xcode 9.x to ignore some elements */
+ (void)disableAttributeKeyPathAnalysis;

/**
 * Configure keyboards preference to make test running stable
 */
+ (void)configureDefaultKeyboardPreferences;

@end

NS_ASSUME_NONNULL_END
