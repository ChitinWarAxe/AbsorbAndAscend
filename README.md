# Absorb & Ascend
Destroy a magic item and absorb it's power!

## Features

This mod enables you to "consume" a magic weapon, armor or clothing item. While in the inventory menu, hold Shift+Alt, then "equip" the magic item. You'll then gain experience based on the magic school(s) of the enchantment. The item is destroyed in the process.

## Notes on the calculation

The experience is calculated as follows:

Item charge/20 + Enchantment cost/2, multiplied with 1 + (((intelligence+enchant)/5 + luck/10)/100)

This calculation is very close to the [“enchantment chance”](https://en.uesp.net/wiki/Morrowind:Enchant#Enchanting_items).

However, the engine interprets gained experience differently based on the magic school. Destruction experience gains are smaller, while experience gain for conjuration is way more impactful.

Also due to how the game engine works, it isnt possible to gain more than one level at once. 

## Compatibility

I noticed some interference with mods that alter the amount of gained experience, like [“Skill Uses Scaled”](https://www.nexusmods.com/morrowind/mods/54267). The script still works, though.