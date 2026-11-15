local ADDON_NAME = "FordsRestedGuide"
local lastTomTomUID = nil
local isCollapsed = false
local selectedQuestIdx = nil

-- Session XP tracking variables (#5)
local sessionStartTime = GetTime()
local sessionGainedXP = 0
local lastKnownXP = nil
local lastKnownMaxXP = nil

local TYPE_COLORS = {
    ACCEPT   = "|cff44ff44[ACCEPT]|r ",
    COMPLETE = "|cffffd100[OBJECTIVE]|r ",
    TURNIN   = "|cff44ccff[TURN IN]|r ",
    TRAVEL   = "|cffff8844[TRAVEL]|r ",
    DUNGEON  = "|cffff44ff[DUNGEON]|r ",
    GRIND    = "|cffcccccc[GRIND]|r "
}

local ROUTE_ORDER = { "AUTO", "Undead", "OrcTroll", "Tauren", "Skyborne" }
local ROUTE_LABELS = {
    ["AUTO"]     = "Auto-Detect Race",
    ["Undead"]   = "Undead (Tirisfal Glades)",
    ["OrcTroll"] = "Orc / Troll (Durotar)",
    ["Tauren"]   = "Tauren (Mulgore)",
    ["Skyborne"] = "Windshaper Skyborne (Zephras Isle)"
}

local CLASS_ORDER = { "AUTO", "WARRIOR", "MAGE", "WARLOCK", "ROGUE", "PRIEST", "SHAMAN", "HUNTER", "DRUID", "PALADIN" }

local DEFAULT_SETTINGS = {
    step = 1,
    version = "10.1",
    routeMode = "AUTO",
    classMode = "AUTO",
    showClassQuests = true,
    autoQuestAccept = false,
    showXPTracker = false,
    locked = false,
    showArrow = true,
    minimapHide = false,
    minimapAngle = 205,
    minimapOffset = 5,
    autoAdvance = true,
    scale = 1.0,
    alpha = 0.95
}

local function EnsureDefaults()
    FordsRestedGuideDB = FordsRestedGuideDB or {}
    for k, v in pairs(DEFAULT_SETTINGS) do
        if FordsRestedGuideDB[k] == nil then
            FordsRestedGuideDB[k] = v
        end
    end
    FordsRestedGuideDB.manualDone = FordsRestedGuideDB.manualDone or {}
end

local function GetActiveRouteKey()
    EnsureDefaults()
    local mode = FordsRestedGuideDB.routeMode or "AUTO"
    if mode ~= "AUTO" and FordsRestedGuide_Routes and FordsRestedGuide_Routes[mode] then
        return mode
    end

    local raceLoc, raceFile = UnitRace("player")
    local rCombined = string.lower((raceLoc or "") .. " " .. (raceFile or ""))
    local curZone = string.lower(GetRealZoneText and GetRealZoneText() or "")

    if string.find(rCombined, "sky") or string.find(rCombined, "windshaper") or string.find(rCombined, "shen") or string.find(curZone, "zephras") then
        return "Skyborne"
    elseif raceFile == "Scourge" then
        return "Undead"
    elseif raceFile == "Tauren" then
        return "Tauren"
    elseif raceFile == "Orc" or raceFile == "Troll" or raceFile == "Goblin" then
        return "OrcTroll"
    end
    return "Undead"
end

local function GetActiveClassKey()
    EnsureDefaults()
    local mode = FordsRestedGuideDB.classMode or "AUTO"
    if mode ~= "AUTO" then
        return mode
    end
    local _, classFile = UnitClass("player")
    return classFile or "WARRIOR"
end

local function CreateFWCrest(parent)
    local crest = CreateFrame("Frame", nil, parent)
    crest:SetSize(24, 24)

    local bg = crest:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(16, 16)
    bg:SetPoint("TOPLEFT", crest, "TOPLEFT", 4, -4)
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    bg:SetVertexColor(0.05, 0.12, 0.20, 1)

    local txt = crest:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    txt:SetPoint("CENTER", crest, "CENTER", 0, 0)
    txt:SetText("|cff00ccffF|r|cff00ff96W|r")

    local ring = crest:CreateTexture(nil, "OVERLAY")
    ring:SetSize(40, 40)
    ring:SetPoint("TOPLEFT", crest, "TOPLEFT", 0, 0)
    ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    return crest
end

local function ParseCoords(coordStr)
    if not coordStr then return nil, nil end
    local x, y = string.match(coordStr, "([%d%.]+)%s*,%s*([%d%.]+)")
    if x and y then
        return tonumber(x) / 100, tonumber(y) / 100, x .. ", " .. y
    end
    return nil, nil, nil
end

local function ExtractCleanNPCName(npcString)
    if not npcString then return nil end
    local clean = string.match(npcString, "^([^%(%-]+)") or npcString
    clean = string.gsub(clean, "^%s+", "")
    clean = string.gsub(clean, "%s+$", "")
    if clean == "" or string.find(clean, "Spawns") or string.find(clean, "Parts") or string.find(clean, "Drop") or string.find(clean, "Hub") then
        return nil
    end
    return clean
end

-- ==========================================
-- MAIN TRACKER WINDOW
-- ==========================================
local frame = CreateFrame("Frame", "FordsRestedGuideFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
frame:SetSize(410, 395)
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
    if not FordsRestedGuideDB.locked then
        self:StartMoving()
    end
end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, relPoint, x, y = self:GetPoint()
    FordsRestedGuideDB.pos = { point = point, relPoint = relPoint, x = x, y = y }
end)

-- Top Title Bar Banner
local titleBar = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
titleBar:SetHeight(26)
titleBar:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
titleBar:SetBackdropColor(0.10, 0.16, 0.24, 0.95)

local headerCrest = CreateFWCrest(titleBar)
headerCrest:SetPoint("LEFT", titleBar, "LEFT", 4, 0)

local header = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
header:SetPoint("LEFT", headerCrest, "RIGHT", 4, 0)
header:SetText("|cff00ccffFord's|r |cff00ff96RestedGuide|r")

local stepCounter = titleBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
stepCounter:SetPoint("LEFT", header, "RIGHT", 8, 0)

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

-- Content Container
local body = CreateFrame("Frame", nil, frame)
body:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, -4)
body:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)

-- Waypoint Arrow Box (Top-Right of Body)
local arrowBox = CreateFrame("Frame", nil, body, BackdropTemplateMixin and "BackdropTemplate")
arrowBox:SetSize(52, 52)
arrowBox:SetPoint("TOPRIGHT", body, "TOPRIGHT", -6, -2)
arrowBox:SetBackdrop({
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 8, edgeSize = 10,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
arrowBox:SetBackdropColor(0.02, 0.03, 0.05, 0.95)
arrowBox:SetBackdropBorderColor(0.3, 0.6, 0.8, 1)

local arrowTex = arrowBox:CreateTexture(nil, "ARTWORK")
arrowTex:SetSize(28, 28)
arrowTex:SetPoint("TOP", arrowBox, "TOP", 0, -5)
arrowTex:SetTexture("Interface\\Minimap\\MinimapArrow")

local distText = arrowBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
distText:SetPoint("BOTTOM", arrowBox, "BOTTOM", 0, 4)
distText:SetText("-- yd")

-- Zone & Active Waypoint Target Subheader
local zoneText = body:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
zoneText:SetPoint("TOPLEFT", body, "TOPLEFT", 8, -4)
zoneText:SetWidth(330)
zoneText:SetJustifyH("LEFT")
zoneText:SetTextColor(0.60, 0.85, 1.0)

-- Step Title
local titleText = body:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("TOPLEFT", zoneText, "BOTTOMLEFT", 0, -4)
titleText:SetWidth(330)
titleText:SetJustifyH("LEFT")

-- #6 Flight Path & Hearthstone Reminder Banner
local reminderText = body:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
reminderText:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -4)
reminderText:SetWidth(385)
reminderText:SetJustifyH("LEFT")
reminderText:SetTextColor(1.0, 0.82, 0.25)

-- Step Description
local noteText = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
noteText:SetPoint("TOPLEFT", reminderText, "BOTTOMLEFT", 0, -4)
noteText:SetWidth(385)
noteText:SetJustifyH("LEFT")
noteText:SetTextColor(0.90, 0.90, 0.90)

-- #4 Scrollable Interactive Quest Checklist Area
local scrollFrame = CreateFrame("ScrollFrame", "FordsRestedGuideScrollFrame", body, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", noteText, "BOTTOMLEFT", 0, -6)
scrollFrame:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", -26, 68)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(355, 240)
scrollFrame:SetScrollChild(scrollChild)

local questRowButtons = {}

-- #5 Optional XP/Hr, TTL & Rested XP Strip
local xpStrip = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
xpStrip:SetPoint("BOTTOMLEFT", body, "BOTTOMLEFT", 8, 50)
xpStrip:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", -8, 50)
xpStrip:SetJustifyH("CENTER")
xpStrip:SetTextColor(0.65, 0.90, 1.0)
xpStrip:Hide()

-- Hub Quest Completion Progress Bar
local progBar = CreateFrame("StatusBar", nil, body, BackdropTemplateMixin and "BackdropTemplate")
progBar:SetHeight(14)
progBar:SetPoint("BOTTOMLEFT", body, "BOTTOMLEFT", 6, 32)
progBar:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", -6, 32)
progBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
progBar:SetStatusBarColor(0.15, 0.75, 0.35, 0.9)
progBar:SetMinMaxValues(0, 1)
progBar:SetValue(0)

local progBg = progBar:CreateTexture(nil, "BACKGROUND")
progBg:SetAllPoints(progBar)
progBg:SetColorTexture(0.12, 0.12, 0.16, 0.9)

local progText = progBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
progText:SetPoint("CENTER", progBar, "CENTER", 0, 0)
progText:SetText("Hub Progress: 0 / 0")

-- Bottom Navigation Bar
local prevBtn = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
prevBtn:SetSize(54, 22)
prevBtn:SetPoint("BOTTOMLEFT", body, "BOTTOMLEFT", 6, 5)
prevBtn:SetText("< Prev")

local syncBtn = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
syncBtn:SetSize(74, 22)
syncBtn:SetPoint("LEFT", prevBtn, "RIGHT", 4, 0)
syncBtn:SetText("Auto-Sync")

local targetBtn = CreateFrame("Button", nil, body, "SecureActionButtonTemplate,UIPanelButtonTemplate")
targetBtn:SetSize(134, 22)
targetBtn:SetPoint("LEFT", syncBtn, "RIGHT", 4, 0)
targetBtn:SetAttribute("type", "macro")
targetBtn:SetText("Target NPC")

local hearthBtn = CreateFrame("Button", "FordsRestedGuideHearthBtn", body, "SecureActionButtonTemplate,UIPanelButtonTemplate")
hearthBtn:SetSize(58, 22)
hearthBtn:SetPoint("LEFT", targetBtn, "RIGHT", 4, 0)
hearthBtn:SetAttribute("type", "macro")
hearthBtn:SetAttribute("macrotext", "/use Hearthstone")
hearthBtn:SetText("HS: Rdy")
hearthBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("|cff00ff96Hearthstone|r")
    local bindLoc = GetBindLocation and GetBindLocation() or "Unknown Inn"
    GameTooltip:AddLine("Bound to: |cffffd100" .. bindLoc .. "|r", 1, 1, 1)
    GameTooltip:AddLine("|cffaaaaaaClick to use your Hearthstone|r", 0.8, 0.8, 0.8)
    GameTooltip:Show()
end)
hearthBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

local nextBtn = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
nextBtn:SetSize(54, 22)
nextBtn:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", -6, 5)
nextBtn:SetText("Next >")

collapseBtn:SetScript("OnClick", function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        body:Hide()
        frame:SetHeight(34)
        collapseBtn:SetText("+")
    else
        body:Show()
        frame:SetHeight(395)
        collapseBtn:SetText("-")
    end
end)

-- ==========================================
-- "FW" BADGE MINIMAP BUTTON
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
    local activeKey = GetActiveRouteKey()
    local activeClass = GetActiveClassKey()
    local routeObj = FordsRestedGuide_Routes and FordsRestedGuide_Routes[activeKey]
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("|cff00ccffFord's|r |cff00ff96RestedGuide|r |cffaaaaaa(FW v10.1)|r")
    GameTooltip:AddLine("|cff88ff88Route:|r " .. (routeObj and routeObj.name or activeKey) .. " (" .. activeClass .. ")", 1, 1, 1)
    GameTooltip:AddLine("|cffffd100Left-Click:|r Toggle Guide Window", 1, 1, 1)
    GameTooltip:AddLine("|cffffd100Right-Click:|r Open Settings Menu", 1, 1, 1)
    GameTooltip:AddLine("|cffffd100Middle-Click:|r Run Smart Auto-Sync", 1, 1, 1)
    GameTooltip:AddLine("|cffaaaaaaDrag to orbit around Minimap|r", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end)

miniBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-- ==========================================
-- SETTINGS / OPTIONS WINDOW
-- ==========================================
local optFrame = CreateFrame("Frame", "FordsRestedGuideOptionsFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
optFrame:SetSize(360, 560)
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
optTitleBar:SetHeight(26)
optTitleBar:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
optTitleBar:SetBackdropColor(0.10, 0.16, 0.24, 0.95)

local optCrest = CreateFWCrest(optTitleBar)
optCrest:SetPoint("LEFT", optTitleBar, "LEFT", 4, 0)

local optHeader = optTitleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
optHeader:SetPoint("LEFT", optCrest, "RIGHT", 4, 0)
optHeader:SetText("|cff00ccffFord's|r |cff00ff96RestedGuide|r - Settings")

local optCloseBtn = CreateFrame("Button", nil, optTitleBar, "UIPanelButtonTemplate")
optCloseBtn:SetSize(20, 18)
optCloseBtn:SetPoint("RIGHT", optTitleBar, "RIGHT", -4, 0)
optCloseBtn:SetText("X")
optCloseBtn:SetScript("OnClick", function() optFrame:Hide() end)

local UpdateDisplay -- forward declaration

local function ApplyVisualSettings()
    EnsureDefaults()
    frame:SetScale(FordsRestedGuideDB.scale or 1.0)
    frame:SetBackdropColor(0.05, 0.06, 0.09, FordsRestedGuideDB.alpha or 0.95)
    if FordsRestedGuideDB.showArrow then
        arrowBox:Show()
    else
        arrowBox:Hide()
    end
    if FordsRestedGuideDB.minimapHide then
        miniBtn:Hide()
    else
        miniBtn:Show()
        UpdateMinimapButtonPosition()
    end
    if FordsRestedGuideDB.showXPTracker then
        xpStrip:Show()
        scrollFrame:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", -26, 68)
    else
        xpStrip:Hide()
        scrollFrame:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", -26, 52)
    end
    if UpdateDisplay then UpdateDisplay() end
end

local function CreateCheckOption(parent, label, yOffset, dbKey)
    local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)
    local text = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
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
CreateCheckOption(optFrame, "Show Optional Class Quests (w/ Rec Level)", -138, "showClassQuests")
CreateCheckOption(optFrame, "Auto-Accept & Auto-Turn-In Quests (Hold Shift to Pause)", -164, "autoQuestAccept")
CreateCheckOption(optFrame, "Show Live XP/Hr, Time-to-Level & Rested XP Bar", -190, "showXPTracker")

-- Race / Starting Route Selector Box
local raceLabel = optFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
raceLabel:SetPoint("TOPLEFT", optFrame, "TOPLEFT", 18, -228)
raceLabel:SetText("Horde Race / Starting Zone Route:")

local raceDropdownBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
raceDropdownBtn:SetSize(324, 24)
raceDropdownBtn:SetPoint("TOPLEFT", raceLabel, "BOTTOMLEFT", 0, -4)

-- Class Selector Box
local classLabel = optFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
classLabel:SetPoint("TOPLEFT", optFrame, "TOPLEFT", 18, -276)
classLabel:SetText("Class Quest Checklist Filter:")

local classDropdownBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
classDropdownBtn:SetSize(324, 24)
classDropdownBtn:SetPoint("TOPLEFT", classLabel, "BOTTOMLEFT", 0, -4)

-- Scale Controls
local scaleLabel = optFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
scaleLabel:SetPoint("TOPLEFT", optFrame, "TOPLEFT", 18, -328)
scaleLabel:SetText("Window Scale: 100%")

local scaleDownBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
scaleDownBtn:SetSize(45, 22)
scaleDownBtn:SetPoint("TOPLEFT", scaleLabel, "BOTTOMLEFT", 0, -4)
scaleDownBtn:SetText("-10%")

local scaleUpBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
scaleUpBtn:SetSize(45, 22)
scaleUpBtn:SetPoint("LEFT", scaleDownBtn, "RIGHT", 6, 0)
scaleUpBtn:SetText("+10%")

-- Opacity Controls
local alphaLabel = optFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
alphaLabel:SetPoint("TOPLEFT", optFrame, "TOPLEFT", 180, -328)
alphaLabel:SetText("Opacity: 95%")

local alphaDownBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
alphaDownBtn:SetSize(45, 22)
alphaDownBtn:SetPoint("TOPLEFT", alphaLabel, "BOTTOMLEFT", 0, -4)
alphaDownBtn:SetText("-10%")

local alphaUpBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
alphaUpBtn:SetSize(45, 22)
alphaUpBtn:SetPoint("LEFT", alphaDownBtn, "RIGHT", 6, 0)
alphaUpBtn:SetText("+10%")

-- Minimap Ring Radius Fine-Tuner
local radLabel = optFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
radLabel:SetPoint("TOPLEFT", optFrame, "TOPLEFT", 18, -380)
radLabel:SetText("Minimap Icon Ring Distance: +5 px")

local radDownBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
radDownBtn:SetSize(65, 22)
radDownBtn:SetPoint("TOPLEFT", radLabel, "BOTTOMLEFT", 0, -4)
radDownBtn:SetText("Closer -")

local radUpBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
radUpBtn:SetSize(65, 22)
radUpBtn:SetPoint("LEFT", radDownBtn, "RIGHT", 6, 0)
radUpBtn:SetText("Further +")

local radResetBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
radResetBtn:SetSize(65, 22)
radResetBtn:SetPoint("LEFT", radUpBtn, "RIGHT", 6, 0)
radResetBtn:SetText("Default")

local function RefreshSlidersText()
    EnsureDefaults()
    scaleLabel:SetText("Window Scale: " .. math.floor((FordsRestedGuideDB.scale or 1.0) * 100 + 0.5) .. "%")
    alphaLabel:SetText("Opacity: " .. math.floor((FordsRestedGuideDB.alpha or 0.95) * 100 + 0.5) .. "%")
    local off = FordsRestedGuideDB.minimapOffset or 5
    local sign = off >= 0 and "+" or ""
    radLabel:SetText("Minimap Icon Ring Distance: " .. sign .. off .. " px")

    local mode = FordsRestedGuideDB.routeMode or "AUTO"
    local raceName = UnitRace("player") or "Horde"
    if mode == "AUTO" then
        raceDropdownBtn:SetText("Race: Auto-Detect (" .. raceName .. " -> " .. GetActiveRouteKey() .. ")")
    else
        raceDropdownBtn:SetText("Race: " .. (ROUTE_LABELS[mode] or mode))
    end

    local cMode = FordsRestedGuideDB.classMode or "AUTO"
    local classLoc = UnitClass("player") or "Warrior"
    if cMode == "AUTO" then
        classDropdownBtn:SetText("Class: Auto-Detect (" .. classLoc .. ")")
    else
        classDropdownBtn:SetText("Class: " .. cMode .. " [Click to Change]")
    end
end

scaleDownBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.scale = math.max(0.7, (FordsRestedGuideDB.scale or 1.0) - 0.1)
    RefreshSlidersText()
    ApplyVisualSettings()
end)

scaleUpBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.scale = math.min(1.4, (FordsRestedGuideDB.scale or 1.0) + 0.1)
    RefreshSlidersText()
    ApplyVisualSettings()
end)

alphaDownBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.alpha = math.max(0.3, (FordsRestedGuideDB.alpha or 0.95) - 0.1)
    RefreshSlidersText()
    ApplyVisualSettings()
end)

alphaUpBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.alpha = math.min(1.0, (FordsRestedGuideDB.alpha or 0.95) + 0.1)
    RefreshSlidersText()
    ApplyVisualSettings()
end)

radDownBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.minimapOffset = (FordsRestedGuideDB.minimapOffset or 5) - 2
    RefreshSlidersText()
    UpdateMinimapButtonPosition()
end)

radUpBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.minimapOffset = (FordsRestedGuideDB.minimapOffset or 5) + 2
    RefreshSlidersText()
    UpdateMinimapButtonPosition()
end)

radResetBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.minimapOffset = 5
    RefreshSlidersText()
    UpdateMinimapButtonPosition()
end)

optFrame:SetScript("OnShow", RefreshSlidersText)

local resetPosBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
resetPosBtn:SetSize(155, 24)
resetPosBtn:SetPoint("BOTTOMLEFT", optFrame, "BOTTOMLEFT", 16, 46)
resetPosBtn:SetText("Reset Window Pos")
resetPosBtn:SetScript("OnClick", function()
    FordsRestedGuideDB.pos = nil
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", 350, 100)
    frame:Show()
end)

local forceSyncBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
forceSyncBtn:SetSize(155, 24)
forceSyncBtn:SetPoint("BOTTOMRIGHT", optFrame, "BOTTOMRIGHT", -16, 46)
forceSyncBtn:SetText("Run Smart Auto-Sync")

local resetStepBtn = CreateFrame("Button", nil, optFrame, "UIPanelButtonTemplate")
resetStepBtn:SetSize(328, 24)
resetStepBtn:SetPoint("BOTTOM", optFrame, "BOTTOM", 0, 14)
resetStepBtn:SetText("Reset Guide to Step 1 (Clear Manual Marks)")

cfgBtn:SetScript("OnClick", function()
    if optFrame:IsShown() then optFrame:Hide() else optFrame:Show() end
end)

local blizzPanel = CreateFrame("Frame", "FordsRestedGuideBlizzOptions")
blizzPanel.name = "Ford's RestedGuide"
local bpTitle = blizzPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
bpTitle:SetPoint("TOPLEFT", 16, -16)
bpTitle:SetText("|cff00ccffFord's|r |cff00ff96RestedGuide|r v10.1")
local bpOpenBtn = CreateFrame("Button", nil, blizzPanel, "UIPanelButtonTemplate")
bpOpenBtn:SetSize(180, 26)
bpOpenBtn:SetPoint("TOPLEFT", bpTitle, "BOTTOMLEFT", 0, -16)
bpOpenBtn:SetText("Open Settings Window")
bpOpenBtn:SetScript("OnClick", function() optFrame:Show() end)
if InterfaceOptions_AddCategory then
    pcall(InterfaceOptions_AddCategory, blizzPanel)
elseif Settings and Settings.RegisterCanvasLayoutCategory then
    pcall(function()
        local cat = Settings.RegisterCanvasLayoutCategory(blizzPanel, blizzPanel.name)
        Settings.RegisterAddOnCategory(cat)
    end)
end

-- ==========================================
-- CORE QUEST, SPELLBOOK & MULTI-ID CHAIN DETECTION (v10.1)
-- ==========================================
local function IsSingleQuestIDDone(questID)
    if not questID then return false end
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        local ok, res = pcall(C_QuestLog.IsQuestFlaggedCompleted, questID)
        if ok and res == true then return true end
    end
    if IsQuestFlaggedCompleted then
        local ok, res = pcall(IsQuestFlaggedCompleted, questID)
        if ok and res == true then return true end
    end
    if GetQuestsCompleted then
        local ok, res = pcall(GetQuestsCompleted)
        if ok and type(res) == "table" and res[questID] then return true end
    end
    return false
end

-- Checks single ID, multi-step chain IDs, known class spells, and manual right-click dismissals!
local function IsQuestEntryDone(q)
    if not q then return false end
    EnsureDefaults()

    -- 1. Check if user right-clicked to manually mark this quest done
    if q.name and FordsRestedGuideDB.manualDone[q.name] then
        return true
    end

    -- 2. Check primary quest ID
    if q.id and IsSingleQuestIDDone(q.id) then
        return true
    end

    -- 3. Check any quest ID in a multi-step chain (e.g. Lesson in Divinity or Old Fire-Eye chain)
    if q.ids then
        for _, cid in ipairs(q.ids) do
            if IsSingleQuestIDDone(cid) then
                return true
            end
        end
    end

    -- 4. Check if the player already learned the reward spell in their Spellbook!
    if q.spellID and IsSpellKnown then
        local ok, known = pcall(IsSpellKnown, q.spellID)
        if ok and known then return true end
    end
    if q.spellName and GetSpellInfo then
        local ok, name = pcall(GetSpellInfo, q.spellName)
        if ok and name then return true end
    end

    return false
end

local function GetQuestLogState(q)
    if not q then return false, false, nil end
    if not GetNumQuestLogEntries or not GetQuestLogTitle then return false, false, nil end

    local numEntries = GetNumQuestLogEntries() or 0
    for i = 1, numEntries do
        local qTitle, _, _, isHeader, _, isComplete, _, qID = GetQuestLogTitle(i)
        if not isHeader and qTitle then
            local idMatch = (q.id and qID and q.id == qID)
            if not idMatch and q.ids and qID then
                for _, cid in ipairs(q.ids) do
                    if cid == qID then idMatch = true; break end
                end
            end
            local nameMatch = (q.name and string.find(string.lower(qTitle), string.lower(q.name), 1, true))
            if idMatch or nameMatch then
                local comp = (isComplete == 1 or isComplete == true)
                return true, comp, i
            end
        end
    end
    return false, false, nil
end

local activeWaypointCoords = nil
local activeWaypointNPC = nil
local activeWaypointTitle = nil

local function SyncTomTom(coordsStr, titleStr)
    if not TomTom or not TomTom.AddWaypoint then return end
    if lastTomTomUID and TomTom.RemoveWaypoint then
        pcall(function() TomTom:RemoveWaypoint(lastTomTomUID) end)
    end
    local tx, ty = ParseCoords(coordsStr)
    if tx and ty and C_Map and C_Map.GetBestMapForUnit then
        local mapID = C_Map.GetBestMapForUnit("player")
        if mapID then
            local ok, uid = pcall(function()
                return TomTom:AddWaypoint(mapID, tx, ty, { title = titleStr or "Ford's RestedGuide" })
            end)
            if ok then lastTomTomUID = uid end
        end
    end
end

local function GetQuestRowButton(idx)
    if not questRowButtons[idx] then
        local btn = CreateFrame("Button", nil, scrollChild)
        btn:SetWidth(340)
        btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
        local txt = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        txt:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -2)
        txt:SetWidth(336)
        txt:SetJustifyH("LEFT")
        btn.text = txt
        questRowButtons[idx] = btn
    end
    return questRowButtons[idx]
end

local function BuildInteractiveChecklist(step)
    for _, b in ipairs(questRowButtons) do
        b:Hide()
    end

    local entries = {}
    local totalQuests = 0
    local doneCount = 0

    if step and step.quests then
        totalQuests = #step.quests
        for _, q in ipairs(step.quests) do
            table.insert(entries, { quest = q, isOptional = false })
        end
    end

    if FordsRestedGuideDB and FordsRestedGuideDB.showClassQuests then
        local classKey = GetActiveClassKey()
        local cList = FordsRestedGuide_ClassQuests and FordsRestedGuide_ClassQuests[classKey]
        local playerLvl = UnitLevel("player") or 1
        if cList then
            for _, cq in ipairs(cList) do
                if playerLvl >= (cq.avail or 1) and not IsQuestEntryDone(cq) then
                    table.insert(entries, { quest = cq, isOptional = true, classKey = classKey })
                end
            end
        end
    end

    local yOffset = 0
    local addedMainHeader = false
    local addedOptHeader = false

    activeWaypointCoords = step and step.coords or nil
    activeWaypointNPC = step and step.npc or nil
    activeWaypointTitle = step and step.title or "Ford's RestedGuide"

    for idx, item in ipairs(entries) do
        local q = item.quest
        local doneServer = IsQuestEntryDone(q)
        local inLog, isComplete, logIndex = GetQuestLogState(q)

        if not item.isOptional and (doneServer or (inLog and isComplete)) then
            doneCount = doneCount + 1
        end

        local qx, qy, qCoordStr = ParseCoords(q.coords or q.npc)
        local qCleanNPC = ExtractCleanNPCName(q.npc) or (step and step.npc)

        local isSelected = (selectedQuestIdx == idx)
        if isSelected then
            activeWaypointCoords = qCoordStr or (step and step.coords)
            activeWaypointNPC = qCleanNPC
            activeWaypointTitle = q.name
        end

        local rowLines = {}
        if not item.isOptional and not addedMainHeader then
            table.insert(rowLines, "|cffffff00Quests in Hub (L-Click: Waypoint | R-Click: Mark Done):|r")
            addedMainHeader = true
        elseif item.isOptional and not addedOptHeader then
            table.insert(rowLines, "")
            table.insert(rowLines, "|cffff88ffOptional " .. (item.classKey or "") .. " Quests (L-Click: Waypoint | R-Click: Hide):|r")
            addedOptHeader = true
        end

        local selPrefix = isSelected and "|cff00ffff>> |r" or ""
        local optBadge = item.isOptional and ("|cff88ff88[Avail " .. q.avail .. " / Rec " .. (q.rec or q.avail) .. "]|r ") or ""
        local npcNote = q.npc and (" |cffaaaaaa- " .. q.npc .. "|r") or ""

        if doneServer then
            table.insert(rowLines, selPrefix .. "|cff777777[x] " .. q.name .. " (Completed)|r")
        elseif inLog and isComplete then
            table.insert(rowLines, selPrefix .. "|cff44ff44[*] " .. q.name .. " (Ready to Turn In!)|r " .. optBadge .. npcNote)
        elseif inLog then
            table.insert(rowLines, selPrefix .. "|cff44ccff[+] " .. q.name .. " (In Log)|r " .. optBadge .. npcNote)
            if logIndex and GetNumQuestLeaderBoards and GetQuestLogLeaderBoard then
                local ok, numObj = pcall(GetNumQuestLeaderBoards, logIndex)
                if ok and numObj and numObj > 0 then
                    for j = 1, numObj do
                        local ok2, text, _, finished = pcall(GetQuestLogLeaderBoard, j, logIndex)
                        if ok2 and text then
                            local col = (finished == 1 or finished == true) and "|cff44ff44" or "|cffdddddd"
                            table.insert(lines or rowLines, "    " .. col .. "- " .. text .. "|r")
                        end
                    end
                end
            end
        else
            local col = item.isOptional and "|cffffaa44[ ][OPT] " or "|cffffd100[ ] "
            table.insert(rowLines, selPrefix .. col .. q.name .. "|r " .. optBadge .. npcNote)
        end

        local btn = GetQuestRowButton(idx)
        btn:ClearAllPoints()
        btn:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -yOffset)
        btn.text:SetText(table.concat(rowLines, "\n"))
        local h = math.max(18, (btn.text:GetStringHeight() or 16) + 4)
        btn:SetHeight(h)
        btn:SetScript("OnClick", function(self, button)
            if button == "RightButton" then
                EnsureDefaults()
                if q.name then
                    FordsRestedGuideDB.manualDone[q.name] = not FordsRestedGuideDB.manualDone[q.name]
                    local statusStr = FordsRestedGuideDB.manualDone[q.name] and "Marked Completed" or "Unmarked"
                    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r " .. statusStr .. ": |cffffd100" .. q.name .. "|r")
                    UpdateDisplay()
                end
            else
                if selectedQuestIdx == idx then
                    selectedQuestIdx = nil
                else
                    selectedQuestIdx = idx
                    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r Waypoint locked to |cffffd100" .. q.name .. "|r" .. (qCoordStr and (" (" .. qCoordStr .. ")") or ""))
                end
                UpdateDisplay()
            end
        end)
        btn:Show()
        yOffset = yOffset + h
    end

    scrollChild:SetHeight(math.max(120, yOffset + 15))

    progBar:SetMinMaxValues(0, math.max(1, totalQuests))
    progBar:SetValue(doneCount)
    local pct = totalQuests > 0 and math.floor((doneCount / totalQuests) * 100) or 0
    progText:SetText("Hub Progress: " .. doneCount .. " / " .. totalQuests .. " Quests (" .. pct .. "%)")
end

local function BuildReminderBanner(step)
    if not step or not step.note then return "" end
    local noteLower = string.lower(step.note)
    local reminders = {}
    local bindLoc = GetBindLocation and GetBindLocation() or ""

    if string.find(noteLower, "hearth") then
        table.insert(reminders, "|cffffcc00[Hearthstone Tip]|r Currently bound to: |cff00ff96" .. (bindLoc ~= "" and bindLoc or "Unknown") .. "|r")
    end
    if string.find(noteLower, "flight path") or string.find(noteLower, "fly to") or string.find(noteLower, "skycutter") then
        table.insert(reminders, "|cff66ccff[Travel / Flight Tip]|r Grab the local Flight Path or Skycutter dock when arriving!")
    end

    return table.concat(reminders, "\n")
end

local function ShouldSkipStep(step, playerLvl)
    if step.quests then
        for _, q in ipairs(step.quests) do
            local inLog = GetQuestLogState(q)
            if inLog and not IsQuestEntryDone(q) then
                return false
            end
        end
    end

    if step.maxLevel and playerLvl > step.maxLevel then
        return true
    end

    if step.quests and #step.quests > 0 and not step.customHub then
        local checkedAny = false
        local allDone = true
        for _, q in ipairs(step.quests) do
            if q.id or q.ids then
                checkedAny = true
                if not IsQuestEntryDone(q) then
                    allDone = false
                    break
                end
            end
        end
        if checkedAny and allDone then
            return true
        end
    end

    return false
end

local function AutoSyncRoute(announce)
    local activeKey = GetActiveRouteKey()
    local route = FordsRestedGuide_Routes and FordsRestedGuide_Routes[activeKey]
    if not route then return end

    if ExpandQuestHeader then
        pcall(ExpandQuestHeader, 0)
    end

    local playerLvl = UnitLevel("player") or 1
    local bestStep = nil

    for i, step in ipairs(route.steps) do
        if step.quests then
            for _, q in ipairs(step.quests) do
                local inLog = GetQuestLogState(q)
                if inLog and not IsQuestEntryDone(q) then
                    bestStep = i
                    break
                end
            end
        end
        if bestStep then break end
    end

    if not bestStep then
        for i, step in ipairs(route.steps) do
            if not ShouldSkipStep(step, playerLvl) then
                bestStep = i
                break
            end
        end
    end

    bestStep = bestStep or #route.steps
    FordsRestedGuideDB.step = bestStep
    FordsRestedGuideDB.version = "10.1"
    selectedQuestIdx = nil

    if announce then
        local s = route.steps[bestStep]
        local raceStr = UnitRace("player") or "Horde"
        local classStr = GetActiveClassKey()
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r [" .. raceStr .. " " .. classStr .. "] Synced Level " .. playerLvl .. " -> Step " .. bestStep .. ": |cffffd100" .. (s and s.title or "") .. "|r")
    end
end

UpdateDisplay = function()
    local activeKey = GetActiveRouteKey()
    local route = FordsRestedGuide_Routes and FordsRestedGuide_Routes[activeKey]
    if not route then return end

    local total = #route.steps
    local idx = FordsRestedGuideDB and FordsRestedGuideDB.step or 1
    if idx < 1 then idx = 1 end
    if idx > total then idx = total end
    if FordsRestedGuideDB then FordsRestedGuideDB.step = idx end

    local step = route.steps[idx]
    BuildInteractiveChecklist(step)

    local badge = TYPE_COLORS[step.type] or ""
    local wpCoords = activeWaypointCoords or step.coords
    local wpNPC = activeWaypointNPC or step.npc
    local coordStr = wpCoords and (" |cffaaaaaa(" .. wpCoords .. ")|r") or ""
    local lvlStr = (step.minLevel and step.maxLevel) and (" |cff88ff88[Lvl " .. step.minLevel .. "-" .. step.maxLevel .. "]|r") or ""
    local npcStr = wpNPC and ("\n|cffffcc00Target NPC:|r " .. wpNPC) or ""

    stepCounter:SetText("[" .. activeKey .. "] Step " .. idx .. "/" .. total)
    zoneText:SetText((step.zone or "Unknown Zone") .. coordStr .. lvlStr .. npcStr)
    titleText:SetText(badge .. (step.title or ""))
    reminderText:SetText(BuildReminderBanner(step))
    noteText:SetText(step.note or "")

    if not InCombatLockdown() then
        if wpNPC then
            targetBtn:SetAttribute("macrotext", "/targetexact " .. wpNPC .. "\n/target " .. wpNPC)
            targetBtn:SetText("Target: " .. string.sub(wpNPC, 1, 11))
            targetBtn:Enable()
        else
            targetBtn:SetAttribute("macrotext", "")
            targetBtn:SetText("No NPC")
            targetBtn:Disable()
        end
    end

    SyncTomTom(wpCoords, activeWaypointTitle)
end

local function IsQuestInActiveChecklist(questTitle)
    if not questTitle then return false end
    local activeKey = GetActiveRouteKey()
    local route = FordsRestedGuide_Routes and FordsRestedGuide_Routes[activeKey]
    local step = route and route.steps[FordsRestedGuideDB and FordsRestedGuideDB.step or 1]
    if step and step.quests then
        for _, q in ipairs(step.quests) do
            if q.name and string.find(string.lower(questTitle), string.lower(q.name), 1, true) then
                return true
            end
        end
    end
    local classKey = GetActiveClassKey()
    local cList = FordsRestedGuide_ClassQuests and FordsRestedGuide_ClassQuests[classKey]
    if cList then
        for _, cq in ipairs(cList) do
            if cq.name and string.find(string.lower(questTitle), string.lower(cq.name), 1, true) then
                return true
            end
        end
    end
    return false
end

raceDropdownBtn:SetScript("OnClick", function()
    EnsureDefaults()
    local cur = FordsRestedGuideDB.routeMode or "AUTO"
    local nextIdx = 1
    for i, k in ipairs(ROUTE_ORDER) do
        if k == cur then
            nextIdx = (i % #ROUTE_ORDER) + 1
            break
        end
    end
    FordsRestedGuideDB.routeMode = ROUTE_ORDER[nextIdx]
    RefreshSlidersText()
    AutoSyncRoute(true)
    UpdateDisplay()
end)

classDropdownBtn:SetScript("OnClick", function()
    EnsureDefaults()
    local cur = FordsRestedGuideDB.classMode or "AUTO"
    local nextIdx = 1
    for i, k in ipairs(CLASS_ORDER) do
        if k == cur then
            nextIdx = (i % #CLASS_ORDER) + 1
            break
        end
    end
    FordsRestedGuideDB.classMode = CLASS_ORDER[nextIdx]
    RefreshSlidersText()
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
    FordsRestedGuideDB.step = 1
    FordsRestedGuideDB.manualDone = {}
    selectedQuestIdx = nil
    UpdateDisplay()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r Reset to Step 1 and cleared manual marks.")
end)

frame:SetScript("OnMouseWheel", function(self, delta)
    if IsShiftKeyDown() then
        selectedQuestIdx = nil
        if delta > 0 then
            FordsRestedGuideDB.step = (FordsRestedGuideDB.step or 1) - 1
        else
            FordsRestedGuideDB.step = (FordsRestedGuideDB.step or 1) + 1
        end
        UpdateDisplay()
    end
end)

local elapsedAccum = 0
local slowAccum = 0
frame:SetScript("OnUpdate", function(self, elapsed)
    local dt = elapsed or 0.05
    elapsedAccum = elapsedAccum + dt
    slowAccum = slowAccum + dt

    if slowAccum >= 1.0 then
        slowAccum = 0

        if GetItemCooldown then
            local start, duration = GetItemCooldown(6948)
            if start and duration and start > 0 and duration > 2 then
                local rem = math.max(0, math.floor((start + duration - GetTime()) / 60 + 0.5))
                hearthBtn:SetText("HS:" .. rem .. "m")
            else
                hearthBtn:SetText("HS: Rdy")
            end
        end

        if FordsRestedGuideDB and FordsRestedGuideDB.showXPTracker then
            local curXP = UnitXP("player") or 0
            local maxXP = math.max(1, UnitXPMax("player") or 1)
            local rested = GetXPExhaustion() or 0
            local restedPct = math.floor((rested / maxXP) * 100 + 0.5)
            local sessTime = math.max(1, GetTime() - sessionStartTime)
            local xpPerHr = math.floor((sessionGainedXP / sessTime) * 3600)
            local xpHrStr = xpPerHr >= 1000 and string.format("%.1fk", xpPerHr / 1000) or tostring(xpPerHr)
            local ttlStr = "--"
            if xpPerHr > 100 then
                local mins = math.floor(((maxXP - curXP) / xpPerHr) * 60 + 0.5)
                ttlStr = mins .. "m"
            end
            xpStrip:SetText("|cff00ccffXP/hr:|r " .. xpHrStr .. "  |  |cff88ff88Next Lvl:|r " .. ttlStr .. "  |  |cffffd100Rested:|r " .. restedPct .. "%")
        end
    end

    if elapsedAccum < 0.1 then return end
    elapsedAccum = 0

    if not FordsRestedGuideDB or not FordsRestedGuideDB.showArrow then return end

    local tx, ty = ParseCoords(activeWaypointCoords)
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
    local finalAngle = angle - facing
    if arrowTex.SetRotation then
        arrowTex:SetRotation(finalAngle)
    end
end)

prevBtn:SetScript("OnClick", function()
    selectedQuestIdx = nil
    FordsRestedGuideDB.step = (FordsRestedGuideDB.step or 1) - 1
    UpdateDisplay()
end)

syncBtn:SetScript("OnClick", function()
    AutoSyncRoute(true)
    UpdateDisplay()
end)

nextBtn:SetScript("OnClick", function()
    selectedQuestIdx = nil
    FordsRestedGuideDB.step = (FordsRestedGuideDB.step or 1) + 1
    UpdateDisplay()
end)

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("QUEST_LOG_UPDATE")
frame:RegisterEvent("QUEST_TURNED_IN")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PLAYER_XP_UPDATE")
frame:RegisterEvent("QUEST_DETAIL")
frame:RegisterEvent("QUEST_PROGRESS")
frame:RegisterEvent("QUEST_COMPLETE")
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
        ApplyVisualSettings()
    elseif event == "PLAYER_ENTERING_WORLD" then
        EnsureDefaults()
        lastKnownXP = UnitXP("player") or 0
        lastKnownMaxXP = UnitXPMax("player") or 1
        FordsRestedGuideDB.minimapHide = false
        if not FordsRestedGuideDB.step or FordsRestedGuideDB.version ~= "10.1" then
            AutoSyncRoute(true)
        end
        ApplyVisualSettings()
        UpdateDisplay()
    elseif event == "PLAYER_XP_UPDATE" then
        local curXP = UnitXP("player") or 0
        local maxXP = UnitXPMax("player") or 1
        if lastKnownXP then
            if curXP >= lastKnownXP then
                sessionGainedXP = sessionGainedXP + (curXP - lastKnownXP)
            elseif lastKnownMaxXP then
                sessionGainedXP = sessionGainedXP + (lastKnownMaxXP - lastKnownXP) + curXP
            end
        end
        lastKnownXP = curXP
        lastKnownMaxXP = maxXP
    elseif event == "QUEST_DETAIL" then
        if FordsRestedGuideDB and FordsRestedGuideDB.autoQuestAccept and not IsShiftKeyDown() then
            local qTitle = GetTitleText and GetTitleText()
            if IsQuestInActiveChecklist(qTitle) and AcceptQuest then
                AcceptQuest()
            end
        end
    elseif event == "QUEST_PROGRESS" then
        if FordsRestedGuideDB and FordsRestedGuideDB.autoQuestAccept and not IsShiftKeyDown() then
            local qTitle = GetTitleText and GetTitleText()
            if IsQuestInActiveChecklist(qTitle) and IsQuestCompletable and IsQuestCompletable() and CompleteQuest then
                CompleteQuest()
            end
        end
    elseif event == "QUEST_COMPLETE" then
        if FordsRestedGuideDB and FordsRestedGuideDB.autoQuestAccept and not IsShiftKeyDown() then
            local qTitle = GetTitleText and GetTitleText()
            local numChoices = GetNumQuestChoices and GetNumQuestChoices() or 0
            if IsQuestInActiveChecklist(qTitle) and numChoices <= 1 and GetQuestReward then
                GetQuestReward(numChoices == 1 and 1 or nil)
            end
        end
    elseif event == "QUEST_TURNED_IN" then
        if FordsRestedGuideDB and FordsRestedGuideDB.autoAdvance then
            local activeKey = GetActiveRouteKey()
            local route = FordsRestedGuide_Routes and FordsRestedGuide_Routes[activeKey]
            local step = route and route.steps[FordsRestedGuideDB.step or 1]
            if step and not step.customHub and ShouldSkipStep(step, UnitLevel("player") or 1) then
                selectedQuestIdx = nil
                FordsRestedGuideDB.step = (FordsRestedGuideDB.step or 1) + 1
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r Hub quests complete! Auto-advancing to next step.")
            end
        end
        UpdateDisplay()
    elseif event == "QUEST_LOG_UPDATE" or event == "PLAYER_LEVEL_UP" then
        UpdateDisplay()
    end
end)

SLASH_FORDSRESTEDGUIDE1 = "/frg"
SLASH_FORDSRESTEDGUIDE2 = "/ford"
SLASH_FORDSRESTEDGUIDE3 = "/fg"
SlashCmdList["FORDSRESTEDGUIDE"] = function(msg)
    msg = string.lower(msg or "")
    local stepNum = string.match(msg, "step%s+(%d+)")
    if msg == "config" or msg == "options" or msg == "settings" then
        if optFrame:IsShown() then optFrame:Hide() else optFrame:Show() end
    elseif msg == "sync" or msg == "autosync" then
        AutoSyncRoute(true)
        UpdateDisplay()
    elseif msg == "reset" then
        FordsRestedGuideDB.step = 1
        FordsRestedGuideDB.manualDone = {}
        selectedQuestIdx = nil
        UpdateDisplay()
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffFord's|r |cff00ff96RestedGuide:|r Reset to Step 1.")
    elseif stepNum then
        FordsRestedGuideDB.step = tonumber(stepNum)
        selectedQuestIdx = nil
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