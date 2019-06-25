import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faSearch, faAngleDown, faLink } from '@fortawesome/free-solid-svg-icons'
import { faGithub, faTwitter } from '@fortawesome/free-brands-svg-icons'

library.add(faSearch, faAngleDown, faLink, faGithub, faTwitter)

dom.watch()
