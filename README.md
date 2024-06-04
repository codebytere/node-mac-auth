[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
 [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![GitHub release](https://img.shields.io/github/release/codebytere/node-mac-auth.svg)](https://GitHub.com/codebytere/node-mac-auth/releases/) [![Actions Status](https://github.com/codebytere/node-mac-auth/workflows/Test/badge.svg)](https://github.com/codebytere/node-mac-auth/actions)

# node-mac-auth

A native node module that allows you to query and handle native macOS biometric authentication. 

This module will have no effect unless there's an app bundle to own it: without one the API will simply appear not to run as a corollary of the way macOS handles native UI APIs.

**Nota Bene:** This module does not nor is it intended to perform process privilege escalation, e.g. allow you to authenticate as an admin user.

## API

### `canPromptTouchID()`

Returns `Boolean` - whether or not this device has the ability to use Touch ID.

```js
const { canPromptTouchID } = require('node-mac-auth')

const canPrompt = canPromptTouchID()
console.log(`I ${canPrompt ? 'can' : 'cannot'} prompt for TouchID!`)
```

**NOTE:** This API will return `false` on macOS systems older than Sierra 10.12.2.

### `promptTouchID(options)`

* `options` Object
  * `reason` String - The reason you are asking for Touch ID authentication.
  * `reuseDuration` Number (optional) - The duration for which Touch ID authentication reuse is allowable, in seconds.

Returns `Promise<void>` - resolves when Touch ID authenticates successfully.

```js
const { promptTouchID } = require('node-mac-auth')

promptTouchID({ reason: 'To get consent for a Security-Gated Thing' }).then(() => {
  console.log('You have successfully authenticated with Touch ID!')
}).catch(err => {
  console.log('TouchID failed because: ', err)
})
```

## Trying It Out

To see this module in action:

```sh
$ git clone https://github.com/electron/electron-quick-start
$ cd electron-quick-start
$ npm install
$ npm install node-mac-auth
```

then open `main.js` inside `electron-quick-start` and add:

```js
const { canPromptTouchID, promptTouchID } = require('node-mac-auth')
```

to the top at line 4, and 

```js
const canPrompt = canPromptTouchID()
console.log(`I ${canPrompt ? 'can' : 'cannot'} prompt for TouchID!`)

promptTouchID({ reason: 'To get consent for a Security-Gated Thing' }).then(() => {
  console.log('You have successfully authenticated with Touch ID!')
}).catch(err => {
  console.log('TouchID failed because: ', err)
})
```

Inside the `createWindow` function beginning at line 9. Enjoy!
