# openproxy-chrome-extension

Chrome Extension for [Open Proxy](http://openproxy.github.io)

## Installation

1. Download [latest CRX](https://github.com/openproxy/openproxy-chrome-extension/raw/master/target/openproxy-chrome-extension.crx)
2. Open "chrome://extensions" (in Chrome)
3. Drug and drop CRX package onto the Extensions page

## Development

> PREREQUISITES: [GIT](http://git-scm.com/downloads), [Node.js and NPM](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager), [Grunt](https://github.com/gruntjs/grunt-cli)

    git clone https://github.com/openproxy/openproxy-chrome-extension.git
    cd openproxy-chrome-extension
    npm install # this will install all required dependencies

    grunt # for "live" unpacked version
    grunt unpacked # for unpacked version
    grunt pack # for CRX

## License

[MIT License](http://opensource.org/licenses/mit-license.php)