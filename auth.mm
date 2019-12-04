#include <napi.h>

#import <LocalAuthentication/LocalAuthentication.h>

// Whether the system allows prompting for Touch ID authentication.
Napi::Boolean CanPromptTouchID(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
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
  return Napi::Boolean::New(env, can_evaluate);
}

// Prompt the user for authentication with Touch ID.
void PromptTouchID(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  Napi::Object data = info[0].As<Napi::Object>();
  
  std::string reason = "";
  if (data.Has("reason"))
    reason = data.Get("reason").As<Napi::String>().Utf8Value();

  int reuse_duration = 0;
  if (data.Has("reuseDuration"))
    reuse_duration = data.Get("reuseDuration").As<Napi::Number>().Int32Value();

  Napi::ThreadSafeFunction ts_fn = Napi::ThreadSafeFunction::New(env,
                                                                info[1].As<Napi::Function>(),
                                                                "Resource Name",
                                                                0,
                                                                1,
                                                                [](Napi::Env){});

  if (@available(macOS 10.12.2, *)) {
    LAContext *context = [[LAContext alloc] init];
    
    // The app-provided reason for requesting authentication
    NSString *request_reason = [NSString stringWithUTF8String:reason.c_str()];
    
    // Authenticate with biometry.
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;

    // Optionally set the duration for which Touch ID authentication reuse is allowable
    if (reuse_duration > 0)
      [context setTouchIDAuthenticationAllowableReuseDuration:reuse_duration];

    [context evaluatePolicy:policy localizedReason:request_reason reply:^(BOOL success, NSError* error) {
      // Callback when no error
      auto null_cb = [](Napi::Env env, Napi::Function js_cb, bool* granted) {
        js_cb.Call({env.Null(), Napi::Boolean::New(env, granted)});
      };

      // Callback for error case
      auto cb = [](Napi::Env env, Napi::Function js_cb, const char* error) {
        js_cb.Call({
          Napi::String::New(env, error),
          Napi::Boolean::New(env, false)
        });
      };

      if (error != nullptr) {
        const char* err_str = [error.localizedDescription UTF8String];
        ts_fn.BlockingCall(err_str, cb);
      } else {
        bool granted = success ? true : false;
        ts_fn.BlockingCall(&granted, null_cb);
      };
    }];
  }
}

// Initializes all functions exposed to JS
Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports.Set(
    Napi::String::New(env, "canPromptTouchID"), Napi::Function::New(env, CanPromptTouchID)
  );
  exports.Set(
    Napi::String::New(env, "promptTouchID"), Napi::Function::New(env, PromptTouchID)
  );

  return exports;
}

NODE_API_MODULE(permissions, Init)