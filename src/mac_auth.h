#include <nan.h>

NAN_METHOD(CanPromptTouchID);
NAN_METHOD(PromptTouchID);

bool IsValid(v8::MaybeLocal<v8::Value> val);
