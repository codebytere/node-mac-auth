const { promptTouchID, canPromptTouchID } = require('./index')

promptTouchID({reason: 'hello'}, (err, status) => {
  if (err) console.log(err)
  console.log(status)
})