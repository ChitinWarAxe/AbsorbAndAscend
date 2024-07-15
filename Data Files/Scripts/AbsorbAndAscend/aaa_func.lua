local storage = require('openmw.storage')

--local settings = storage.playerSection("SettingsAbsorbAndAscend")
local settings = storage.globalSection('SettingsAbsorbAndAscend')

function getSettingAAAToggle()
    return settings:get("aaaToggle")
end

function getSettingProtectedItems()
    return settings:get("aaaProtectedItems")
end

function getSettingCustomKeyToggle()
    return settings:get("aaaCustomKeyToggle")
end

function getSettingCustomKey1()
    return settings:get("aaaCustomKey1")
end

function getSettingCustomKey2()
    return settings:get("aaaCustomKey2")
end

function isItemProtected(itemRecordId)
    local protectedItems = getSettingProtectedItems()
    return string.find(string.lower(protectedItems), string.lower(itemRecordId)) ~= nil
end