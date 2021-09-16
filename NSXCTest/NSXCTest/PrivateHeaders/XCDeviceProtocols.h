#ifndef XCDeviceProtocols_h
#define XCDeviceProtocols_h

@protocol XCUIIOSDevice <XCUIIPhoneOSDevice>
@property(nonatomic) long long orientation;
- (void)pressLockButton;
- (void)holdHomeButtonForDuration:(double)arg1;
- (void)pressButton:(long long)arg1;
@end

@protocol XCUIIPhoneOSDevice <XCUIDevice>
@property(readonly) XCUISiriService *siriService;
@property(readonly) _Bool isSimulatorDevice;
- (_Bool)performDeviceEvent:(XCDeviceEvent *)arg1 error:(id *)arg2;
@end

#endif /* XCDeviceProtocols_h */
