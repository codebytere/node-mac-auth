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
  if (info[0]->IsUndefined()) {
    Nan::ThrowError("Options are required.");
    return;
  }

  v8::Local<v8::Object> options = info[0].As<v8::Object>();
  Nan::Utf8String *reason_utf8 = StringFromObject(options, "reason");

  if (info[1]->IsUndefined()) {
    Nan::ThrowError("Callback is required.");
    return;
  }

  Nan::Callback *callback = new Nan::Callback(info[1].As<v8::Function>());

  if (@available(macOS 10.12.2, *)) {
    auto* isolate = v8::Isolate::GetCurrent();
    LAContext *context = [[LAContext alloc] init];
    
    // The app-provided reason for requesting authentication
    NSString *reason = [NSString stringWithUTF8String:**(reason_utf8)];
    
    // Authenticate with biometry.
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;

    [context evaluatePolicy:policy
              localizedReason:reason
              reply:^(BOOL success, NSError* error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                  if (!success) {
                    const char *err_str = [error.localizedDescription UTF8String];
                    auto err = v8::String::NewFromUtf8(isolate, err_str);
                    v8::Local<v8::Value> argv[] = { Nan::Error(err) };
                    callback->Call(1, argv);
                  } else {
                    v8::Local<v8::Value> argv[] = { Nan::Null() };
                    callback->Call(1, argv);
                  }
                });
              }];
  }
}

Nan::Utf8String* StringFromObject(v8::Local<v8::Object> object, const char *key) {
  v8::Local<v8::String> key_handle = Nan::New(key).ToLocalChecked();
  v8::MaybeLocal<v8::Value> handle = Nan::Get(object, key_handle);

  if (handle.IsEmpty() || Nan::Equals(handle.ToLocalChecked(), Nan::Undefined()).FromJust()) {
    Nan::ThrowError("Invalid parameter: " + key);
    return nullptr;
  }

  return new Nan::Utf8String(handle.ToLocalChecked());
}