# node-mac-auth

A native node module that allows you to query and handle native macOS biometric authentication. 

## API

### `canPromptTouchID()`

Returns `Boolean` - whether or not this device has the ability to use Touch ID.

**NOTE:** This API will return `false` on macOS systems older than Sierra 10.12.2.

```js
const { canPromptTouchID } = require('node-mac-auth')

const canPrompt = canPromptTouchID()
console.log(`I ${canPrompt ? 'can' : 'cannot'} prompt for TouchID!`)
```

### `promptTouchID(options, callback)`

* `options` Object
  * `reason` String - The reason you are asking for Touch ID authentication.
* `callback` Function
  * `error` - The reason authentication failed, if it failed.

```javascript
const { promptTouchID } = require('node-mac-auth')

promptTouchID({ reason: 'To get consent for a Security-Gated Thing' }, (err) => {
  if (err) {
    console.log('TouchID failed because: ', err)
  } else {
    console.log('You have successfully authenticated with Touch ID!')
  }
})
```

**NOTE:** This API will have no effect on macOS systems older than Sierra 10.12.2.