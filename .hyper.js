// See https://hyper.is#cfg for more configuration
module.exports = {
  config: {
    fontSize: 12,
    fontFamily: 'Hasklig, Menlo, monospace',
    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: 'BEAM',
    cursorBlink: true,
    // the shell to run when spawning a new session (i.e. /bin/bash)
    // if left empty, your system's login shell will be used by default
    shell: '/usr/local/bin/zsh',
    shellArgs: ['--login'],
    env: {},
    bell: false,
    copyOnSelect: true,
    hyperTabs: {
      tabIconsColored: true,
      closeAlign: 'right'
    }
  },
  plugins: [
    // Theme and improved tab bar
    `hyper-chesterish`,
    `hyper-tabs-enhanced`,
    // Support Hasklig
    `hyper-ligatures`,
    // Scrolling inside nano
    `hyperterm-alternatescroll`,
    // Don't run commands automatically on paste & concat to a single line
    `hyperterm-paste`,
    // Make links "click-able"
    `hyperlinks`
  ],
  keymaps: {
    'tab:next': 'ctrl+tab',
    'tab:prev': 'ctrl+tab+shift'
  }
};
