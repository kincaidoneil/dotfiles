// See https://hyper.is#cfg for more configuration
module.exports = {
  config: {
    fontSize: 12,
    fontFamily: `Hasklig, 'Source Code Pro', Menlo, monospace`,
    cursorShape: 'BEAM',
    cursorBlink: true,
    shell: '/usr/local/bin/zsh',
    bell: false,
    copyOnSelect: true,
    hyperTabs: {
      trafficButtons: false,
      tabIconsColored: true,
      closeAlign: 'right'
    },
    // Change to a better link highlight color
    termCSS: `
      x-screen a {
        color: #BE86E3;
      }
    `
  },
  plugins: [
    // Theme and improved tab bar
    'hyper-chesterish',
    'hyper-tabs-enhanced',
    // 'hyper-statusline',
    // Support Hasklig
    'hyper-ligatures',
    // Scrolling inside nano
    'hyperterm-alternatescroll',
    // Don't run commands automatically on paste & concat to a single line
    'hyperterm-paste',
    // Make links "click-able"
    'hyperlinks'
  ],
  keymaps: {
    'tab:next': 'ctrl+tab',
    'tab:prev': 'ctrl+tab+shift'
  }
};
