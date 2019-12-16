#include <napi.h>

#import <LocalAuthentication/LocalAuthentication.h>

// No-op value to pass into function parameter for ThreadSafeFunction
Napi::Value NoOp(const Napi::CallbackInfo &info) {
  return info.Env().Undefined();
}

// Whether the system allows prompting for Touch ID authentication.
Napi::Boolean CanPromptTouchID(const Napi::CallbackInfo &info) {
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
Napi::Promise PromptTouchID(const Napi::CallbackInfo &info) {
  Napi::Env env = info.Env();
  Napi::Object data = info[0].As<Napi::Object>();

  std::string reason = "";
  if (data.Has("reason"))
    reason = data.Get("reason").As<Napi::String>().Utf8Value();

  int reuse_duration = 0;
  if (data.Has("reuseDuration"))
    reuse_duration = data.Get("reuseDuration").As<Napi::Number>().Int32Value();

  Napi::Promise::Deferred deferred = Napi::Promise::Deferred::New(env);
  Napi::ThreadSafeFunction ts_fn =
      Napi::ThreadSafeFunction::New(env, Napi::Function::New(env, NoOp),
                                    "authCallback", 0, 1, [](Napi::Env) {});

  if (@available(macOS 10.12.2, *)) {
    LAContext *context = [[LAContext alloc] init];

    // The app-provided reason for requesting authentication
    NSString *request_reason = [NSString stringWithUTF8String:reason.c_str()];

    // Authenticate with biometry.
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;

    // Optionally set the duration for which Touch ID authentication reuse is
    // allowable
    if (reuse_duration > 0)
      [context setTouchIDAuthenticationAllowableReuseDuration:reuse_duration];

    [context
         evaluatePolicy:policy
        localizedReason:request_reason
                  reply:^(BOOL success, NSError *error) {
                    // Promise resolution callback
                    auto resolve_cb = [=](Napi::Env env,
                                          Napi::Function noop_cb) {
                      deferred.Resolve(env.Null());
                    };

                    // Promise rejection callback
                    auto reject_cb = [=](Napi::Env env, Napi::Function noop_cb,
                                         const char *error) {
                      deferred.Reject(Napi::String::New(env, error));
                    };

                    if (error != nullptr) {
                      const char *err_str =
                          [error.localizedDescription UTF8String];
                      ts_fn.BlockingCall(err_str, reject_cb);
                    } else {
                      ts_fn.BlockingCall(resolve_cb);
                    };
                  }];
  }

  return deferred.Promise();
}

// Initializes all functions exposed to JS
Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports.Set(Napi::String::New(env, "canPromptTouchID"),
              Napi::Function::New(env, CanPromptTouchID));
  exports.Set(Napi::String::New(env, "promptTouchID"),
              Napi::Function::New(env, PromptTouchID));

  return exports;
}

NODE_API_MODULE(permissions, Init)