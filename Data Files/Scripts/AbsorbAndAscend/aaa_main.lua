local self = require('openmw.self')
local core = require('openmw.core')
local types = require('openmw.types')
local ui = require('openmw.ui')

print("Local script loaded!") -- Debug message

local function printEnchantmentInfo(data)
    print("Received enchantmentUsed event") -- Debug message
    print("Item used: " .. data.itemName .. " (Type: " .. data.itemType .. ")")
    
    if data.enchantmentId then
        print("Enchanting...!")
        print("Enchantment ID: " .. tostring(data.enchantmentId))
        print("Enchantment Type: " .. tostring(data.enchantmentType))
        print("Total Charge: " .. tostring(data.charge))
        print("Cost: " .. tostring(data.cost))
        print("Auto Calculate: " .. tostring(data.autocalcFlag))
        print("Magic Effects:")
        
        for i, effect in ipairs(data.effects) do
            print(string.format("  Effect %d: %s", i, effect.id))
            print(string.format("    School: %s", tostring(effect.school)))
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

    local enchantSkill = types.NPC.stats.skills.enchant(self).modified
    print("Player's Enchant Skill: " .. tostring(enchantSkill))
end

return {
    eventHandlers = {
        enchantmentUsed = printEnchantmentInfo
    }
}