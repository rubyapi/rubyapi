const _ = require('lodash')

module.exports = {
  content: [
    './app/views/**/*.html.slim',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        code: {
          "header": "#2f3e46",
          "background": "#282c34",
          "text": "#dcdfe4"
        },
        red: {
          "100": "#f2d7d8",
          "200": "#f3b8bc",
          "300": "#f399a5",
          "400": "#f0667f",
          "500": "#ea3a66",
          "600": "#e1175a",
          "700": "#d10f4a",
          "800": "#bb0c3f",
          "900": "#a20c36",
        },
      }
    }
  },
  plugins: [
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
  ],
}
