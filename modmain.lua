local G = GLOBAL
-- c_spawn("hivehat").components.armor:SetPercent(0.1) //remote
-- local item = c_spawn("armorslurper")
-- ThePlayer.components.inventory:GiveItem(item)
-- item.components.armor:SetPercent(0.02)
local cfgNotif = GetModConfigData("MAU_notif")
local cfgForce = GetModConfigData("MAU_force")
local cfgHands = GetModConfigData("MAU_hands")
local cfgEyeItems = GetModConfigData("MAU_EYE")
local cfgDreadstone = GetModConfigData("MAU_DREADSTONE")
local incBeeQueen = GetModConfigData("MAU_BEEQUEN")
local wathgrithr_improvedhat = GetModConfigData("wathgrithr_improvedhat")
local cfgPercent = GetModConfigData("MAU_unequipPer")
local debug_mode = GetModConfigData("debug_mode")
local durabilidadesAnteriores = {}

if cfgEyeItems < 1 and cfgPercent ~= false then
    cfgEyeItems = cfgEyeItems * 100
end
if cfgDreadstone < 1 and cfgPercent ~= false then
    cfgDreadstone = cfgDreadstone * 100
end

if cfgPercent < 1 then
    cfgPercent = cfgPercent * 100
end

local notification = "%s\nauto-unequipped"

local EYEUPDATE = {
    shieldofterror = true,
    eyemaskhat = true
}

local DREADSTONE = {
    armordreadstone = true,
    dreadstonehat = true,
    shadow_battleaxe = true
}

local NONREFILLABLE = {
    armor_sanity = true,
    armordragonfly = true,
    armorgrass = true,
    armormarble = true,
    armorruins = true,
    armorskeleton = true,
    armorsnurtleshell = true,
    armorwood = true,
    beehat = true,
    blue_mushroomhat = true,
    blueamulet = true,
    bushhat = true,
    flowerhat = true,
    footballhat = true,
    green_mushroomhat = true,
    greenamulet = true,
    hawaiianshirt = true,
    minerhat = true,
    onemanband = true,
    purpleamulet = true,
    red_mushroomhat = true,
    ruinshat = true,
    sansundertalehat = true,
    slurper = true,
    slurtlehat = true,
    spiderhat = true,
    watermelonhat = true,
    wathgrithrhat = true,
    -- VANILLA UNREPAIRABLES
    hivehat = not incBeeQueen,
    wathgrithr_improvedhat = not wathgrithr_improvedhat,
    armor_bramble = true,
    cookiecutterhat = true,
    armorwagpunk = true,
    wagpunkhat = true,
    -- MODDED UNREPAIRABLES
    armor_rock = true,
    gear_wings = true,
    hat_marble = true,
    hat_rock = true,
    -- MODDED UNBREAKABLES
    candlehat = true,
    axe = true,
    batbat = true,
    brush = true,
    glasscutter = true,
    golden_farm_hoe = true,
    goldenaxe = true,
    goldenpickaxe = true,
    goldenshovel = true,
    hammer = true,
    lighter = true,
    bernie_inactive = true,
    minifan = true,
    malbatross_beak = true,
    moonglassaxe = true,
    multitool_axe_pickaxe = true,
    nightstick = true,
    nightsword = true,
    oar = true,
    oar_driftwood = true,
    pitchfork = true,
    ruins_bat = true,
    spear = true,
    spear_wathgrithr = true,
    tentaclespike = true,
    torch = true,
    trident = true,
    whip = true,
    -- VANILLA UNBREAKABLES
    lantern = true,
    premiumwateringcan = true,
    wateringcan = true,
    pocketwatch_weapon = true,
    -- MODDED UNREPAIRABLES https://steamcommunity.com/workshop/filedetails/discussion/1581892848/1741103267263389256/
    dark_axe = true,
    dark_pickaxe = true,
    fryingpan = true,
    mace_sting = true,
    sword_rock = true,
    armor_iron = true,
    armor_gold = true,
    armor_seashell = true,
    armor_obsidian = true,
    armor_limestone = true,
    armor_cactus = true,
    armor_stone = true,
    armor_bone = true,
    armor_cobalt = true,
    armor_tungsten = true,
    armormosquito = true,
    geararmor = true,
    armor_my = true,
    armor_bluegem = true,
    armor_redgem = true,
    armor_purplegem = true,
    armor_greengem = true,
    armor_orangegem = true,
    armor_yellowgem = true,
    armor_whitegem = true,
    armor_opalgem = true,
    hat_wood = true,
    hat_ox = true,
    oxhat = true,
    ruinsNhat = true,
    helmet_iron = true,
    helmet_cobalt = true,
    gear_helmet = true,
    bucket_helmet = true,
    tungsten_hardhat = true,
    spartahelmut = true,
    birchnuthat = true,
    wathgrithrhat_f_common = true,
    footballhat_festive = true,
    bonehat = true,
    dragonhat = true,
    dragonarmor = true,
    spiderarmor = true,
    toothhat = true,
    goldarmor = true,
    goldhelm = true,
    nightswatchcloak = true,
    -- MODDED UNBREAKABLES
    bottlelantern = true,
    broomstick = true,
    elegantlantern = true,
    opulentlantern = true,
    scythe = true,
    snowglobe = true,
    -- From Beyond

    staff_lunarplant = true,
    shovel_lunarplant = true,
    sword_lunarplant = true,
    pickaxe_lunarplant = true,
    lunarplanthat = true,
    armor_lunarplant = true,
    armor_voidcloth = true,
    voidclothhat = true,
    voidcloth_umbrella = true,
    voidcloth_scythe = true

    -- MODDED Tropical Experience
}

local DebugPrint = debug_mode and function(...)
        local msg = ""
        for i = 1, arg.n do
            msg = msg .. " " .. tostring(arg[i])
        end
        print(msg)
    end or function()
        --[[disabled]]
    end

local function Unequip(inst)
    if not (inst and inst.replica and inst.replica.equippable) then
        return
    end

    local equip = inst.replica.equippable

    if equip:IsEquipped() then
        G.ThePlayer.replica.inventory:ControllerUseItemOnSelfFromInvTile(inst)
    end

    if cfgForce and not equip:IsEquipped() and inst.unequiptask ~= nil then
        inst.unequiptask:Cancel()
        inst.unequiptask = nil
    end
end

local function imprimirObjeto(objeto, nivel)
    nivel = nivel or 0
    local indentacion = string.rep("  ", nivel)
    for clave, valor in pairs(objeto) do
        if type(valor) == "table" then
            print(indentacion .. tostring(clave) .. ":")
            imprimirObjeto(valor, nivel + 1)
        else
            print(indentacion .. tostring(clave) .. ": " .. tostring(valor))
        end
    end
end
local function print_data(data) --for debugging
    if type(data) ~= "table" then
        print(data, "is not a table.")
        return
    end
    for k, v in pairs(data) do
        print(k, v)
    end
end

local function checkEquip(inst, data)
    if not (type(data) == "table" and data.eslot and data.item and data.item.components and data.item.components.armor) then
        DebugPrint("[AutoUnequip] Invalid equipment data")
        DebugPrint("[AutoUnequip] Item prefab: " .. tostring(data.item and data.item.prefab))
        return
    end

    if NONREFILLABLE[data.item.prefab] and not DREADSTONE[data.item.prefab] and not EYEUPDATE[data.item.prefab] then
        DebugPrint("[AutoUnequip] Skipping non-refillable item: " .. data.item.prefab)
        return
    end

    local durability =
        math.floor((data.item.components.armor.condition / data.item.components.armor.maxcondition) * 100 + 0.5)

    if not durabilidadesAnteriores[data.item] then
        durabilidadesAnteriores[data.item] = durability
        DebugPrint("[AutoUnequip] Tracking new item: " .. data.item.prefab .. " at " .. durability .. "%")
        return
    end

    DebugPrint(
        "[AutoUnequip] Durability: " .. durability .. "% | Slot: " .. data.eslot .. " | Item: " .. data.item.prefab
    )
end

local function AutoUnequip(inst)
    -- imprimirObjeto(inst)
    local item = inst.entity:GetParent()

    if item.replica.equippable == nil then
        return
    end

    if not item.replica.inventoryitem:IsHeldBy(G.ThePlayer) then
        return
    end

    if not item.replica.equippable:IsEquipped() then
        return
    end

    if NONREFILLABLE[item.prefab] and not DREADSTONE[item.prefab] and not EYEUPDATE[item.prefab] then
        DebugPrint("[AutoUnequip] Skipping hardcoded non-refillable item: " .. item.prefab)
        return
    end

    if not durabilidadesAnteriores[inst] then
        durabilidadesAnteriores[inst] = inst.percentused:value()
        DebugPrint(
            "[AutoUnequip] Initial durability set for: " ..
                item.prefab .. " at " .. durabilidadesAnteriores[inst] .. "%"
        )
        return
    end

    local Cur_Percent = inst.percentused:value()

    if durabilidadesAnteriores[inst] and Cur_Percent > durabilidadesAnteriores[inst] then
        DebugPrint(
            "[AutoUnequip] Durability increased: " .. durabilidadesAnteriores[inst] .. "% → " .. Cur_Percent .. "%"
        )
        durabilidadesAnteriores[inst] = Cur_Percent
        return
    else
        DebugPrint(
            "[AutoUnequip] Durability decreased: " .. durabilidadesAnteriores[inst] .. "% → " .. Cur_Percent .. "%"
        )
    end

    durabilidadesAnteriores[inst] = Cur_Percent
    local slot = item.replica.equippable:EquipSlot()
    local shouldbe = false
    local reason = "none"

    -- Evaluación de condiciones
    if shouldbe == false then
        shouldbe = not (cfgHands and slot ~= G.EQUIPSLOTS.HANDS and not NONREFILLABLE[item.prefab]) or false
        reason = "Hand slot protection"
    end
    if shouldbe == false then
        shouldbe = cfgEyeItems and EYEUPDATE[item.prefab] or false
        reason = "Eye item check"
    end
    if shouldbe == false then
        shouldbe = cfgDreadstone and DREADSTONE[item.prefab] or false
        reason = "Dreadstone check"
    end
    if shouldbe == false then
        shouldbe = not NONREFILLABLE[item.prefab] or false
        reason = "Normal item check"
    end

    -- Información de debug
    DebugPrint("[AutoUnequip] ──────────────────────────────")
    DebugPrint("[AutoUnequip] Item: " .. item.prefab .. " | Durability: " .. Cur_Percent .. "% | Slot: " .. slot)
    DebugPrint("[AutoUnequip] Unequip evaluation: " .. tostring(shouldbe) .. " | Reason: " .. reason)
    DebugPrint(
        "[AutoUnequip] Settings → Eye: " ..
            tostring(cfgEyeItems) ..
                "% | Dreadstone: " .. tostring(cfgDreadstone) .. "% | Normal: " .. tostring(cfgPercent) .. "%"
    )
    DebugPrint("[AutoUnequip] ──────────────────────────────")

    -- Verificaciones de porcentaje mínimo
    if
        (cfgHands and slot == G.EQUIPSLOTS.HANDS) or
            (not EYEUPDATE[item.prefab] and not DREADSTONE[item.prefab] and Cur_Percent > cfgPercent)
     then
        DebugPrint("[AutoUnequip] Keeping item equipped - above threshold")
        return
    end

    if EYEUPDATE[item.prefab] then
        if Cur_Percent > cfgEyeItems then
            DebugPrint("[AutoUnequip] Eye item above threshold: " .. Cur_Percent .. "% > " .. cfgEyeItems .. "%")
            return
        end
    end

    if DREADSTONE[item.prefab] then
        if Cur_Percent > cfgDreadstone then
            DebugPrint("[AutoUnequip] Dreadstone above threshold: " .. Cur_Percent .. "% > " .. cfgDreadstone .. "%")
            return
        end
    end

    if not NONREFILLABLE[item.prefab] and not DREADSTONE[item.prefab] and not EYEUPDATE[item.prefab] then
        if Cur_Percent > cfgPercent then
            DebugPrint("[AutoUnequip] Normal item above threshold: " .. Cur_Percent .. "% > " .. cfgPercent .. "%")
            return
        end
    end

    -- Acción de desequipar
    DebugPrint("[AutoUnequip] Unequipping: " .. item.prefab .. " (Slot: " .. slot .. ") at " .. Cur_Percent .. "%")

    if cfgForce then
        item.unequiptask =
            item:DoPeriodicTask(
            0,
            function()
                Unequip(item)
            end
        )
    end

    Unequip(item)

    if cfgNotif and G.ThePlayer.components.talker then
        G.ThePlayer.components.talker:Say(notification:format(item.name or slot .. " slot item"))
    end
end

local function PostInit(inst)
    local item = inst.entity:GetParent()

    if item == nil or item.replica.equippable == nil then
        return
    end

    inst:ListenForEvent(
        "percentuseddirty",
        function()
            AutoUnequip(inst)
        end
    )
end

AddComponentPostInit(
    "playercontroller",
    function(self)
        if self.inst ~= GLOBAL.ThePlayer then
            return
        end
        -- self.inst:ListenForEvent("equip", checkEquip)
        self.inst:ListenForEvent("equip", checkEquip)
    end
)

AddPrefabPostInit(
    "inventoryitem_classified",
    function(inst)
        if not G.TheNet:IsDedicated() then
            inst:DoTaskInTime(
                0,
                function()
                    PostInit(inst)
                end
            )
        end
    end
)
