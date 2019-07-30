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

NAN_METHOD(PromptTouchID) {
  Nan::HandleScope scope;

  v8::Local<v8::Object> options = info[0].As<v8::Object>();
  v8::Local<v8::String> reason_v8 = Nan::New("reason").ToLocalChecked();
  v8::Local<v8::String> duration_v8 = Nan::New("reuseDuration").ToLocalChecked();

  // Set defaults for options obj properties
  int reuse_duration = 0;
  std::string reason = "";

  v8::MaybeLocal<v8::Value> reason_value = Nan::Get(options, reason_v8);
  if (IsValid(reason_value))
    reason = std::string(*Nan::Utf8String(reason_value.ToLocalChecked()->ToString()));

  // reuseDuration is optional, so we can't assume that property exists on the object
  if (Nan::HasOwnProperty(options, duration_v8).FromJust()) {
    v8::MaybeLocal<v8::Value> duration_val = Nan::Get(options, duration_v8);
    if (IsValid(reason_value))
      reuse_duration = duration_val.ToLocalChecked()->NumberValue();
  }

  Nan::Callback *callback = new Nan::Callback(info[1].As<v8::Function>());

  if (@available(macOS 10.12.2, *)) {
    v8::Isolate* isolate = v8::Isolate::GetCurrent();
    LAContext *context = [[LAContext alloc] init];
    
    // The app-provided reason for requesting authentication
    NSString *request_reason = [NSString stringWithUTF8String:reason.c_str()];
    
    // Authenticate with biometry.
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;

    // Optionally set the duration for which Touch ID authentication reuse is allowable
    if (reuse_duration > 0)
      [context setTouchIDAuthenticationAllowableReuseDuration:reuse_duration];

    [context evaluatePolicy:policy
              localizedReason:request_reason
              reply:^(BOOL success, NSError* error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                  v8::Local<v8::Value> argv[1];
                  if (!success) {
                    const char *err_str = [error.localizedDescription UTF8String];
                    auto err = v8::String::NewFromUtf8(isolate, err_str);
                    argv[0] = Nan::Error(err);
                  } else {
                    argv[0] = Nan::Null();
                  }
                  callback->Call(1, argv);
                });
              }];
  }
}

bool IsValid(v8::MaybeLocal<v8::Value> val) {
  if (val.IsEmpty() || Nan::Equals(val.ToLocalChecked(), Nan::Undefined()).FromJust()) 
    return false;
  return true;
}