name = 'Auto-Unequip on 1-20% (2026 Update)'
version = '5.91'
description =
    'Client mod. Automatically unequips your magiluminescence upon reaching (1-10)% durability to prevent it from breaking. Feature also applies to similar equippables such as eyebrellas, puffy vests, rain hats, etc.\nalso udpate to An Eye for an Eye Update and Dreadstone set\n\nversion=' .. version
author = 'Kevindevm, John Watson original idea'
forumthread = ''
api_version = 10
dst_compatible = true
client_only_mod = true
dont_starve_compatible = false
reign_of_giants_compatible = true
all_clients_require_mod = false
icon_atlas = 'icon.xml'
icon = 'icon.tex'
server_filter_tags = {}
local boolean = {{
    description = "Yes",
    data = true
}, {
    description = "No",
    data = false
}}

-- 210215 null: original BuildNumConfig() breaks on saving Double click speed for 0.15, 0.4, 0.45, and 0.5 values (they reset to 0)
-- Created an alternative function to handle decimal step values
-- Continue to use original BuildNumConfig() to maintain old functionality
-- Use nullBuildNumConfig() when needing to use float step values
local function nullBuildNumConfig(start_num, end_num, step, percent)
    local num_table = {}
    local iterator = 1
    local suffix = percent and "%" or ""

    local ostart_num, oend_num, ostep -- For storing original parameters if needed
    if step > 0 and step < 1 then -- If step = float between 0 and 1 (IE, Double click speed)
        ostart_num, oend_num, ostep = start_num, end_num, step -- Store the original parameters

        -- Convert floats to integers (only 2 decimal places though)
        start_num = start_num * 100
        end_num = end_num * 100
        step = step * 100
    end

    for i = start_num, end_num, step do -- if step was a non-integer, iterate as integers instead
        local i = ostep and i / 100 or i -- if step was a non-integer, convert i back to a float first

        num_table[iterator] = {
            description = i .. suffix,
            data = percent and i / 100 or i
        } -- original code
        iterator = iterator + 1
    end
    return num_table
end
local function AddHeader(header)
    return {
        label = header,
        name = header:lower():gsub("%s+", "_"), -- convierte a minúsculas y reemplaza espacios por guiones bajos
        options = { {description = "", data = 0} },
        default = 0,
    }
end
local function AddConfig(label, name, options, default, hover)
    return {
        label = label,
        name = name,
        options = options,
        default = default,
        hover = hover or ""
    }
end

configuration_options = {AddHeader("Special Items"),
                         AddConfig("Eye Mask and Shield Of Terror", "MAU_EYE", nullBuildNumConfig(1, 60, 1, "%"), 25,"Will unequip shield & mask of terror when reaching this percent"),
                         AddConfig("Dreadston Set", "MAU_DREADSTONE", nullBuildNumConfig(1, 60, 1, "%"), 5,"Will unequip Dreadston armour when reaching this percent"),
                         AddConfig("Unequip At ", "MAU_unequipPer", nullBuildNumConfig(1, 10, 1, "%"), 4,"other normal items such as Magiluminescence and ITEM LIST BELOW"),
                         AddHeader("Config"),

                         AddConfig("Notify on unequip", "MAU_notif", boolean, true,"your character will speak when an item is unequipped if set true"),
                         AddConfig("Ignore hand slot items", "MAU_hands", boolean, true,"ignore ALL items in hand"),
                         AddConfig("Force retrying unequip", "MAU_force", boolean, true),
                         AddConfig("Debug mode", "debug_mode", boolean, false),
                         
                         AddHeader("Items List"),
                         AddConfig("Include Bee Queen Crown", "MAU_BEEQUEN", boolean, false,"should it be unequipped?"),
                         AddConfig("Include Commander's Helm", "wathgrithr_improvedhat", boolean, false,"should it be unequipped?")}

