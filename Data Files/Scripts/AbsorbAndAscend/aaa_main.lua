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

local function calculateAndApplyExperience(data)

    local enchantSkill = types.NPC.stats.skills.enchant(self).modified
    local luck = types.NPC.stats.attributes.luck(self).modified
    local intelligence = types.NPC.stats.attributes.intelligence(self).modified

    if data.enchantmentType == 1 or data.enchantmentType == 2 then -- On Strike or On Use
       
        ambient.playSound("swallow")
        ui.showMessage('You destroyed your item and absorbed its power!')
    
        -- local baseExp = (data.charge + data.cost) * (1 + enchantSkill/10) * (1 + luck/10)
        -- (Enchant + Intelligence/5 + Luck/10
        local itemExpValue = data.charge/10 + data.cost
        local attributeMultiplier = 1 + ((((intelligence+enchantSkill)/5)+(luck/10))/100)
        local baseExp = itemExpValue * attributeMultiplier
        local expPerEffect = baseExp / #data.effects
        
        --print('charge + cost base: ' .. (data.charge + data.cost) )
       -- print('int+ench und luck:' .. ((intelligence+enchantSkill)/5)  + (luck/10))
        print('item exp value: ' .. itemExpValue)
        print('multiplier: ' .. attributeMultiplier )
        
        print("Experience: " .. baseExp)
        print("Experience per Effect: " .. expPerEffect)
        
        for i, effect in ipairs(data.effects) do
            local skill = types.NPC.stats.skills[effect.school](self)
            
            -- Use SkillProgression.skillUsed instead of directly modifying skill.progress
            I.SkillProgression.skillUsed(effect.school, {
                skillGain = expPerEffect
            })

        end
    else
        print("Enchantment type does not grant experience (Constant Effect or Cast Once)")
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