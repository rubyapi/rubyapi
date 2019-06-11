const _ = require('lodash')

module.exports = {
  theme: {
    fontFamily: {
      diaply: ["proxima-nova", "sans-serif"],
      body: ["proxima-nova", "sans-serif"],
    },
    extend: {
      colors: {
        gray: {
          "100": "#f5f5f5",
          "200": "#e9e9e9",
          "300": "#c5c5c8",
          "400": "#aeaeb2",
          "500": "#97979c",
          "600": "#818187",
          "700": "#535356",
          "800": "#3b3b3e",
          "900": "#242425",
        },
        red: {
          "100": "#efefef",
          "200": "#d4d4d7",
          "300": "#ea5c8b",
          "400": "#e7457b",
          "500": "#e42e6a",
          "600": "#e1175a",
          "700": "#de004a",
          "800": "#ca0044",
          "900": "#b6003d",
        }
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
