import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faSearch, faCaretDown, faLink, faFastForward, faFastBackward, faForward, faBackward, faHistory, faCheck, faSun, faMoon } from '@fortawesome/free-solid-svg-icons'
import { faPlay, faSync, faInfoCircle, faCode, faExternalLinkAlt, faBars } from '@fortawesome/free-solid-svg-icons'
import { faCopy } from '@fortawesome/free-regular-svg-icons'
import { faGithub, faTwitter } from '@fortawesome/free-brands-svg-icons'
import { setTheme } from 'controllers/app/theme-switch_controller'

library.add(faSearch, faCaretDown, faLink, faFastForward, faFastBackward, faForward, faBackward, faGithub, faTwitter, faHistory, faPlay, faCopy, faCheck, faSync, faInfoCircle, faSun, faMoon, faCode, faExternalLinkAlt, faBars)

dom.watch()

// Set initial color theme
setTheme()
