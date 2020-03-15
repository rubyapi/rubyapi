const { ThemeBuilder, Theme } = require('tailwindcss-theming');

const lightTheme = new Theme()
  .name('light')
  .default()
  .assignable()
  .colors({
    // Tailwind‘s colors
    'white': '#ffffff',
    'black': '#000',

    'blue-400': '#63b3ed',

    'gray-100': '#f7fafc',
    'gray-200': '#edf2f7',
    'gray-300': '#e2e8f0',
    'gray-400': '#cbd5e0',
    'gray-500': '#a0aec0',
    'gray-600': '#718096',
    'gray-700': '#4a5568',
    'gray-800': '#2d3748',
    'gray-900': '#1a202c',

    // RubyAPI‘s custom red
    'red-100': '#f2d7d8',
    'red-200': '#f3b8bc',
    'red-300': '#f399a5',
    'red-400': '#f0667f',
    'red-500': '#ea3a66',
    'red-600': '#e1175a',
    'red-700': '#d10f4a',
    'red-800': '#bb0c3f',
    'red-900': '#a20c36',

    'background': '#ffffff',
    'body': '#4a5568',

    'home-container-background': '#e1175a',
    'github-links-hover': '#f2d7d8',
    'github-links': '#4a5568',
    'github-links-background': '#ffffff',
    'github-link-hover-background': '#edf2f7',
    'github-link': '#2d3748',
    'ruby-version-hover': '#f2d7d8',
    'ruby-version-list': '#4a5568',
    'ruby-version-list-background': '#ffffff',
    'ruby-version-list-item-hover-background': '#edf2f7',
    'core-class-border': '#e2e8f0',
    'core-class-title': '#2d3748',
    'core-class': '#4a5568',
    'header-background': '#e1175a',
    'header-autocomplete-background': '#bb0c3f',
    'header-github-link-hover': '#f2d7d8',
    'header-github-links': '#4a5568',
    'header-github-links-background': '#ffffff',
    'header-github-link-hover-background': '#edf2f7',
    'header-github-repo': '#2d3748',
    'header-ruby-version-list': '#4a5568',
    'header-ruby-version-list-background': '#ffffff',
    'object-method-title': '#4a5568',
    'object-method-link-hover-background': '#edf2f7',
    'object-title': '#2d3748',
    'object-label-background': '#edf2f7',
    'object-callseq-title': '#1a202c',
    'object-type': '#edf2f7',
    'object-type-background': '#edf2f7',
    'object-type-hover-background': '#e2e8f0',
    'object-type-hover': '#2d3748',
    'search-title': '#2d3748',
    'result-text': '#4a5568',
    'result-title': '#2d3748',
    'experiment-notice': '#4a5568',
    'experiment-notice-background': '#cbd5e0',
    'executed-result': '#4a5568',
    'executed-result-background': '#e2e8f0',

    'code-header': '#2f3e46',
    'code-background': '#1b2b34',
    'code-text': '#d8dee9',
  })
;

const darkTheme = new Theme()
  .name('dark')
  .colors({
    // Tailwind‘s colors
    'white': '#fff',
    'black': '#000',

    'blue-400': '#63b3ed',

    'gray-100': '#f7fafc',
    'gray-200': '#edf2f7',
    'gray-300': '#e2e8f0',
    'gray-400': '#cbd5e0',
    'gray-500': '#a0aec0',
    'gray-600': '#718096',
    'gray-700': '#4a5568',
    'gray-800': '#2d3748',
    'gray-900': '#1a202c',

    // RubyAPI‘s custom red
    'red-100': '#f2d7d8',
    'red-200': '#f3b8bc',
    'red-300': '#f399a5',
    'red-400': '#f0667f',
    'red-500': '#ea3a66',
    'red-600': '#e1175a',
    'red-700': '#d10f4a',
    'red-800': '#bb0c3f',
    'red-900': '#a20c36',

    'background':'#2d3748',
    'body': '#cbd5e0',

    'home-container-background': '#4a5568',
    'github-links-hover': '#cbd5e0',
    'github-links': '#cbd5e0',
    'github-links-background': '#1a202c',
    'github-link-hover-background': '#2d3748',
    'github-link': '#edf2f7',
    'ruby-version-hover': '#cbd5e0',
    'ruby-version-list': '#cbd5e0',
    'ruby-version-list-background': '#1a202c',
    'ruby-version-list-item-hover-background': '#2d3748',
    'core-class-border': '#4a5568',
    'core-class-title': '#edf2f7',
    'core-class': '#a0aec0',
    'header-background': '#4a5568',
    'header-autocomplete-background': '#2d3748',
    'header-github-link-hover': '#cbd5e0',
    'header-github-links': '#cbd5e0',
    'header-github-links-background': '#1a202c',
    'header-github-link-hover-background': '#2d3748',
    'header-github-repo': '#edf2f7',
    'header-ruby-version-list': '#cbd5e0',
    'header-ruby-version-list-background': '#1a202c',
    'object-method-title': '#edf2f7',
    'object-method-link-hover-background': '#4a5568',
    'object-title': '#edf2f7',
    'object-label-background': '#4a5568',
    'object-callseq-title': '#edf2f7',
    'object-type-background': '#4a5568',
    'object-type-hover-background': '#1a202c',
    'object-type-hover': '#cbd5e0',
    'search-title': '#edf2f7',
    'result-text': '#a0aec0',
    'result-title': '#ffffff',
    'experiment-notice': '#edf2f7',
    'experiment-notice-background': '#2d3748',
    'executed-result': '#edf2f7',
    'executed-result-background': '#1a202c',

    'code-header': '#4a5568',
    'code-background': '#1b2b34',
    'code-text': '#d8dee9',
  })
;

module.exports = new ThemeBuilder()
  .asDataThemeAttribute()
  .default(lightTheme)
  .dark(darkTheme);
