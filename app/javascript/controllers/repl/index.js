// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { application } from "../application"
import ReplController from "./repl_controller"

application.register("repl", ReplController)
