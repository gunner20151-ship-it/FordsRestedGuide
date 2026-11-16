FordsRestedGuide_Routes = FordsRestedGuide_Routes or {}

-- ============================================================================
-- ALLIANCE STARTER 1: HIGH ORDER SKYBORNE (ZEPHRAS ISLE 1-12)
-- ============================================================================
FordsRestedGuide_Routes["Alliance_Starter_Skyborne"] = {
    {
        type = "ACCEPT", minLevel = 1, maxLevel = 6, customHub = true,
        zone = "Zephras Isle", coords = "48.2, 62.4", npc = "Acolyte Vaelen",
        title = "Zephras Isle: Sanctuary of the Winds (1-6)",
        note = "Welcome to Zephras Isle! Clear the initial High Order Skyborne trials around the Sanctuary of the Winds, attune to the Windshaper Pylons, and cull the Unbound Gale Elementals.",
        quests = {
            { name = "Awakening Upon the Gale", npc = "Acolyte Vaelen (Sanctuary of the Winds)" },
            { name = "Trial of the High Order", npc = "Magister Aelindor (Zephras Sanctum)" },
            { name = "Unbound Aether", npc = "Arcanist Lyria (Cull Unbound Sprites)" },
            { name = "Feather and Talon", npc = "Ranger-Captain Sylas" },
            { name = "Whispers in the Roost", npc = "Skycaller Oren" }
        }
    },
    {
        type = "COMPLETE", minLevel = 6, maxLevel = 12, customHub = true,
        zone = "Zephras Isle", coords = "54.6, 38.2", npc = "High Commander Valen",
        title = "Zephras Spire & Emissary to Stormwind (6-12)",
        note = "Complete the Skyborne faction split chain at Zephras Spire! Pledge your loyalty to the High Order (Alliance), defeat the Sundered Windshaper rebels, and take the Skyborne portal/vessel to Stormwind City at Level 12.",
        quests = {
            { name = "The Sundered Roost", npc = "High Commander Valen" },
            { name = "Reclaiming the Sky-Spire", npc = "Magister Aelindor" },
            { name = "Tempest at the Summit", npc = "Skycaller Oren" },
            { name = "Oath of the High Order", npc = "High Commander Valen (Pledge Alliance)" },
            { name = "Wings Over Stormwind", npc = "Ambassador Lothar (Travel to Stormwind)" }
        }
    }
}

-- ============================================================================
-- ALLIANCE STARTER 2: HUMAN (NORTHSHIRE & ELWYNN FOREST 1-12)
-- ============================================================================
FordsRestedGuide_Routes["Alliance_Starter_Human"] = {
    {
        type = "ACCEPT", minLevel = 1, maxLevel = 6,
        zone = "Elwynn Forest", coords = "48.2, 42.9", npc = "Marshal McBride",
        title = "Northshire Abbey Starter Hub (1-6)",
        note = "Clear Northshire Valley in a clean loop: Kobold Vermin & Workers north of the Abbey, Defias Thugs across the river to the east, and Garrick Padfoot (57.5, 48.2) before heading down the road to Goldshire.",
        quests = {
            { id = 783,  name = "A Threat Within", npc = "Deputy Willem (48.2, 43.6)" },
            { id = 7,    name = "Kobold Camp Cleanup", npc = "Marshal McBride (48.2, 42.9)" },
            { id = 33,   name = "Wolves Across the Border", npc = "Eagan Peltskinner (48.9, 40.2)" },
            { id = 15,   name = "Investigate Echo Ridge", npc = "Marshal McBride" },
            { id = 21,   name = "Skirmish at Echo Ridge", npc = "Marshal McBride" },
            { id = 18,   name = "Brotherhood of Thieves", npc = "Deputy Willem (48.2, 43.6)" },
            { id = 6,    name = "Bounty on Garrick Padfoot", npc = "Deputy Willem" },
            { id = 3903, name = "Milly Osworth", npc = "Deputy Willem" },
            { id = 3904, name = "Milly's Harvest", npc = "Milly Osworth (50.7, 39.3)" },
            { id = 54,   name = "Report to Goldshire", npc = "Marshal McBride" }
        }
    },
    {
        type = "ACCEPT", minLevel = 5, maxLevel = 12,
        zone = "Elwynn Forest", coords = "42.1, 65.9", npc = "Marshal Dughan",
        title = "Goldshire, Fargodeep/Jasperlode & Eastvale (6-12)",
        note = "Set your Hearthstone at Goldshire (43.8, 65.8). Clear the Maclure & Stonefield farm quests, Fargodeep Mine, Jasperlode Mine (61.8, 54.0), Eastvale Logging Camp (79.5, 68.7), and Hogger (27.0, 86.7)!",
        quests = {
            { id = 62,   name = "The Fargodeep Mine", npc = "Marshal Dughan (42.1, 65.9)" },
            { id = 60,   name = "Kobold Candles", npc = "William Pestle (43.3, 65.7)" },
            { id = 47,   name = "Gold Dust Exchange", npc = "Remy 'Two Times' (42.1, 67.3)" },
            { id = 85,   name = "Lost Necklace", npc = " " .. "Aunt" .. " Bernice Stonefield (34.5, 84.3)" },
            { id = 88,   name = "Princess Must Die!", npc = "Ma Stonefield (34.6, 84.5)" },
            { id = 76,   name = "The Jasperlode Mine", npc = "Marshal Dughan (42.1, 65.9)" },
            { id = 37,   name = "Find the Lost Guards", npc = "Marshal Dughan" },
            { id = 45,   name = "Discover Rolf's Fate", npc = "Half-eaten body (72.7, 60.3)" },
            { id = 5545, name = "A Bundle of Trouble", npc = "Supervisor Raelen (81.4, 66.1)" },
            { id = 11,   name = "Riverpaw Gnoll Bounty", npc = "Deputy Rainer (24.2, 74.5)" },
            { id = 176,  name = "Wanted: 'Hogger'", npc = "Wanted Poster (24.5, 74.7)" }
        }
    }
}

-- ============================================================================
-- ALLIANCE STARTER 3: DWARF & GNOME (COLDHERT VALLEY & DUN MOROGH 1-12)
-- ============================================================================
FordsRestedGuide_Routes["Alliance_Starter_DwarfGnome"] = {
    {
        type = "ACCEPT", minLevel = 1, maxLevel = 6,
        zone = "Dun Morogh", coords = "29.9, 71.2", npc = "Sten Stoutarm",
        title = "Coldridge Valley Starter Hub (1-6)",
        note = "Clear Coldridge Valley: Ragged Timber Wolves, Rockjaw Troggs, Frostmane Troll Whelps in the SW cave (26.8, 79.8), and Felix's 3 stolen items before heading through the tunnel to Kharanos.",
        quests = {
            { id = 179,  name = "Dwarven Outfitters", npc = "Sten Stoutarm (29.9, 71.2)" },
            { id = 233,  name = "Coldridge Valley Mail Delivery", npc = "Sten Stoutarm" },
            { id = 170,  name = "A New Threat", npc = "Balir Frosthammer (29.7, 71.3)" },
            { id = 3361, name = "A Refugee's Quandary", npc = "Felix Whindlebolt (28.6, 67.8)" },
            { id = 182,  name = "The Troll Cave", npc = "Grelin Whitebeard (25.1, 75.7)" },
            { id = 218,  name = "The Stolen Journal", npc = "Grelin Whitebeard" },
            { id = 282,  name = "Senir's Observations", npc = "Grelin Whitebeard" },
            { id = 2160, name = "Supplies to Tannok", npc = "Hands Springsprocket (33.8, 72.2)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 6, maxLevel = 12,
        zone = "Dun Morogh", coords = "47.2, 52.2", npc = "Ragnar Thunderbrew",
        title = "Kharanos, Brewnall Village & Gol'Bolar Quarry (6-12)",
        note = "Set your Hearthstone at Kharanos (47.4, 52.5). Clear Brewnall Village to the west, the Wendigo cave, Shimmer Ridge (42.0, 35.0), and Gol'Bolar Quarry to the east before entering Loch Modan!",
        quests = {
            { id = 384, name = "Beer Basted Boar Ribs", npc = "Ragnar Thunderbrew (46.8, 52.4)" },
            { id = 317, name = "Stocking Jetsteam", npc = "Pilot Bellowfiz (49.4, 48.4)" },
            { id = 313, name = "The Grizzled Den", npc = "Senir Whitebeard (46.7, 53.8)" },
            { id = 412, name = "Operation Recombobulation", npc = "Razzle Sprysprocket (45.8, 49.4)" },
            { id = 287, name = "Frostmane Hold", npc = "Senir Whitebeard" },
            { id = 314, name = "Protecting the Herd", npc = "Rudra Amberstill (63.1, 49.9)" },
            { id = 433, name = "The Public Servant", npc = "Senator Mehr Stonehallow (68.7, 56.0)" },
            { id = 432, name = "Those Blasted Troggs!", npc = "Foreman Stonebrow (69.1, 56.3)" }
        }
    }
}

-- ============================================================================
-- ALLIANCE STARTER 4: NIGHT ELF (SHADOWGLEN & TELDRASSIL 1-12)
-- ============================================================================
FordsRestedGuide_Routes["Alliance_Starter_NightElf"] = {
    {
        type = "ACCEPT", minLevel = 1, maxLevel = 6,
        zone = "Teldrassil", coords = "58.7, 44.3", npc = "Conservator Ilthalaine",
        title = "Shadowglen Starter Hub (1-6)",
        note = "Clear Shadowglen around Aldrassil: Young Nightsabers, Thistle Boars, Webwood Spiders in Shadowthread Cave (56.8, 31.7), and follow the road west to Dolanaar.",
        quests = {
            { id = 456,  name = "The Balance of Nature", npc = "Conservator Ilthalaine (58.7, 44.3)" },
            { id = 457,  name = "The Balance of Nature", npc = "Conservator Ilthalaine" },
            { id = 458,  name = "The Woodland Protector", npc = "Melithar Staghelm (59.9, 42.5)" },
            { id = 459,  name = "The Woodland Protector", npc = "Tarindrella (57.8, 45.1)" },
            { id = 916,  name = "Webwood Venom", npc = "Tallonkai Swiftroot (60.9, 42.0)" },
            { id = 917,  name = "Webwood Egg", npc = "Tallonkai Swiftroot" },
            { id = 2159, name = "Dolanaar Delivery", npc = "Porthannius (61.2, 47.6)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 6, maxLevel = 12,
        zone = "Teldrassil", coords = "55.6, 59.8", npc = "Athridas Bearmantle",
        title = "Dolanaar, Starbreeze, Ban'ethil & Darnassus (6-12)",
        note = "Set your Hearthstone at Dolanaar (55.6, 59.8). Clear Starbreeze Village, Fel Rock, Ban'ethil Barrow Den, and the Oracle Glade before taking the boat from Rut'theran Village to Darkshore/Wetlands.",
        quests = {
            { id = 475,  name = "A Troubling Breeze", npc = "Athridas Bearmantle (56.0, 57.3)" },
            { id = 928,  name = "Crown of the Earth", npc = "Corithras Moonrage (56.2, 61.7)" },
            { id = 488,  name = "Zenn's Bidding", npc = "Zenn Foulhoof (60.4, 56.3)" },
            { id = 2438, name = "The Emerald Dreamcatcher", npc = "Tallonkai Swiftroot (55.5, 56.7)" },
            { id = 2459, name = "Ferocitas the Dream Eater", npc = "Tallonkai Swiftroot" },
            { id = 489,  name = "Seek Redemption!", npc = "Syral Bladeleaf (56.0, 57.7)" },
            { id = 932,  name = "Twisted Hatred", npc = "Tallonkai Swiftroot (Lord Melenas 51.2, 50.8)" },
            { id = 487,  name = "The Road to Darnassus", npc = "Moon Priestess Amara (55.5, 58.3)" },
            { id = 933,  name = "Crown of the Earth", npc = "Corithras Moonrage" },
            { id = 935,  name = "Crown of the Earth", npc = "Arch Druid Fandral Staghelm (Darnassus)" }
        }
    }
}

-- ============================================================================
-- ALLIANCE SHARED LEVELING ROUTE (12-60 + ALL WOW: FOREVER CUSTOM DUNGEONS)
-- ============================================================================
FordsRestedGuide_Routes["Alliance_Shared_12_60"] = {
    {
        type = "ACCEPT", minLevel = 12, maxLevel = 17,
        zone = "Westfall", coords = "56.3, 47.5", npc = "Gryan Stoutmantle",
        title = "Westfall (Sentinel Hill), Loch Modan & Cozy Sleeping Bag (12-17)",
        note = "Clear Sentinel Hill in Westfall (56.3, 47.5) and Thelsamar in Loch Modan (33.9, 50.9) to unlock The Deadmines chain! At Level 14+, grab the WoW: Forever Cozy Sleeping Bag starting at the burned-out farm in Westfall (37, 50) -> Barrens (46, 74) -> Stonetalon (40.6, 52.4) -> Loch Modan dam (49.4, 12.9) -> Thoradin Wall (87.3, 49.6)!",
        quests = {
            { id = 64,  name = "The Forgotten Heirloom", npc = "Furlbrow (Westfall 60.0, 19.4)" },
            { id = 36,  name = "Westfall Stew", npc = "Salma Saldean (56.4, 30.5)" },
            { id = 12,  name = "The People's Militia", npc = "Gryan Stoutmantle (56.3, 47.5)" },
            { id = 65,  name = "The Defias Brotherhood", npc = "Gryan Stoutmantle (Deadmines Chain!)" },
            { id = 102, name = "Patrolling Westfall", npc = "Captain Danuvin (56.5, 47.6)" },
            { id = 416, name = "Rat Catching", npc = "Mountaineer Kadrell (Loch Modan 34.9, 47.0)" },
            { id = 418, name = "Thelsamar Blood Sausages", npc = "Vidra Hearthstove (Loch Modan 34.8, 49.1)" }
        }
    },
    {
        type = "DUNGEON", minLevel = 16, maxLevel = 22, customHub = true,
        zone = "Westfall", coords = "42.5, 71.7", npc = "Gryan Stoutmantle",
        title = "Dungeons: The Deadmines & NEW Ruins of Lordaeron (16-21)",
        note = "Run The Deadmines (Moonbrook 42.5, 71.7) with all 5 Alliance quests, and if your group travels north to Tirisfal/Silverpine, run WoW: Forever's new Ruins of Lordaeron (15-20) for massive buffed dungeon XP!",
        quests = {
            { id = 166, name = "The Defias Brotherhood", npc = "Gryan Stoutmantle (Sentinel Hill 56.3, 47.5)" },
            { id = 214, name = "Red Silk Bandanas", npc = "Scout Riell (Sentinel Hill Tower 56.7, 47.4)" },
            { id = 167, name = "Oh Brother. . .", npc = "Wilder Thistlenettle (Stormwind Dwarven Dist 65.4, 21.2)" },
            { id = 168, name = "Collecting Memories", npc = "Wilder Thistlenettle (Stormwind)" },
            { id = 2040, name = "Underground Assault", npc = "Shoni the Shilent (Stormwind 55.5, 12.5)" },
            { id = 373, name = "The Unsent Letter", npc = "Drops from Edwin VanCleef -> Baros Alexston" }
        }
    },
    {
        type = "ACCEPT", minLevel = 18, maxLevel = 25,
        zone = "Redridge Mountains", coords = "30.7, 59.4", npc = "Magistrate Solomon",
        title = "Redridge Mountains (Lakeshire) & Darkshore/Ashenvale (18-25)",
        note = "Clear Lakeshire in Redridge Mountains (30.7, 59.4). Remember to spend your first Legacy Point at Level 25 on 'Well Rested' (+20% Rested XP cap & rate)!",
        quests = {
            { id = 244, name = "Encroaching Gnolls", npc = "Guard Parker (Redridge 15.3, 71.5)" },
            { id = 125, name = "The Lost Tools", npc = "Foreman Oslow (32.1, 48.6)" },
            { id = 118, name = "The Price of Shoes", npc = "Verner Osgood (31.0, 47.3)" },
            { id = 120, name = "Messenger to Stormwind", npc = "Magistrate Solomon (29.9, 44.5)" },
            { id = 92,  name = "Redridge Goulash", npc = "Chef Breanna (22.7, 44.0)" },
            { id = 128, name = "Blackrock Bounty", npc = "Guard Howe (31.5, 57.9)" },
            { id = 19,  name = "Tharil'zun", npc = "Marshal Marris (33.5, 48.9)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 22, maxLevel = 29,
        zone = "Duskwood", coords = "73.6, 46.9", npc = "Commander Althea Ebonlocke",
        title = "Duskwood (Darkshire), Wetlands & The Stockade (22-29)",
        note = "Clear Raven Hill and Darkshire in Duskwood (73.6, 46.9), Menethil Harbor in Wetlands, and run Stormwind Stockade (24-28) with all 6 quests!",
        quests = {
            { id = 163, name = "Raven Hill", npc = "Elaine Carevin (Darkshire 75.3, 48.7)" },
            { id = 164, name = "Deliveries to Sven", npc = "Elaine Carevin (Duskwood)" },
            { id = 165, name = "The Hermit", npc = "Elaine Carevin" },
            { id = 56,  name = "The Night Watch", npc = "Commander Althea Ebonlocke (73.6, 46.9)" },
            { id = 101, name = "The Totem of Infliction", npc = "Madame Eva (75.8, 45.3)" },
            { id = 55,  name = "Morbent Fel", npc = "Sven Yorgen (7.8, 34.1)" },
            { id = 387, name = "Quell the Uprising", npc = "Warden Thelwater (Stormwind Stockade)" },
            { id = 388, name = "The Color of Blood", npc = "Nikova Raskol (Stormwind Old Town - Stockade)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 29, maxLevel = 34, customHub = true,
        zone = "Hillsbrad Foothills", coords = "50.3, 57.1", npc = "Magistrate Henry Maleb",
        title = "Southshore & Level 30 City of Dalaran Attunement (29-34)",
        note = "Head to Southshore in Hillsbrad Foothills (50.3, 57.1). At Level 30, complete the Alliance City of Dalaran Sewer Key attunement ('An Alarming Request' -> 'Shrewd Negotiations' -> 'Friend of the Kirin Tor' -> 'Heart of Disruption' with Image of Archmage Modera at Silverpine 68.5, 45.1)!",
        quests = {
            { id = 536,   name = "Down the Coast", npc = "Lieutenant Farren Orinelle (51.5, 58.4)" },
            { id = 505,   name = "Syndicate Assassins", npc = "Magistrate Henry Maleb (48.2, 59.4)" },
            { id = 564,   name = "Costly Menace", npc = "Darren Malvew (52.4, 56.0)" },
            { id = 92432, name = "An Alarming Request", npc = "Dalaran Attunement Step 1" },
            { id = 97287, name = "Shrewd Negotiations", npc = "Dalaran Attunement Step 2" },
            { id = 92459, name = "Friend of the Kirin Tor", npc = "Unlocks Dalaran Sewer Key" },
            { id = 92458, name = "Heart of Disruption", npc = "Image of Archmage Modera (Silverpine 68.5, 45.1)" }
        }
    },
    {
        type = "DUNGEON", minLevel = 30, maxLevel = 35, customHub = true,
        zone = "Silverpine Forest", coords = "69.3, 45.6", npc = "Rexxie Copperclutch",
        title = "NEW DUNGEON: City of Dalaran & Gnomeregan (30-35)",
        note = "Run WoW: Forever's City of Dalaran (30-34) via the sewer entrance at Silverpine (69.3, 45.6)! Pick up 'Starving Arcane', 'A Green Sample', and 'Power Overwhelming', plus 'Opportunistic Education' from Rexxie Copperclutch inside.",
        quests = {
            { id = 92458, name = "Heart of Disruption", npc = "Image of Archmage Modera (Silverpine 68.5, 45.1)" },
            { id = 92457, name = "Starving Arcane", npc = "Alliance Dalaran Dungeon Quest" },
            { id = 92456, name = "A Green Sample", npc = "Alliance Dalaran Dungeon Quest" },
            { id = 92489, name = "Power Overwhelming", npc = "Alliance Dalaran Dungeon Quest" },
            { id = 96987, name = "Opportunistic Education", npc = "Rexxie Copperclutch (Inside Entrance)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 32, maxLevel = 38,
        zone = "Stranglethorn Vale", coords = "38.0, 3.5", npc = "Sergeant Yohwa",
        title = "Shimmering Flats, North STV & NEW DUNGEON: The Drowned City (32-39)",
        note = "Clear the 6 Mirage Raceway quests in Shimmering Flats (77.8, 77.2), Rebel Camp & Nesingwary's Expedition in North STV, and Booty Bay (Krazek 27.0, 77.2) to run WoW: Forever's The Drowned City (35-40)!",
        quests = {
            { id = 1110,  name = "Rocket Car Parts", npc = "Kravel Koalbeard (Shimmering Flats 77.8, 77.2)" },
            { id = 1104,  name = "Salt Flat Venom", npc = "Fizzle Brassbolts (78.0, 77.1)" },
            { id = 1105,  name = "Hardened Shells", npc = "Wizzle Brassbolts (78.3, 77.0)" },
            { id = 203,   name = "The Second Rebellion", npc = "Sergeant Yohwa (STV Rebel Camp 38.0, 3.3)" },
            { id = 204,   name = "Bad Medicine", npc = "Sergeant Yohwa (Rebel Camp)" },
            { id = 185,   name = "Tiger Mastery", npc = "Ajeck Rouack (Nesingwary 35.6, 10.7)" },
            { id = 190,   name = "Panther Mastery", npc = "Sir S. J. Erlgadin (35.6, 10.5)" },
            { id = 194,   name = "Raptor Mastery", npc = "Hemet Nesingwary (35.7, 10.8)" },
            { id = 95787, name = "Take Two With Water", npc = "The Drowned City (Alliance)" },
            { id = 95788, name = "Magics of the Drowned City", npc = "The Drowned City (Alliance)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 36, maxLevel = 45, customHub = true,
        zone = "The Riverglades", coords = "42.0, 52.0", npc = "Powderfuse Port",
        title = "NEW ZONES: The Riverglades, Krol'dok & Shen'dralas (36-45)",
        note = "Travel to WoW: Forever's The Riverglades (via the road fork between Redridge & Burning Steppes or the boat from Tanaris to Powderfuse Port)! Clear the Alliance Riverglades hubs, buy your Level 40 Mount, run Krol'dok Stronghold (40-45), and clear Shen'dralas (40-43) in Desolace!",
        quests = {
            { id = 94982, name = "Eye of Mugg", npc = "Krol'dok Stronghold Dungeon Quest" },
            { id = 94984, name = "Tome of Twilight", npc = "Krol'dok Stronghold Dungeon Quest" },
            { id = 94983, name = "Twilight Mementos", npc = "Krol'dok Stronghold Dungeon Quest" },
            { id = 94974, name = "Key Ingredients", npc = "Krol'dok Moulding Drop" },
            { id = 1367,  name = "Magram Alliance", npc = "Desolace (Recommended before Shen'dralas!)" },
            { id = 1053,  name = "In the Name of the Light", npc = "Raleigh the Devout (Southshore - SM)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 43, maxLevel = 52,
        zone = "Tanaris", coords = "51.6, 26.8", npc = "Chief Engineer Bilgewhizzle",
        title = "Tanaris, Feathermoon, ZF, Maraudon & NEW Alcaz Prison (43-52)",
        note = "Clear Gadgetzan in Tanaris (51.6, 26.8), Feathermoon Stronghold in Feralas (30.2, 46.2), Aerie Peak in The Hinterlands, and run Zul'Farrak (44-48), Maraudon (48-51), and WoW: Forever's Alcaz Prison (48-53) on Alcaz Island!",
        quests = {
            { id = 1690, name = "Wastewander Justice", npc = "Chief Engineer Bilgewhizzle (52.5, 28.5)" },
            { id = 1707, name = "Water Pouch Bounty", npc = "Spigot Operator Luglunket (52.5, 28.4)" },
            { id = 3042, name = "Troll Temper", npc = "Trenton Lighthammer (Gadgetzan - ZF)" },
            { id = 2865, name = "Scarab Shells", npc = "Tran'rek (Gadgetzan - ZF)" },
            { id = 2768, name = "Divino-matic Rod", npc = "Chief Engineer Bilgewhizzle (ZF)" },
            { id = 2770, name = "Gahz'rilla", npc = "Wizzle Brassbolts (Shimmering Flats - ZF)" },
            { id = 2870, name = "Against Lord Shalzaru", npc = "Latronicus Moonspear (Feathermoon 30.4, 46.2)" },
            { id = 2989, name = "The Altar of Zul", npc = "Gryphon Master Talonaxe (Aerie Peak 9.8, 44.5)" }
        }
    },
    {
        type = "DUNGEON", minLevel = 51, maxLevel = 60, customHub = true,
        zone = "Un'Goro Crater", coords = "43.6, 8.5", npc = "Williden Marshal",
        title = "Un'Goro, Plaguelands & NEW 55-60 Blackmaw Hold & Shaper's Terrace",
        note = "Clear Marshal's Refuge in Un'Goro (save 15 of each Power Crystal for Shaper's Terrace), Felwood, Chillwind Camp (WPL), and run Blackrock Depths, Blackmaw Hold (Azshara 38.4, 32.6), and The Shaper's Terrace (Un'Goro 48.1, 6.1) to hit Level 60!",
        quests = {
            { id = 4284, name = "Crystals of Power", npc = "J.D. Collie (Un'Goro Cave 41.9, 2.7)" },
            { id = 3881, name = "Expedition Salvation", npc = "Williden Marshal (43.9, 7.2)" },
            { id = 3882, name = "Roll the Bones", npc = "Spark Nilminer (43.6, 7.4)" },
            { id = 4289, name = "The Apes of Un'Goro", npc = "Karna Remtravel (46.4, 13.4)" },
            { id = 5092, name = "Clear the Way", npc = "Commander Ashlam Valorfist (WPL 42.7, 84.1)" },
            { name = "Beneath Nordrassil", npc = "Blackmaw Hold Attunement Chain" },
            { name = "The Shaper's Terrace", npc = "Un'Goro Northern Rim (48.1, 6.1)" }
        }
    }
}