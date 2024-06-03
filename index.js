const auth = require('bindings')('auth.node')

function promptTouchID(options, callback) {
  // Parse and sanitize options object
  if (!options) {
    throw new Error('Options object is required.')
  } else if (!options.hasOwnProperty('reason')) {
    throw new Error('Reason parameter is required.')
  } else if (typeof options.reason !== 'string') {
    throw new TypeError('Reason parameter must be a string.')
  }

  // reuseDuration is optional
  if (options.hasOwnProperty('reuseDuration') && typeof options.reuseDuration !== 'number') {
    throw new TypeError('reuseDuration parameter must be a number.')
  }

  return auth.promptTouchID.call(this, options)
}

module.exports = {
  canPromptTouchID: auth.canPromptTouchID,
  promptTouchID,
}
