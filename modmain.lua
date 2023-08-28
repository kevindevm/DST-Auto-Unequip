local G = GLOBAL

local cfgNotif = GetModConfigData('MAU_notif')
local cfgForce = GetModConfigData('MAU_force')
local cfgHands = GetModConfigData('MAU_hands')
local cfgEyeItems = GetModConfigData('MAU_EYE')
local cfgDreadstone = GetModConfigData('MAU_DREADSTONE')
local cfgPercent = GetModConfigData('MAU_unequipPer')
local debug_mode = GetModConfigData('debug_mode')
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

local notification = '%s\nauto-unequipped'

local EYEUPDATE = {
    shieldofterror = true,
    eyemaskhat = true

}

local DREADSTONE = {
    armordreadstone = true,
    dreadstonehat = true

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
    orangeamulet = true,
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
    armor_bramble = true,
    cookiecutterhat = true,

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
    armor_lunarplant = true


    -- MODDED Tropical Experience

}

local DebugPrint = debug_mode and function(...)
    local msg = "[Auto Unequip At " .. cfgPercent .. "%]"
    for i = 1, arg.n do
        msg = msg .. " " .. tostring(arg[i])
    end
    print(msg)
end or function() --[[disabled]]
end

local function Unequip(inst)

    if inst.replica.equippable:IsEquipped() then
        G.ThePlayer.replica.inventory:ControllerUseItemOnSelfFromInvTile(inst)
    end

    if cfgForce and not inst.replica.equippable:IsEquipped() and inst.unequiptask ~= nil then
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
        DebugPrint("nada=" .. data.item.prefab)
        return
    end
   if NONREFILLABLE[data.item.prefab] and not DREADSTONE[data.item.prefab] and not EYEUPDATE[data.item.prefab] then 
        DebugPrint("in the list, not a DREADSTONE and not eye item, item=" .. data.item.prefab)
        return
    end

    local durability = math.floor((data.item.components.armor.condition / data.item.components.armor.maxcondition) * 100+0.5)

    if not durabilidadesAnteriores[data.item] then
        durabilidadesAnteriores[data.item] = durability
        DebugPrint("opa")
        return
    end  

    DebugPrint(durability .. " " .. data.eslot .. " " .. data.item.prefab)

end

local function AutoUnequip(inst)
    -- imprimirObjeto(inst)
    local item = inst.entity:GetParent()
    if item.replica.equippable == nil or (not item.replica.inventoryitem:IsHeldBy(G.ThePlayer)) or (not item.replica.equippable:IsEquipped()) and NONREFILLABLE[item.prefab] then
        return
    end
    if NONREFILLABLE[item.prefab] and not DREADSTONE[item.prefab] and not EYEUPDATE[item.prefab] then 
        DebugPrint("in the list, not a DREADSTONE and not eye item, item=" .. item.prefab)
        return
    end


    if not durabilidadesAnteriores[inst] then
        durabilidadesAnteriores[inst] = inst.percentused:value()
        DebugPrint("asdasd")
        return
    end  
    local Cur_Percent = inst.percentused:value()

    if durabilidadesAnteriores[inst] and Cur_Percent>durabilidadesAnteriores[inst] then
        DebugPrint("previous=" .. durabilidadesAnteriores[inst] .. " now=" .. Cur_Percent .. " so its going up")
        return
    else 
        DebugPrint("previous=" .. durabilidadesAnteriores[inst] .. " now=" .. Cur_Percent .. " so its going down")
        -- DebugPrint("going down")
    end



    durabilidadesAnteriores[inst] = Cur_Percent
    local slot = item.replica.equippable:EquipSlot()
    local shouldbe = false
    local reason = "none"

    if shouldbe == false then
        shouldbe = not (cfgHands and slot ~= G.EQUIPSLOTS.HANDS and not NONREFILLABLE[item.prefab]) or false
        reason = "WILL UNIQUIP HAND"
    end
    if shouldbe == false then
        shouldbe = cfgEyeItems and EYEUPDATE[item.prefab] or false
        reason = "(EYE) unequip at=" .. tostring(cfgEyeItems)
    end
    if shouldbe == false then
        shouldbe = cfgDreadstone and DREADSTONE[item.prefab] or false
        reason = "(DREADSTONE) unequip at=" .. tostring(cfgDreadstone)
    end
    if shouldbe == false then
        shouldbe = not NONREFILLABLE[item.prefab] or false
        reason = "NOT hardcode, unequip at=" .. tostring(cfgPercent)
    end

    DebugPrint("(1/3) i=" .. item.prefab .. " p=" .. Cur_Percent .. "% s=" .. slot)
    DebugPrint("(2/3) should unequip? :" .. tostring(shouldbe) .. " reason=" .. reason)

    DebugPrint("(3/3) EYE=" .. tostring(cfgEyeItems) .. "% DREAD=" .. tostring(cfgDreadstone) .. "% NORMAL=" ..
                   tostring(cfgPercent) .. "%")

    if (cfgHands and slot == G.EQUIPSLOTS.HANDS) or (NONREFILLABLE[item.prefab]) or
        (cfgDreadstone and DREADSTONE[item.prefab] and Cur_Percent > cfgEyeItems) or (cfgDreadstone and DREADSTONE[item.prefab] and Cur_Percent > cfgDreadstone) or
        (not EYEUPDATE[item.prefab] and not DREADSTONE[item.prefab] and Cur_Percent > cfgPercent) then
        return
    end

    if EYEUPDATE[item.prefab] then
        if Cur_Percent > cfgEyeItems then
            return
        end
    end
    if DREADSTONE[item.prefab] then
        if Cur_Percent > cfgDreadstone then
            return
        end
    end

    if not NONREFILLABLE[item.prefab] and not DREADSTONE[item.prefab] and not EYEUPDATE[item.prefab] then
        if Cur_Percent > cfgPercent then
            return
        end
    end

    DebugPrint("Unequiping=" .. item.prefab .. " slot=" .. slot .. " at=" .. Cur_Percent)
    if cfgForce then
        item.unequiptask = item:DoPeriodicTask(0, function()
            Unequip(item)
        end)
    end

    Unequip(item)

    if cfgNotif and G.ThePlayer.components.talker then
        G.ThePlayer.components.talker:Say(notification:format(item.name or slot .. ' slot item'))
    end

end


local function PostInit(inst)

    local item = inst.entity:GetParent()


    if item == nil or item.replica.equippable == nil then
        return
    end

    inst:ListenForEvent('percentuseddirty', function()
        AutoUnequip(inst)
    end)

end


AddComponentPostInit("playercontroller", function(self)
    if self.inst ~= GLOBAL.ThePlayer then
        return
    end
    -- self.inst:ListenForEvent("equip", checkEquip)
    self.inst:ListenForEvent("equip", checkEquip)

end)

AddPrefabPostInit('inventoryitem_classified', function(inst)
    if not G.TheNet:IsDedicated() then
        inst:DoTaskInTime(0, function()
            PostInit(inst)
        end)
    end
end)