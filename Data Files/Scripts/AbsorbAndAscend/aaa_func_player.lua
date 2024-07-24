local self = require('openmw.self')
local storage = require('openmw.storage')
local input = require('openmw.input')
local core = require('openmw.core')
local ui = require('openmw.ui')
local ambient = require('openmw.ambient')
local types = require('openmw.types')
local I = require('openmw.interfaces')

local settings2 = storage.playerSection("SettingsAbsorbAndAscend2")
local settings3 = storage.playerSection("SettingsAbsorbAndAscend3")

local L = core.l10n("AbsorbAndAscend")

math.randomseed(os.time())

local function getSettingXPCap()
    return settings2:get("aaaRawXPCap")
end

local function getSettingConstantEffectXPBase()
    return settings2:get("aaaConstantEffectXPBase")
end

local function getSettingConstantEffectXPPerEffect()
    return settings2:get("aaaConstantEffectXPPerEffect")
end

local function getSettingFailToggle()
    return settings2:get("aaaFailToggle")
end

local function getSettingCustomKeyToggle()
    return settings3:get("aaaCustomKeyToggle")
end

local function getSettingCustomKey1()
    local key = settings3:get("aaaCustomKey1")
    return key ~= "" and input.KEY[key] or nil
end

local function getSettingCustomKey2()
    local key = settings3:get("aaaCustomKey2")
    return key ~= "" and input.KEY[key] or nil
end

--

local function itemAbsorbSuccessAlert(name)
    ui.showMessage(string.format(L("aaaAbsorbSuccess", {name = name})))
    ambient.playSound("enchant success")   
end

local function itemAbsorbFailAlert(name)
    ui.showMessage(string.format(L("aaaAbsorbFail", {name = name})))
    ambient.playSound("enchant fail")   
end

local function getPlayerIntelligence()
    return math.min(types.NPC.stats.attributes.intelligence(self).modified, 100)
end

local function getPlayerEnchantSkill()
    return math.min(types.NPC.stats.skills.enchant(self).modified, 100)
end

local function getPlayerLuck()
    return math.min(types.NPC.stats.attributes.luck(self).modified, 100)
end

local function getAttributeMultiplier(intelligence, enchantSkill, luck)
    return 1 + ((((intelligence+enchantSkill)/5)+(luck/10))/100)
end

local function getFailChance(itemXP)
    return (100 - ((getPlayerIntelligence()+getPlayerEnchantSkill()) + getPlayerLuck()/10)) + itemXP/2
end

local function checkAbsorbSuccess(itemXP)
    
    local rand = math.random(1, 1000)
    local failChance = getFailChance(itemXP)
    print("fail chance: " .. failChance*10)
    local success = true
    
    print("rand: " .. rand)
    
    if rand < failChance*10 then
        success = false
    end
    
    return success
end

local function getItemXP(data)

    local itemXP = 0

    if data.enchantmentType == 1 or data.enchantmentType == 2 then -- on use, on strike enchantments
        itemXP = math.min(data.charge/20 + data.cost/2, getSettingXPCap())
    elseif data.enchantmentType == 3 then -- constant effect enchantments
        itemXP = getSettingConstantEffectXPBase() + (#data.effects * getSettingConstantEffectXPPerEffect())
    end
    
    return itemXP
end

local function getModifiedXP(itemXP)
    
    local modifiedXP = 0

    modifiedXP = itemXP * getAttributeMultiplier(getPlayerIntelligence(), getPlayerEnchantSkill(), getPlayerLuck())
    
    return modifiedXP
end

local function progressSkill(skill, xp)
    I.SkillProgression.skillUsed(skill, {
        skillGain = xp,
        useType = 0
    })
end

return {
    getSettingCustomKeyToggle = getSettingCustomKeyToggle,
    getSettingCustomKey1 = getSettingCustomKey1,
    getSettingCustomKey2 = getSettingCustomKey2,
    getSettingFailToggle = getSettingFailToggle,
    checkAbsorbSuccess = checkAbsorbSuccess,
    getItemXP = getItemXP,
    getModifiedXP = getModifiedXP,
    itemAbsorbSuccessAlert = itemAbsorbSuccessAlert,
    itemAbsorbFailAlert = itemAbsorbFailAlert,
    progressSkill = progressSkill
}