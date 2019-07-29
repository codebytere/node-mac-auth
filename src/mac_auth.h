#include <nan.h>

NAN_METHOD(CanPromptTouchID);
NAN_METHOD(PromptTouchID);

Nan::Utf8String* StringFromObject(v8::Local<v8::Object> object, const char* key);
