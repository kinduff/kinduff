document.addEventListener("DOMContentLoaded", function(event) {
  const schemeSwitch = document.querySelector('#theme-switch input[type="checkbox"]');
  const utterancesIframe = document.querySelector('.utterances-frame');

  function updateUtterancesTheme(scheme) {
    addEventListener('message', function(event) {
      if (event.origin !== 'https://utteranc.es') return;

      setUtterancesTheme(scheme);
    })

    setUtterancesTheme(scheme);
  }

  function setUtterancesTheme(scheme) {
    if (!utterancesIframe) return;

    utterancesIframe.contentWindow.postMessage(
      { type: 'set-theme', theme: `github-${scheme}` },
      'https://utteranc.es'
    );
  }

  function setDocumentTheme(scheme) {
    document.documentElement.setAttribute("data-theme", scheme);
  }

  function setSchemeSwitchCheckbox(scheme) {
    schemeSwitch.checked = (scheme === "dark");
  }

  function saveSchemePreference(scheme) {
    localStorage.setItem("theme", scheme);
  }

  function setTheme(scheme) {
    updateUtterancesTheme(scheme);
    setDocumentTheme(scheme);
    setSchemeSwitchCheckbox(scheme);
    saveSchemePreference(scheme);
  }

  function detectColorScheme() {
    let theme = "light";

    if (localStorage.getItem("theme")) {
      if (localStorage.getItem("theme") == "dark") {
        theme = "dark";
      }
    } else if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
        theme = "dark";
    }

    setTheme(theme)
  }

  schemeSwitch.addEventListener('change', function(e) {
    setTheme(e.target.checked ? 'dark' : 'light')
  }, false);

  detectColorScheme();
});
