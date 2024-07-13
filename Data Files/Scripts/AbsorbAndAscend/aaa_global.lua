local I = require('openmw.interfaces')
local types = require('openmw.types')
local core = require('openmw.core')

local function getEnchantment(item)
    local record = item.type.record(item)
    if record and record.enchant then
        return core.magic.enchantments.records[record.enchant]
    end
    return nil
end

local function getEnchantmentTypeName(typeNumber)
    local enchantmentTypes = {
        [0] = "Cast Once",
        [1] = "Cast on Strike",
        [2] = "Cast when Used",
        [3] = "Constant Effect"
    }
    return enchantmentTypes[typeNumber] or "Unknown"
end

local function printMagicEffects(effects)
    for i, effect in ipairs(effects) do
        local magicEffect = core.magic.effects.records[effect.id]
        print(string.format("  Effect %d: %s", i, effect.id))
        print(string.format("    School: %s", magicEffect.school)) -- already provides the school full name
        print(string.format("    Magnitude: %d - %d", effect.magnitudeMin, effect.magnitudeMax))
        print(string.format("    Duration: %d", effect.duration))
        print(string.format("    Area: %d", effect.area))
        if effect.affectedAttribute then
            print(string.format("    Affected Attribute: %s", effect.affectedAttribute))
        end
        if effect.affectedSkill then
            print(string.format("    Affected Skill: %s", effect.affectedSkill))
        end
    end
end

local function handleItemUsage(item, actor)
    local itemType = item.type
    local itemRecord = itemType.record(item)
    local itemName = itemRecord.name

    print("Item used: " .. itemName .. " (Type: " .. tostring(itemType) .. ")")

    local enchantment = getEnchantment(item)
    if enchantment then
        print("Enchanting...!")
        print("Enchantment ID: " .. tostring(enchantment.id))
        print("Enchantment Type: " .. getEnchantmentTypeName(enchantment.type))
        print("Total Charge: " .. tostring(enchantment.charge))
        print("Cost: " .. tostring(enchantment.cost))
        print("Auto Calculate: " .. tostring(enchantment.autocalcFlag))
        print("Magic Effects:")
        printMagicEffects(enchantment.effects)
    end
end

-- Add handlers for Weapons, Armors, and Clothing
I.ItemUsage.addHandlerForType(types.Weapon, handleItemUsage)
I.ItemUsage.addHandlerForType(types.Armor, handleItemUsage)
I.ItemUsage.addHandlerForType(types.Clothing, handleItemUsage)