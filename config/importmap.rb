# Pin npm packages by running ./bin/importmap

pin "application"

pin "mustache" # @4.2.0
pin "clipboard-copy" # @4.0.1
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "throttle-debounce" # @5.0.2
pin "stimulus-use" # @0.52.3
pin "@stimulus-components/dropdown", to: "@stimulus-components--dropdown.js" # @3.0.0
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "hotkeys-js" # @3.13.9

pin_all_from "app/javascript/controllers", under: "controllers"
pin "application"
