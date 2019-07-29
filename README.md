# node-mac-auth

A native node module that allows you to query and handle native macOS biometric authentication. 

## API

### `canPromptTouchID()`

Returns `Boolean` - whether or not this device has the ability to use Touch ID.

**NOTE:** This API will return `false` on macOS systems older than Sierra 10.12.2.