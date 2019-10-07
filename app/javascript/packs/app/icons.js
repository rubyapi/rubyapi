import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faSearch, faCaretDown, faLink, faFastForward, faFastBackward, faForward, faBackward, faHistory, faCheck } from '@fortawesome/free-solid-svg-icons'
import { faCopy } from '@fortawesome/free-regular-svg-icons'
import { faGithub, faTwitter } from '@fortawesome/free-brands-svg-icons'

library.add(faSearch, faCaretDown, faLink, faFastForward, faFastBackward, faForward, faBackward, faGithub, faTwitter, faHistory, faCopy, faCheck)

dom.watch()
