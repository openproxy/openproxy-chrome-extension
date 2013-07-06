###
    Copyright (c) 2013 Stanley Shyiko
    Licensed under the MIT license.
    https://github.com/openproxy/openproxy-chrome-extension
###

# hooking extension into openproxy web application
chrome.tabs.onUpdated.addListener (tabId, changeInfo, tab) ->
    if changeInfo.status is 'complete' && tab.url.indexOf('localhost') > -1
        chrome.pageAction.show tabId
        chrome.tabs.executeScript null, file: 'scripts/content.js'

# registering proxy activation by OP_PROXY_ON event
chrome.runtime.onConnect.addListener (port) ->
    port.onMessage.addListener (event) ->
        if event.type is 'OP_PROXY_ON'
            proxy = event.body;
            # https://developer.chrome.com/extensions/proxy.html
            chrome.proxy.settings.set
                scope: 'regular'
                value:
                    mode: 'fixed_servers'
                    rules:
                        singleProxy:
                            host: proxy.host
                            port: proxy.port
                            scheme: proxy.scheme || "http" # or "https", "socks4", "socks5"

# binding page action to "reset proxy settings"
chrome.pageAction.onClicked.addListener ->
    # basically OP_PROXY_OFF
    chrome.proxy.settings.set
        scope: 'regular'
        value:
            mode: 'direct'


