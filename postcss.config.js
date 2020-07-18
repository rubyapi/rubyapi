const purgecss = require('@fullhuman/postcss-purgecss')({
  content: [
    './app/javascript/controllers/search_controller.js',
    './app/javascript/controllers/code_example_controller.js',
    './app/**/*.html.slim',
  ],
  whitelistPatterns: [/ruby|code|mode-dark/],
  // Include any special characters you're using in this regular expression
  defaultExtractor: content => content.match(/[A-Za-z0-9-_:/]+/g) || []
})

module.exports = {
  plugins: [
    require('tailwindcss'),
    require('autoprefixer'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    }),
    ...process.env.NODE_ENV === 'production'
      ? [purgecss]
      : []
  ]
}
