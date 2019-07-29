#import <LocalAuthentication/LocalAuthentication.h>

#include "mac_auth.h"

NAN_METHOD(CanPromptTouchID) {
  bool can_evaluate = false;
  if (@available(macOS 10.12.2, *)) {
    LAContext *context = [[LAContext alloc] init];
    if ([context
            canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                        error:nil]) {
      if (@available(macOS 10.13.2, *)) {
        can_evaluate = [context biometryType] == LABiometryTypeTouchID;
      } else {
        can_evaluate = true;
      }
    }
  }
  info.GetReturnValue().Set(can_evaluate);                  
}
