#include <nan.h>

#include "src/mac_auth.h"

void Init(v8::Local<v8::Object> exports) {
  exports->Set(Nan::New("canPromptTouchID").ToLocalChecked(),
               Nan::New<v8::FunctionTemplate>(CanPromptTouchID)->GetFunction());
}

NODE_MODULE(auth, Init);