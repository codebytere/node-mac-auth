const { expect } = require('chai')
const { promptTouchID, canPromptTouchID } = require('../index')

describe('node-mac-auth', () => {
  describe('canPromptTouchID()', () => {
    it('should not throw', () => {
      expect(() => { canPromptTouchID() }).to.not.throw()
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
      }).to.throw(/Reason parameter is required./)
    })

    it('should throw if reason is not a string', () => {
      expect(() => {
        promptTouchID({ reason: 1 })
      }).to.throw(/Reason parameter must be a string./)
    })

    it('should throw if no callback is passed', () => {
      expect(() => {
        promptTouchID({ reason: 'i want to' })
      }).to.throw(/Callback function is required./)
    })
    
    it('should not throw if no reuseDuration is passed', () => {
      expect(() => {
        promptTouchID({ reason: 'i want to' }, () => {})
      }).to.not.throw()
    })
  })
})