local storage = require('openmw.storage')
local input = require('openmw.input')
local core = require('openmw.core')
local ui = require('openmw.ui')
local ambient = require('openmw.ambient')

local settings = storage.playerSection("SettingsAbsorbAndAscend2")

local L = core.l10n("AbsorbAndAscend")

function getSettingCustomKeyToggle()
    return settings:get("aaaCustomKeyToggle")
end

function getSettingCustomKey1()
    local key = settings:get("aaaCustomKey1")
    return key ~= "" and input.KEY[key] or nil
end

function getSettingCustomKey2()
    local key = settings:get("aaaCustomKey2")
    return key ~= "" and input.KEY[key] or nil
end

function itemAbsorbAlert(name)
    ui.showMessage(string.format(L("aaaAbsorbMessage", {name = name})))
    ambient.playSound("enchant success")   
end