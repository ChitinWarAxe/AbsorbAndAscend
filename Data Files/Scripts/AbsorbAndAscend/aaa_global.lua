local I = require('openmw.interfaces')
local types = require('openmw.types')
local core = require('openmw.core')
local aaaFunc = require('scripts.absorbandascend.aaa_func')

local activationPressed = false

local function getEnchantment(item)
    local record = item.type.record(item)
    if record and record.enchant then
        return core.magic.enchantments.records[record.enchant]
    end
    return nil
end

local function isThrownWeaponOrAmmo(item)
    if item.type == types.Weapon then
        local weaponType = types.Weapon.record(item).type
        -- Weapon types: 11 = Thrown, 12 = Arrow, 13 = Bolt
        return weaponType == 11 or weaponType == 12 or weaponType == 13
    end
    return false
end

local function handleItemUsage(item, actor)
    if not getSettingAAAToggle() then
        return
    end
    
    local itemType = item.type
    local itemRecord = itemType.record(item)
    local itemName = itemRecord.name

    if isItemProtected(itemRecord.id) then
        return
    end    
    
    if not activationPressed then
        return
    end

    if isThrownWeaponOrAmmo(item) then
        return  -- Ignore thrown weapons, arrows, and bolts
    end

    local enchantmentInfo = {
        itemName = itemName,
        itemType = tostring(itemType),
    }

    local enchantment = getEnchantment(item)
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
                school = magicEffect.school,
                magnitudeMin = effect.magnitudeMin,
                magnitudeMax = effect.magnitudeMax,
                duration = effect.duration,
                area = effect.area,
                affectedAttribute = effect.affectedAttribute,
                affectedSkill = effect.affectedSkill
            })
        end
        actor:sendEvent('enchantmentUsed', enchantmentInfo)
        item:remove()
        return false
    end
end

if getSettingAAAToggle() then
    I.ItemUsage.addHandlerForType(types.Weapon, handleItemUsage)
    I.ItemUsage.addHandlerForType(types.Armor, handleItemUsage)
    I.ItemUsage.addHandlerForType(types.Clothing, handleItemUsage)
end

local function onActivationStateChanged(data)
    activationPressed = data.pressed
    -- print("Activation state changed: " .. tostring(activationPressed))
end

if getSettingAAAToggle() then
    return {
        eventHandlers = {
            activationStateChanged = onActivationStateChanged
        }
    }
end