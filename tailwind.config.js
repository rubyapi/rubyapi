const _ = require('lodash')

module.exports = {
  theme: {
    extend: {
      screens: {
        xxl: '1680px',
      },
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
  variants: {
    backgroundColor: ['focus', 'hover', 'dark', 'dark-focus', 'dark-hover', 'dark-group-hover', 'dark-even', 'dark-odd'],
    borderColor: ['focus', 'hover', 'dark', 'dark-focus', 'dark-focus-within'],
    textColor: ['focus', 'hover', 'dark', 'dark-focus', 'dark-hover', 'dark-active', 'dark-placeholder'],
    opacity: ['responsive', 'hover', 'focus', 'disabled'],
    cursor: ['responsive', 'hover', 'focus', 'disabled'],
  },
  plugins: [
    require('tailwindcss-dark-mode')(),
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
  purge: {
    options: {
      whitelist: ['mode-dark']
    },
    content: [
      './app/javascript/controllers/app/search_controller.js',
      './app/javascript/controllers/app/code_example_controller.js',
      './app/javascript/controllers/app/method_controller.js',
      './app/**/*.html.slim',
    ],
  }
}
