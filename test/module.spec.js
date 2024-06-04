const { expect } = require('chai')
const { promptTouchID, canPromptTouchID } = require('../index')

describe('node-mac-auth', () => {
  describe('canPromptTouchID()', () => {
    it('should not throw', () => {
      expect(() => {
        canPromptTouchID()
      }).to.not.throw()
    })

    it('should return a boolean', () => {
      const canPrompt = canPromptTouchID()
      expect(canPrompt).to.be.a('boolean')
    })
  })

  describe('promptTouchID()', () => {
    it('should throw if no options object is passed', () => {
      expect(() => {
        promptTouchID()
      }).to.throw(/Options object is required./)
    })

    it('should throw if no reason is passed', () => {
      expect(() => {
        promptTouchID({})
      }).to.throw(/Reason parameter must be a string./)
    })

    it('should throw if reason is not a string', () => {
      expect(() => {
        promptTouchID({ reason: 1 })
      }).to.throw(/Reason parameter must be a string./)
    })

    it('should throw if reuseDuration is not a number', () => {
      expect(() => {
        promptTouchID({ reason: 'i want to', reuseDuration: 'not-a-number' })
      }).to.throw(/reuseDuration parameter must be a number./)
    })

    it('should not throw if no reuseDuration is passed', () => {
      expect(() => {
        promptTouchID({ reason: 'i want to' }, () => {})
      }).to.not.throw()

      // Quit after test passes, or it will hang on system prompt.
      process.exit(0)
    })
  })
})
