document.addEventListener("DOMContentLoaded", function(){
  const toggleSwitch = document.querySelector('#theme-switch input[type="checkbox"]');
  const utterances = document.querySelector('iframe');

  function detectColorScheme() {
    var theme = "light";

    if (localStorage.getItem("theme")) {
      if (localStorage.getItem("theme") == "dark") {
        theme = "dark";
      }
    } else if (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches) {
      theme = "dark";
    }

    if (theme == "dark") {
      document.documentElement.setAttribute("data-theme", "dark");
      toggleSwitch.checked = true;
      utterances.contentWindow.postMessage(
        {type: 'set-theme',theme: 'github-dark'},
        'https://utteranc.es'
      );
    } else {
      utterances.contentWindow.postMessage(
        {type: 'set-theme',theme: 'github-light'},
        'https://utteranc.es'
      );
    }
  }

  function switchTheme(e) {
    if (e.target.checked) {
      localStorage.setItem('theme', 'dark');
      document.documentElement.setAttribute('data-theme', 'dark');
      toggleSwitch.checked = true;
      utterances.contentWindow.postMessage(
        {type: 'set-theme',theme: 'github-dark'},
        'https://utteranc.es'
      );
    } else {
      localStorage.setItem('theme', 'light');
      document.documentElement.setAttribute('data-theme', 'light');
      toggleSwitch.checked = false;
      utterances.contentWindow.postMessage(
        {type: 'set-theme',theme: 'github-light'},
        'https://utteranc.es'
      );
    }
  }

  toggleSwitch.addEventListener('change', switchTheme, false);

  detectColorScheme();
});
