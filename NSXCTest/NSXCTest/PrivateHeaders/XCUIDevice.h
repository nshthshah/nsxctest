#ifndef XCUIDevice_h
#define XCUIDevice_h

@interface XCUIDevice ()

// Since Xcode 10.2
@property (readonly) id accessibilityInterface; // implements XCUIAccessibilityInterface
@property (readonly) id eventSynthesizer; // implements XCUIEventSynthesizing

- (void)pressLockButton;
- (void)holdHomeButtonForDuration:(double)arg1;
- (void)_silentPressButton:(long long)arg1;
- (void)_dispatchEventWithPage:(unsigned int)arg1 usage:(unsigned int)arg2 duration:(double)arg3;

@end


#endif /* XCUIDevice_h */
