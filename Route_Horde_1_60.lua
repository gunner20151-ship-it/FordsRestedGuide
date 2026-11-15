FordsRestedGuide_Routes = FordsRestedGuide_Routes or {}

-- ==========================================
-- OPTIONAL CLASS-SPECIFIC QUEST DATABASE (v10.1 Verified Chain IDs + Spell Checks)
-- Supports: id, ids = {...} (any completed ID in chain marks done), and spellID (marks done if spell is known!)
-- Right-click any quest row in-game to manually mark/unmark it done!
-- ==========================================
FordsRestedGuide_ClassQuests = {
    ["PALADIN"] = {
        { id = 91208, ids = { 91208, 91209, 98389 }, avail = 2, rec = "2-6", name = "Coming to Terms / A Light in the Darkness", npc = "Aramis Hammerhand (Deathknell, Tirisfal Glades)" },
        { id = 91294, ids = { 91294, 91317, 95803, 99152 }, avail = 10, rec = "10-12", name = "Touring the Grounds / The Tarnished", npc = "Danitha Morr & Hilda the Breaker (Bandarion Keep, Tirisfal 22.1, 44.7)" },
        { id = 94427, ids = { 94427, 94434, 94436, 94438, 94441 }, spellID = 7328, spellName = "Redemption", avail = 12, rec = "12-14", name = "A Lesson in Divinity (Unlocks Redemption!)", npc = "Danitha Morr (Bandarion Keep 22.1, 44.7) -> Tanis Alderwood (Undercity 65.5, 37.5) -> Resurrect Falgan (Venomweb Vale 86.7, 47.7)" },
        { id = 91858, ids = { 91858, 91859, 91861, 91862, 96204, 95034, 95140 }, avail = 20, rec = "22-26", name = "Diplomatic Incident -> Old Fire-Eye (Wolfsbane 2H Sword!)", npc = "Danitha Morr (Bandarion Keep 22.1, 44.7) -> Rescue Lumina Windsinger (Fenris Keep 65.6, 23.2) -> SFK/DM/BFD -> Slay Old Fire-Eye" },
        { id = 13819, spellID = 13819, spellName = "Summon Warhorse", avail = 40, rec = "40", name = "Report to Danitha -> A Paladin's Steed (Warhorse Mount!)", npc = "Garen Largo (Undercity) -> Danitha Morr (Bandarion Keep, Tirisfal 22.1, 44.7)" },
        { id = 99500, avail = 50, rec = "52-58", name = "The Knight of Mourning (Sword of Mourning Chain)", npc = "Knight of Mourning (South of Bandarion Keep, Tirisfal 17.7, 67.6 -> Blackmaw Hold)" }
    },
    ["WARRIOR"] = {
        { id = 1505, ids = { 1505, 1498, 1502, 1503 }, spellID = 71, spellName = "Defensive Stance", avail = 10, rec = "10-12", name = "Veteran Uzzek / Path of Defense (Defensive Stance)", npc = "Christoph Walker (Brill) / Sorek (Orgrimmar) / Krang (Bloodhoof) -> Uzzek (Barrens 61.4, 21.1)" },
        { id = 1823, ids = { 1823, 1824, 1825, 1838 }, avail = 20, rec = "23-27", name = "Speak with Ruga -> Brutal Armor (Chestpiece)", npc = "Ruga Ragetotem (Camp Taurajo 44.7, 59.4) -> Thun'grim Firegaze (Barrens 57.2, 30.3)" },
        { id = 1718, ids = { 1718, 1719 }, spellID = 2458, spellName = "Berserker Stance", avail = 30, rec = "30-32", name = "The Islander / The Affray (Berserker Stance & Intercept)", npc = "Warrior Trainer -> Klannoc Macleod (Fray Island, Barrens 68.6, 49.2)" },
        { id = 1791, ids = { 1791, 1712, 1713 }, avail = 30, rec = "37-40 (or 30 w/ help)", name = "The Windwatcher -> Cyclonian (Whirlwind Axe/Sword/Mace!)", npc = "Klannoc Macleod -> Bath'rah the Windwatcher (Alterac 80.5, 66.9) - Needs 30 Troll Charms, 8 Liferoot, 24 Elemental Crests" },
        { id = 8417, ids = { 8417, 8423, 8424, 8425 }, avail = 50, rec = "52-54", name = "A Troubled Spirit (Sunken Temple Class Quest)", npc = "Warrior Trainer -> Fallen Hero of the Horde (Swamp of Sorrows 34.3, 66.2)" }
    },
    ["MAGE"] = {
        { id = 1881, ids = { 1881, 1882, 1883, 1884 }, avail = 10, rec = "10-12", name = "Speak with Anastasia / Un'thuwa (Class Wand)", npc = "Anastasia Hartwell (Undercity 85.1, 10.0) / Un'thuwa (Sen'jin 56.3, 75.1)" },
        { id = 1947, ids = { 1947, 1948, 1949, 1950, 1951, 1952 }, avail = 26, rec = "30-35", name = "Journey to the Marsh -> Rituals of Power (SM Library)", npc = "Deino (Orgrimmar 38.4, 86.1) -> Tabetha (Dustwallow 46.0, 57.0)" },
        { id = 1954, ids = { 1954, 1955, 1956, 1957, 1958 }, avail = 35, rec = "39-41", name = "The Infernal Orb (Celestial Orb / Staff)", npc = "Tabetha (Dustwallow 46.0, 57.0 - Kill Infernal in Desolace)" },
        { id = 8251, ids = { 8251, 8252, 8253 }, avail = 50, rec = "52-54", name = "Magic Dust (Sunken Temple Class Trinket)", npc = "Archmage Xylem (Azshara 29.6, 40.6)" }
    },
    ["WARLOCK"] = {
        { id = 1478, ids = { 1478, 1470, 1485 }, spellID = 688, spellName = "Summon Imp", avail = 1, rec = "2-3", name = "Piercing the Veil (Summon Imp)", npc = "Maximillion (Deathknell) / Rwag (Valley of Trials)" },
        { id = 1473, ids = { 1473, 1471, 1472, 1474, 1501, 1504 }, spellID = 697, spellName = "Summon Voidwalker", avail = 10, rec = "10-12", name = "Creature of the Void (Summon Voidwalker)", npc = "Carendin Halgar (Undercity 85.0, 25.6) / Gan'rul Bloodeye (Orgrimmar 48.2, 45.3)" },
        { id = 1507, ids = { 1507, 1508, 1509, 1510, 1511, 1512, 1513, 1476 }, spellID = 712, spellName = "Summon Succubus", avail = 20, rec = "20-23", name = "Devourer of Souls (Summon Succubus)", npc = "Carendin Halgar (Undercity) / Gan'rul Bloodeye (Orgrimmar)" },
        { id = 1795, ids = { 1795, 1801, 1802, 1803, 1804, 1805 }, spellID = 691, spellName = "Summon Felhunter", avail = 30, rec = "31-33", name = "Tome of the Cabal (Summon Felhunter)", npc = "Carendin Halgar (Undercity) -> Ratchet -> Thousand Needles / Hillsbrad" },
        { id = 4961, ids = { 4961, 4962, 4963, 4965, 4967, 4968, 4969, 4975 }, avail = 35, rec = "38-40", name = "Cleansing the Orb of Orahil (Orb/Staff of Noh'rahil)", npc = "Menara Voidrender (Ratchet 62.6, 35.5) -> Tabetha (Dustwallow)" },
        { id = 4488, ids = { 4487, 4488, 4489, 4490 }, spellID = 5784, spellName = "Summon Felsteed", avail = 40, rec = "40", name = "Summon Felsteed (Free Level 40 Mount!)", npc = "Godrick Farsan (Undercity) / Zevrost (Orgrimmar)" },
        { id = 8419, ids = { 8419, 8420, 8421, 8422 }, avail = 50, rec = "52-54", name = "An Imp's Request (Sunken Temple Soul Harvester)", npc = "Warlock Trainer -> Impsy (Felwood 41.6, 45.0)" }
    },
    ["ROGUE"] = {
        { id = 1963, ids = { 1963, 1858, 1859, 1978 }, avail = 10, rec = "10-16", name = "The Shattered Hand (Lockpicking & Blade)", npc = "Mennet Carkad (Undercity 83.5, 69.1) / Therzok (Orgrimmar 42.7, 53.5)" },
        { id = 2478, ids = { 2478, 2479, 2480 }, avail = 20, rec = "22-24", name = "Mission: Possible But Not Probable (Poisons!)", npc = "Shenthul (Orgrimmar 43.0, 53.7) -> West Barrens Tower (54.7, 5.7)" },
        { id = 8409, ids = { 8409, 8410, 8412, 8413 }, avail = 50, rec = "52-54", name = "A Simple Request (Sunken Temple Ebon Mask)", npc = "Ormok (Orgrimmar) -> Lord Jorach Ravenholdt (Alterac 86.0, 79.0)" }
    },
    ["PRIEST"] = {
        { id = 5658, ids = { 5658, 5652, 5660, 5661 }, avail = 5, rec = "5-10", name = "Touch of Weakness / Devouring Plague", npc = "Dark Cleric Beryl (Brill 61.6, 52.2) / Father Lankester (Undercity)" },
        { id = 8415, ids = { 8415, 8416, 8417 }, avail = 50, rec = "52-54", name = "Cenarion Aid (Sunken Temple Staff)", npc = "Priest Trainer -> Ogtinc (Azshara 42.2, 42.6)" }
    },
    ["SHAMAN"] = {
        { id = 1516, ids = { 1516, 1517, 1518, 1519, 1520, 1521 }, spellID = 8071, spellName = "Stoneskin Totem", avail = 4, rec = "4-5", name = "Call of Earth (Earth Totem)", npc = "Canaga Earthcaller (Valley of Trials) / Seer Ravenfeather (Camp Narache)" },
        { id = 1524, ids = { 1524, 1525, 1526, 1527 }, spellID = 3599, spellName = "Searing Totem", avail = 10, rec = "10-12", name = "Call of Fire (Fire Totem)", npc = "Swart (Razor Hill) / Kranal Fiss (Barrens 55.8, 20.0)" },
        { id = 1528, ids = { 1528, 1529, 1530, 1534, 1535, 1536, 63, 100 }, spellID = 5394, spellName = "Healing Stream Totem", avail = 20, rec = "22-24", name = "Call of Water (Water Totem)", npc = "Islen Waterseer (Barrens 65.8, 43.8 -> Silverpine / Tarren Mill)" },
        { id = 1532, ids = { 1531, 1532 }, avail = 30, rec = "30-31", name = "Call of Air (Air Totem)", npc = "Prate Cloudseer (Thousand Needles 53.8, 42.7)" },
        { id = 8410, ids = { 8410, 8411 }, avail = 50, rec = "52-54", name = "Elemental Mastery (Sunken Temple Totem)", npc = "Sagorne Creststrider (Orgrimmar) -> Bath'rah (Alterac 80.5, 66.9)" }
    },
    ["HUNTER"] = {
        { id = 6062, ids = { 6061, 6062, 6063, 6064, 6081, 6082, 6083, 6087, 6088 }, spellID = 883, spellName = "Call Pet", avail = 10, rec = "10", name = "Taming the Beast (Learn Pet Taming & Feed Pet!)", npc = "Thotar (Razor Hill 51.9, 43.5) / Yaw Sharpmane (Bloodhoof 47.8, 55.7)" },
        { id = 8418, ids = { 8418, 8254, 8255 }, avail = 50, rec = "52-54", name = "The Hunter's Charm (Sunken Temple Polearm/Trinket)", npc = "Ormak Grimshot (Orgrimmar) -> Ogtinc (Azshara 42.2, 42.6)" }
    },
    ["DRUID"] = {
        { id = 5922, ids = { 5922, 5929, 5930, 5932, 6002 }, spellID = 5487, spellName = "Bear Form", avail = 10, rec = "10-11", name = "Moonglade -> Great Bear Spirit (Bear Form!)", npc = "Gennia Runetotem (Bloodhoof 48.5, 59.6) -> Dendrite Starblaze (Moonglade)" },
        { id = 6126, ids = { 6126, 6127, 6128, 6129, 6130 }, spellID = 8946, spellName = "Cure Poison", avail = 14, rec = "14-16", name = "Lessons Anew -> Cure Poison", npc = "Turak Runetotem (Thunder Bluff 76.5, 27.2)" },
        { id = 27,   ids = { 27, 28, 29, 30, 272 }, spellID = 1066, spellName = "Aquatic Form", avail = 16, rec = "16-18", name = "A Lesson to Learn -> Aquatic Form!", npc = "Turak Runetotem -> Dendrite Starblaze (Moonglade)" },
        { id = 8414, ids = { 8414, 8426, 8427 }, avail = 50, rec = "52-54", name = "Torwa Pathfinder (Sunken Temple Druid Staff)", npc = "Turak Runetotem (Thunder Bluff) -> Torwa Pathfinder (Un'Goro 71.6, 76.0)" }
    }
}

-- ==========================================
-- RACE-SPECIFIC STARTER CHAINS (LEVELS 1-16)
-- ==========================================
FordsRestedGuide_Starters = {
    ["Skyborne"] = {
        {
            type = "ACCEPT", minLevel = 1, maxLevel = 5, customHub = true,
            zone = "Zephras Isle", coords = "46.3, 18.0", npc = "Halaan Hawk-Eye",
            title = "[Windshaper Skyborne] Thendal Village (1-5)",
            note = "1) Complete the opening Thendal Village quests and visit the Elemental Convergence (48.3, 20.4) to attune your 'Skysight' racial (+30% Charged speed!).\n2) Climb the watchtower to Halaan Hawk-Eye & Myriaal for 'The Anchors of Zephras' and jump off using your 'Walk on Air' glide racial for 'Falling with Style'.\n3) Clear the bear cave for 6 Scrawny Ursera Claws, 8 Scavengers, and slay Urs'anah for 'Foul Matriarch'.\n4) Grab 'The Adventurer' on the curved road at Thendal Grove (38.3, 30.3) heading south!",
            quests = {
                { name = "Coming of Age", npc = "Thendal Starter Hub" },
                { name = "Harmony in Balance", npc = "Thendal Starter Hub" },
                { name = "Elemental Unrest", npc = "Elemental Convergence (48.3, 20.4)" },
                { name = "Reading the Ley Lines", npc = "Leyline Convergence (46.3, 18.0)" },
                { name = "The Anchors of Zephras", npc = "Halaan Hawk-Eye (Watchtower)" },
                { name = "Falling with Style", npc = "Myriaal (Watchtower - Use Walk on Air)" },
                { name = "Foul Matriarch", npc = "Urs'anah (Thendal Bear Cave)" },
                { name = "The Adventurer", npc = "Thendal Grove Road (38.3, 30.3)" }
            }
        },
        {
            type = "ACCEPT", minLevel = 5, maxLevel = 9, customHub = true,
            zone = "Zephras Isle", coords = "41.7, 44.7", npc = "Raan Wildwind",
            title = "[Windshaper Skyborne] Shen'dar & Falaath Village (5-9)",
            note = "1) Stop at Raan Wildwind's tent (41.7, 44.7) for 'The Great Outdoors' (/sit at his campfire to unlock Camping & Boosted Rest!).\n2) In Shen'dar Village, prioritize Indari Sunseam's 'The Problem With Prideclaws' for a free 6-slot bag!\n3) Clear west bandits, then swing east for Hippogryphs (Matriarch at 35.0, 54.2) and Vulgara the Insatiable.\n4) Do Constable Aonda's spy chain: talk to Missionary Jasaan (46.8, 56.2), eavesdrop at the Wardrobe in Falaath Village inn (48.9, 53.8), and slay Commander Aanders in the Western Watch tower!\n*Hold off on 'To Valanaar' until all Shen'dar quests are done.",
            quests = {
                { name = "The Great Outdoors", npc = "Raan Wildwind (41.7, 44.7 - Unlocks Camping!)" },
                { name = "The Problem With Prideclaws", npc = "Indari Sunseam (Rewards 6-Slot Bag!)" },
                { name = "Restocking the Larders", npc = "Shen'dar Village (Galestrider Meat)" },
                { name = "Hippogryph Harassment", npc = "Hippogryph Matriarch (35.0, 54.2)" },
                { name = "A Little Beauty", npc = "8 Hippogryph Down Feathers (35.0, 54.2)" },
                { name = "WANTED: Vulgara the Insatiable", npc = "Shen'dar Wanted Poster" },
                { name = "Infiltrating the Cult", npc = "Constable Aonda -> Jasaan (46.8, 56.2)" },
                { name = "Among the Faithful", npc = "Missionary Jasaan -> Wardrobe (48.9, 53.8)" },
                { name = "The Western Watch", npc = "Slay Commander Aanders in Tower" },
                { name = "To Valanaar", npc = "Take road south to Valanaar when Level 9+" }
            }
        },
        {
            type = "COMPLETE", minLevel = 9, maxLevel = 14, customHub = true,
            zone = "Zephras Isle", coords = "66.2, 76.6", npc = "Valennia Stormfist",
            title = "[Windshaper Skyborne] Valanaar & Skycutter to Thunder Bluff (9-14)",
            note = "1) Climb the big tree in Valanaar (66.2, 76.6) to turn in to Valennia Stormfist & Talanis Shadowsong, but clear ALL surrounding Valanaar hubs first (Windfield Orchard, Shadowgale Forest, and Ruins of Ban'aethal) before starting the final departure chain!\n2) Complete the Shrine of Akir finale ('The Turncoat' -> 'Al'aketh Assassins' at 56.8, 61.1 -> 'Confront Lorthuna' with Ayessa Dawnsinger).\n3) Take the Horde Skycutter Ship at Valanaar's western dock (58.2, 79.5) directly to Thunder Bluff (34.3, 25.8)!\n*Remember: At Level 40, return to Fairweather Stables in Zephras Isle (53.8, 81.3) to train Galestrider Riding with your Windshapers reputation discount!",
            quests = {
                { name = "Crab Season", npc = "Windfield Orchard Hub" },
                { name = "Ornery Galestriders", npc = "Windfield Orchard Hub" },
                { name = "The Wounds of Betrayal", npc = "Shadowgale Forest (Commander Haalien)" },
                { name = "The Missing Scholar", npc = "Ruins of Ban'aethal (Parts 1-3)" },
                { name = "Catching Wind", npc = "Ruins of Ban'aethal" },
                { name = "Breaking the Breaker", npc = "Ruins of Ban'aethal" },
                { name = "The Turncoat", npc = "Valanaar Uphill (56.8, 61.1)" },
                { name = "Confront Lorthuna", npc = "Ayessa Dawnsinger (Sanctum of Storms)" },
                { name = "What Comes Next", npc = "Board Horde Skycutter Ship at Dock (58.2, 79.5) -> Thunder Bluff!" }
            }
        }
    },

    ["Undead"] = {
        {
            type = "ACCEPT", minLevel = 1, maxLevel = 5,
            zone = "Tirisfal Glades", coords = "30.8, 65.1", npc = "Shadow Priest Sarvis",
            title = "[Undead] Deathknell Starter Quests (1-6)",
            note = "Clear Deathknell in order: Zombies outside the church, Skeletons & Duskbats/Wolves, Night Web Spiders (27.2, 59.0), and Scarlet Converts + Samuel Fipps (36.7, 61.6).",
            quests = {
                { id = 363,  name = "Rude Awakening", npc = "Undertaker Mordo (30.2, 71.7)" },
                { id = 364,  name = "The Mindless Ones", npc = "Shadow Priest Sarvis (30.8, 65.1)" },
                { id = 3901, name = "Rattling the Rattlecages", npc = "Shadow Priest Sarvis" },
                { id = 376,  name = "The Damned", npc = "Novice Elreth (30.9, 66.1)" },
                { id = 380,  name = "Night Web's Hollow", npc = "Executor Arren (32.2, 66.0)" },
                { id = 381,  name = "The Scarlet Crusade", npc = "Executor Arren" },
                { id = 382,  name = "The Red Messenger", npc = "Executor Arren" },
                { id = 6395, name = "Marla's Last Wish", npc = "Novice Elreth" }
            }
        },
        {
            type = "ACCEPT", minLevel = 5, maxLevel = 12,
            zone = "Tirisfal Glades", coords = "61.3, 50.8", npc = "Magistrate Sevren",
            title = "[Undead] Brill Hub & Bandarion Keep (6-12)",
            note = "Set your Hearthstone at Brill (61.9, 52.7). Complete 'Rear Guard Patrol' (65.5, 60.2) to unlock 'The Wrath of Rath'mael' for Ruins of Lordaeron at 15, and visit Bandarion Keep (22.0, 44.7) in NW Tirisfal!",
            quests = {
                { id = 8,     name = "A Rogue's Deal", npc = "Calvin Montague (38.2, 56.8)" },
                { id = 365,   name = "Fields of Grief", npc = "Apothecary Johaan (59.5, 52.4)" },
                { id = 404,   name = "A Putrid Task", npc = "Deathguard Dillinger (58.2, 51.4)" },
                { id = 367,   name = "A New Plague", npc = "Apothecary Johaan (59.5, 52.4)" },
                { id = 358,   name = "Graverobbers", npc = "Magistrate Sevren (61.3, 50.8)" },
                { id = 354,   name = "Deaths in the Family", npc = "Coleman Farthing (61.7, 52.3)" },
                { id = 362,   name = "The Haunted Mills", npc = "Coleman Farthing" },
                { id = 356,   name = "Rear Guard Patrol", npc = "Deathguard Linnea (65.5, 60.2 - RoL Prereq!)" },
                { id = 96899, name = "Bandarion Keep", npc = "Hadric Harlson (Balnir 65.9, 61.1 -> Bandarion 22.0, 44.7)" },
                { id = 408,   name = "The Family Crypt", npc = "Magistrate Sevren (61.3, 50.8)" }
            }
        },
        {
            type = "ACCEPT", minLevel = 12, maxLevel = 16,
            zone = "Silverpine Forest", coords = "43.4, 40.8", npc = "High Executor Hadrec",
            title = "[Undead] Silverpine Forest & The Sepulcher (12-16)",
            note = "Clear The Sepulcher hub (complete 'A Recipe For Death' chain to unlock 'The New Plague' for Ruins of Lordaeron).",
            quests = {
                { id = 6321, name = "Supplying the Sepulcher", npc = "Podrig (43.4, 41.6)" },
                { id = 447,  name = "A Recipe For Death", npc = "Apothecary Renferrel (42.8, 40.9 - RoL Prereq!)" },
                { id = 437,  name = "The Dead Fields", npc = "High Executor Hadrec (43.4, 40.8)" },
                { id = 421,  name = "Prove Your Worth", npc = "Dalar Dawnweaver (44.2, 39.8)" },
                { id = 477,  name = "Border Crossings", npc = "Shadow Priest Allister (44.0, 40.9)" }
            }
        }
    },

    ["OrcTroll"] = {
        {
            type = "ACCEPT", minLevel = 1, maxLevel = 5,
            zone = "Durotar", coords = "43.3, 68.5", npc = "Kaltunk",
            title = "[Orc/Troll] Valley of Trials Starter Quests (1-6)",
            note = "Clear Mottled Boars, Scorpids, Vile Familiars, Lazy Peons, and Sarkoth (40.6, 62.6), then clear the Burning Blade Coven cave (42.5, 53.5).",
            quests = {
                { id = 4641, name = "Your Place In The World", npc = "Kaltunk (43.3, 68.5)" },
                { id = 788,  name = "Cutting Teeth", npc = "Gornek (42.1, 68.4)" },
                { id = 790,  name = "Sarkoth", npc = "Hana'zua (40.6, 62.6)" },
                { id = 789,  name = "Sting of the Scorpid", npc = "Gornek (42.1, 68.4)" },
                { id = 4402, name = "Galgar's Cactus Apple Surprise", npc = "Galgar (42.7, 67.3)" },
                { id = 5441, name = "Lazy Peons", npc = "Foreman Thazz'ril (44.6, 68.7)" },
                { id = 792,  name = "Vile Familiars", npc = "Zureetha Fargaze (42.9, 69.1)" },
                { id = 794,  name = "Burning Blade Medallion", npc = "Zureetha Fargaze (Cave 42.5, 53.5)" }
            }
        },
        {
            type = "ACCEPT", minLevel = 5, maxLevel = 10,
            zone = "Durotar", coords = "51.9, 43.5", npc = "Gar'Thok",
            title = "[Orc/Troll] Sen'jin Village & Razor Hill Hub (6-10)",
            note = "Stop at Sen'jin Village (55.9, 74.7) on your way north to Razor Hill (51.9, 43.5). Set your Hearthstone at Razor Hill and clear Tiragarde Keep, Echo Isles, and Razormane grounds.",
            quests = {
                { id = 786, name = "Thwarting Kolkar Aggression", npc = "Lar Prowltusk (Sen'jin 54.6, 76.3)" },
                { id = 817, name = "Practical Prey", npc = "Vel'rin Fang (Sen'jin 56.0, 73.9)" },
                { id = 818, name = "A Solvent Spirit", npc = "Master Vornal (Sen'jin 55.9, 74.4)" },
                { id = 805, name = "Report to Sen'jin Village", npc = "Master Gadrin (56.0, 74.6)" },
                { id = 826, name = "Zalazane", npc = "Master Gadrin (Echo Isles 67.0, 86.0)" },
                { id = 784, name = "Vanquish the Betrayers", npc = "Gar'Thok (Razor Hill 51.9, 43.5)" },
                { id = 837, name = "Encroachment", npc = "Gar'Thok (Razor Hill)" },
                { id = 815, name = "Break a Few Eggs", npc = "Cook Torka (Razor Hill 51.1, 42.4)" },
                { id = 840, name = "Conscript of the Horde", npc = "Takrin Pathseeker (50.9, 43.6)" }
            }
        },
        {
            type = "COMPLETE", minLevel = 9, maxLevel = 15,
            zone = "Durotar", coords = "55.0, 11.0", npc = "Rezlak",
            title = "[Orc/Troll] North Durotar, Skull Rock & Ragefire Chasm (10-15)",
            note = "Clear Thunder Ridge (41.5, 26.0), Skull Rock (55.0, 11.0), and Gazz'uz, then enter Orgrimmar to run Ragefire Chasm (13-15)!",
            quests = {
                { id = 834,  name = "Winds in the Desert", npc = "Rezlak (46.4, 22.9)" },
                { id = 835,  name = "Securing the Lines", npc = "Rezlak" },
                { id = 806,  name = "Dark Storms", npc = "Orgnil Soulscar (Razor Hill 52.2, 43.2)" },
                { id = 808,  name = "Minshina's Skull", npc = "Master Gadrin (Skull Rock 55.0, 11.0)" },
                { id = 828,  name = "Margoz", npc = "Orgnil Soulscar -> Margoz (56.4, 20.1)" },
                { id = 827,  name = "Skull Rock", npc = "Margoz (56.4, 20.1)" },
                { id = 5726, name = "Hidden Enemies", npc = "Thrall (Orgrimmar 31.8, 37.8 - RFC)" },
                { id = 5728, name = "Testing an Enemy's Strength", npc = "Rahauro (Thunder Bluff - RFC)" }
            }
        }
    },

    ["Tauren"] = {
        {
            type = "ACCEPT", minLevel = 1, maxLevel = 5,
            zone = "Mulgore", coords = "44.9, 77.1", npc = "Chief Hawkwind",
            title = "[Tauren] Camp Narache Starter Quests (1-6)",
            note = "Clear Plainstriders, Mountain Cougars, Battleboars, and the Brambleblade Ravine Quilboars (61.0, 81.0) in Red Cloud Mesa.",
            quests = {
                { id = 747,  name = "The Hunt Begins", npc = "Grull Hawkwind (44.9, 77.1)" },
                { id = 750,  name = "The Hunt Continues", npc = "Grull Hawkwind" },
                { id = 752,  name = "A Humble Task", npc = "Chief Hawkwind (44.2, 76.1)" },
                { id = 753,  name = "A Humble Task", npc = "Water Pitcher -> Chief Hawkwind" },
                { id = 755,  name = "Rites of the Earthmother", npc = "Chief Hawkwind" },
                { id = 757,  name = "Rite of Strength", npc = "Seer Graytongue (42.6, 92.2)" },
                { id = 780,  name = "The Battleboars", npc = "Grull Hawkwind" },
                { id = 781,  name = "Attack on Camp Narache", npc = "Dirt-stained Map Drop" }
            }
        },
        {
            type = "ACCEPT", minLevel = 5, maxLevel = 10,
            zone = "Mulgore", coords = "47.5, 60.2", npc = "Baine Bloodhoof",
            title = "[Tauren] Bloodhoof Village Hub (6-10)",
            note = "Walk north to Bloodhoof Village (47.5, 60.2), set your Hearthstone, and pick up all town quests.",
            quests = {
                { id = 761, name = "Swoop Hunting", npc = "Harken Windtotem (48.7, 59.3)" },
                { id = 748, name = "Poison Water", npc = "Mull Thunderhorn (48.5, 60.4)" },
                { id = 745, name = "Sharing the Land", npc = "Baine Bloodhoof (47.5, 60.2)" },
                { id = 746, name = "Dwarven Digging", npc = "Baine Bloodhoof" },
                { id = 743, name = "Dangers of the Windfury", npc = "Ruul Eagletalon (47.4, 62.0)" },
                { id = 767, name = "Rite of Vision", npc = "Baine Bloodhoof -> Zarlman Two-Moons" },
                { id = 749, name = "The Ravaged Caravan", npc = "Morin Cloudstalker (Patrols East Road)" },
                { id = 771, name = "Rite of Vision", npc = "Zarlman Two-Moons (47.8, 57.5)" }
            }
        },
        {
            type = "COMPLETE", minLevel = 9, maxLevel = 15,
            zone = "Mulgore", coords = "38.5, 81.6", npc = "Eyahn Eagletalon",
            title = "[Tauren] Thunder Bluff, Venture Co. & Ragefire Chasm (10-15)",
            note = "Finish the Venture Co. Mine (61.5, 47.2), The Demon Scarred Cloak, and Arra'chea, then visit Thunder Bluff and fly to Orgrimmar to run Ragefire Chasm (13-15)!",
            quests = {
                { id = 764,  name = "The Venture Co.", npc = "Morin Cloudstalker (East Road)" },
                { id = 765,  name = "Supervisor Fizsprocket", npc = "Morin Cloudstalker (Mine 61.5, 47.2)" },
                { id = 773,  name = "Rite of Wisdom", npc = "Ancestral Spirit (61.5, 21.0)" },
                { id = 776,  name = "Rites of the Earthmother", npc = "Cairne Bloodhoof (Thunder Bluff)" },
                { id = 833,  name = "A Sacred Burial", npc = "Lorekeeper Raintotem (59.8, 25.6)" },
                { id = 861,  name = "The Hunter's Way", npc = "Skorn Whitecloud (46.8, 60.2)" },
                { id = 5728, name = "Testing an Enemy's Strength", npc = "Rahauro (Thunder Bluff 70.4, 29.6 - RFC)" },
                { id = 5726, name = "Hidden Enemies", npc = "Thrall (Orgrimmar 31.8, 37.8 - RFC)" }
            }
        }
    }
}

-- ==========================================
-- CONVERGED HORDE + WOW: FOREVER ROUTE (13-60)
-- ==========================================
FordsRestedGuide_Shared_13_60 = {
    {
        type = "ACCEPT", minLevel = 13, maxLevel = 20,
        zone = "The Barrens", coords = "52.2, 31.0", npc = "Sergra Darkthorn",
        title = "The Barrens (Crossroads) & Cozy Sleeping Bag (13-19)",
        note = "Clear the Crossroads hub (52.2, 31.0). At Level 14+, grab the WoW: Forever Cozy Sleeping Bag (+3% XP & Rested XP item) starting south of Camp Taurajo at the Burned-Out Remains (Barrens 46, 74) -> Westfall (37, 50) -> Stonetalon (40.6, 52.4) -> Loch Modan (49.4, 12.9) -> Thoradin Wall (87.3, 49.6)!",
        quests = {
            { id = 844, name = "Plainstrider Menace", npc = "Sergra Darkthorn (Crossroads 52.2, 31.0)" },
            { id = 870, name = "The Forgotten Pools", npc = "Tonga Runetotem (52.3, 31.9)" },
            { id = 869, name = "Raptor Thieves", npc = "Gazrog (51.9, 30.3)" },
            { id = 871, name = "Disrupt the Attacks", npc = "Thork (51.5, 30.9)" },
            { id = 850, name = "Kolkar Leaders", npc = "Regthar Deathgate (45.3, 28.4)" },
            { id = 865, name = "Raptor Horns", npc = "Mebok Mizzyrix (Ratchet 62.4, 37.6)" },
            { id = 895, name = "WANTED: Baron Longshore", npc = "Wanted Sign (Ratchet 62.6, 37.5)" },
            { id = 900, name = "Samophlange", npc = "Sputtervalve (62.9, 37.2)" }
        }
    },
    {
        type = "DUNGEON", minLevel = 15, maxLevel = 21, customHub = true,
        zone = "Undercity", coords = "57.8, 89.8", npc = "Morbin Lightbane",
        title = "NEW DUNGEON: Ruins of Lordaeron & Wailing Caverns (15-21)",
        note = "Run Wailing Caverns in The Barrens (46.0, 36.4) and take the zeppelin to Undercity for WoW: Forever's Ruins of Lordaeron dungeon (NE Undercity courtyard) and Shadowfang Keep (20-23)!",
        quests = {
            { name = "A Frightened Request", npc = "Tabitha Heartweaver (Sepulcher 44.5, 43.0 - RoL)" },
            { name = "Light's Justice", npc = "Morbin Lightbane (Undercity 57.8, 89.8 - RoL)" },
            { name = "The New Plague", npc = "Theodore Griffs (Undercity 46.6, 72.0 - RoL)" },
            { name = "The Wrath of Rath'mael", npc = "Deathguard Kristof (Tirisfal 65.2, 60.2 - RoL)" },
            { id = 959,  name = "Leaders of the Fang", npc = "Nara Wildmane (Thunder Bluff - WC)" },
            { id = 962,  name = "Serpentbloom", npc = "Apothecary Zamah (Thunder Bluff - WC)" },
            { id = 1014, name = "Arugal Must Die", npc = "Dalar Dawnweaver (The Sepulcher - SFK)" },
            { id = 1013, name = "The Book of Ur", npc = "Keeper Bel'dugur (Undercity - SFK)" }
        }
    },
    {
        type = "COMPLETE", minLevel = 20, maxLevel = 26,
        zone = "Stonetalon Mountains", coords = "47.5, 62.1", npc = "Ziz Fizziks",
        title = "Stonetalon Mountains & Camp Taurajo (20-25)",
        note = "Clear Sun Rock Retreat (46.0, 59.8) & Windshear Crag in Stonetalon Mountains, plus Camp Taurajo in Southern Barrens (44.5, 59.2).",
        quests = {
            { id = 1093, name = "Super Reaper 6000", npc = "Ziz Fizziks (Windshear Crag 59.0, 62.5)" },
            { id = 6282, name = "Harpies Threaten", npc = "Maggran Earthbinder (Sun Rock 47.2, 61.1)" },
            { id = 6401, name = "Kaya's Alive", npc = "Tammra Windfield (47.5, 58.4)" },
            { id = 1062, name = "Goblin Invaders", npc = "Seereth Stonebreak (35.3, 27.8)" },
            { id = 878,  name = "Tribes at War", npc = "Mangletooth (Camp Taurajo 44.5, 59.2)" },
            { id = 907,  name = "Enraged Thunder Lizards", npc = "Jorn Skyseer (Camp Taurajo 44.8, 59.1)" }
        }
    },
    {
        type = "COMPLETE", minLevel = 23, maxLevel = 28,
        zone = "Hillsbrad Foothills", coords = "62.3, 19.0", npc = "High Executor Darthalia",
        title = "Tarren Mill Hub (Hillsbrad Foothills) (23-28)",
        note = "At Level 25, spend your first Legacy Point on 'Well Rested' (boosts Rested XP cap & rate by 20%). Clear all standard Tarren Mill quests.",
        quests = {
            { id = 493, name = "Journey to Hillsbrad", npc = "Apothecary Lydon (61.4, 19.2)" },
            { id = 496, name = "Elixir of Suffering", npc = "Apothecary Lydon" },
            { id = 501, name = "Elixir of Pain", npc = "Apothecary Lydon" },
            { id = 509, name = "Elixir of Agony", npc = "Apothecary Lydon" },
            { id = 527, name = "Battle of Hillsbrad", npc = "High Executor Darthalia (62.3, 19.0)" },
            { id = 546, name = "Souvenirs of Death", npc = "Deathguard Samsa (62.2, 19.7)" },
            { id = 552, name = "Helcular's Revenge", npc = "Novice Thaivand (63.9, 19.6)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 28, maxLevel = 31,
        zone = "Thousand Needles", coords = "45.6, 50.8", npc = "Cliffwatcher Longhorn",
        title = "Level 29 Bridge: Freewind Post & RFK Prep (29-30)",
        note = "Because the City of Dalaran attunement in Tarren Mill requires Level 30 to pick up, cross to Kalimdor at 29! Grab RFK quests in Thunder Bluff/Ratchet, ride down the Great Lift to Freewind Post (45.6, 50.8), and clear Freewind Post to hit Level 30-31.",
        quests = {
            { id = 4841, name = "Pacify the Centaur", npc = "Cliffwatcher Longhorn (45.6, 50.8)" },
            { id = 5147, name = "Wanted - Arnak Grimtotem", npc = "Wanted Poster (45.9, 50.9)" },
            { id = 4821, name = "Alien Egg", npc = "Hagar Lightninghoof (44.7, 50.3)" },
            { id = 4767, name = "Wind Rider", npc = "Elu (44.8, 49.0)" },
            { id = 5062, name = "Sacred Fire", npc = "Motega Firemane (Whitereach 21.5, 32.3)" },
            { id = 5151, name = "Hypercapacitor Gizmo", npc = "Wizlo Bearingshiner (Whitereach 21.5, 32.3)" },
            { id = 5064, name = "Grimtotem Spying", npc = "Cliffwatcher Longhorn (Darkcloud Pinnacle)" },
            { id = 4904, name = "Free at Last", npc = "Lakota Windsong (Darkcloud 38.0, 26.6)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 30, maxLevel = 34, customHub = true,
        zone = "Hillsbrad Foothills", coords = "61.5, 20.7", npc = "Magus Wordeen Voidglare",
        title = "Level 30+: City of Dalaran Attunement (Tarren Mill)",
        note = "Once you hit Level 30, return to Tarren Mill (61.5, 20.7)!\n1) Accept 'Prison Break In' & 'Key to the City' from Magus Wordeen Voidglare (loot Grimy Key from the Warden's Footlocker on the upper floor of the 2-story Internment building).\n2) Turn in & complete 'Dalaran Patrols' (6 Dalaran Summoners + Elemental Slaves).\n3) Complete 'Blood in the Streets' -> follow Lordamere Lake NW to the Image of Archmage Modera outside the sewer (Silverpine 68.5, 45.1) to get your Dalaran Sewer Key!\n*SKIP Keeper Bel'Varil's 'Stone Tokens' & 'Bracers of Binding'—they are NOT required for the key!",
        quests = {
            { name = "Prison Break In", npc = "Magus Wordeen Voidglare (Tarren Mill 61.5, 20.7)" },
            { name = "Key to the City", npc = "Magus Wordeen Voidglare (Warden's Footlocker)" },
            { name = "Dalaran Patrols", npc = "Magus Wordeen Voidglare (6 Summoners & Slaves)" },
            { name = "Blood in the Streets", npc = "Magus Wordeen Voidglare -> Archmage Modera" },
            { name = "Heart of Disruption", npc = "Image of Archmage Modera (Silverpine 68.5, 45.1)" }
        }
    },
    {
        type = "DUNGEON", minLevel = 30, maxLevel = 35, customHub = true,
        zone = "Silverpine Forest", coords = "69.3, 45.6", npc = "Rexxie Copperclutch",
        title = "NEW DUNGEON: City of Dalaran (30-34)",
        note = "Grab 'Source of Power' in Undercity (46.4, 74.3) and 'The Grave Knight' in Tarren Mill (62.6, 20.6). Enter the Dalaran Sewer at Silverpine (69.3, 45.6)—avoid Kirin Tor guards! Pick up 'Opportunistic Education' from Rexxie Copperclutch right INSIDE the entrance. (Only 1 party member needs the Sewer Key to open the grate).",
        quests = {
            { name = "Source of Power", npc = "Doctor Martin Felben (Undercity 46.4, 74.3)" },
            { name = "The Grave Knight", npc = "Melisara (Tarren Mill 62.6, 20.6)" },
            { name = "Heart of Disruption", npc = "Image of Archmage Modera (Silverpine 68.5, 45.1)" },
            { name = "Opportunistic Education", npc = "Rexxie Copperclutch (Inside Dungeon Entrance)" }
        }
    },
    {
        type = "DUNGEON", minLevel = 30, maxLevel = 35,
        zone = "The Barrens", coords = "42.3, 89.5", npc = "Heralath Fallowbrook",
        title = "Run Dungeon: Razorfen Kraul (RFK) (31-34)",
        note = "Grab the 3 RFK pre-quests in Thunder Bluff & Ratchet, then enter RFK (42.3, 89.5) and pick up the 2 inside quests for a huge 5-quest XP payout!",
        quests = {
            { id = 1102, name = "A Vengeful Fate", npc = "Rahauro (Thunder Bluff 70.4, 29.6)" },
            { id = 1109, name = "Going, Going, Guano!", npc = "Apothecary Zamah (TB Spirit Rise 22.9, 20.9)" },
            { id = 1221, name = "Blueleaf Tubers", npc = "Mebok Mizzyrix (Ratchet 62.4, 37.6)" },
            { id = 1142, name = "Mortality Wanes", npc = "Heralath Fallowbrook (Inside RFK)" },
            { id = 1144, name = "Willix the Importer", npc = "Willix the Importer (Inside RFK)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 31, maxLevel = 36,
        zone = "Thousand Needles", coords = "77.8, 77.2", npc = "Kravel Koalbeard",
        title = "Shimmering Flats: All 6 Mirage Raceway Quests (32-35)",
        note = "Run east to Mirage Raceway (77.8, 77.2). Pick up all 6 quests at the Goblin & Gnome stands and clear the flats in a clockwise loop.",
        quests = {
            { id = 1110, name = "Rocket Car Parts", npc = "Kravel Koalbeard (77.8, 77.2)" },
            { id = 1111, name = "Wharfmaster Dizzywig", npc = "Kravel Koalbeard (77.8, 77.2)" },
            { id = 1104, name = "Salt Flat Venom", npc = "Fizzle Brassbolts (78.0, 77.1)" },
            { id = 1105, name = "Hardened Shells", npc = "Wizzle Brassbolts (78.3, 77.0)" },
            { id = 1176, name = "Load Lightening", npc = "Pozzik (80.1, 75.8)" },
            { id = 1175, name = "A Bump in the Road", npc = "Trackmaster Zherin (81.6, 77.9)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 33, maxLevel = 39,
        zone = "Stranglethorn Vale", coords = "32.2, 28.9", npc = "Commander Aggro'gosh",
        title = "North STV & NEW DUNGEON: The Drowned City (34-39)",
        note = "Set Hearth at Grom'gol (32.5, 29.3). Clear Nesingwary's Expedition (35.6, 10.5) and complete Kin'weelay's chain ('Bloodscalp Ears' -> 'The Vile Reef' -> 'Locating the Lost City') + Booty Bay's Krazek (27.0, 77.2) to unlock all quests for WoW: Forever's The Drowned City (35-40)!",
        quests = {
            { id = 568, name = "The Defense of Grom'gol", npc = "Commander Aggro'gosh (32.2, 28.9)" },
            { id = 581, name = "Hunt for Yenniku", npc = "Nimboya (32.2, 28.8)" },
            { id = 189, name = "Bloodscalp Ears", npc = "Kin'weelay (32.2, 27.8 - Drowned City Chain)" },
            { id = 629, name = "The Vile Reef", npc = "Kin'weelay -> Unlocks 'The Drowned City'" },
            { id = 185, name = "Tiger Mastery", npc = "Ajeck Rouack (Nesingwary 35.6, 10.7)" },
            { id = 190, name = "Panther Mastery", npc = "Sir S. J. Erlgadin (35.6, 10.5)" },
            { id = 194, name = "Raptor Mastery", npc = "Hemet Nesingwary (35.7, 10.8)" },
            { name = "The Drowned City", npc = "Kin'weelay (Grom'gol - Dungeon)" },
            { name = "The Only Good Brinescale...", npc = "Commander Aggro'gosh (Grom'gol - Dungeon)" },
            { name = "The Saltseer Captain", npc = "Krazek (Booty Bay 27.0, 77.2 - Dungeon)" }
        }
    },
    {
        type = "DUNGEON", minLevel = 35, maxLevel = 41,
        zone = "Tirisfal Glades", coords = "84.9, 32.9", npc = "Varimathras",
        title = "Scarlet Monastery (GY/Lib/Arm/Cath) & Arathi (35-40)",
        note = "Clear Hammerfall in Arathi Highlands (73.8, 33.9) and run Scarlet Monastery (84.9, 32.9) once with all quests.",
        quests = {
            { id = 1113, name = "Hearts of Zeal", npc = "Master Apothecary Faranell (Undercity)" },
            { id = 1049, name = "Compendium of the Fallen", npc = "Sage Truthseeker (Thunder Bluff)" },
            { id = 1051, name = "Vorrel's Revenge", npc = "Vorrel Sengutz (Inside SM Graveyard)" },
            { id = 1048, name = "Into the Scarlet Monastery", npc = "Varimathras (Undercity 56.2, 92.6)" },
            { id = 655,  name = "Hammerfall", npc = "Tor'gan (Arathi Highlands 74.6, 36.3)" },
            { id = 672,  name = "Raising Spirits", npc = "Tor'gan (Arathi Highlands)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 35, maxLevel = 45, customHub = true,
        zone = "The Riverglades", coords = "59.4, 45.5", npc = "Krom'rosh",
        title = "NEW ZONE: The Riverglades (150+ Quests) & Krol'dok (36-45)",
        note = "The #1 leveling zone in WoW: Forever! Take the boat from Steamwheedle Port in Tanaris to Powderfuse Port (or the road fork between Redridge & Burning Steppes). Head to Rog'mar (59.4, 45.5), clear the 150+ zone quests, buy your Level 40 Mount (Skyborne train Galestriders at Fairweather Stables in Zephras Isle 53.8, 81.3!), and unlock all 4 Krol'dok Stronghold (40-45) dungeon quests!",
        quests = {
            { name = "Clugfist's Decree", npc = "Clugfist (Rog'mar 59.4, 45.5 - Starts Chain)" },
            { name = "The Wayward Warrior", npc = "Rog'mar Chain Step 2" },
            { name = "Show Them How It's Done", npc = "Rog'mar Chain Step 3" },
            { name = "Bring Me His Head", npc = "Rog'mar Chain Step 4" },
            { name = "It Is Time, Brother...", npc = "Unlocks Krol'dok Dungeon Quests" },
            { name = "Eye of Mugg", npc = "Krom'rosh (Rog'mar 59.4, 45.5 - Krol'dok)" },
            { name = "Tome of Twilight", npc = "Tran'gul (Rog'mar 59.4, 44.0 - Krol'dok)" },
            { name = "A Token of Vengeance", npc = "Da'grosh (Riverglades 33.4, 38.0 - Krol'dok)" },
            { name = "Key Ingredients", npc = "Krol'dok Moulding Drop -> Kreza Darkthorn" }
        }
    },
    {
        type = "ACCEPT", minLevel = 38, maxLevel = 44,
        zone = "Desolace", coords = "24.1, 68.2", npc = "Taiga Wisemane",
        title = "Desolace + NEW ZONE: Shen'dralas (38-43)",
        note = "Complete your Gelkis/Magram alignment in Desolace (Magram is recommended before entering Shen'dralas so half the zone isn't hostile!), then explore WoW: Forever's new Shen'dralas zone (40-43) with Mordent Evenshade for the Spectral Magister's Commission katana and Maraudon pre-quest!",
        quests = {
            { id = 1365, name = "Khan Dez'hepah", npc = "Felgur Twocuts (Desolace 56.2, 59.5)" },
            { id = 1367, name = "Magram Alliance", npc = "Gorka (Desolace - Recommended for Shen'dralas!)" },
            { id = 5501, name = "Bone Collector", npc = "Bibbly F'utzbuckle (62.3, 38.9)" },
            { id = 5381, name = "Hand of Iruxos", npc = "Taiga Wisemane (Shadowprey 25.8, 68.2)" },
            { id = 1251, name = "The Black Shield", npc = "Krog (Brackenwall 36.4, 31.8)" },
            { id = 710,  name = "Study of the Elements: Rock", npc = "Lotwil Veriatus (Badlands 25.9, 44.9)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 43, maxLevel = 49,
        zone = "Tanaris", coords = "51.6, 26.8", npc = "Chief Engineer Bilgewhizzle",
        title = "Tanaris (Gadgetzan), Feralas & Zul'Farrak (43-48)",
        note = "Clear Gadgetzan (51.6, 26.8) and Camp Mojache in Feralas (74.8, 45.1), and run Zul'Farrak (38.7, 20.0) with all 7 quests!",
        quests = {
            { id = 1690, name = "Wastewander Justice", npc = "Chief Engineer Bilgewhizzle (52.5, 28.5)" },
            { id = 1707, name = "Water Pouch Bounty", npc = "Spigot Operator Luglunket (52.5, 28.4)" },
            { id = 3042, name = "Troll Temper", npc = "Trenton Lighthammer (Gadgetzan - ZF)" },
            { id = 2865, name = "Scarab Shells", npc = "Tran'rek (Gadgetzan - ZF)" },
            { id = 2768, name = "Divino-matic Rod", npc = "Chief Engineer Bilgewhizzle (ZF)" },
            { id = 2770, name = "Gahz'rilla", npc = "Wizzle Brassbolts (Shimmering Flats - ZF)" },
            { id = 2846, name = "Tiara of the Deep", npc = "Tabetha (Dustwallow 46.0, 57.0 - ZF)" },
            { id = 2822, name = "The Mark of Quality", npc = "Jangdor Swiftstrider (Feralas 74.4, 42.9)" }
        }
    },
    {
        type = "DUNGEON", minLevel = 47, maxLevel = 53,
        zone = "The Hinterlands", coords = "78.2, 81.3", npc = "Primal Torntusk",
        title = "Hinterlands, Maraudon & NEW DUNGEON: Alcaz Prison (47-53)",
        note = "Clear Revantusk Village in The Hinterlands (78.2, 81.3), run Maraudon (48-51), and run WoW: Forever's new Alcaz Prison (48-53) on Alcaz Island (5 bosses: Overseer Wrex, The Questioner, Tidemistress Ca'zass, Katerina the Cleaner, and Blazeroar)!",
        quests = {
            { id = 7815, name = "Snapjaws, Mon!", npc = "Katoom the Angler (Hinterlands 80.3, 81.5)" },
            { id = 7844, name = "Cannibalistic Cousins", npc = "Mystic Yayo'jin (78.8, 78.4)" },
            { id = 7862, name = "Job Opening: Guard Captain of Revantusk Village", npc = "Wanted Poster (79.0, 79.0)" },
            { id = 7064, name = "Corruption of Earth and Seed", npc = "Selendra (Desolace 26.9, 77.5 - Maraudon)" },
            { id = 7067, name = "The Pariah's Instructions", npc = "Centaur Pariah (Desolace - Maraudon)" }
        }
    },
    {
        type = "ACCEPT", minLevel = 50, maxLevel = 56,
        zone = "Un'Goro Crater", coords = "43.6, 8.5", npc = "Williden Marshal",
        title = "Un'Goro Crater, Felwood & BRD (50-56)",
        note = "Levels 50-60 hold more XP than 1-40 combined! Clear Marshal's Refuge in Un'Goro (43.6, 8.5)—save 15 of each color Power Crystal (60 total) to summon the 4 console bosses & Nanaya in WoW: Forever's Shaper's Terrace dungeon at 58!",
        quests = {
            { id = 4284, name = "Crystals of Power", npc = "J.D. Collie (Un'Goro Cave 41.9, 2.7)" },
            { id = 3881, name = "Expedition Salvation", npc = "Williden Marshal (43.9, 7.2)" },
            { id = 3882, name = "Roll the Bones", npc = "Spark Nilminer (43.6, 7.4)" },
            { id = 4289, name = "The Apes of Un'Goro", npc = "Karna Remtravel (46.4, 13.4)" },
            { id = 4501, name = "Beware of Pterrordax", npc = "Wanted Sign (43.6, 8.3)" },
            { id = 5155, name = "Forces of Jaedenar", npc = "Greta Mosshoof (Felwood 51.2, 82.2)" },
            { id = 4521, name = "Wild Guardians", npc = "Trull Failbane (Felwood 34.7, 52.8)" }
        }
    },
    {
        type = "DUNGEON", minLevel = 55, maxLevel = 60, customHub = true,
        zone = "Azshara", coords = "38.4, 32.6", npc = "Jediga",
        title = "NEW 55-60 DUNGEONS: Blackmaw Hold & The Shaper's Terrace",
        note = "1) BLACKMAW HOLD (Azshara tunnel 38.4, 32.6 -> portal 35.0, 23.4): Start 'Beneath Nordrassil' with Jediga in Valormok -> Nara Wildmane in Thunder Bluff for 'Get to the Roots of It', plus grab 'Claws That Rend, Tusks that Gore' (Ogtinc) & 'Blackmaw Pouches' (Ekkal at Ruins of Eldarath).\n2) THE SHAPER'S TERRACE (Un'Goro northern rim 48.1, 6.1, opens at 55): Before flying to Un'Goro, visit Mayena Earthseeker in Mulgore (34.8, 22.2) and Chemist Fuely & Master Apothecary Faranell in Undercity for all 3 Horde quests (41,900 total quest XP)!\n3) Clear WPL/EPL Cauldrons & Winterspring to ding 60!",
        quests = {
            { name = "Beneath Nordrassil", npc = "Jediga (Valormok, Azshara -> TB - Blackmaw Prereq)" },
            { name = "Get to the Roots of It", npc = "Nara Wildmane (Thunder Bluff Elder Rise - Blackmaw)" },
            { name = "Claws That Rend, Tusks that Gore", npc = "Ogtinc (Azshara - Blackmaw Hold)" },
            { name = "Blackmaw Pouches", npc = "Ekkal (Ruins of Eldarath, Azshara - Blackmaw Hold)" },
            { name = "Shaper's Terrace: Elemental Crystals", npc = "Mayena Earthseeker (Mulgore 34.8, 22.2)" },
            { name = "Shaper's Terrace: 8 Seeping Slime Essence", npc = "Chemist Fuely (Undercity Apothecarium)" },
            { name = "Shaper's Terrace: Drained Crystal Fragment", npc = "Master Apothecary Faranell (Undercity)" },
            { id = 5228, name = "Target: Felstone Field", npc = "High Executor Derrington (WPL 83.0, 68.5)" }
        }
    }
}

local function BuildFullRoute(starterKey, label)
    local steps = {}
    local starter = FordsRestedGuide_Starters[starterKey] or {}
    for _, s in ipairs(starter) do table.insert(steps, s) end
    for _, s in ipairs(FordsRestedGuide_Shared_13_60) do table.insert(steps, s) end
    return { name = label, steps = steps }
end

FordsRestedGuide_Routes["Undead"]   = BuildFullRoute("Undead",   "Undead (Tirisfal -> 60)")
FordsRestedGuide_Routes["OrcTroll"] = BuildFullRoute("OrcTroll", "Orc / Troll (Durotar -> 60)")
FordsRestedGuide_Routes["Tauren"]   = BuildFullRoute("Tauren",   "Tauren (Mulgore -> 60)")
FordsRestedGuide_Routes["Skyborne"] = BuildFullRoute("Skyborne", "Windshaper Skyborne (Zephras Isle -> 60)")