local I = require('openmw.interfaces')
local types = require('openmw.types')
local core = require('openmw.core')

local activationPressed = false

local function onActivationStateChanged(data)
    activationPressed = data.pressed
    print("Activation state changed: " .. tostring(activationPressed))
end

local function handleItemUsage(item, actor)
    if not I.aaaGlobalUtil.getSettingAAAToggle() then
        return
    end
    
    local itemType = item.type
    local itemRecord = itemType.record(item)
    local itemName = itemRecord.name

    if I.aaaGlobalUtil.isThrownWeaponOrAmmo(item) then
        return  -- Ignore thrown weapons, arrows, and bolts
    end

    if I.aaaGlobalUtil.isItemProtected(itemRecord.id) then
        return
    end    
    
    if not activationPressed then
        return
    end

    local enchantmentInfo = {
        itemName = itemName,
        itemType = tostring(itemType),
    }

    local enchantment = I.aaaGlobalUtil.getEnchantment(item)
    if enchantment then
        if (enchantment.type == 4) then -- ignore scrolls
            return
        end

        enchantmentInfo.enchantmentId = enchantment.id
        enchantmentInfo.enchantmentType = enchantment.type
        enchantmentInfo.charge = enchantment.charge
        enchantmentInfo.cost = enchantment.cost
        enchantmentInfo.effects = {}

        for i, effect in ipairs(enchantment.effects) do
            local magicEffect = core.magic.effects.records[effect.id]
            table.insert(enchantmentInfo.effects, {
                id = effect.id,
                school = magicEffect.school
                --affectedAttribute = effect.affectedAttribute,
                --affectedSkill = effect.affectedSkill
            })
        end
        actor:sendEvent('enchantmentUsed', enchantmentInfo)
        item:remove()
        return false
    end
end

if I.aaaGlobalUtil.getSettingAAAToggle() then
    I.ItemUsage.addHandlerForType(types.Weapon, handleItemUsage)
    I.ItemUsage.addHandlerForType(types.Armor, handleItemUsage)
    I.ItemUsage.addHandlerForType(types.Clothing, handleItemUsage)
end

if I.aaaGlobalUtil.getSettingAAAToggle() then
    return {
        eventHandlers = {
            activationStateChanged = onActivationStateChanged
        }
    }
end