local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local lib_characters = require("solylib.characters")
local lib_unitxt = require("solylib.unitxt")
local cfg = require("Monster Reader.configuration")
local cfgMonsters = require("Monster Reader.monsters")
local optionsLoaded, options = pcall(require, "Monster Reader.options")

local optionsFileName = "addons/Monster Reader/options.lua"
local firstPresent = true
local ConfigurationWindow

if optionsLoaded then
    -- If options loaded, make sure we have all those we need
    options.configurationEnableWindow = lib_helpers.NotNilOrDefault(options.configurationEnableWindow, true)
    options.enable                    = lib_helpers.NotNilOrDefault(options.enable, true)
    options.fontScale                 = lib_helpers.NotNilOrDefault(options.fontScale, 1.0)
    options.invertMonsterList         = lib_helpers.NotNilOrDefault(options.invertMonsterList, false)
    options.showCurrentRoomOnly       = lib_helpers.NotNilOrDefault(options.showCurrentRoomOnly, false)
    options.showMonsterStatus         = lib_helpers.NotNilOrDefault(options.showMonsterStatus, false)
    options.showMonsterID             = lib_helpers.NotNilOrDefault(options.showMonsterID, false)

    options.mhpEnableWindow      = lib_helpers.NotNilOrDefault(options.mhpEnableWindow, true)
    options.mhpChanged           = lib_helpers.NotNilOrDefault(options.mhpChanged, false)
    options.mhpAnchor            = lib_helpers.NotNilOrDefault(options.mhpAnchor, 1)
    options.mhpX                 = lib_helpers.NotNilOrDefault(options.mhpX, 50)
    options.mhpY                 = lib_helpers.NotNilOrDefault(options.mhpY, 50)
    options.mhpW                 = lib_helpers.NotNilOrDefault(options.mhpW, 450)
    options.mhpH                 = lib_helpers.NotNilOrDefault(options.mhpH, 350)
    options.mhpNoTitleBar        = lib_helpers.NotNilOrDefault(options.mhpNoTitleBar, "")
    options.mhpNoResize          = lib_helpers.NotNilOrDefault(options.mhpNoResize, "")
    options.mhpNoMove            = lib_helpers.NotNilOrDefault(options.mhpNoMove, "")
    options.mhpTransparentWindow = lib_helpers.NotNilOrDefault(options.mhpTransparentWindow, false)

    options.targetEnableWindow      = lib_helpers.NotNilOrDefault(options.targetEnableWindow, true)
    options.targetChanged           = lib_helpers.NotNilOrDefault(options.targetChanged, false)
    options.targetAnchor            = lib_helpers.NotNilOrDefault(options.targetAnchor, 3)
    options.targetX                 = lib_helpers.NotNilOrDefault(options.targetX, 150)
    options.targetY                 = lib_helpers.NotNilOrDefault(options.targetY, -45)
    options.targetW                 = lib_helpers.NotNilOrDefault(options.targetW, 120)
    options.targetH                 = lib_helpers.NotNilOrDefault(options.targetH, 85)
    options.targetNoTitleBar        = lib_helpers.NotNilOrDefault(options.targetNoTitleBar, "NoTitleBar")
    options.targetNoResize          = lib_helpers.NotNilOrDefault(options.targetNoResize, "NoResize")
    options.targetNoMove            = lib_helpers.NotNilOrDefault(options.targetNoMove, "NoMove")
    options.targetNoScrollbar       = lib_helpers.NotNilOrDefault(options.targetNoScrollbar, "NoScrollbar")
    options.targetTransparentWindow = lib_helpers.NotNilOrDefault(options.targetTransparentWindow, false)
else
    options = 
    {
        configurationEnableWindow = true,
        enable = true,
        fontScale = 1.0,
        invertMonsterList = false,
        showCurrentRoomOnly = false,
        showMonsterStatus = false,
        showMonsterID = false,

        mhpEnableWindow = true,
        mhpChanged = false,
        mhpAnchor = 1,
        mhpX = 50,
        mhpY = 50,
        mhpW = 450,
        mhpH = 350,
        mhpNoTitleBar = "",
        mhpNoResize = "",
        mhpNoMove = "",
        mhpTransparentWindow = false,

        targetEnableWindow = true,
        targetChanged = false,
        targetAnchor = 3,
        targetX = 150,
        targetY = -45,
        targetW = 120,
        targetH = 85,
        targetNoTitleBar = "NoTitleBar",
        targetNoResize = "NoResize",
        targetNoMove = "NoMove",
        targetNoScrollbar = "NoScrollbar",
        targetTransparentWindow = false,
    }
end

local function SaveOptions(options)
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)

        io.write("return\n")
        io.write("{\n")
        io.write(string.format("    configurationEnableWindow = %s,\n", tostring(options.configurationEnableWindow)))
        io.write(string.format("    enable = %s,\n", tostring(options.enable)))
        io.write(string.format("    fontScale = %s,\n", tostring(options.fontScale)))
        io.write(string.format("    invertMonsterList = %s,\n", tostring(options.invertMonsterList)))
        io.write(string.format("    showCurrentRoomOnly = %s,\n", tostring(options.showCurrentRoomOnly)))
        io.write(string.format("    showMonsterStatus = %s,\n", tostring(options.showMonsterStatus)))
        io.write(string.format("    showMonsterID = %s,\n", tostring(options.showMonsterID)))
        io.write("\n")
        io.write(string.format("    mhpEnableWindow = %s,\n", tostring(options.mhpEnableWindow)))
        io.write(string.format("    mhpChanged = %s,\n", tostring(options.mhpChanged)))
        io.write(string.format("    mhpAnchor = %i,\n", options.mhpAnchor))
        io.write(string.format("    mhpX = %i,\n", options.mhpX))
        io.write(string.format("    mhpY = %i,\n", options.mhpY))
        io.write(string.format("    mhpW = %i,\n", options.mhpW))
        io.write(string.format("    mhpH = %i,\n", options.mhpH))
        io.write(string.format("    mhpNoTitleBar = \"%s\",\n", options.mhpNoTitleBar))
        io.write(string.format("    mhpNoResize = \"%s\",\n", options.mhpNoResize))
        io.write(string.format("    mhpNoMove = \"%s\",\n", options.mhpNoMove))
        io.write(string.format("    mhpTransparentWindow = %s,\n", tostring(options.mhpTransparentWindow)))
        io.write("\n")
        io.write(string.format("    targetEnableWindow = %s,\n", tostring(options.targetEnableWindow)))
        io.write(string.format("    targetChanged = %s,\n", tostring(options.targetChanged)))
        io.write(string.format("    targetAnchor = %i,\n", options.targetAnchor))
        io.write(string.format("    targetX = %i,\n", options.targetX))
        io.write(string.format("    targetY = %i,\n", options.targetY))
        io.write(string.format("    targetW = %i,\n", options.targetW))
        io.write(string.format("    targetH = %i,\n", options.targetH))
        io.write(string.format("    targetNoTitleBar = \"%s\",\n", options.targetNoTitleBar))
        io.write(string.format("    targetNoResize = \"%s\",\n", options.targetNoResize))
        io.write(string.format("    targetNoMove = \"%s\",\n", options.targetNoMove))
        io.write(string.format("    targetNoScrollbar = \"%s\",\n", options.targetNoScrollbar))
        io.write(string.format("    targetTransparentWindow = %s,\n", tostring(options.targetTransparentWindow)))
        io.write("}\n")

        io.close(file)
    end
end

local _PlayerArray = 0x00A94254
local _PlayerIndex = 0x00A9C4F4
local _PlayerCount = 0x00AAE168
local _Difficulty = 0x00A9CD68
local _Ultimate

local _ID = 0x1C
local _Room = 0x28
local _Room2 = 0x2E
local _PosX = 0x38
local _PosY = 0x3C
local _PosZ = 0x40

local _targetPointerOffset = 0x18
local _targetOffset = 0x108C

local _EntityCount = 0x00AAE164
local _EntityArray = 0x00AAD720

local _MonsterUnitxtID = 0x378
local _MonsterHP = 0x334
local _MonsterHPMax = 0x2BC

-- Special addresses for De Rol Le
local _BPDeRolLeData = 0x00A43CC8
local _MonsterDeRolLeHP = 0x6B4
local _MonsterDeRolLeHPMax = 0x6B0
local _MonsterDeRolLeSkullHP = 0x6B8
local _MonsterDeRolLeSkullHPMax = 0x20
local _MonsterDeRolLeShellHP = 0x39C
local _MonsterDeRolLeShellHPMax = 0x1C

-- Special addresses for Barba Ray
local _BPBarbaRayData = 0x00A43CC8
local _MonsterBarbaRayHP = 0x704
local _MonsterBarbaRayHPMax = 0x700
local _MonsterBarbaRaySkullHP = 0x708
local _MonsterBarbaRaySkullHPMax = 0x20
local _MonsterBarbaRayShellHP = 0x7AC
local _MonsterBarbaRayShellHPMax = 0x1C

-- Special code pointer for Dubwitch
local _DubwitchObjectCode = 0x00B267C0

-- Special code pointer for Darvant
local _DarvantObjectCode = 0x00AF7D60

local function CopyMonster(monster)
    local copy = {}

    copy.address  = monster.address
    copy.index    = monster.index
    copy.id       = monster.id
    copy.room     = monster.room
    copy.posX     = monster.posX
    copy.posY     = monster.posY
    copy.posZ     = monster.posZ
    copy.unitxtID = monster.unitxtID
    copy.HP       = monster.HP
    copy.HPMax    = monster.HPMax
    copy.HP2      = monster.HP2
    copy.HP2Max   = monster.HP2Max
    copy.name     = monster.name
    copy.color    = monster.color
    copy.display  = monster.display

    return copy
end

local function GetMonsterDataDeRolLe(monster)
    local maxDataPtr = pso.read_u32(_BPDeRolLeData)
    local skullMaxHP = 0
    local shellMaxHP = 0
    local newName = monster.name

    if maxDataPtr ~= 0 then
        skullMaxHP = pso.read_u32(maxDataPtr + _MonsterDeRolLeSkullHPMax)
        shellMaxHP = pso.read_u32(maxDataPtr + _MonsterDeRolLeShellHPMax)
    end

    if monster.index == 0 then
        monster.HP = pso.read_u32(monster.address + _MonsterDeRolLeHP)
        monster.HPMax = pso.read_u32(monster.address + _MonsterDeRolLeHPMax)

        monster.HP2 = pso.read_u32(monster.address + _MonsterDeRolLeSkullHP)
        monster.HP2Max = skullMaxHP
    else
        monster.HP = pso.read_u32(monster.address + _MonsterDeRolLeShellHP)
        monster.HPMax = shellMaxHP
        monster.name = monster.name .. " Shell"
    end

    return monster
end

local function GetMonsterDataBarbaRay(monster)
    local maxDataPtr = pso.read_u32(_BPBarbaRayData)
    local skullMaxHP = 0
    local shellMaxHP = 0
    local newName = monster.name

    if maxDataPtr ~= 0 then
        skullMaxHP = pso.read_u32(maxDataPtr + _MonsterBarbaRaySkullHPMax)
        shellMaxHP = pso.read_u32(maxDataPtr + _MonsterBarbaRayShellHPMax)
    end

    if monster.index == 0 then
        monster.HP = pso.read_u32(monster.address + _MonsterBarbaRayHP)
        monster.HPMax = pso.read_u32(monster.address + _MonsterBarbaRayHPMax)

        monster.HP2 = pso.read_u32(monster.address + _MonsterBarbaRaySkullHP)
        monster.HP2Max = skullMaxHP
    else
        monster.HP = pso.read_u32(monster.address + _MonsterBarbaRayShellHP)
        monster.HPMax = shellMaxHP
        monster.name = monster.name .. " Shell"
    end

    return monster
end

local function GetMonsterData(monster)
    monster.code = pso.read_u32(monster.address)
    monster.id = pso.read_u16(monster.address + _ID)
    monster.unitxtID = pso.read_u32(monster.address + _MonsterUnitxtID)
    monster.HP = pso.read_u16(monster.address + _MonsterHP)
    monster.HPMax = pso.read_u16(monster.address + _MonsterHPMax)
    monster.room = pso.read_u16(monster.address + _Room)
    monster.posX = pso.read_f32(monster.address + _PosX)
    monster.posY = pso.read_f32(monster.address + _PosY)
    monster.posZ = pso.read_f32(monster.address + _PosZ)

    -- Dubwitches have an id of zero so we force it to 49
    -- instead, which is where the Dubwitch unitxt data is
    if monster.code == _DubwitchObjectCode then
        monster.unitxtID = 49
    end

    -- Other stuff
    monster.name = lib_unitxt.GetMonsterName(monster.unitxtID, _Ultimate)
    monster.color = 0xFFFFFFFF
    monster.display = true

    -- Darvants also have an id of zero, but they don't actually
    -- have an unitxt ID so we give it a fake ID of 999
    if monster.code == _DarvantObjectCode then
        monster.unitxtID = 999
        monster.name = "Darvant"
    end

    if monster.unitxtID == 45 then
        monster = GetMonsterDataDeRolLe(monster)
    end
    if monster.unitxtID == 73 then
        monster = GetMonsterDataBarbaRay(monster)
    end

    return monster
end

local function GetTargetMonster()
    local difficulty = pso.read_u32(_Difficulty)
    _Ultimate = difficulty == 3

    local pIndex = pso.read_u32(_PlayerIndex)
    local pAddr = pso.read_u32(_PlayerArray + 4 * pIndex)

    -- If we don't have address (maybe warping or something)
    -- return the empty list
    if pAddr == 0 then
        return nil
    end

    local targetID = -1
    local targetPointerOffset = pso.read_u32(pAddr + _targetPointerOffset)
    if targetPointerOffset ~= 0 then
        targetID = pso.read_i16(targetPointerOffset + _targetOffset)
    end

    if targetID == -1 then
        return nil
    end

    local _targetPointerOffset = 0x18
    local _targetOffset = 0x108C

    local playerCount = pso.read_u32(_PlayerCount)
    local entityCount = pso.read_u32(_EntityCount)

    local i = 0
    while i < entityCount do
        local monster = {}

        monster.address = pso.read_u32(_EntityArray + 4 * (i + playerCount))
        -- If we got a pointer, then read from it
        if monster.address ~= 0 then
            monster.id = pso.read_i16(monster.address + _ID)

            if monster.id == targetID then
                monster = GetMonsterData(monster)
                return monster
            end
        end
        i = i + 1
    end

    return nil
end

local function GetMonsterList()
    local monsterList = {}

    local difficulty = pso.read_u32(_Difficulty)
    _Ultimate = difficulty == 3

    local pIndex = pso.read_u32(_PlayerIndex)
    local pAddr = pso.read_u32(_PlayerArray + 4 * pIndex)

    -- If we don't have address (maybe warping or something)
    -- return the empty list
    if pAddr == 0 then
        return monsterList
    end

    -- Get player position
    local playerRoom1 = pso.read_u16(pAddr + _Room)
    local playerRoom2 = pso.read_u16(pAddr + _Room2)
    local pPosX = pso.read_f32(pAddr + _PosX)
    local pPosZ = pso.read_f32(pAddr + _PosZ)

    local playerCount = pso.read_u32(_PlayerCount)
    local entityCount = pso.read_u32(_EntityCount)

    local i = 0
    while i < entityCount do
        local monster = {}

        monster.display = true
        monster.index = i
        monster.address = pso.read_u32(_EntityArray + 4 * (i + playerCount))

        -- If we got a pointer, then read from it
        if monster.address ~= 0 then
            monster = GetMonsterData(monster)

            if cfgMonsters.m[monster.unitxtID] ~= nil then
                monster.color = cfgMonsters.m[monster.unitxtID].color
                monster.display = cfgMonsters.m[monster.unitxtID].display
            end

            -- Calculate the distance between it and the player
            -- And hide the monster if its too far
            local xDist = math.abs(pPosX - monster.posX)
            local zDist = math.abs(pPosZ - monster.posZ)
            local tDist = math.sqrt(xDist ^ 2 + zDist ^ 2)

            if cfgMonsters.maxDistance ~= 0 and tDist > cfgMonsters.maxDistance then
                monster.display = false
            end

            -- Determine whether the player is in the same room as the monster
            if options.showCurrentRoomOnly and playerRoom1 ~= monster.room and playerRoom2 ~= monster.room then
                monster.display = false
            end

            -- Do not show monsters that have been killed
            if monster.HP <= 0 then
                monster.display = false
            end

            -- If we have De Rol Le, make a copy for the body HP
            if monster.unitxtID == 45 and monster.index == 0 then
                local head = CopyMonster(monster)
                table.insert(monsterList, head)

                monster.index = monster.index + 1
                monster.HP = monster.HP2
                monster.HPMax = monster.HP2Max
                monster.name = monster.name .. " Skull"
            elseif monster.unitxtID == 73 and monster.index == 0 then
                local head = CopyMonster(monster)
                table.insert(monsterList, head)

                monster.index = monster.index + 1
                monster.HP = monster.HP2
                monster.HPMax = monster.HP2Max
                monster.name = monster.name .. " Skull"
            end

        
            table.insert(monsterList, monster)
        end
        i = i + 1
    end

    return monsterList
end

local function PresentMonsters()
    local monsterList = GetMonsterList()
    local monsterListCount = table.getn(monsterList)

    local columnCount = 2

    -- Get how many columns we'll need
    if options.showMonsterID == true then
        columnCount = columnCount + 1
    end
    if options.showMonsterStatus then
        columnCount = columnCount + 1
    end
    imgui.Columns(columnCount)

    if options.showMonsterStatus then
        local windowWidth = imgui.GetWindowSize()
        local charWidth = 8 * options.fontScale
        local statusColumnWidth = #"J30 Z30 F P" * charWidth + 10
        imgui.SetColumnOffset(1, 16 * charWidth)
        imgui.SetColumnOffset(2, windowWidth - statusColumnWidth)
    end

    local startIndex = 1
    local endIndex = monsterListCount
    local step = 1

    if options.invertMonsterList then
        startIndex = monsterListCount
        endIndex = 1
        step = -1
    end

    for i=startIndex, endIndex, step do
        local monster = monsterList[i]
        if monster.display then
            local mHP = monster.HP
            local mHPMax = monster.HPMax

            lib_helpers.TextC(true, monster.color, monster.name)
            imgui.NextColumn()

            if options.showMonsterID == true then
                lib_helpers.Text(true, "%04X", monster.id)
                imgui.NextColumn()
            end

            lib_helpers.imguiProgressBar(true, mHP/mHPMax, -1.0, 13.0 * options.fontScale, lib_helpers.HPToGreenRedGradient(mHP/mHPMax), nil, mHP)
            imgui.NextColumn()

            if options.showMonsterStatus then
                local atkTech = lib_characters.GetPlayerTechniqueStatus(monster.address, 0)
                local defTech = lib_characters.GetPlayerTechniqueStatus(monster.address, 1)
                
                if atkTech.type == 0 then
                    lib_helpers.TextC(true, 0, "    ")
                else
                    lib_helpers.TextC(true, 0xFFFF0000, atkTech.name .. atkTech.level .. string.rep(" ", 2 - #tostring(atkTech.level)) .. " ")
                end
                
                if defTech.type == 0 then
                    lib_helpers.TextC(false, 0, "    ")
                else
                    lib_helpers.TextC(false, 0xFF0000FF, defTech.name .. defTech.level .. string.rep(" ", 2 - #tostring(defTech.level)) .. " ")
                end

                local frozen = lib_characters.GetPlayerFrozenStatus(monster.address)
                local confused = lib_characters.GetPlayerConfusedStatus(monster.address)
                local paralyzed = lib_characters.GetPlayerParalyzedStatus(monster.address)

                if frozen then
                    lib_helpers.TextC(false, 0xFF00FFFF, "F ")
                elseif confused then
                    lib_helpers.TextC(false, 0xFFFF00FF, "C ")
                else
                    lib_helpers.TextC(false, 0, "  ")
                end
                if paralyzed then
                    lib_helpers.TextC(false, 0xFFFF4000, "P ")
                end

                imgui.NextColumn()
            end
        end
    end
end

local function PresentTargetMonster(monster)
    if monster ~= nil then
        local mHP = monster.HP
        local mHPMax = monster.HPMax

        local atkTech = lib_characters.GetPlayerTechniqueStatus(monster.address, 0)
        local defTech = lib_characters.GetPlayerTechniqueStatus(monster.address, 1)

        lib_helpers.Text(true, monster.name)
        if options.showMonsterID == true then
            lib_helpers.Text(false, " - ID: %04X", monster.id)
        end

        lib_helpers.imguiProgressBar(true, mHP/mHPMax, -1.0, 13.0 * options.fontScale, lib_helpers.HPToGreenRedGradient(mHP/mHPMax), nil, mHP)
        if atkTech.type == 0 then
            lib_helpers.Text(true, "")
        else
            lib_helpers.Text(true, "%s %i: %s", atkTech.name, atkTech.level, os.date("!%M:%S", atkTech.time))
        end
        if defTech.type == 0 then
            lib_helpers.Text(true, "")
        else
            lib_helpers.Text(true, "%s %i: %s", defTech.name, defTech.level, os.date("!%M:%S", defTech.time))
        end
    end
end

-- Need to use this so I can hide the window when nothing is targetted
local targetCache = nil
local targetWindowTimeOut = 0
local function PresentTargetMonsterWindow()
    local monster = GetTargetMonster()

    if monster == nil then
        if targetWindowTimeOut > 0 then
            targetWindowTimeOut = targetWindowTimeOut - 1
        end

        monster = targetCache
        if targetWindowTimeOut <= 0 then
            return
        end
    else 
        targetWindowTimeOut = 90
        targetCache = monster
    end
    
    if options.targetEnableWindow then
        if firstPresent or options.targetChanged then
          options.targetChanged = false
          local ps = lib_helpers.GetPosBySizeAndAnchor(options.targetX, options.targetY, options.targetW, options.targetH, options.targetAnchor)
          imgui.SetNextWindowPos(ps[1], ps[2], "Always");
          imgui.SetNextWindowSize(options.targetW, options.targetH, "Always");
        end

        if options.targetTransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if imgui.Begin("Monster Reader - Target", nil, { options.targetNoTitleBar, options.targetNoResize, options.targetNoMove, options.targetNoScrollbar }) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentTargetMonster(monster)
        end
        imgui.End()
    
        if options.targetTransparentWindow == true then
          imgui.PopStyleColor()
        end
    end
end

local function present()
    -- If the addon has never been used, open the config window
    -- and disable the config window setting
    if options.configurationEnableWindow then
        ConfigurationWindow.open = true
        options.configurationEnableWindow = false
    end

    ConfigurationWindow.Update()
    if ConfigurationWindow.changed then
        ConfigurationWindow.changed = false
        SaveOptions(options)
    end

    -- Global enable here to let the configuration window work
    if options.enable == false then
        return
    end

    if options.mhpEnableWindow then
        if firstPresent or options.mhpChanged then
            options.mhpChanged = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(options.mhpX, options.mhpY, options.mhpW, options.mhpH, options.mhpAnchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            imgui.SetNextWindowSize(options.mhpW, options.mhpH, "Always");
        end

        if options.mhpTransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if imgui.Begin("Monster Reader - HP", nil, { options.mhpNoTitleBar, options.mhpNoResize, options.mhpNoMove }) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentMonsters()
        end
        imgui.End()

        if options.mhpTransparentWindow == true then
            imgui.PopStyleColor()
        end
    end

    PresentTargetMonsterWindow()

    if firstPresent then
        firstPresent = false
    end
end

local function init()
    ConfigurationWindow = cfg.ConfigurationWindow(options)

    local function mainMenuButtonHandler()
        ConfigurationWindow.open = not ConfigurationWindow.open
    end

    core_mainmenu.add_button("Monster Reader", mainMenuButtonHandler)

    return
    {
        name = "Monster Reader",
        version = "1.0.5",
        author = "Solybum",
        description = "Information about monsters",
        present = present,
    }
end

return
{
    __addon =
    {
        init = init
    }
}
