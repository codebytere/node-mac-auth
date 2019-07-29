#include <nan.h>

#include "src/mac_auth.h"

void Init(v8::Local<v8::Object> exports) {
  Nan::Set(
    exports,
    Nan::New("canPromptTouchID").ToLocalChecked(),
    Nan::GetFunction(Nan::New<v8::FunctionTemplate>(CanPromptTouchID)).ToLocalChecked()
  );

  Nan::Set(
    exports,
    Nan::New("promptTouchID").ToLocalChecked(),
    Nan::GetFunction(Nan::New<v8::FunctionTemplate>(PromptTouchID)).ToLocalChecked()
  );
}

NODE_MODULE(auth, Init);