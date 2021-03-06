# openproxy-chrome-extension

Chrome Extension for [OpenProxy](http://openproxy.github.io).

It allows to switch proxies directly through the OpenProxy web page.

## Installation

> Follow the same instructions if you need to update an extension.

1. Download [latest CRX](https://github.com/openproxy/openproxy-chrome-extension/releases)
2. Open "chrome://extensions" (in Chrome)
3. Drug and drop CRX package onto the Extensions page

## Development

> PREREQUISITES: [GIT](http://git-scm.com/downloads), [Node.js and NPM](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager), [Grunt](https://github.com/gruntjs/grunt-cli)

    git clone https://github.com/openproxy/openproxy-chrome-extension.git
    cd openproxy-chrome-extension
    npm install # this will install all required dependencies

    grunt # for a "live" unpacked version
    grunt unpacked # for the unpacked version
    grunt pack # for the CRX

## License

[MIT License](http://opensource.org/licenses/mit-license.php)