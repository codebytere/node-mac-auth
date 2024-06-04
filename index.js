const auth = require('bindings')('auth.node')

function promptTouchID(options) {
  if (!options) {
    throw new Error('Options object is required.')
  }

  if (!options.hasOwnProperty('reason') || typeof options.reason !== 'string') {
    throw new Error('Reason parameter must be a string.')
  }

  if (options.hasOwnProperty('reuseDuration') && typeof options.reuseDuration !== 'number') {
    throw new TypeError('reuseDuration parameter must be a number.')
  }

  return auth.promptTouchID.call(this, options)
}

module.exports = {
  canPromptTouchID: auth.canPromptTouchID,
  promptTouchID,
}
