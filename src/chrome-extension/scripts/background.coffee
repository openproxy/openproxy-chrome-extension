###
    Copyright (c) 2013 Stanley Shyiko
    Licensed under the MIT license.
    https://github.com/openproxy/openproxy-chrome-extension
###

# @settings {host, port, scheme (default - 'http'), whitelist (optional), blacklist (optional)}
configureProxy = (settings) ->
    settings.scheme ||= 'http' # or "https", "socks4", "socks5"
    if settings.whitelist
        proxyType = if settings.scheme.indexOf('http') is 0 then 'PROXY' else 'SOCKS'
        mode: 'pac_script',
        pacScript:
            data:
                """
                function FindProxyForURL(url, host) {
                    var whitelist = #{JSON.stringify(settings.whitelist)};
                    for (i = 0, e = whitelist.length; i < e; i++) {
                        if (shExpMatch(host, whitelist[i])) {
                            return '#{proxyType} #{settings.host}:#{settings.port}';
                        }
                    }
                    return 'DIRECT';
                }
                """ # use alert() + chrome://net-internals/#events to debug
    else
        mode: 'fixed_servers'
        rules:
            singleProxy:
                host: settings.host, port: settings.port, scheme: settings.scheme
            bypassList: settings.blacklist || []

# @event {type, body}
eventHandler = (event) ->
    switch event.type
        when 'OP_PROXY_ON'
            chrome.proxy.settings.set
                scope: 'regular', value: configureProxy(event.body)
        when 'OP_PROXY_OFF'
            chrome.proxy.settings.set
                scope: 'regular', value: mode: 'direct'
        else return false
    return true

# registering listener for OP_PROXY_* events
chrome.runtime.onConnect.addListener (port) ->
    port.onMessage.addListener (event) ->
        if (eventHandler(event))
            port.postMessage type: 'OP_COMPLETED', body: event

chrome.runtime.onMessage.addListener eventHandler
