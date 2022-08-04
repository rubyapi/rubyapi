import { application } from "../application"
import CodeExampleController from "./code_example_controller"
import GithubLinksController from "./github_links_controller"
import HeaderController from "./header_controller"
import MethodController from "./method_controller"
import SearchController from "./search_controller"
import ThemeSwitchController from "./theme-switch_controller"
import Dropdown from 'stimulus-dropdown'

application.register("code-example", CodeExampleController)
application.register("github-links", GithubLinksController)
application.register("header", HeaderController)
application.register("method", MethodController)
application.register("search", SearchController)
application.register("theme-switch", ThemeSwitchController)
application.register("dropdown", Dropdown)