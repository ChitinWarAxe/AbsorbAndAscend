local I = require('openmw.interfaces')
local types = require('openmw.types')
local core = require('openmw.core')

print("Global script loaded!") -- Debug message

local function getEnchantment(item)
    local record = item.type.record(item)
    if record and record.enchant then
        return core.magic.enchantments.records[record.enchant]
    end
    return nil
end

local function handleItemUsage(item, actor)
    print("Item usage detected!") -- Debug message
    
    -- Check if the actor is the player
    --local player = nearby.getPlayer()

    local itemType = item.type
    local itemRecord = itemType.record(item)
    local itemName = itemRecord.name

    local enchantmentInfo = {
        itemName = itemName,
        itemType = tostring(itemType),
    }

    local enchantment = getEnchantment(item)
    if enchantment then
        print("Enchanted item detected!") -- Debug message
        enchantmentInfo.enchantmentId = enchantment.id
        enchantmentInfo.enchantmentType = enchantment.type
        enchantmentInfo.charge = enchantment.charge
        enchantmentInfo.cost = enchantment.cost
        enchantmentInfo.autocalcFlag = enchantment.autocalcFlag
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
        print("Sent enchantmentUsed event to player") -- Debug message
    else
        print("Item is not enchanted") -- Debug message
    end
end

-- Add handlers for Weapons, Armors, and Clothing
I.ItemUsage.addHandlerForType(types.Weapon, handleItemUsage)
I.ItemUsage.addHandlerForType(types.Armor, handleItemUsage)
I.ItemUsage.addHandlerForType(types.Clothing, handleItemUsage)

