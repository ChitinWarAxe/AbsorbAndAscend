local self = require('openmw.self')
local core = require('openmw.core')
local types = require('openmw.types')
local ui = require('openmw.ui')
local input = require('openmw.input')
local I = require('openmw.interfaces')
local ambient = require('openmw.ambient')

local function isShiftAltPressed()
    return input.isShiftPressed() and input.isAltPressed()
end

local lastShiftAltState = false

local function checkShiftAltState()
    local currentState = isShiftAltPressed()
    if currentState ~= lastShiftAltState then
        lastShiftAltState = currentState
        core.sendGlobalEvent('shiftAltStateChanged', {pressed = currentState})
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
       
        ambient.playSound("swallow")
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
        onUpdate = checkShiftAltState
    }
}