import "./application.css"
import "@fortawesome/fontawesome-free/css/solid"
import "@fortawesome/fontawesome-free/css/fontawesome"
import "@fortawesome/fontawesome-free/css/brands"
import hotkeys from 'hotkeys-js'


hotkeys('/', (event, handler) => {
  event.preventDefault()

  const search = document.getElementById("search")
  if(search != null) { search.focus() }
})
