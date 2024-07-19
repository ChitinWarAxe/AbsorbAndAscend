local self = require('openmw.self')
local core = require('openmw.core')
local types = require('openmw.types')
local input = require('openmw.input')
local I = require('openmw.interfaces')
local aaaFuncPlayer = require('scripts.absorbandascend.aaa_func_player')

local activationPressed = false

local function isCustomKeyComboPressed()
    local key1 = getSettingCustomKey1()
    local key2 = getSettingCustomKey2()
    
    if not key1 and not key2 then
        return false
    elseif not key2 then
        return input.isKeyPressed(key1)
    elseif not key1 then
        return input.isKeyPressed(key2)
    else
        return input.isKeyPressed(key1) and input.isKeyPressed(key2)
    end
end

local function onKeyPress(e)
    local code = e.code
    
    if getSettingCustomKeyToggle() then
        if isCustomKeyComboPressed() then
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
    
    if getSettingCustomKeyToggle() then
        if not isCustomKeyComboPressed() then
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
    
    local totalExp = 0
    
    local enchantSkill = types.NPC.stats.skills.enchant(self).modified
    local luck = types.NPC.stats.attributes.luck(self).modified
    local intelligence = types.NPC.stats.attributes.intelligence(self).modified
    local attributeMultiplier = 1 + ((((intelligence+enchantSkill)/5)+(luck/10))/100)

    if data.enchantmentType == 1 or data.enchantmentType == 2 then -- on use, on strike enchantments
    
        local itemExpValue = data.charge/20 + data.cost/2
        totalExp = itemExpValue * attributeMultiplier
        
    elseif data.enchantmentType == 3 then -- constant effect enchantments
        
        totalExp = (20 + (#data.effects * 5) ) * attributeMultiplier
        
    end
    
    return totalExp
end

local function calculateAndApplyExperience(data)

    local calculatedTotalExperience = getCalculatedTotalExperience(data)

    if calculatedTotalExperience ~= 0 then
        
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
        
        itemAbsorbAlert(data.itemName)

    end
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

