import { Application } from "@hotwired/stimulus"
import StimulusReflex from 'stimulus_reflex'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

StimulusReflex.initialize(application, { isolate: true })

export { application }