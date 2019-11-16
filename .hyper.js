// See https://hyper.is#cfg for more configuration
module.exports = {
  config: {
    fontSize: 12,
    fontFamily: `Hasklig, 'Source Code Pro', Menlo, monospace`,
    cursorShape: 'BEAM',
    cursorBlink: true,
    shell: '/usr/local/bin/zsh',
    bell: false,
    copyOnSelect: true
  },
  plugins: [
    // Theme and improved tab bar
    'hyper-chesterish',
    'hyper-statusline',
    // Support Hasklig
    'hyper-ligatures',
    // Make links "click-able"
    'hyperlinks'
  ]
};
