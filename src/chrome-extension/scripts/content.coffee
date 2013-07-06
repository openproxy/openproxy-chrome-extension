###
    Copyright (c) 2013 Stanley Shyiko
    Licensed under the MIT license.
    https://github.com/openproxy/openproxy-chrome-extension
###

# informing web page about presence of extension
window.postMessage type: 'OP_CHROME_EXTENSION_INITIALIZED', '*'

# routing events form web page to background.js
background = chrome.runtime.connect()
window.addEventListener 'message', ((event) -> background.postMessage(event.data) if event.source is window), false
