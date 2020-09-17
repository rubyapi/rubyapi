import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faSearch, faCaretDown, faLink, faFastForward, faFastBackward, faForward, faBackward, faHistory, faCheck, faSun, faMoon } from '@fortawesome/free-solid-svg-icons'
import { faPlay, faSync, faInfoCircle, faCode, faExternalLinkAlt } from '@fortawesome/free-solid-svg-icons'
import { faCopy } from '@fortawesome/free-regular-svg-icons'
import { faGithub, faTwitter } from '@fortawesome/free-brands-svg-icons'

library.add(faSearch, faCaretDown, faLink, faFastForward, faFastBackward, faForward, faBackward, faGithub, faTwitter, faHistory, faPlay, faCopy, faCheck, faSync, faInfoCircle, faSun, faMoon, faCode, faExternalLinkAlt)

dom.watch()
