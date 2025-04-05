// Set Dark Mode if the browser prefers it
if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
  document.querySelector("html")?.classList.add("dark")
}

// Watch for changes to `prefers-color-scheme` media query and update the theme
window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", (e) => {
  if (e.matches) {
    document.querySelector("html")?.classList.add("dark")
  } else {
    document.querySelector("html")?.classList.remove("dark")
  }
})