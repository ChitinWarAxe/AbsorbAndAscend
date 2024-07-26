local storage = require('openmw.storage')
local types = require('openmw.types')
local core = require('openmw.core')

local settings1 = storage.globalSection('SettingsAbsorbAndAscend1')

local function getSettingAAAToggle()
    return settings1:get("aaaToggle")
end

local function getSettingProtectedItems()
    return settings1:get("aaaProtectedItems")
end

local function isItemProtected(itemRecordId)
    local protectedItems = getSettingProtectedItems()
    return string.find(string.lower(protectedItems), string.lower(itemRecordId)) ~= nil
end

local function isThrownWeaponOrAmmo(item)
    if item.type == types.Weapon then
        local weaponType = types.Weapon.record(item).type
        -- Weapon types: 11 = Thrown, 12 = Arrow, 13 = Bolt
        return weaponType == 11 or weaponType == 12 or weaponType == 13
    end
    return false
end

local function getEnchantment(item)
    local record = item.type.record(item)
    if record and record.enchant then
        return core.magic.enchantments.records[record.enchant]
    end
    return nil
end

return {
    interfaceName = "aaaGlobalUtil",
    interface = {
      getSettingAAAToggle = getSettingAAAToggle,
      isItemProtected = isItemProtected,
      isThrownWeaponOrAmmo = isThrownWeaponOrAmmo,
      getEnchantment = getEnchantment
    }
}