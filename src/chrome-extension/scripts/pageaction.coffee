###
    Copyright (c) 2013 Stanley Shyiko
    Licensed under the MIT license.
    https://github.com/openproxy/openproxy-chrome-extension
###

changePageActionIcon = (tab, suffix = '') ->
    chrome.pageAction.setIcon
        tabId: tab.id
        path:
            19: "images/icon-19x19#{suffix}.png"
            38: "images/icon-38x38#{suffix}.png"

animatePageActionIcon = (tab) ->
    changePageActionIcon tab, '-alpha'
    setTimeout (-> changePageActionIcon tab), 500

# binding page action to "reset proxy settings"
chrome.pageAction.onClicked.addListener (tab) ->
    animatePageActionIcon tab
    chrome.runtime.sendMessage type: 'OP_PROXY_OFF'
