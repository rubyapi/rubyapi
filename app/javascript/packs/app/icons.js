import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faSearch, faCaretDown, faLink, faFastForward, faFastBackward, faForward, faBackward, faHistory, faCheck, faPlay, faSync, faInfoCircle, faMoon as faMoonSolid } from '@fortawesome/free-solid-svg-icons'
import { faCopy, faMoon as faMoonRegular } from '@fortawesome/free-regular-svg-icons'
import { faGithub, faTwitter } from '@fortawesome/free-brands-svg-icons'

library.add(faSearch, faCaretDown, faLink, faFastForward, faFastBackward, faForward, faBackward, faGithub, faTwitter, faHistory, faPlay, faCopy, faCheck, faSync, faInfoCircle, faMoonSolid, faMoonRegular)

dom.watch()
