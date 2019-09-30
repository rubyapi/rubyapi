const _ = require('lodash')

module.exports = {
  theme: {
    extend: {
      colors: {
        red: {
          "100": "#e64177",
          "200": "#d4d4d7",
          "300": "#ea5c8b",
          "400": "#e7457b",
          "500": "#e42e6a",
          "600": "#e1175a",
          "700": "#de004a",
          "800": "#ca0044",
          "900": "#b6003d",
        },
      }
    }
  },
  variants: {},
  plugins: [
    ({ addUtilities, config, e }) => {
      const maxScreenSizeUtilities = _.map(config('theme.screens'), (value, key) => {
        return {
          [`.${e(`max-w-screen-${key}`)}`]: {
            "max-width": `${value} !important`
          }
        }
      })

      addUtilities(maxScreenSizeUtilities)
    }
  ]
}
