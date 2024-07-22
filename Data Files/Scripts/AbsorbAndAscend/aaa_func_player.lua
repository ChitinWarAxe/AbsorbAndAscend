local storage = require('openmw.storage')
local input = require('openmw.input')
local core = require('openmw.core')
local ui = require('openmw.ui')
local ambient = require('openmw.ambient')

local settings2 = storage.playerSection("SettingsAbsorbAndAscend2")
local settings3 = storage.playerSection("SettingsAbsorbAndAscend3")

local L = core.l10n("AbsorbAndAscend")

function getSettingXPCap()
    return settings2:get("aaaRawXPCap")
end

function getSettingCustomKeyToggle()
    return settings3:get("aaaCustomKeyToggle")
end

function getSettingCustomKey1()
    local key = settings3:get("aaaCustomKey1")
    return key ~= "" and input.KEY[key] or nil
end

function getSettingCustomKey2()
    local key = settings3:get("aaaCustomKey2")
    return key ~= "" and input.KEY[key] or nil
end

function itemAbsorbAlert(name)
    ui.showMessage(string.format(L("aaaAbsorbSuccess", {name = name})))
    ambient.playSound("enchant success")   
end