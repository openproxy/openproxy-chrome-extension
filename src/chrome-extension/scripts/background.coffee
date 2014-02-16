###
    Copyright (c) 2013 Stanley Shyiko
    Licensed under the MIT license.
    https://github.com/openproxy/openproxy-chrome-extension
###

# @settings {host, port, scheme (default - 'http'), whitelist (optional), blacklist (optional)}
configureProxy = (settings) ->
    scheme = settings.scheme or 'http' # or "https", "socks4", "socks5"
    proxyConfig = "#{if scheme.indexOf('http') is 0 then 'PROXY' else 'SOCKS'} #{settings.host}:#{settings.port}"
    mode: 'pac_script',
    pacScript:
        data:
            """
            function FindProxyForURL(url, host) {
                var bypassProxy = true;
                if (!isPlainHostName(host) &&
                    !shExpMatch(host, '*.local') &&
                    !isInNet(dnsResolve(host), '10.0.0.0', '255.0.0.0') &&
                    !isInNet(dnsResolve(host), '172.16.0.0',  '255.240.0.0') &&
                    !isInNet(dnsResolve(host), '192.168.0.0',  '255.255.0.0') &&
                    !isInNet(dnsResolve(host), '127.0.0.0', '255.255.255.0')) {
                    var blacklist = #{JSON.stringify(settings.blacklist or [])},
                        blacklisted = false;
                    for (var j = 0, je = blacklist.length; j < je; j++) {
                        if (shExpMatch(host, blacklist[j])) {
                            blacklisted = true;
                            break;
                        }
                    }
                    if (!blacklisted) {
                        var whitelist = #{JSON.stringify(settings.whitelist or [])};
                        if (whitelist.length) {
                            for (var i = 0, ie = whitelist.length; i < ie; i++) {
                                if (shExpMatch(host, whitelist[i])) {
                                    bypassProxy = false;
                                    break;
                                }
                            }
                        } else {
                            bypassProxy = false;
                        }
                    }
                }
                return bypassProxy ? 'DIRECT' : '#{proxyConfig}';
            }
            """ # use alert() + chrome://net-internals/#events to debug

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
