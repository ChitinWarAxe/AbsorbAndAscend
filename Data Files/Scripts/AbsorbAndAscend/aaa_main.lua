local self = require('openmw.self')
local core = require('openmw.core')
local types = require('openmw.types')
local ui = require('openmw.ui')
local input = require('openmw.input')
local I = require('openmw.interfaces')
local ambient = require('openmw.ambient')
local aaaFuncPlayer = require('scripts.absorbandascend.aaa_func_player')

local activationPressed = false

local function onKeyPress(e)
    local code = e.code
    local key1 = getSettingCustomKey1()
    local key2 = getSettingCustomKey2()
    
    if getSettingCustomKeyToggle() then
        if (code == key1) or (code == key2) then
            activationPressed = true
            core.sendGlobalEvent('activationStateChanged', {pressed = true})
        end
    else
        if (code == input.KEY.LeftShift or code == input.KEY.RightShift) and input.isAltPressed() then
            activationPressed = true
            core.sendGlobalEvent('activationStateChanged', {pressed = true})
        elseif (code == input.KEY.LeftAlt or code == input.KEY.RightAlt) and input.isShiftPressed() then
            activationPressed = true
            core.sendGlobalEvent('activationStateChanged', {pressed = true})
        end
    end
end

local function onKeyRelease(e)
    local code = e.code
    local key1 = getSettingCustomKey1()
    local key2 = getSettingCustomKey2()
    
    if getSettingCustomKeyToggle() then
        if (code == key1) or (code == key2) then
            activationPressed = false
            core.sendGlobalEvent('activationStateChanged', {pressed = false})
        end
    else
        if (code == input.KEY.LeftShift or code == input.KEY.RightShift or
            code == input.KEY.LeftAlt or code == input.KEY.RightAlt) and not (input.isShiftPressed() and input.isAltPressed()) then
            activationPressed = false
            core.sendGlobalEvent('activationStateChanged', {pressed = false})
        end
    end
end

local function getCalculatedTotalExperience(data)
    
    print('type: ' .. data.enchantmentType)
    
    local totalExp = 0
    
    local enchantSkill = types.NPC.stats.skills.enchant(self).modified
    local luck = types.NPC.stats.attributes.luck(self).modified
    local intelligence = types.NPC.stats.attributes.intelligence(self).modified
    local attributeMultiplier = 1 + ((((intelligence+enchantSkill)/5)+(luck/10))/100)
    
    print('multiplier ' .. attributeMultiplier)
    
    if data.enchantmentType == 1 or data.enchantmentType == 2 then
    
        local itemExpValue = data.charge/20 + data.cost/2
        print('itemExp ' .. itemExpValue)
        totalExp = itemExpValue * attributeMultiplier
        
    elseif data.enchantmentType == 3 then
        
        totalExp = (20 + (#data.effects * 5) ) * attributeMultiplier
        
    end
    
    print("Experience: " .. totalExp)
    
    return totalExp
end

local function calculateAndApplyExperience(data)

    local calculatedTotalExperience = getCalculatedTotalExperience(data)
    
    print('calculatedTotalExperience ' .. calculatedTotalExperience)

    if calculatedTotalExperience ~= 0 then
       
        ambient.playSound("enchant success")
        ui.showMessage('You destroyed your item and absorbed its power!')        
        
        local expPerEffect = calculatedTotalExperience / #data.effects
        
        print("Experience per Effect: " .. expPerEffect)
        
        for i, effect in ipairs(data.effects) do
        
            local skill = types.NPC.stats.skills[effect.school](self)

            I.SkillProgression.skillUsed(effect.school, {
                skillGain = expPerEffect,
                useType = 0
            })

            I.SkillProgression.skillUsed('enchant', {
                skillGain = 1,
                useType = 0
            })

        end
    else
        print("Enchantment type does not grant experience.")
    end
end

local function printEnchantmentInfo(data)

end

return {
    eventHandlers = {
        enchantmentUsed = calculateAndApplyExperience
    },
    engineHandlers = {
        onKeyPress = onKeyPress,
        onKeyRelease = onKeyRelease
    }
}

