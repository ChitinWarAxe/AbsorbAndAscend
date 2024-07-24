local self = require('openmw.self')
local core = require('openmw.core')
local types = require('openmw.types')
local input = require('openmw.input')
local I = require('openmw.interfaces')
local f = require('scripts.absorbandascend.aaa_func_player')

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

local function progressSkill(skill, xp)
    I.SkillProgression.skillUsed(skill, {
        skillGain = xp,
        useType = 0
    })
end

local function calculateAndApplyExperience(data)

    print("calculateAndApplyExperience!")

    local itemXP = f.getItemXP(data)
    local absorbSuccess = true

    if f.getSettingFailToggle() then
    
        print("check for success!")
    
        absorbSuccess = f.checkAbsorbSuccess(itemXP)
        if absorbSuccess == false then
            f.itemAbsorbFailAlert(data.itemName)
        end
    end
    
    if absorbSuccess then
    
        print("absorb will succeed.")
    
        local modifiedXP = f.getModifiedXP(itemXP)
    
        if modifiedXP ~= 0 then
        
            print("xp was modified!")
            
            local xpPerEffect = modifiedXP / #data.effects
            
            -- print("Experience per Effect: " .. xpPerEffect)
            
            for i, effect in ipairs(data.effects) do
    
                local roundedExp = math.floor(xpPerEffect)
                
                for j = 1, roundedExp do progressSkill(effect.school, 1) end
                
                progressSkill('enchant', 1)
                    
            end
            
            f.itemAbsorbSuccessAlert(data.itemName)
            
        end        
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

