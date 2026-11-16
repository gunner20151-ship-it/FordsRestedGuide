local ADDON_NAME = "FordsRestedGuide"
local lastTomTomUID = nil
local isCollapsed = false
local lockedQuestIdx = nil
local hsNeedsRebind = false
local serverCompletedCache = {}

local sessionStartTime = GetTime()
local sessionStartXP = 0
local sessionGainedXP = 0

local TYPE_COLORS = {
    ACCEPT   = "|cff44ff44[ACCEPT]|r ",
    COMPLETE = "|cffffd100[OBJECTIVE]|r ",
    TURNIN   = "|cff44ccff[TURN IN]|r ",
    TRAVEL   = "|cffff8844[TRAVEL]|r ",
    DUNGEON  = "|cffff44ff[DUNGEON]|r ",
    GRIND    = "|cffcccccc[GRIND]|r "
}

local RACE_CYCLE = {
    "AUTO",
    "Alliance_Skyborne",
    "Alliance_Human",
    "Alliance_DwarfGnome",
    "Alliance_NightElf",
    "Horde_Skyborne",
    "Horde_Undead",
    "Horde_OrcTroll",
    "Horde_Tauren"
}

local RACE_LABELS = {
    ["AUTO"]                = "Auto-Detect (Faction & Race)",
    ["Alliance_Skyborne"]   = "Alliance: High Order Skyborne (Zephras Isle)",
    ["Alliance_Human"]      = "Alliance: Human (Elwynn Forest)",
    ["Alliance_DwarfGnome"] = "Alliance: Dwarf / Gnome (Dun Morogh)",
    ["Alliance_NightElf"]   = "Alliance: Night Elf (Teldrassil)",
    ["Horde_Skyborne"]      = "Horde: Windshaper Skyborne (Zephras Isle)",
    ["Horde_Undead"]        = "Horde: Undead (Tirisfal Glades)",
    ["Horde_OrcTroll"]      = "Horde: Orc / Troll (Durotar)",
    ["Horde_Tauren"]        = "Horde: Tauren (Mulgore)"
}

-- ============================================================================
-- VERIFIED WOWHEAD CLASSIC & WOW: FOREVER CUSTOM DUNGEON QUEST ID TABLE
-- ============================================================================
local QUEST_NAME_FALLBACK_IDS = {
    -- Ragefire Chasm (13-18)
    ["testing an enemy's strength"] = { 5723 },
    ["searching for the lost satchel"] = { 5722 },
    ["returning the lost satchel"] = { 5724 },
    ["hidden enemies"] = { 5726, 5727, 5728, 5729, 5730 },
    ["the power to destroy"] = { 5725 },
    ["slaying the beast"] = { 5761 },

    -- Hall of Thanes (13-20 - WoW: Forever Custom Dungeon)
    ["old ironforge incursion"] = { 96393 },
    ["the restless dead"] = { 96394 },
    ["an ancient grudge"] = { 96395 },
    ["important heirlooms"] = { 96403 },
    ["the treaty of understanding"] = { 96396, 96404 },

    -- Ruins of Lordaeron (15-22 - WoW: Forever Custom Dungeon)
    ["a frightened request"] = { 92401 },
    ["remember that i love you"] = { 92414, 92415, 92416 },
    ["blood-stained letter"] = { 92414, 92415 },
    ["light's justice"] = { 92421 },
    ["intact limbs"] = { 92421 },
    ["the wrath of rath'mael"] = { 92422 },
    ["bloodied insignia"] = { 95195 },
    ["crest of lordaeron"] = { 95204, 95189 },
    ["the new plague"] = { 95216 },
    ["unending torment"] = { 97288, 97289, 97290, 97291, 97292 },
    ["abominable head"] = { 97288, 97289, 97290, 97291, 97292 },

    -- Wailing Caverns (15-24)
    ["leaders of the fang"] = { 914 },
    ["serpentbloom"] = { 962 },
    ["smart drinks"] = { 1491 },
    ["raptor horns"] = { 865 },
    ["deviate hides"] = { 1486 },
    ["deviate eradication"] = { 1487 },
    ["trouble at the docks"] = { 959 },
    ["the glowing shard"] = { 6981, 3366 },

    -- The Deadmines (17-26) & Stormwind Stockade (24-32)
    ["the defias brotherhood"] = { 166 },
    ["red silk bandanas"] = { 214 },
    ["oh brother. . ."] = { 167 },
    ["collecting memories"] = { 168 },
    ["underground assault"] = { 2040 },
    ["the unsent letter"] = { 373 },
    ["quell the uprising"] = { 387 },
    ["the color of blood"] = { 388 },
    ["crime and punishment"] = { 391 },
    ["theate of stormwind"] = { 386 },
    ["what comes around..."] = { 386 },

    -- Shadowfang Keep (20-30)
    ["arugal must die"] = { 1014 },
    ["deathstalkers in shadowfang"] = { 1098 },
    ["the book of ur"] = { 1013 },

    -- Blackfathom Deeps (24-32)
    ["allegiance to the old gods"] = { 6564, 6565 },
    ["amongst the ruins"] = { 6921 },
    ["blackfathom villainy"] = { 6561 },
    ["the essence of aku'mai"] = { 6563 },
    ["baron aquanis"] = { 6922 },
    ["in search of thaelrid"] = { 1198 },
    ["researching the corruption"] = { 1275 },
    ["twilight falls"] = { 1199 },

    -- Excavation Site: Wetlands (26-33 - WoW: Forever Custom Dungeon)
    ["horrors in the highland"] = { 95646 },
    ["lost in the thicket things"] = { 95647 },
    ["dragonmaw rumors"] = { 95663 },
    ["elder knowledge"] = { 95664, 98823 },
    ["open the maw"] = { 95682 },
    ["songblade search"] = { 95737 },
    ["heartwoven"] = { 95809 },
    ["lost relic carry"] = { 95665, 95664 },

    -- City of Dalaran (28-35 - WoW: Forever Custom Dungeon & Attunement)
    ["prison break in"] = { 544 },
    ["dalaran patrols"] = { 545 },
    ["souvenirs of death"] = { 546 },
    ["souvenir of death"] = { 546 },
    ["umber's research"] = { 547 },
    ["stone tokens"] = { 556 },
    ["bracers of binding"] = { 557 },
    ["key to the city"] = { 93680, 543 },
    ["blood in the streets"] = { 92434 },
    ["an alarming request"] = { 92432 },
    ["shrewd negotiations"] = { 97287 },
    ["friend of the kirin tor"] = { 92459 },
    ["heart of disruption"] = { 96984, 92458 },
    ["the grave knight"] = { 96986 },
    ["opportunistic education"] = { 96987 },
    ["source of power"] = { 96988 },
    ["starving arcane"] = { 92457, 96985 },
    ["a green sample"] = { 92456 },
    ["power overwhelming"] = { 92489 },
    ["unstable magic"] = { 96603 },

    -- Razorfen Kraul (29-38)
    ["going, going, guano!"] = { 1109 },
    ["an unholy alliance"] = { 6521, 6522, 1100, 1101 },
    ["conquering the kraul"] = { 6522 },
    ["a vengeful fate"] = { 1102 },
    ["vengeful fate"] = { 1102 },
    ["mortality wanes"] = { 1142 },
    ["willix the importer"] = { 1144 },
    ["blueleaf tubers"] = { 1221 },

    -- Gnomeregan (29-38)
    ["rig wars"] = { 2841 },
    ["chief engineer scooty"] = { 2842 },
    ["gnomer-gooooone!"] = { 2843 },
    ["the grand betrayal"] = { 2929 },
    ["data rescue"] = { 2930 },
    ["essential artificials"] = { 2924 },
    ["save techbot's brain!"] = { 2922 },
    ["grime-encrusted ring"] = { 2945 },

    -- Thousand Needles & Shimmering Flats
    ["wind rider"] = { 4767 },
    ["alien egg"] = { 4821 },
    ["serpent wild"] = { 4865 },
    ["pacify the centaur"] = { 4841 },
    ["grimtotem spying"] = { 5064 },
    ["wanted - arnak grimtotem"] = { 5147 },
    ["test of faith"] = { 1149 },
    ["test of endurance"] = { 1150 },
    ["test of strength"] = { 1151 },
    ["test of lore"] = { 1152, 6627 },
    ["protect kanati greycloud"] = { 4966 },
    ["sacred fire"] = { 5062 },
    ["arikara"] = { 5088 },
    ["hypercapacitor gizmo"] = { 5151 },
    ["homeward bound"] = { 4770 },
    ["free at last"] = { 4904 },
    ["steelsnap"] = { 1131 },
    ["melor sends word"] = { 1130 },
    ["hardened shells"] = { 1104, 1105 },
    ["salt flat venom"] = { 1104, 1105 },
    ["rocket car parts"] = { 1110 },
    ["wharfmaster dizzywig"] = { 1111 },
    ["load lightening"] = { 1176 },
    ["a bump in the road"] = { 1175 },
    ["martek the exiled"] = { 1106 },
    ["encrusted tail fins"] = { 1107 },
    ["parts for kravel"] = { 1112 },
    ["delivery to the gnomes"] = { 1114 },
    ["the rumormonger"] = { 1115 },
    ["goblin sponsorship"] = { 1180, 1181, 1182, 1183 },
    ["the eighteenth pilot"] = { 1186 },
    ["razzeric's tweaking"] = { 1187 },
    ["safety first"] = { 1188, 1189 },
    ["keeping pace"] = { 1190 },
    ["zamek's distraction"] = { 1191 },
    ["indurium ore"] = { 1192 },
    ["the swarm grows"] = { 1145, 1146, 1147 },
    ["parts of the swarm"] = { 1148, 1184 },

    -- Stranglethorn Vale & The Drowned City (35-40 - WoW: Forever Custom Dungeon)
    ["welcome to the jungle"] = { 583 },
    ["tiger mastery"] = { 185, 186, 187, 188 },
    ["panther mastery"] = { 190, 191, 192, 193 },
    ["raptor mastery"] = { 194, 195, 196, 197 },
    ["the green hills of stranglethorn"] = { 338 },
    ["hunt for yenniku"] = { 581 },
    ["headhunting"] = { 582 },
    ["bloodscalp ears"] = { 189 },
    ["the vile reef"] = { 629 },
    ["mok'thardin's enchantment"] = { 570, 571, 572, 573 },
    ["split bone necklace"] = { 598 },
    ["the defense of grom'gol"] = { 568, 569 },
    ["locating the lost city"] = { 95770, 95748, 96078 },
    ["the drowned city"] = { 95775 },
    ["the only good brinescale"] = { 95776 },
    ["take two with water"] = { 95787 },
    ["magics of the drowned city"] = { 95788 },
    ["shady saltseers"] = { 95789 },
    ["the saltseer captain"] = { 95791 },
    ["ancient gurubashi idol"] = { 96774 },
    ["ancient gurubashi secrets"] = { 97130 },

    -- Scarlet Monastery (30-46) & Razorfen Downs (37-46)
    ["hearts of zeal"] = { 1113 },
    ["into the scarlet monastery"] = { 1048 },
    ["compendium of the fallen"] = { 1049 },
    ["vorrel's revenge"] = { 1051 },
    ["in the name of the light"] = { 1053 },
    ["mythology of the titans"] = { 1050 },
    ["a host of evil"] = { 6626 },
    ["scourge of the downs"] = { 3523 },
    ["extinguishing the idol"] = { 3525 },
    ["bring the end"] = { 3341 },
    ["bring the light"] = { 3636 },

    -- The Riverglades & Krol'dok Stronghold (40-45 - WoW: Forever Custom Dungeon)
    ["show them how it's done"] = { 95428, 94744 },
    ["eye of mugg"] = { 94968, 94982 },
    ["krol'dok no more!"] = { 94969 },
    ["tome of twilight"] = { 94972, 94984 },
    ["krol'dok moulding"] = { 94973, 94980 },
    ["key ingredients"] = { 94974, 94981 },
    ["a token of vengeance"] = { 94970, 94971, 94975 },
    ["twilight mementos"] = { 94983, 94997, 94998 },
    ["vengeance of the highborne"] = { 94985, 94986, 94999 },

    -- Zul'Farrak (44-54), Maraudon (46-55) & Alcaz Prison (48-53)
    ["troll temper"] = { 3042 },
    ["scarab shells"] = { 2865 },
    ["divino-matic rod"] = { 2768 },
    ["gahz'rilla"] = { 2770 },
    ["tiara of the deep"] = { 2846 },
    ["the prophecy of mosh'aru"] = { 3527 },
    ["corruption of earth and seed"] = { 7064, 7065 },
    ["legends of maraudon"] = { 7044 },
    ["shadowshard fragments"] = { 7070 },
    ["the honor of the kor'kron"] = { 95454 },
    ["a little payback"] = { 96332 },
    ["a bit of wet work"] = { 96381 },
    ["somber news"] = { 95263 },
    ["the secret prison"] = { 95262 },

    -- Blackmaw Hold (55-60) & The Shaper's Terrace (58-60 - WoW: Forever Custom Dungeons)
    ["beneath nordrassil"] = { 92346, 92345 },
    ["get to the roots of it"] = { 92343, 92344 },
    ["blackmaw magic"] = { 97173, 97174 },
    ["blackmaw pouches"] = { 97327 },
    ["crystalline elements"] = { 95928 },
    ["essence of seeping slimes"] = { 97049 }
}

local DEFAULT_SETTINGS = {
    step = 1,
    version = "11.8",
    raceRoute = "AUTO",
    locked = false,
    showArrow = true,
    minimapHide = false,
    minimapAngle = 205,
    minimapOffset = 5,
    autoAdvance = true,
    autoQuest = false,
    showXPBar = false,
    scale = 1.0,
    alpha = 0.95,
    manualDone = {}
}

local function EnsureDefaults()
    FordsRestedGuideDB = FordsRestedGuideDB or {}
    for k, v in pairs(DEFAULT_SETTINGS) do
        if FordsRestedGuideDB[k] == nil then
            if type(v) == "table" then
                FordsRestedGuideDB[k] = {}
            else
                FordsRestedGuideDB[k] = v
            end
        end
    end
    FordsRestedGuideDB.manualDone = FordsRestedGuideDB.manualDone or {}
end

-- ==========================================
-- UNIVERSAL ROUTE RESOLVER
-- ==========================================
local activeSteps = {}
local activeRouteTag = "Auto"

local function DetectPlayerRouteKey()
    local mode = FordsRestedGuideDB and FordsRestedGuideDB.raceRoute or "AUTO"
    if mode ~= "AUTO" and RACE_LABELS[mode] then
        return mode
    end

    local faction = UnitFactionGroup and UnitFactionGroup("player") or "Horde"
    local raceName, raceFile = UnitRace("player")
    local r = string.lower((raceName or "") .. " " .. (raceFile or ""))
    local z = string.lower(GetRealZoneText and GetRealZoneText() or "")

    local isSkyborne = string.find(r, "sky") or string.find(r, "windshaper") or string.find(r, "high order") or string.find(z, "zephras")

    if faction == "Alliance" then
        if isSkyborne then return "Alliance_Skyborne"
        elseif string.find(r, "dwarf") or string.find(r, "gnome") then return "Alliance_DwarfGnome"
        elseif string.find(r, "night") or string.find(r, "nelf") then return "Alliance_NightElf"
        else return "Alliance_Human" end
    else
        if isSkyborne then return "Horde_Skyborne"
        elseif string.find(r, "orc") or string.find(r, "troll") then return "Horde_OrcTroll"
        elseif string.find(r, "tauren") then return "Horde_Tauren"
        else return "Horde_Undead" end
    end
end

local function AppendStepsFromEntry(entry)
    if type(entry) ~= "table" then return 0 end
    local list = (type(entry.steps) == "table" and entry.steps) or entry
    local added = 0
    for _, s in ipairs(list) do
        if type(s) == "table" and (s.title or s.zone or s.quests) then
            table.insert(activeSteps, s)
            added = added + 1
        end
    end
    return added
end

local function RebuildActiveRoute()
    activeSteps = {}
    local routesTbl = FordsRestedGuide_Routes or ForeverGuide_Routes
    if type(routesTbl) ~= "table" then return end

    local key = DetectPlayerRouteKey()
    local starterCandidates = {}
    local sharedCandidates = {}
    local fullCandidates = {}

    if key == "Alliance_Skyborne" then
        activeRouteTag = "A-Skyborne"
        starterCandidates = { "Alliance_Starter_Skyborne", "Skyborne_Alliance" }
        sharedCandidates  = { "Alliance_Shared_12_60", "Alliance_Shared" }
        fullCandidates    = { "Alliance_Skyborne", "Alliance_1_60", "Alliance" }
    elseif key == "Alliance_DwarfGnome" then
        activeRouteTag = "Dwarf/Gnome"
        starterCandidates = { "Alliance_Starter_DwarfGnome", "DwarfGnome" }
        sharedCandidates  = { "Alliance_Shared_12_60", "Alliance_Shared" }
        fullCandidates    = { "Alliance_DwarfGnome", "Alliance_1_60", "Alliance" }
    elseif key == "Alliance_NightElf" then
        activeRouteTag = "NightElf"
        starterCandidates = { "Alliance_Starter_NightElf", "NightElf" }
        sharedCandidates  = { "Alliance_Shared_12_60", "Alliance_Shared" }
        fullCandidates    = { "Alliance_NightElf", "Alliance_1_60", "Alliance" }
    elseif key == "Alliance_Human" then
        activeRouteTag = "Human"
        starterCandidates = { "Alliance_Starter_Human", "Human" }
        sharedCandidates  = { "Alliance_Shared_12_60", "Alliance_Shared" }
        fullCandidates    = { "Alliance_Human", "Alliance_1_60", "Alliance" }
    elseif key == "Horde_Skyborne" then
        activeRouteTag = "H-Skyborne"
        starterCandidates = { "Horde_Starter_Skyborne", "Starter_Skyborne", "Skyborne", "Windshaper" }
        sharedCandidates  = { "Horde_Shared_13_60", "Shared_13_60", "Horde_Shared", "Horde_13_60" }
        fullCandidates    = { "Horde_Skyborne", "Skyborne_1_60", "Horde_1_60", "Horde" }
    elseif key == "Horde_OrcTroll" then
        activeRouteTag = "Orc/Troll"
        starterCandidates = { "Horde_Starter_OrcTroll", "Starter_OrcTroll", "OrcTroll", "Durotar" }
        sharedCandidates  = { "Horde_Shared_13_60", "Shared_13_60", "Horde_Shared", "Horde_13_60" }
        fullCandidates    = { "Horde_OrcTroll", "OrcTroll_1_60", "Horde_1_60", "Horde" }
    elseif key == "Horde_Tauren" then
        activeRouteTag = "Tauren"
        starterCandidates = { "Horde_Starter_Tauren", "Starter_Tauren", "Tauren", "Mulgore" }
        sharedCandidates  = { "Horde_Shared_13_60", "Shared_13_60", "Horde_Shared", "Horde_13_60" }
        fullCandidates    = { "Horde_Tauren", "Tauren_1_60", "Horde_1_60", "Horde" }
    else
        activeRouteTag = "Undead"
        starterCandidates = { "Horde_Starter_Undead", "Starter_Undead", "Undead", "Tirisfal" }
        sharedCandidates  = { "Horde_Shared_13_60", "Shared_13_60", "Horde_Shared", "Horde_13_60" }
        fullCandidates    = { "Horde_Undead", "Undead_1_60", "Horde_1_60", "Horde" }
    end

    local foundStarter = false
    for _, k in ipairs(starterCandidates) do
        if routesTbl[k] and AppendStepsFromEntry(routesTbl[k]) > 0 then
            foundStarter = true
            break
        end
    end
    for _, k in ipairs(sharedCandidates) do
        if routesTbl[k] and AppendStepsFromEntry(routesTbl[k]) > 0 then
            break
        end
    end

    if #activeSteps <= 5 then
        for _, k in ipairs(fullCandidates) do
            if routesTbl[k] then
                if not foundStarter then activeSteps = {} end
                if AppendStepsFromEntry(routesTbl[k]) > 0 then break end
            end
        end
    end

    if #activeSteps == 0 then
        AppendStepsFromEntry(routesTbl)
    end

    if #activeSteps == 0 then
        local bestList = nil
        local bestCount = 0
        for _, v in pairs(routesTbl) do
            if type(v) == "table" then
                local candidate = (type(v.steps) == "table" and v.steps) or v
                if type(candidate) == "table" and #candidate > bestCount and type(candidate[1]) == "table" and (candidate[1].title or candidate[1].zone) then
                    bestCount = #candidate
                    bestList = candidate
                end
            end
        end
        if bestList then
            AppendStepsFromEntry(bestList)
        end
    end
end

-- ==========================================
-- POLISHED 20x20 SQUARE "FW" CREST BUILDER
-- ==========================================
local function CreateSquareFWLogo(parent)
    local crest = CreateFrame("Button", nil, parent, BackdropTemplateMixin and "BackdropTemplate")
    crest:SetSize(20, 20)
    crest:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 8, edgeSize = 10,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    crest:SetBackdropColor(0.04, 0.11, 0.19, 1)
    crest:SetBackdropBorderColor(0.90, 0.75, 0.25, 1)

    local innerBg = crest:CreateTexture(nil, "BACKGROUND")
    innerBg:SetPoint("TOPLEFT", crest, "TOPLEFT", 2, -2)
    innerBg:SetPoint("BOTTOMRIGHT", crest, "BOTTOMRIGHT", -2, 2)
    innerBg:SetColorTexture(0.05, 0.13, 0.22, 1)

    local txt = crest:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    txt:SetPoint("CENTER", crest, "CENTER", 0, 0)
    txt:SetText("|cff00ccffF|r|cff00ff96W|r")

    return crest
end

-- ==========================================
-- MAIN TRACKER WINDOW (425px Wide)
-- ==========================================
local frame = CreateFrame("Frame", "FordsRestedGuideFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
frame:SetSize(425, 385)
frame:SetPoint("CENTER", UIParent, "CENTER", 350, 100)
frame:SetBackdrop({
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 14,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
frame:SetBackdropColor(0.05, 0.06, 0.09, 0.95)
frame:SetBackdropBorderColor(0.25, 0.55, 0.75, 1)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:EnableMouseWheel(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function(self)
    if not FordsRestedGuideDB.locked then self:StartMoving() end
end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, relPoint, x, y = self:GetPoint()
    FordsRestedGuideDB.pos = { point = point, relPoint = relPoint, x = x, y = y }
end)

local titleBar = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
titleBar:SetHeight(24)
titleBar:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
titleBar:SetBackdropColor(0.10, 0.16, 0.24, 0.95)

local crestBox = CreateSquareFWLogo(titleBar)
crestBox:SetPoint("LEFT", titleBar, "LEFT", 4, 0)

local header = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
header:SetPoint("LEFT", crestBox, "RIGHT", 6, 0)
header:SetText("|cff00ccffFord's|r |cff00ff96RestedGuide|r")

local stepCounter = titleBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
stepCounter:SetPoint("LEFT", header, "RIGHT", 6, 0)

local closeBtn = CreateFrame("Button", nil, titleBar, "UIPanelButtonTemplate")
closeBtn:SetSize(20, 18)
closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", -4, 0)
closeBtn:SetText("X")
closeBtn:SetScript("OnClick", function() frame:Hide() end)

local collapseBtn = CreateFrame("Button", nil, titleBar, "UIPanelButtonTemplate")
collapseBtn:SetSize(20, 18)
collapseBtn:SetPoint("RIGHT", closeBtn, "LEFT", -3, 0)
collapseBtn:SetText("-")

local cfgBtn = CreateFrame("Button", nil, titleBar, "UIPanelButtonTemplate")
cfgBtn:SetSize(32, 18)
cfgBtn:SetPoint("RIGHT", collapseBtn, "LEFT", -3, 0)
cfgBtn:SetText("Cfg")

local body = CreateFrame("Frame", nil, frame)
body:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, -4)
body:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)

local arrowBox = CreateFrame("Frame", nil, body, BackdropTemplateMixin and "BackdropTemplate")
arrowBox:SetSize(50, 50)
arrowBox:SetPoint("TOPRIGHT", body, "TOPRIGHT", -24, -2)
arrowBox:SetBackdrop({
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 8, edgeSize = 10,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
arrowBox:SetBackdropColor(0.02, 0.03, 0.05, 0.95)
arrowBox:SetBackdropBorderColor(0.3, 0.6, 0.8, 1)

local arrowTex = arrowBox:CreateTexture(nil, "ARTWORK")
arrowTex:SetSize(26, 26)
arrowTex:SetPoint("TOP", arrowBox, "TOP", 0, -5)
arrowTex:SetTexture("Interface\\Minimap\\MinimapArrow")

local distText = arrowBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
distText:SetPoint("BOTTOM", arrowBox, "BOTTOM", 0, 4)
distText:SetText("-- yd")

local zoneText = body:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
zoneText:SetPoint("TOPLEFT", body, "TOPLEFT", 8, -4)
zoneText:SetWidth(330)
zoneText:SetJustifyH("LEFT")
zoneText:SetTextColor(0.60, 0.85, 1.0)

local titleText = body:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("TOPLEFT", zoneText, "BOTTOMLEFT", 0, -5)
titleText:SetWidth(330)
titleText:SetJustifyH("LEFT")

local noteText = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
noteText:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -5)
noteText:SetWidth(390)
noteText:SetJustifyH("LEFT")
noteText:SetTextColor(0.90, 0.90, 0.90)

local scrollFrame = CreateFrame("ScrollFrame", "FordsRestedGuideScrollFrame", body, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", noteText, "BOTTOMLEFT", 0, -8)
scrollFrame:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", -26, 68)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(375, 220)
scrollFrame:SetScrollChild(scrollChild)

local questRows = {}

local xpInfoBar = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
xpInfoBar:SetPoint("BOTTOMLEFT", body, "BOTTOMLEFT", 8, 50)
xpInfoBar:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", -8, 50)
xpInfoBar:SetJustifyH("CENTER")
xpInfoBar:SetTextColor(0.65, 0.90, 1.0)
xpInfoBar:SetText("XP/hr: -- | Next Lvl: -- | Rested: 0%")

local progBar = CreateFrame("StatusBar", nil, body, BackdropTemplateMixin and "BackdropTemplate")
progBar:SetHeight(14)
progBar:SetPoint("BOTTOMLEFT", body, "BOTTOMLEFT", 6, 32)
progBar:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", -6, 32)
progBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
progBar:SetStatusBarColor(0.15, 0.75, 0.35, 0.9)
progBar:SetMinMaxValues(0, 1)
progBar:SetValue(0)
progBar:EnableMouse(true)

local progBg = progBar:CreateTexture(nil, "BACKGROUND")
progBg:SetAllPoints(progBar)
progBg:SetColorTexture(0.12, 0.12, 0.16, 0.9)

local progText = progBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
progText:SetPoint("CENTER", progBar, "CENTER", 0, 0)
progText:SetText("Hub Progress: 0 / 0")

-- Clean 5-Button Bottom Bar
local prevBtn = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
prevBtn:SetSize(58, 22)
prevBtn:SetPoint("BOTTOMLEFT", body, "BOTTOMLEFT", 6, 5)
prevBtn:SetText("< Prev")

local syncBtn = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
syncBtn:SetSize(72, 22)
syncBtn:SetPoint("LEFT", prevBtn, "RIGHT", 5, 0)
syncBtn:SetText("Auto-Sync")

local targetBtn = CreateFrame("Button", nil, body, "SecureActionButtonTemplate,UIPanelButtonTemplate")
targetBtn:SetSize(122, 22)
targetBtn:SetPoint("LEFT", syncBtn, "RIGHT", 5, 0)
targetBtn:RegisterForClicks("AnyUp", "AnyDown")
targetBtn:SetAttribute("type", "macro")
targetBtn:SetText("Target NPC")

local hsBtn = CreateFrame("Button", "FordsRestedGuideHSButton", body, "SecureActionButtonTemplate,UIPanelButtonTemplate")
hsBtn:SetSize(78, 22)
hsBtn:SetPoint("LEFT", targetBtn, "RIGHT", 5, 0)
hsBtn:RegisterForClicks("AnyUp", "AnyDown")
hsBtn:SetText("HS: Rdy")

local function BindHearthstoneAttributes()
    if InCombatLockdown() then
        hsNeedsRebind = true
        return
    end
    hsBtn:SetAttribute("type", "macro")
    hsBtn:SetAttribute("macrotext", "/use item:6948\n/use Hearthstone")
    hsBtn:SetAttribute("type1", "item")
    hsBtn:SetAttribute("item1", "item:6948")
    hsBtn:SetAttribute("type2", "macro")
    hsBtn:SetAttribute("macrotext2", "/use item:6948\n/use Hearthstone")
    hsNeedsRebind = false
end
BindHearthstoneAttributes()

local nextBtn = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
nextBtn:SetSize(58, 22)
nextBtn:SetPoint("LEFT", hsBtn, "RIGHT", 5, 0)
nextBtn:SetText("Next >")

-- ==========================================
-- LIVE HEARTHSTONE COOLDOWN & BAG CHECKER
-- ==========================================
local function GetHearthstoneCooldownInfo()
    local start, duration, enable = 0, 0, 1

    if C_Container and C_Container.GetItemCooldown then
        local ok, s, d, e = pcall(C_Container.GetItemCooldown, 6948)
        if ok and s then start, duration, enable = s, d, e end
    end

    if (not start or start == 0) and GetItemCooldown then
        local ok, s, d, e = pcall(GetItemCooldown, 6948)
        if ok and s then start, duration, enable = s, d, e end
    end

    local foundInBags = false
    local getNumSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
    local getItemID   = (C_Container and C_Container.GetContainerItemID) or GetContainerItemID
    local getSlotCD   = (C_Container and C_Container.GetContainerItemCooldown) or GetContainerItemCooldown

    if getNumSlots and getItemID then
        for bag = 0, 4 do
            local numSlots = getNumSlots(bag) or 0
            for slot = 1, numSlots do
                local itemID = getItemID(bag, slot)
                if itemID == 6948 then
                    foundInBags = true
                    if (not start or start == 0) and getSlotCD then
                        local ok, s, d, e = pcall(getSlotCD, bag, slot)
                        if ok and s then start, duration, enable = s, d, e end
                    end
                    break
                end
            end
            if foundInBags then break end
        end
    else
        foundInBags = true
    end

    local remaining = 0
    if start and start > 0 and duration and duration > 1.5 then
        remaining = (start + duration) - GetTime()
        if remaining < 0 then remaining = 0 end
    end

    return remaining, foundInBags
end

local function FormatCooldownShort(seconds)
    if seconds >= 60 then
        local mins = math.ceil(seconds / 60)
        return mins .. "m"
    else
        return math.ceil(seconds) .. "s"
    end
end

local function UpdateHearthstoneButton()
    if hsNeedsRebind and not InCombatLockdown() then
        BindHearthstoneAttributes()
    end

    local rem, hasHS = GetHearthstoneCooldownInfo()
    if not hasHS then
        hsBtn:SetText("|cff888888HS: None|r")
    elseif rem > 0 then
        hsBtn:SetText("|cffffaa00HS: " .. FormatCooldownShort(rem) .. "|r")
    else
        hsBtn:SetText("|cff44ff44HS: Rdy|r")
    end
end

hsBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    local bindLoc = GetBindLocation and GetBindLocation() or "Unknown Inn"
    local rem, hasHS = GetHearthstoneCooldownInfo()
    GameTooltip:AddLine("Hearthstone", 0.2, 0.8, 1.0)
    GameTooltip:AddLine("Bound to: |cffffd100" .. bindLoc .. "|r", 1, 1, 1)
    if not hasHS then
        GameTooltip:AddLine("Status: |cffff4444Not in Bags|r", 1, 1, 1)
    elseif rem > 0 then
        local mins = math.floor(rem / 60)
        local secs = math.floor(rem % 60)
        GameTooltip:AddLine(string.format("Cooldown Remaining: |cffffaa00%dm %02ds|r", mins, secs), 1, 1, 1)
    else
        GameTooltip:AddLine("Status: |cff44ff44Ready to Cast!|r", 1, 1, 1)
    end
    GameTooltip:AddLine("|cffaaaaaaLeft/Right-Click to cast Hearthstone|r", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end)
hsBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

collapseBtn:SetScript("OnClick", function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        body:Hide()
        frame:SetHeight(32)
        collapseBtn:SetText("+")
    else
        body:Show()
        frame:SetHeight(385)
        collapseBtn:SetText("-")
    end
end)

-- ==========================================
-- CIRCULAR "FW" MINIMAP BUTTON (WoW: Forever Style)
-- ==========================================
local miniBtn = CreateFrame("Button", "FordsRestedGuideMinimapButton", Minimap)
miniBtn:SetSize(31, 31)
miniBtn:SetFrameStrata("MEDIUM")
miniBtn:SetFrameLevel(8)
miniBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp")
miniBtn:RegisterForDrag("LeftButton")
miniBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

local miniBg = miniBtn:CreateTexture(nil, "BACKGROUND")
miniBg:SetSize(20, 20)
miniBg:SetPoint("TOPLEFT", miniBtn, "TOPLEFT", 6, -5)
miniBg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
miniBg:SetVertexColor(0.05, 0.12, 0.20, 1)

local miniText = miniBtn:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
miniText:SetPoint("CENTER", miniBtn, "CENTER", 0, 0)
miniText:SetText("|cff00ccffF|r|cff00ff96W|r")

local miniBorder = miniBtn:CreateTexture(nil, "OVERLAY")
miniBorder:SetSize(53, 53)
miniBorder:SetPoint("TOPLEFT", miniBtn, "TOPLEFT", 0, 0)
miniBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

miniBtn:SetScript("OnMouseDown", function()
    miniText:SetPoint("CENTER", miniBtn, "CENTER", 1, -1)
end)
miniBtn:SetScript("OnMouseUp", function()
    miniText:SetPoint("CENTER", miniBtn, "CENTER", 0, 0)
end)

local function UpdateMinimapButtonPosition()
    local angle = math.rad(FordsRestedGuideDB and FordsRestedGuideDB.minimapAngle or 205)
    local mapWidth = Minimap:GetWidth()
    if not mapWidth or mapWidth <= 0 then mapWidth = 140 end
    local mapRadius = mapWidth / 2
    local offset = (FordsRestedGuideDB and FordsRestedGuideDB.minimapOffset) or 5
    local radius = mapRadius + offset
    local x = math.cos(angle) * radius
    local y = math.sin(angle) * radius
    miniBtn:ClearAllPoints()
    miniBtn:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

miniBtn:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function()
        local mx, my = Minimap:GetCenter()
        local cx, cy = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        cx, cy = cx / scale, cy / scale
        FordsRestedGuideDB.minimapAngle = math.deg(math.atan2(cy - my, cx - mx))
        UpdateMinimapButtonPosition()
    end)
end)

miniBtn:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
end)

miniBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("|cff00ccffFord's|r |cff00ff96RestedGuide|r |cffaaaaaa(FW)|r v11.8")
    GameTooltip:AddLine("|cffffd100Left-Click:|r Toggle Guide Window", 1, 1, 1)
    GameTooltip:AddLine("|cffffd100Right-Click:|r Open Settings Menu", 1, 1, 1)
    GameTooltip:AddLine("|cffffd100Middle-Click:|r Run Smart Auto-Sync", 1, 1, 1)
    GameTooltip:AddLine("|cffaaaaaaDrag to orbit around Minimap|r", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end)
miniBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- ==========================================
-- SETTINGS / OPTIONS WINDOW
-- ==========================================
local optFrame = CreateFrame("Frame", "FordsRestedGuideOptionsFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
optFrame:SetSize(370, 495)
optFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
optFrame:SetFrameStrata("DIALOG")
optFrame:SetBackdrop({
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 14,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
optFrame:SetBackdropColor(0.06, 0.07, 0.11, 0.98)
optFrame:SetBackdropBorderColor(0.25, 0.55, 0.75, 1)
optFrame:SetMovable(true)
optFrame:EnableMouse(true)
optFrame:RegisterForDrag("LeftButton")
optFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
optFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
optFrame:Hide()

local optTitleBar = CreateFrame("Frame", nil, optFrame, BackdropTemplateMixin and "BackdropTemplate")
optTitleBar:SetPoint("TOPLEFT", optFrame, "TOPLEFT", 4, -4)
optTitleBar:SetPoint("TOPRIGHT", optFrame, "TOPRIGHT", -4, -4)
optTitleBar:SetHeight(24)
optTitleBar:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
optTitleBar:SetBackdropColor(0.10, 0.16, 0.24, 0.95)

local optCrest = CreateSquareFWLogo(optTitleBar)
optCrest:SetPoint("LEFT", optTitleBar, "LEFT", 4, 0)

local optHeader = optTitleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
optHeader:SetPoint("LEFT", optCrest, "RIGHT", 6, 0)
optHeader:SetText("|cff00ccffFord's|r |cff00ff96RestedGuide|r - Settings (v11.8)")

local optCloseBtn = CreateFrame("Button", nil, optTitleBar, "UIPanelButtonTemplate")
optCloseBtn:SetSize(20, 18)
optCloseBtn:SetPoint("RIGHT", optTitleBar, "RIGHT", -4, 0)
optCloseBtn:SetText("X")
optCloseBtn:SetScript("OnClick", function() optFrame:Hide() end)

crestBox:SetScript("OnClick", function()
    if optFrame:IsShown() then optFrame:Hide() else optFrame:Show() end
end)

local function ApplyVisualSettings()
    EnsureDefaults()
    frame:SetScale(FordsRestedGuideDB.scale or 1.0)
    frame:SetBackdropColor(0.05, 0.06, 0.09, FordsRestedGuideDB.alpha or 0.95)
    if FordsRestedGuideDB.showArrow then arrowBox:Show() else arrowBox:Hide() end
    if FordsRestedGuideDB.showXPBar then xpInfoBar:Show() else xpInfoBar:Hide() end
    if FordsRestedGuideDB.minimapHide then
        miniBtn:Hide()
    else
        miniBtn:Show()
        UpdateMinimapButtonPosition()
    end
end

local function CreateCheckOption(parent, label, yOffset, dbKey)
    local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)
    local text = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("LEFT", cb, "RIGHT", 4, 0)
    text:SetText(label)
    cb:SetScript("OnShow", function(self)
        EnsureDefaults()
        self:SetChecked(FordsRestedGuideDB[dbKey])
    end)
    cb:SetScript("OnClick", function(self)
        FordsRestedGuideDB[dbKey] = self:GetChecked() and true or false
        ApplyVisualSettings()
    end)
    return cb
end

CreateCheckOption(optFrame, "Lock Guide Window Position", -34, "locked")
CreateCheckOption(optFrame, "Show 3D Waypoint Arrow", -60, "showArrow")
CreateCheckOption(optFrame, "Hide 'FW' Minimap Icon", -86, "minimapHide")
CreateCheckOption(optFrame, "Auto-Advance When Hub Quests Complete", -112, "autoAdvance")
CreateCheckOption(optFrame, "Auto-Accept & Auto-Turn-In Quests (Hold Shift to Pause)", -138, "autoQuest")
CreateCheckOption(optFrame, "Show Live XP/Hr, Time-to-Level & Rested XP Bar", -164, "showXPBar")

local raceLabel = optFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
raceLabel:SetPoint("TOPLEFT", optFrame, "TOPLEFT", 18, -196)
raceLabel:SetText("Faction & Starting Zone Route (Click to Cycle):")

local raceSelectBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
raceSelectBtn:SetSize(334, 24)
raceSelectBtn:SetPoint("TOPLEFT", raceLabel, "BOTTOMLEFT", 0, -4)

local scaleLabel = optFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
scaleLabel:SetPoint("TOPLEFT", optFrame, "TOPLEFT", 18, -248)
scaleLabel:SetText("Window Scale: 100%")

local scaleDownBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
scaleDownBtn:SetSize(45, 22)
scaleDownBtn:SetPoint("TOPLEFT", scaleLabel, "BOTTOMLEFT", 0, -4)
scaleDownBtn:SetText("-10%")

local scaleUpBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
scaleUpBtn:SetSize(45, 22)
scaleUpBtn:SetPoint("LEFT", scaleDownBtn, "RIGHT", 6, 0)
scaleUpBtn:SetText("+10%")

local alphaLabel = optFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
alphaLabel:SetPoint("TOPLEFT", optFrame, "TOPLEFT", 195, -248)
alphaLabel:SetText("Opacity: 95%")

local alphaDownBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
alphaDownBtn:SetSize(45, 22)
alphaDownBtn:SetPoint("TOPLEFT", alphaLabel, "BOTTOMLEFT", 0, -4)
alphaDownBtn:SetText("-10%")

local alphaUpBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
alphaUpBtn:SetSize(45, 22)
alphaUpBtn:SetPoint("LEFT", alphaDownBtn, "RIGHT", 6, 0)
alphaUpBtn:SetText("+10%")

local radLabel = optFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
radLabel:SetPoint("TOPLEFT", optFrame, "TOPLEFT", 18, -300)
radLabel:SetText("Minimap Icon Ring Distance: +5 px")

local radDownBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
radDownBtn:SetSize(75, 22)
radDownBtn:SetPoint("TOPLEFT", radLabel, "BOTTOMLEFT", 0, -4)
radDownBtn:SetText("Closer -")

local radUpBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
radUpBtn:SetSize(75, 22)
radUpBtn:SetPoint("LEFT", radDownBtn, "RIGHT", 6, 0)
radUpBtn:SetText("Further +")

local radResetBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
radResetBtn:SetSize(75, 22)
radResetBtn:SetPoint("LEFT", radUpBtn, "RIGHT", 6, 0)
radResetBtn:SetText("Default")

local function RefreshSlidersText()
    EnsureDefaults()
    scaleLabel:SetText("Window Scale: " .. math.floor((FordsRestedGuideDB.scale or 1.0) * 100 + 0.5) .. "%")
    alphaLabel:SetText("Opacity: " .. math.floor((FordsRestedGuideDB.alpha or 0.95) * 100 + 0.5) .. "%")
    local mode = FordsRestedGuideDB.raceRoute or "AUTO"
    raceSelectBtn:SetText(RACE_LABELS[mode] or RACE_LABELS["AUTO"])
    local off = FordsRestedGuideDB.minimapOffset or 5
    local sign = off >= 0 and "+" or ""
    radLabel:SetText("Minimap Icon Ring Distance: " .. sign .. off .. " px")
end

scaleDownBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.scale = math.max(0.7, (FordsRestedGuideDB.scale or 1.0) - 0.1)
    RefreshSlidersText(); ApplyVisualSettings()
end)
scaleUpBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.scale = math.min(1.4, (FordsRestedGuideDB.scale or 1.0) + 0.1)
    RefreshSlidersText(); ApplyVisualSettings()
end)
alphaDownBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.alpha = math.max(0.3, (FordsRestedGuideDB.alpha or 0.95) - 0.1)
    RefreshSlidersText(); ApplyVisualSettings()
end)
alphaUpBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.alpha = math.min(1.0, (FordsRestedGuideDB.alpha or 0.95) + 0.1)
    RefreshSlidersText(); ApplyVisualSettings()
end)
radDownBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.minimapOffset = (FordsRestedGuideDB.minimapOffset or 5) - 2
    RefreshSlidersText(); UpdateMinimapButtonPosition()
end)
radUpBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.minimapOffset = (FordsRestedGuideDB.minimapOffset or 5) + 2
    RefreshSlidersText(); UpdateMinimapButtonPosition()
end)
radResetBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.minimapOffset = 5
    RefreshSlidersText(); UpdateMinimapButtonPosition()
end)

optFrame:SetScript("OnShow", RefreshSlidersText)

local UpdateDisplay -- forward declaration

local resetPosBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
resetPosBtn:SetSize(160, 24)
resetPosBtn:SetPoint("BOTTOMLEFT", optFrame, "BOTTOMLEFT", 16, 76)
resetPosBtn:SetText("Reset Window Pos")
resetPosBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.pos = nil
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", 350, 100)
    frame:Show()
end)

local forceSyncBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
forceSyncBtn:SetSize(160, 24)
forceSyncBtn:SetPoint("BOTTOMRIGHT", optFrame, "BOTTOMRIGHT", -16, 76)
forceSyncBtn:SetText("Run Smart Auto-Sync")

local clearManualBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
clearManualBtn:SetSize(338, 24)
clearManualBtn:SetPoint("BOTTOM", optFrame, "BOTTOM", 0, 44)
clearManualBtn:SetText("Clear Manually Checked Quests")
clearManualBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.manualDone = {}
    if UpdateDisplay then UpdateDisplay() end
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r Cleared manual quest checks.")
end)

local resetStepBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
resetStepBtn:SetSize(338, 24)
resetStepBtn:SetPoint("BOTTOM", optFrame, "BOTTOM", 0, 14)
resetStepBtn:SetText("Reset Guide to Step 1 (Starter Zone)")

cfgBtn:SetScript("OnClick", function()
    if optFrame:IsShown() then optFrame:Hide() else optFrame:Show() end
end)

-- ==========================================
-- CORE QUEST, AUTO-SYNC & CLICKABLE CHECKLIST
-- ==========================================
local function ParseCoords(coordStr)
    if not coordStr then return nil, nil end
    local x, y = string.match(coordStr, "([%d%.]+)%s*,%s*([%d%.]+)")
    if x and y then return tonumber(x) / 100, tonumber(y) / 100 end
    return nil, nil
end

local function RefreshServerQuestCache()
    if QueryQuestsCompleted then pcall(QueryQuestsCompleted) end
    if GetQuestsCompleted then
        local ok, res = pcall(GetQuestsCompleted)
        if ok and type(res) == "table" then
            for qid, val in pairs(res) do
                if val then serverCompletedCache[tonumber(qid) or qid] = true end
            end
        end
    end
end

local function IsSingleIDCompleted(questID)
    if not questID then return false end
    local numID = tonumber(questID) or questID
    if serverCompletedCache[numID] then return true end
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        local ok, res = pcall(C_QuestLog.IsQuestFlaggedCompleted, numID)
        if ok and res == true then
            serverCompletedCache[numID] = true
            return true
        end
    end
    if IsQuestFlaggedCompleted then
        local ok, res = pcall(IsQuestFlaggedCompleted, numID)
        if ok and res == true then
            serverCompletedCache[numID] = true
            return true
        end
    end
    return false
end

local function GetQuestManualKey(q)
    if not q then return "unknown" end
    return string.lower(tostring(q.name or q.id or "unknown"))
end

local function IsQuestDoneOnServer(qOrID, optName)
    EnsureDefaults()
    local qID = type(qOrID) == "table" and qOrID.id or qOrID
    local qName = type(qOrID) == "table" and qOrID.name or optName

    if type(qOrID) == "table" then
        local mKey = GetQuestManualKey(qOrID)
        if FordsRestedGuideDB.manualDone[mKey] ~= nil then
            return FordsRestedGuideDB.manualDone[mKey]
        end
    elseif qName then
        local mKey = string.lower(tostring(qName))
        if FordsRestedGuideDB.manualDone[mKey] ~= nil then
            return FordsRestedGuideDB.manualDone[mKey]
        end
    end

    if qID then
        if type(qID) == "table" then
            for _, idVal in ipairs(qID) do
                if IsSingleIDCompleted(idVal) then return true end
            end
        elseif IsSingleIDCompleted(qID) then
            return true
        end
    end

    if qName then
        local lowName = string.lower(qName)
        local stripped = string.gsub(lowName, "%s*%b()", "")
        local idList = QUEST_NAME_FALLBACK_IDS[lowName] or QUEST_NAME_FALLBACK_IDS[stripped]
        if idList then
            for _, altID in ipairs(idList) do
                if IsSingleIDCompleted(altID) then return true end
            end
        end
        for pat, altList in pairs(QUEST_NAME_FALLBACK_IDS) do
            if string.find(lowName, pat, 1, true) then
                for _, altID in ipairs(altList) do
                    if IsSingleIDCompleted(altID) then return true end
                end
            end
        end
    end

    return false
end

local function GetQuestLogState(questName, questID)
    if not questName and not questID then return false, false, nil end
    if not GetNumQuestLogEntries or not GetQuestLogTitle then return false, false, nil end

    local numEntries = GetNumQuestLogEntries() or 0
    for i = 1, numEntries do
        local qTitle, _, _, isHeader, _, isComplete, _, qID = GetQuestLogTitle(i)
        if not isHeader and qTitle then
            local idMatch = (questID and qID and tonumber(questID) == tonumber(qID))
            local nameMatch = (questName and string.find(string.lower(qTitle), string.lower(questName), 1, true))
            if idMatch or nameMatch then
                local comp = (isComplete == 1 or isComplete == true)
                return true, comp, i
            end
        end
    end
    return false, false, nil
end

local function ShouldSkipStep(step, playerLvl)
    if step.quests then
        for _, q in ipairs(step.quests) do
            local inLog = GetQuestLogState(q.name, q.id)
            if inLog and not IsQuestDoneOnServer(q) then
                return false
            end
        end
    end
    if step.maxLevel and playerLvl > step.maxLevel then
        return true
    end
    if step.quests and #step.quests > 0 then
        local allDone = true
        for _, q in ipairs(step.quests) do
            if not IsQuestDoneOnServer(q) then
                allDone = false
                break
            end
        end
        if allDone then return true end
    end
    return false
end

local function SyncTomTom(coordsStr, labelText)
    if not TomTom or not TomTom.AddWaypoint then return end
    if lastTomTomUID and TomTom.RemoveWaypoint then
        pcall(function() TomTom:RemoveWaypoint(lastTomTomUID) end)
    end
    local tx, ty = ParseCoords(coordsStr)
    if tx and ty and C_Map and C_Map.GetBestMapForUnit then
        local mapID = C_Map.GetBestMapForUnit("player")
        if mapID then
            local ok, uid = pcall(function()
                return TomTom:AddWaypoint(mapID, tx, ty, { title = labelText or "Ford's RestedGuide" })
            end)
            if ok then lastTomTomUID = uid end
        end
    end
end

local function GetOrCreateQuestRow(idx)
    if questRows[idx] then return questRows[idx] end
    local btn = CreateFrame("Button", nil, scrollChild)
    btn:SetWidth(365)
    btn:SetHeight(18)
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    local hl = btn:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints(btn)
    hl:SetColorTexture(0.25, 0.55, 0.85, 0.20)

    local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fs:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -1)
    fs:SetWidth(360)
    fs:SetJustifyH("LEFT")
    btn.text = fs

    btn:SetScript("OnEnter", function(self)
        if self.qData then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.qData.name or "Quest", 1, 0.85, 0.2)
            if self.qData.npc then GameTooltip:AddLine("NPC / Info: " .. self.qData.npc, 0.8, 0.9, 1.0) end
            if self.qData.coords then GameTooltip:AddLine("Coords: " .. self.qData.coords, 0.6, 1.0, 0.6) end
            GameTooltip:AddLine("|cff00ff96Left-Click:|r Lock Waypoint Arrow & Target NPC", 1, 1, 1)
            GameTooltip:AddLine("|cff00ccffRight-Click:|r Toggle Completed [x]", 1, 1, 1)
            GameTooltip:Show()
        end
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    btn:SetScript("OnClick", function(self, mouseBtn)
        if mouseBtn == "RightButton" and self.qData then
            EnsureDefaults()
            local mKey = GetQuestManualKey(self.qData)
            local currentlyDone = IsQuestDoneOnServer(self.qData)
            FordsRestedGuideDB.manualDone[mKey] = not currentlyDone
            UpdateDisplay()
        else
            if lockedQuestIdx == idx then
                lockedQuestIdx = nil
            else
                lockedQuestIdx = idx
            end
            UpdateDisplay()
        end
    end)

    questRows[idx] = btn
    return btn
end

UpdateDisplay = function()
    EnsureDefaults()
    RefreshServerQuestCache()
    RebuildActiveRoute()
    local total = #activeSteps
    if total == 0 then return end

    local idx = FordsRestedGuideDB and FordsRestedGuideDB.step or 1
    if idx < 1 then idx = 1 end
    if idx > total then idx = total end
    if FordsRestedGuideDB then FordsRestedGuideDB.step = idx end

    local step = activeSteps[idx]
    local badge = TYPE_COLORS[step.type] or ""
    local activeQ = (lockedQuestIdx and step.quests and step.quests[lockedQuestIdx]) or nil
    local activeCoords = (activeQ and (activeQ.coords or activeQ.npc)) or step.coords
    local activeNPC = (activeQ and activeQ.npc and string.gsub(activeQ.npc, "%s*%b()", "")) or step.npc

    local coordStr = step.coords and (" |cffaaaaaa(" .. step.coords .. ")|r") or ""
    local lvlStr = (step.minLevel and step.maxLevel) and (" |cff88ff88[Lvl " .. step.minLevel .. "-" .. step.maxLevel .. "]|r") or ""
    local npcStr = activeNPC and ("\n|cffffcc00Target:|r " .. activeNPC) or ""

    stepCounter:SetText("[" .. activeRouteTag .. "] " .. idx .. "/" .. total)
    zoneText:SetText((step.zone or "Unknown Zone") .. coordStr .. lvlStr .. npcStr)
    titleText:SetText(badge .. (step.title or ""))
    noteText:SetText(step.note or "")

    for _, r in pairs(questRows) do r:Hide() end

    local yOffset = 0
    local totalQuests = step.quests and #step.quests or 0
    local doneCount = 0

    if step.quests then
        for i, q in ipairs(step.quests) do
            local row = GetOrCreateQuestRow(i)
            row.qData = q
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -yOffset)

            local doneServer = IsQuestDoneOnServer(q)
            local inLog, isComplete, logIndex = GetQuestLogState(q.name, q.id)
            local prefix = (lockedQuestIdx == i) and "|cff00ffff>> |r" or ""
            local npcNote = q.npc and (" |cffaaaaaa- " .. q.npc .. "|r") or ""
            local lineStr = ""

            if doneServer then
                doneCount = doneCount + 1
                lineStr = prefix .. "|cff777777[x] " .. q.name .. " (Completed)|r"
            elseif inLog and isComplete then
                doneCount = doneCount + 1
                lineStr = prefix .. "|cff44ff44[*] " .. q.name .. " (Ready to Turn In!)|r" .. npcNote
            elseif inLog then
                lineStr = prefix .. "|cff44ccff[+] " .. q.name .. " (In Quest Log)|r" .. npcNote
                if logIndex and GetNumQuestLeaderBoards and GetQuestLogLeaderBoard then
                    local ok, numObj = pcall(GetNumQuestLeaderBoards, logIndex)
                    if ok and numObj and numObj > 0 then
                        for j = 1, numObj do
                            local ok2, text, _, finished = pcall(GetQuestLogLeaderBoard, j, logIndex)
                            if ok2 and text then
                                local col = (finished == 1 or finished == true) and "|cff44ff44" or "|cffdddddd"
                                lineStr = lineStr .. "\n    " .. col .. "- " .. text .. "|r"
                            end
                        end
                    end
                end
            else
                lineStr = prefix .. "|cffffd100[ ] " .. q.name .. "|r" .. npcNote
            end

            row.text:SetText(lineStr)
            local h = math.max(18, (row.text:GetStringHeight() or 16) + 4)
            row:SetHeight(h)
            row:Show()
            yOffset = yOffset + h
        end
    end

    scrollChild:SetHeight(math.max(120, yOffset + 10))

    progBar:SetMinMaxValues(0, math.max(1, totalQuests))
    progBar:SetValue(doneCount)
    local pct = totalQuests > 0 and math.floor((doneCount / totalQuests) * 100) or 0
    progText:SetText("Hub Progress: " .. doneCount .. " / " .. totalQuests .. " (" .. pct .. "%)  [Right-Click: Mark All]")

    if not InCombatLockdown() then
        if activeNPC then
            targetBtn:SetAttribute("macrotext", "/targetexact " .. activeNPC .. "\n/target " .. activeNPC)
            targetBtn:SetText("Target: " .. string.sub(activeNPC, 1, 11))
            targetBtn:Enable()
        else
            targetBtn:SetAttribute("macrotext", "")
            targetBtn:SetText("No NPC")
            targetBtn:Disable()
        end
    end

    UpdateHearthstoneButton()
    SyncTomTom(activeCoords, (activeQ and activeQ.name) or step.title)
end

progBar:SetScript("OnMouseUp", function(self, button)
    if button == "RightButton" then
        EnsureDefaults()
        local step = activeSteps[FordsRestedGuideDB.step or 1]
        if step and step.quests then
            local allDone = true
            for _, q in ipairs(step.quests) do
                if not IsQuestDoneOnServer(q) then allDone = false; break end
            end
            for _, q in ipairs(step.quests) do
                FordsRestedGuideDB.manualDone[GetQuestManualKey(q)] = not allDone
            end
            UpdateDisplay()
        end
    end
end)

local function AutoSyncRoute(announce)
    RefreshServerQuestCache()
    RebuildActiveRoute()
    if #activeSteps == 0 then return end

    if ExpandQuestHeader then pcall(ExpandQuestHeader, 0) end

    local playerLvl = UnitLevel("player") or 1
    local bestStep = nil

    for i, step in ipairs(activeSteps) do
        if step.quests then
            for _, q in ipairs(step.quests) do
                local inLog = GetQuestLogState(q.name, q.id)
                if inLog and not IsQuestDoneOnServer(q) then
                    bestStep = i
                    break
                end
            end
        end
        if bestStep then break end
    end

    if not bestStep then
        for i, step in ipairs(activeSteps) do
            if not ShouldSkipStep(step, playerLvl) then
                bestStep = i
                break
            end
        end
    end

    bestStep = bestStep or #activeSteps
    lockedQuestIdx = nil
    FordsRestedGuideDB.step = bestStep
    FordsRestedGuideDB.version = "11.8"

    if announce then
        local s = activeSteps[bestStep]
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r Synced [" .. activeRouteTag .. " Lvl " .. playerLvl .. "] -> Step " .. bestStep .. ": |cffffd100" .. (s and s.title or "") .. "|r")
    end
end

raceSelectBtn:SetScript("OnClick", function()
    local cur = FordsRestedGuideDB.raceRoute or "AUTO"
    local nextIdx = 1
    for i, k in ipairs(RACE_CYCLE) do
        if k == cur then
            nextIdx = (i % #RACE_CYCLE) + 1
            break
        end
    end
    FordsRestedGuideDB.raceRoute = RACE_CYCLE[nextIdx]
    RefreshSlidersText()
    AutoSyncRoute(true)
    UpdateDisplay()
end)

local function IsQuestInCurrentStep(title)
    if not title then return false end
    local step = activeSteps[FordsRestedGuideDB and FordsRestedGuideDB.step or 1]
    if not step or not step.quests then return false end
    local lowTitle = string.lower(title)
    for _, q in ipairs(step.quests) do
        if q.name and string.find(lowTitle, string.lower(q.name), 1, true) then
            return true
        end
    end
    return false
end

local elapsedAccum = 0
local hsAccum = 0

frame:SetScript("OnUpdate", function(self, elapsed)
    local dt = elapsed or 0.05
    elapsedAccum = elapsedAccum + dt
    hsAccum = hsAccum + dt

    if hsAccum >= 0.5 then
        hsAccum = 0
        UpdateHearthstoneButton()

        if FordsRestedGuideDB and FordsRestedGuideDB.showXPBar then
            local curXP = UnitXP("player") or 0
            local maxXP = UnitXPMax("player") or 1
            local rested = GetXPExhaustion() or 0
            local restPct = math.floor((rested / maxXP) * 100 + 0.5)
            local dtSession = math.max(1, GetTime() - sessionStartTime)
            local xphr = math.floor((sessionGainedXP / dtSession) * 3600)
            local remXP = math.max(0, maxXP - curXP)
            local ttlStr = "--"
            if xphr > 100 then
                local mins = math.ceil((remXP / xphr) * 60)
                ttlStr = mins .. "m"
            end
            xpInfoBar:SetText(string.format("XP/hr: %.1fk | Next Lvl: %s | Rested: %d%%", xphr / 1000, ttlStr, restPct))
        end
    end

    if elapsedAccum < 0.1 then return end
    elapsedAccum = 0

    if not FordsRestedGuideDB or not FordsRestedGuideDB.showArrow then return end
    local step = activeSteps[FordsRestedGuideDB.step or 1]
    if not step then return end

    local activeQ = (lockedQuestIdx and step.quests and step.quests[lockedQuestIdx]) or nil
    local tx, ty = ParseCoords((activeQ and (activeQ.coords or activeQ.npc)) or step.coords)
    if not tx or not ty then
        distText:SetText("--")
        arrowBox:SetBackdropBorderColor(0.3, 0.6, 0.8, 1)
        return
    end

    local px, py = nil, nil
    if C_Map and C_Map.GetBestMapForUnit and C_Map.GetPlayerMapPosition then
        local mapID = C_Map.GetBestMapForUnit("player")
        if mapID then
            local pos = C_Map.GetPlayerMapPosition(mapID, "player")
            if pos then px, py = pos:GetXY() end
        end
    elseif GetPlayerMapPosition then
        px, py = GetPlayerMapPosition("player")
    end

    if not px or not py or (px == 0 and py == 0) then
        distText:SetText("Zone")
        arrowBox:SetBackdropBorderColor(0.3, 0.6, 0.8, 1)
        return
    end

    local dx = tx - px
    local dy = ty - py
    local distYards = math.floor(math.sqrt(dx * dx + dy * dy) * 3500)
    distText:SetText(distYards .. " yd")

    if distYards < 40 then
        arrowBox:SetBackdropBorderColor(0.2, 1.0, 0.4, 1)
        distText:SetTextColor(0.3, 1.0, 0.4)
    elseif distYards < 150 then
        arrowBox:SetBackdropBorderColor(1.0, 0.85, 0.2, 1)
        distText:SetTextColor(1.0, 0.9, 0.3)
    else
        arrowBox:SetBackdropBorderColor(0.3, 0.6, 0.8, 1)
        distText:SetTextColor(0.9, 0.9, 0.9)
    end

    local angle = math.atan2(-dx, -dy)
    local facing = GetPlayerFacing and GetPlayerFacing() or 0
    if arrowTex.SetRotation then
        arrowTex:SetRotation(angle - facing)
    end
end)

prevBtn:SetScript("OnClick", function()
    lockedQuestIdx = nil
    FordsRestedGuideDB.step = (FordsRestedGuideDB.step or 1) - 1
    UpdateDisplay()
end)

syncBtn:SetScript("OnClick", function()
    AutoSyncRoute(true)
    UpdateDisplay()
end)

nextBtn:SetScript("OnClick", function()
    lockedQuestIdx = nil
    FordsRestedGuideDB.step = (FordsRestedGuideDB.step or 1) + 1
    UpdateDisplay()
end)

miniBtn:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        if optFrame:IsShown() then optFrame:Hide() else optFrame:Show() end
    elseif button == "MiddleButton" then
        AutoSyncRoute(true)
        UpdateDisplay()
    else
        if frame:IsShown() then frame:Hide() else frame:Show() end
    end
end)

forceSyncBtn:SetScript("OnClick", function()
    AutoSyncRoute(true)
    UpdateDisplay()
end)

resetStepBtn:SetScript("OnClick", function()
    lockedQuestIdx = nil
    FordsRestedGuideDB.step = 1
    UpdateDisplay()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r Reset to Step 1.")
end)

frame:SetScript("OnMouseWheel", function(self, delta)
    if IsShiftKeyDown() then
        lockedQuestIdx = nil
        if delta > 0 then
            FordsRestedGuideDB.step = (FordsRestedGuideDB.step or 1) - 1
        else
            FordsRestedGuideDB.step = (FordsRestedGuideDB.step or 1) + 1
        end
        UpdateDisplay()
    end
end)

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("BAG_UPDATE_COOLDOWN")
frame:RegisterEvent("QUEST_LOG_UPDATE")
frame:RegisterEvent("QUEST_TURNED_IN")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PLAYER_XP_UPDATE")
frame:RegisterEvent("QUEST_DETAIL")
frame:RegisterEvent("QUEST_PROGRESS")
frame:RegisterEvent("QUEST_COMPLETE")

local lastRawXP = nil

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        EnsureDefaults()
        if FordsRestedGuideDB.pos then
            frame:ClearAllPoints()
            frame:SetPoint(
                FordsRestedGuideDB.pos.point,
                UIParent,
                FordsRestedGuideDB.pos.relPoint,
                FordsRestedGuideDB.pos.x,
                FordsRestedGuideDB.pos.y
            )
        end
        BindHearthstoneAttributes()
        ApplyVisualSettings()
    elseif event == "PLAYER_ENTERING_WORLD" then
        EnsureDefaults()
        RefreshServerQuestCache()
        sessionStartTime = GetTime()
        lastRawXP = UnitXP("player") or 0
        RebuildActiveRoute()
        if not FordsRestedGuideDB.step then
            AutoSyncRoute(true)
        end
        BindHearthstoneAttributes()
        ApplyVisualSettings()
        UpdateDisplay()
    elseif event == "PLAYER_REGEN_ENABLED" then
        if hsNeedsRebind then BindHearthstoneAttributes() end
        UpdateDisplay()
    elseif event == "BAG_UPDATE_COOLDOWN" then
        UpdateHearthstoneButton()
    elseif event == "PLAYER_XP_UPDATE" then
        local cur = UnitXP("player") or 0
        if lastRawXP and cur > lastRawXP then
            sessionGainedXP = sessionGainedXP + (cur - lastRawXP)
        end
        lastRawXP = cur
    elseif event == "QUEST_DETAIL" then
        if FordsRestedGuideDB and FordsRestedGuideDB.autoQuest and not IsShiftKeyDown() then
            local qTitle = GetTitleText and GetTitleText()
            if IsQuestInCurrentStep(qTitle) and AcceptQuest then
                AcceptQuest()
            end
        end
    elseif event == "QUEST_PROGRESS" then
        if FordsRestedGuideDB and FordsRestedGuideDB.autoQuest and not IsShiftKeyDown() then
            local qTitle = GetTitleText and GetTitleText()
            if IsQuestInCurrentStep(qTitle) and IsQuestCompletable and IsQuestCompletable() then
                CompleteQuest()
            end
        end
    elseif event == "QUEST_COMPLETE" then
        if FordsRestedGuideDB and FordsRestedGuideDB.autoQuest and not IsShiftKeyDown() then
            local qTitle = GetTitleText and GetTitleText()
            local numChoices = GetNumQuestChoices and GetNumQuestChoices() or 0
            if IsQuestInCurrentStep(qTitle) and numChoices <= 1 and GetQuestReward then
                GetQuestReward(numChoices == 1 and 1 or nil)
            end
        end
    elseif event == "QUEST_TURNED_IN" then
        if arg1 then serverCompletedCache[tonumber(arg1) or arg1] = true end
        if FordsRestedGuideDB and FordsRestedGuideDB.autoAdvance then
            local step = activeSteps[FordsRestedGuideDB.step or 1]
            if step and ShouldSkipStep(step, UnitLevel("player") or 1) then
                lockedQuestIdx = nil
                FordsRestedGuideDB.step = (FordsRestedGuideDB.step or 1) + 1
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r Hub complete! Auto-advancing.")
            end
        end
        UpdateDisplay()
    elseif event == "QUEST_LOG_UPDATE" or event == "PLAYER_LEVEL_UP" then
        UpdateDisplay()
    end
end)

SLASH_FORDSRESTEDGUIDE1 = "/frg"
SLASH_FORDSRESTEDGUIDE2 = "/ford"
SLASH_FORDSRESTEDGUIDE3 = "/fordsguide"
SlashCmdList["FORDSRESTEDGUIDE"] = function(msg)
    msg = string.lower(msg or "")
    local stepNum = string.match(msg, "step%s+(%d+)")
    if msg == "config" or msg == "options" or msg == "settings" then
        if optFrame:IsShown() then optFrame:Hide() else optFrame:Show() end
    elseif msg == "sync" or msg == "autosync" then
        AutoSyncRoute(true)
        UpdateDisplay()
    elseif msg == "reset" then
        lockedQuestIdx = nil
        FordsRestedGuideDB.step = 1
        UpdateDisplay()
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r Reset to Step 1.")
    elseif stepNum then
        lockedQuestIdx = nil
        FordsRestedGuideDB.step = tonumber(stepNum)
        UpdateDisplay()
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r Jumped to Step " .. stepNum .. ".")
    elseif msg == "show" then
        frame:Show()
    elseif msg == "hide" then
        frame:Hide()
    else
        if frame:IsShown() then frame:Hide() else frame:Show() end
    end
end