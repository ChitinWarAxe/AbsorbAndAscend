local storage = require('openmw.storage')
local input = require('openmw.input')

local settings = storage.playerSection("SettingsAbsorbAndAscend2")

function getSettingCustomKeyToggle()
    return settings:get("aaaCustomKeyToggle")
end

function getSettingCustomKey1()
    return input.KEY[settings:get("aaaCustomKey1")] or 0
end

function getSettingCustomKey2()
    return input.KEY[settings:get("aaaCustomKey2")] or 0
end