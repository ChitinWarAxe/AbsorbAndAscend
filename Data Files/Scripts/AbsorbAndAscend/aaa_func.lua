local storage = require('openmw.storage')

local settings1 = storage.globalSection('SettingsAbsorbAndAscend1')

function getSettingAAAToggle()
    return settings1:get("aaaToggle")
end

function getSettingProtectedItems()
    return settings1:get("aaaProtectedItems")
end

function isItemProtected(itemRecordId)
    local protectedItems = getSettingProtectedItems()
    return string.find(string.lower(protectedItems), string.lower(itemRecordId)) ~= nil
end