local storage = require('openmw.storage')

local settings = storage.globalSection('SettingsAbsorbAndAscend')

function getSettingAAAToggle()
    return settings:get("aaaToggle")
end

function getSettingProtectedItems()
    return settings:get("aaaProtectedItems")
end

function isItemProtected(itemRecordId)
    local protectedItems = getSettingProtectedItems()
    return string.find(string.lower(protectedItems), string.lower(itemRecordId)) ~= nil
end