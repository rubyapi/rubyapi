const _ = require('lodash')

module.exports = {
  theme: {},
  variants: {},
  plugins: [
    require('./theme.config'),
    ({ addUtilities, addVariant, config, e, theme }) => {
      addUtilities(_.map(config('theme.screens'), (value, key) => {
        return {
          [`.${e(`max-w-screen-${key}`)}`]: {
            "max-width": `${value} !important`
          }
        }
      }))
    },
    ({ addUtilities, e, theme, }) => {
      addUtilities(_.fromPairs(
        _.map(theme('opacity'), (value, modifier) => {
          return [
            `.${e(`placeholder-opacity-${modifier}`)}::placeholder`,
            {
              opacity: value,
            },
          ]
        })
      ))
    }
  ]
}
