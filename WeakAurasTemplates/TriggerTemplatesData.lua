local WeakAuras = WeakAuras
local L = WeakAuras.L
local GetSpellInfo, tinsert, GetItemInfo, GetSpellDescription, C_Timer, Spell =
  GetSpellInfo,
  tinsert,
  GetItemInfo,
  GetSpellDescription,
  C_Timer,
  Spell

-- The templates tables are created on demand
local templates = {
  class = {},
  race = {
    Human = {},
    NightElf = {},
    Dwarf = {},
    Gnome = {},
    Draenei = {},
    Worgen = {},
    Pandaren = {},
    Orc = {},
    Scourge = {},
    Tauren = {},
    Troll = {},
    BloodElf = {},
    Goblin = {},
    Nightborne = {},
    LightforgedDraenei = {},
    HighmountainTauren = {},
    VoidElf = {}
  },
  general = {
    title = L["General"],
    icon = 136116,
    args = {}
  },
  items = {}
}

local powerTypes = {
  [0] = {
    name = POWER_TYPE_MANA,
    icon = "Interface\\Icons\\inv_elemental_mote_mana"
  },
  [1] = {
    name = POWER_TYPE_RED_POWER,
    icon = "Interface\\Icons\\spell_misc_emotionangry"
  },
  [2] = {
    name = POWER_TYPE_FOCUS,
    icon = "Interface\\Icons\\ability_hunter_focusfire"
  },
  [3] = {
    name = POWER_TYPE_ENERGY,
    icon = "Interface\\Icons\\spell_shadow_shadowworddominate"
  },
  [4] = {
    name = COMBO_POINTS,
    icon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01"
  },
  [6] = {
    name = RUNIC_POWER,
    icon = "Interface\\Icons\\inv_sword_62"
  },
  [7] = {
    name = SOUL_SHARDS_POWER,
    icon = "Interface\\Icons\\inv_misc_gem_amethyst_02"
  },
  [8] = {
    name = POWER_TYPE_LUNAR_POWER,
    icon = "Interface\\Icons\\ability_druid_eclipseorange"
  },
  [9] = {
    name = HOLY_POWER,
    icon = "Interface\\Icons\\achievement_bg_winsoa"
  },
  [11] = {
    name = POWER_TYPE_MAELSTROM,
    icon = 135990
  },
  [12] = {
    name = CHI_POWER,
    icon = "Interface\\Icons\\ability_monk_healthsphere"
  },
  [13] = {
    name = POWER_TYPE_INSANITY,
    icon = "Interface\\Icons\\spell_priest_shadoworbs"
  },
  [16] = {
    name = POWER_TYPE_ARCANE_CHARGES,
    icon = "Interface\\Icons\\spell_arcane_arcane01"
  },
  [17] = {
    name = POWER_TYPE_FURY_DEMONHUNTER,
    icon = 1344651
  },
  [18] = {
    name = POWER_TYPE_PAIN,
    icon = 1247265
  },
  [99] = {
    name = STAGGER,
    icon = "Interface\\Icons\\monk_stance_drunkenox"
  }
}

local generalAzeriteTraits = { {
  spell = 279928,
  type = "buff",
  unit = "player"
}, { --Earthlink
  spell = 271543,
  type = "buff",
  unit = "player"
}, { --Ablative Shielding
  spell = 268435,
  type = "buff",
  unit = "player"
}, { --Azerite Fortification
  spell = 264108,
  type = "buff",
  unit = "player"
}, { --Blood Siphon
  spell = 270657,
  type = "buff",
  unit = "player"
}, { --Bulwark of the Masses
  spell = 270586,
  type = "buff",
  unit = "player"
}, { --Champion of Azeroth
  spell = 271538,
  type = "buff",
  unit = "player"
}, { --Crystalline Carapace
  spell = 272572,
  type = "buff",
  unit = "player"
}, { --Ephemeral Recovery
  spell = 270576,
  type = "buff",
  unit = "player"
}, { --Gemhide
  spell = 268437,
  type = "buff",
  unit = "player"
}, { --Impassive Visage
  spell = 270621,
  type = "buff",
  unit = "player"
}, { --Lifespeed
  spell = 267879,
  type = "buff",
  unit = "player"
}, { --On My Way
  spell = 270568,
  type = "buff",
  unit = "player"
}, { --Resounding Protection
  spell = 270661,
  type = "buff",
  unit = "player"
}, { --Self Reliance
  spell = 272090,
  type = "buff",
  unit = "player"
}, { --Synergistic Growth
  spell = 269239,
  type = "buff",
  unit = "player"
}, { --Vampiric Speed
  spell = 269214,
  type = "buff",
  unit = "player"
}, { --Winds of War
  spell = 281516,
  type = "buff",
  unit = "player"
}, { --Unstable Catalyst
  spell = 279902,
  type = "buff",
  unit = "player"
}, { --Unstable Flames
  spell = 279956,
  type = "debuff",
  unit = "multi"
}, { --Azerite Globules
  spell = 270674,
  type = "buff",
  unit = "player"
}, { --Azerite Veins
  spell = 271843,
  type = "buff",
  unit = "player"
}, { --Blessed Portents
  spell = 272276,
  type = "buff",
  unit = "target"
}, { --Bracing Chill
  spell = 272260,
  type = "buff",
  unit = "target"
}, { --Concentrated Mending
  spell = 268955,
  type = "buff",
  unit = "player"
}, { --Elemental Whirl
  spell = 263987,
  type = "buff",
  unit = "player"
}, { --Heed My Call
  spell = 271711,
  type = "buff",
  unit = "player"
}, { --Overwhelming Power
  spell = 271550,
  type = "buff",
  unit = "player"
}, { --Strength in Numbers
  spell = 271559,
  type = "buff",
  unit = "player"
}, { --Shimmering Haven
  spell = 269085,
  type = "buff",
  unit = "player"
}, { --Woundbinder
  spell = 273685,
  type = "buff",
  unit = "player"
}, { --Meticulous Scheming
  spell = 273714,
  type = "buff",
  unit = "player"
}, { --Seize the Moment!
  spell = 273870,
  type = "buff",
  unit = "player"
}, { --Sandstorm
  spell = 280204,
  type = "buff",
  unit = "player"
}, { --Wandering Soul
  spell = 280409,
  type = "buff",
  unit = "player"
}, { --Blood Rite
  spell = 273836,
  type = "buff",
  unit = "player"
}, { --Filthy Transfusion
  spell = 280413,
  type = "buff",
  unit = "player"
}, { --Incite the Pack
  spell = 273794,
  type = "debuff",
  unit = "multi"
}, { --Rezan's Fury
  spell = 280433,
  type = "buff",
  unit = "player"
}, { --Swirling Sands
  spell = 280385,
  type = "debuff",
  unit = "multi"
}, { --Thunderous Blast
  spell = 280404,
  type = "buff",
  unit = "target"
}, { --Tidal Surge
  spell = 273842,
  type = "buff",
  unit = "player"
}, { --Secrets of the Deep
  spell = 280286,
  type = "debuff",
  unit = "target"
}, { --Dagger in the Back
  spell = 281843,
  type = "buff",
  unit = "player"
}, { --Tradewinds
  spell = 280709,
  type = "buff",
  unit = "player"
}, { --Archive of the Titans
  spell = 280573,
  type = "buff",
  unit = "player"
}, { --Reorigination Array
  spell = 287471,
  type = "buff",
  unit = "player"
}, { --Shadow of Elune
  spell = 287610,
  type = "buff",
  unit = "player"
}, { --Ancient's Bulwark (Deep Roots)
  spell = 287608,
  type = "buff",
  unit = "player"
} } --Ancient's Bulwark (Uproot)

local pvpAzeriteTraits = { {
  spell = 280876,
  type = "buff",
  unit = "player"
}, { --Anduin's Dedication
  spell = 280809,
  type = "buff",
  unit = "player"
}, { --Sylvanas' Resolve
  spell = 280855,
  type = "debuff",
  unit = "target"
}, { --Battlefield Precision
  spell = 280817,
  type = "debuff",
  unit = "target"
}, { --Battlefield Focus
  spell = 280858,
  type = "buff",
  unit = "player"
}, { --Stand As One
  spell = 280830,
  type = "buff",
  unit = "player"
}, { --Liberator's Might
  spell = 280780,
  type = "buff",
  unit = "player"
}, { --Glory in Battle
  spell = 280861,
  type = "buff",
  unit = "player"
}, { --Last Gift
  spell = 280787,
  type = "buff",
  unit = "player"
} } --Retaliatory Fury

-- Collected by WeakAurasTemplateCollector:
if WeakAuras.IsClassic() then
  templates.class.WARRIOR = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 2565,
          type = "buff",
          unit = "player"
        }, { -- Shield Block
          spell = 6673,
          type = "buff",
          unit = "player"
        }, { -- Battle Shout
          spell = 18499,
          type = "buff",
          unit = "player"
        }, { -- Berserker Rage
          spell = 12292,
          type = "buff",
          unit = "player"
        }, { -- Sweeping Strikes
          spell = 12328,
          type = "buff",
          unit = "player"
        }, { -- Death Wish
          spell = 12317,
          type = "buff",
          unit = "player"
        }, { -- Enrage
          spell = 12319,
          type = "buff",
          unit = "player"
        }, { -- Flurry
          spell = 12975,
          type = "buff",
          unit = "player"
        } }, -- Last Stand
        icon = 132333
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 355,
          type = "debuff",
          unit = "target"
        }, { -- Taunt
          spell = 676,
          type = "debuff",
          unit = "target"
        }, { -- Disarm
          spell = 694,
          type = "debuff",
          unit = "target"
        }, { -- Mocking Blow
          spell = 772,
          type = "debuff",
          unit = "target"
        }, { -- Rend
          spell = 1160,
          type = "debuff",
          unit = "target"
        }, { -- Demoralizing Shout
          spell = 1715,
          type = "debuff",
          unit = "target"
        }, { -- Hamstring
          spell = 5246,
          type = "debuff",
          unit = "target"
        }, { -- Intimidating Shout
          spell = 6343,
          type = "debuff",
          unit = "target"
        }, { -- Thunder Clap
          spell = 7384,
          type = "debuff",
          unit = "target"
        }, { -- Sunder Armor
          spell = 12289,
          type = "debuff",
          unit = "target"
        }, { -- Improved Hamstring
          spell = 12294,
          type = "debuff",
          unit = "target"
        }, { -- Mortal Strike
          spell = 12797,
          type = "debuff",
          unit = "target"
        }, { -- Improved Revenge
          spell = 12809,
          type = "debuff",
          unit = "target"
        } }, -- Concussion Blow
        icon = 132366
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 72,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          form = 2
        }, { -- Shield Bash
          spell = 100,
          type = "ability",
          requiresTarget = true,
          form = 1
        }, { -- Charge
          spell = 355,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          form = 2
        }, { -- Taunt
          spell = 676,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          form = 2
        }, { -- Disarm
          spell = 694,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          form = 1
        }, { -- Mocking Blow
          spell = 772,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, { -- Rend
          spell = 845,
          type = "ability"
        }, { -- Cleave
          spell = 871,
          type = "ability",
          buff = true,
          form = 2
        }, { -- Shield Wall
          spell = 1160,
          type = "ability",
          debuff = true
        }, { -- Demoralizing Shout
          spell = 1161,
          type = "ability",
          debuff = true
        }, { -- Challenging Shout
          spell = 1464,
          type = "ability",
          requiresTarget = true
        }, { -- Slam
          spell = 1680,
          type = "ability",
          form = 3
        }, { -- Whirlwind
          spell = 1715,
          type = "ability",
          requiresTarget = true,
          form = { 1, 2 }
        }, { -- Hamstring
          spell = 1719,
          type = "ability",
          buff = true,
          form = 3
        }, { -- Recklessness
          spell = 2565,
          type = "ability",
          buff = true,
          form = 2
        }, { -- Shield Block
          spell = 2687,
          type = "ability",
          buff = true
        }, { -- Bloodrage
          spell = 5246,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, { -- Intimidating Shout
          spell = 5308,
          type = "ability",
          requiresTarget = true,
          form = { 1, 3 }
        }, { -- Execute
          spell = 6343,
          type = "ability",
          debuff = true,
          form = 1
        }, { -- Thunder Clap
          spell = 6552,
          type = "ability",
          requiresTarget = true,
          form = 3
        }, { -- Pummel
          spell = 6572,
          type = "ability",
          requiresTarget = true,
          usable = true,
          form = 2
        }, { -- Revenge
          spell = 6673,
          type = "ability",
          buff = true
        }, { -- Battle Shout
          spell = 7384,
          type = "ability",
          requiresTarget = true,
          form = 1
        }, { -- Overpower
          spell = 7386,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Sunder Armor
          spell = 12323,
          type = "ability",
          debuff = true,
          talent = 26
        }, { -- Piercing Howl
          spell = 12292,
          type = "ability",
          buff = true,
          talent = 13
        }, { -- Sweeping Strikes
          spell = 12294,
          type = "ability",
          requiresTarget = true,
          talent = 18
        }, { -- Mortal Strike
          spell = 12809,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 54
        }, { -- Concussion Blow
          spell = 12975,
          type = "ability",
          buff = true,
          talent = 46
        }, { -- Last Stand
          spell = 12328,
          type = "ability",
          buff = true,
          talent = 33
        }, { -- Death Wish
          spell = 18499,
          type = "ability",
          buff = true,
          form = 3
        }, { -- Berserker Rage
          spell = 20230,
          type = "ability",
          buff = true,
          form = 1
        }, { -- Retaliation
          spell = 20252,
          type = "ability",
          requiresTarget = true,
          form = 3
        }, { -- Intercept
          spell = 23881,
          type = "ability",
          requiresTarget = true,
          talent = 37
        }, { -- Bloodthirst
          spell = 23922,
          type = "ability",
          requiresTarget = true,
          talent = 57
        } }, -- Shield Slam
        icon = 132355
      },
      [4] = {},
      [5] = {},
      [6] = {},
      [7] = {},
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\spell_misc_emotionangry"
      }
    }
  }

  templates.class.PALADIN = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 498,
          type = "buff",
          unit = "player"
        }, { -- Divine Protection
          spell = 642,
          type = "buff",
          unit = "player"
        }, { -- Divine Shield
          spell = 1022,
          type = "buff",
          unit = "group"
        }, { -- Blessing of Protection
          spell = 1044,
          type = "buff",
          unit = "group"
        }, { -- Blessing of Freedom
          spell = 6940,
          type = "buff",
          unit = "group"
        } }, -- Blessing of Sacrifice
        icon = 135964
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 853,
          type = "debuff",
          unit = "target"
        } }, -- Hammer of Justice
        icon = 135952
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 498,
          type = "ability",
          buff = true
        }, { -- Divine Protection
          spell = 633,
          type = "ability"
        }, { -- Lay on Hands
          spell = 642,
          type = "ability",
          buff = true
        }, { -- Divine Shield
          spell = 853,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Hammer of Justice
          spell = 879,
          type = "ability",
          requiresTarget = true,
          usable = true
        }, { -- Exorcism
          spell = 1022,
          type = "ability",
          buff = true
        }, { -- Blessing of Protection
          spell = 1044,
          type = "ability",
          buff = true
        }, { -- Blessing of Freedom
          spell = 1052,
          type = "ability"
        }, { -- Purify
          spell = 2812,
          type = "ability"
        }, { -- Holy Wrath
          spell = 4987,
          type = "ability"
        }, { -- Cleanse
          spell = 6940,
          type = "ability"
        }, { -- Blessing of Sacrifice
          spell = 19876,
          type = "ability",
          buff = true
        }, { -- Shadow Resistance Aura
          spell = 19888,
          type = "ability",
          buff = true
        }, { -- Frost Resistance Aura
          spell = 19891,
          type = "ability",
          buff = true
        }, { -- Fire Resistance Aura
          spell = 20066,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 55
        }, { -- Repentance
          spell = 20165,
          type = "ability",
          buff = true
        }, { -- Seal of Justice
          spell = 20165,
          type = "ability",
          buff = true
        }, { -- Seal of Light
          spell = 20166,
          type = "ability",
          buff = true
        }, { -- Seal of Wisdom
          spell = 20182,
          type = "ability",
          buff = true
        }, { -- Seal of the Crusader
          spell = 20271,
          type = "ability",
          buff = true,
          requiresTarget = true
        }, { -- Judgement
          spell = 20375,
          type = "ability",
          buff = true,
          talent = 48
        }, { -- Seal of Command
          spell = 20925,
          type = "ability",
          charges = true,
          buff = true,
          talent = 35
        }, { -- Holy Shield
          spell = 21084,
          type = "ability",
          buff = true
        }, { -- Seal of Righteousness
          spell = 24275,
          type = "ability",
          requiresTarget = true,
          usable = true
        }, { -- Hammer of Wrath
          spell = 26573,
          type = "ability",
          talent = 6
        } }, -- Consecration
        icon = 135972
      },
      [4] = {},
      [5] = {},
      [6] = {},
      [7] = {},
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_elemental_mote_mana"
      }
    }
  }

  templates.class.HUNTER = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 136,
          type = "buff",
          unit = "pet"
        }, { -- Mend Pet
          spell = 3045,
          type = "buff",
          unit = "player"
        }, { -- Rapid Fire
          spell = 5384,
          type = "buff",
          unit = "player"
        }, { -- Feign Death
          spell = 6197,
          type = "buff",
          unit = "player"
        }, { -- Eagle Eye
          spell = 19621,
          type = "buff",
          unit = "pet"
        }, { -- Frenzy
          spell = 24450,
          type = "buff",
          unit = "pet"
        } }, -- Prowl
        icon = 132242
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 1130,
          type = "debuff",
          unit = "target"
        }, { -- Hunter's Mark
          spell = 1513,
          type = "debuff",
          unit = "target"
        }, { -- Scare Beast
          spell = 1978,
          type = "debuff",
          unit = "target"
        }, { -- Serpent Sting
          spell = 2649,
          type = "debuff",
          unit = "target"
        }, { -- Growl
          spell = 2974,
          type = "debuff",
          unit = "target"
        }, { -- Wing Clip
          spell = 3034,
          type = "debuff",
          unit = "target"
        }, { -- Viper Sting
          spell = 3043,
          type = "debuff",
          unit = "target"
        }, { -- Scorpid Sting
          spell = 3355,
          type = "debuff",
          unit = "multi"
        }, { -- Freezing Trap
          spell = 5116,
          type = "debuff",
          unit = "target"
        }, { -- Concussive Shot
          spell = 24394,
          type = "debuff",
          unit = "target"
        } }, -- Intimidation
        icon = 135860
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 781,
          type = "ability"
        }, { -- Disengage
          spell = 1130,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Hunter's Mark
          spell = 1495,
          type = "ability",
          requiresTarget = true,
          usable = true
        }, { -- Mongoose Bite
          spell = 1499,
          type = "ability"
        }, { -- Freezing Trap
          spell = 1510,
          type = "ability"
        }, { -- Volley
          spell = 1513,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Scare Beast
          spell = 1543,
          type = "ability",
          duration = 30
        }, { -- Flare
          spell = 1978,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Serpent Sting
          spell = 2643,
          type = "ability"
        }, { -- Multi-Shot
          spell = 2649,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Growl
          spell = 2973,
          type = "ability",
          requiresTarget = true
        }, { -- Raptor Strike
          spell = 2974,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Wing Clip
          spell = 3034,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Viper Sting
          spell = 3043,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Scorpid Sting
          spell = 3044,
          type = "ability",
          requiresTarget = true
        }, { -- Arcane Shot
          spell = 3045,
          type = "ability",
          buff = true
        }, { -- Rapid Fire
          spell = 5116,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Concussive Shot
          spell = 5384,
          type = "ability",
          buff = true,
          unit = "player"
        }, { -- Feign Death
          spell = 13795,
          type = "ability"
        }, { -- Immolation Trap
          spell = 13809,
          type = "ability"
        }, { -- Frost Trap
          spell = 13813,
          type = "ability"
        }, { -- Explosive Trap
          spell = 16827,
          type = "ability",
          requiresTarget = true
        }, { -- Claw
          spell = 19263,
          type = "ability",
          buff = true
        }, { -- Deterrence -TODO
          spell = 19306,
          type = "ability",
          requiresTarget = true,
          usable = true
        }, { -- Counterattack -TODO
          spell = 19434,
          type = "ability",
          requiresTarget = true
        }, { -- Aimed Shot -TODO
          spell = 19386,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Wyvern Sting -TODO
          spell = 19503,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Scatter Shot -TODO
          spell = 19574,
          type = "ability",
          buff = true
        }, { -- Bestial Wrath -TODO
          spell = 19577,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Intimidation -TODO
          spell = 19801,
          type = "ability",
          requiresTarget = true
        }, { -- Tranquilizing Shot
          spell = 20736,
          type = "ability",
          requiresTarget = true
        } }, -- Distracting Shot
        icon = 135130
      },
      [4] = {},
      [5] = {},
      [6] = {},
      [7] = {},
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\ability_hunter_focusfire"
      }
    }
  }

  templates.class.ROGUE = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 2983,
          type = "buff",
          unit = "player"
        }, { -- Sprint
          spell = 5171,
          type = "buff",
          unit = "player"
        }, { -- Slice and Dice
          spell = 5277,
          type = "buff",
          unit = "player"
        }, { -- Evasion
          spell = 13750,
          type = "buff",
          unit = "player"
        }, { -- Adrenaline Rush
          spell = 13877,
          type = "buff",
          unit = "player"
        }, { -- Blade Fury
          spell = 14177,
          type = "buff",
          unit = "player"
        }, { -- Cold Blood
          spell = 14149,
          type = "buff",
          unit = "player"
        }, { -- Remorseless
          spell = 14278,
          type = "buff",
          unit = "player"
        } }, -- Ghostly Strike
        icon = 132290
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 703,
          type = "debuff",
          unit = "target"
        }, { -- Garrote
          spell = 14251,
          type = "debuff",
          unit = "target"
        }, { -- Riposte
          spell = 11198,
          type = "debuff",
          unit = "target"
        }, { -- Expose Armor
          spell = 18425,
          type = "debuff",
          unit = "target"
        }, { -- Kick - Silenced
          spell = 17348,
          type = "debuff",
          unit = "target"
        }, { -- Hemorrhage
          spell = 14183,
          type = "debuff",
          unit = "target"
        } }, -- Premeditation
        icon = 132302
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 53,
          type = "ability",
          requiresTarget = true,
          usable = true
        }, { -- Backstab
          spell = 703,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Garrote
          spell = 921,
          type = "ability",
          requiresTarget = true,
          usable = true
        }, { -- Pick Pocket
          spell = 1725,
          type = "ability",
          usable = true
        }, { -- Distract
          spell = 1752,
          type = "ability",
          requiresTarget = true
        }, { -- Sinister Strike
          spell = 1766,
          type = "ability",
          requiresTarget = true
        }, { -- Kick
          spell = 1776,
          type = "ability",
          requiresTarget = true,
          usable = true,
          debuff = true
        }, { -- Gouge
          spell = 1784,
          type = "ability",
          buff = true
        }, { -- Stealth
          spell = 1856,
          type = "ability",
          buff = true
        }, { -- Vanish
          spell = 2094,
          type = "ability",
          requiresTarget = true
        }, { -- Blind
          spell = 2098,
          type = "ability",
          requiresTarget = true
        }, { -- Eviscerate
          spell = 2983,
          type = "ability",
          buff = true
        }, { -- Sprint
          spell = 5171,
          type = "ability",
          requiresTarget = true,
          buff = true
        }, { -- Slice and Dice
          spell = 5277,
          type = "ability",
          buff = true
        }, { -- Evasion
          spell = 6770,
          type = "ability",
          requiresTarget = true,
          usable = true,
          debuff = true
        }, { -- Sap
          spell = 8647,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Expose Armor
          spell = 13750,
          type = "ability",
          buff = true,
          talent = 39
        }, { -- Adrenaline Rush
          spell = 13877,
          type = "ability",
          buff = true,
          talent = 34
        }, { -- Blade Fury
          spell = 14177,
          type = "ability",
          buff = true,
          talent = 12
        }, { -- Cold Blood
          spell = 14183,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 57
        }, { -- Premeditation
          spell = 14185,
          type = "ability"
        }, { -- Preparation
          spell = 14251,
          type = "ability",
          requiresTarget = true,
          usable = true,
          debuff = true,
          talent = 28
        }, { -- Riposte
          spell = 14271,
          type = "ability",
          requiresTarget = true,
          buff = true,
          talent = 47
        }, { -- Ghostly Strike
          spell = 16511,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 55
        } }, -- Hemorrhage
        icon = 132350
      },
      [4] = {},
      [5] = {},
      [6] = {},
      [7] = {},
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01"
      }
    }
  }

  templates.class.PRIEST = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 586,
          type = "buff",
          unit = "player"
        }, { -- Fade
          spell = 17,
          type = "buff",
          unit = "target"
        }, { -- Power Word: Shield
          spell = 21562,
          type = "buff",
          unit = "player"
        }, { -- Power Word: Fortitude
          spell = 2096,
          type = "buff",
          unit = "player"
        }, { -- Mind Vision
          spell = 1706,
          type = "buff",
          unit = "player"
        } }, -- Levitate
        icon = 135940
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 8122,
          type = "debuff",
          unit = "target"
        }, { -- Psychic Scream
          spell = 2096,
          type = "debuff",
          unit = "target"
        }, { -- Mind Vision
          spell = 589,
          type = "debuff",
          unit = "target"
        }, { -- Shadow Word: Pain
          spell = 9484,
          type = "debuff",
          unit = "multi"
        } }, -- Shackle Undead
        icon = 136207
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 17,
          type = "ability"
        }, { -- Power Word: Shield
          spell = 527,
          type = "ability"
        }, { -- Purify
          spell = 552,
          type = "ability"
        }, { -- Abolish Disease
          spell = 585,
          type = "ability",
          requireTarget = true
        }, { -- Smite
          spell = 586,
          type = "ability",
          buff = true
        }, { -- Fade
          spell = 589,
          type = "ability",
          debuff = true
        }, { -- Shadow Word: Pain
          spell = 2060,
          type = "ability"
        }, { -- Greater Heal
          spell = 2061,
          type = "ability"
        }, { -- Flash Heal
          spell = 6064,
          type = "ability"
        }, { -- Heal
          spell = 8092,
          type = "ability",
          requireTarget = true
        }, { -- Mind Blast
          spell = 8122,
          type = "ability"
        }, { -- Psychic Scream
          spell = 10060,
          type = "ability",
          buff = true,
          talent = 15
        }, { -- Power Infusion
          spell = 10876,
          type = "ability",
          requireTarget = true
        }, { -- Mana Burn
          spell = 10947,
          type = "ability",
          requireTarget = true
        }, { -- Mind Flay
          spell = 10951,
          type = "ability",
          buff = true
        }, { -- Inner Fire
          spell = 14751,
          type = "ability",
          buff = true,
          talent = 7
        }, { -- Inner Focus
          spell = 14914,
          type = "ability",
          debuff = true,
          requireTarget = true
        }, { -- Holy Fire
          spell = 15487,
          type = "ability",
          debuff = true,
          requireTarget = true,
          talnet = 52
        } }, -- Silence
        icon = 136224
      },
      [4] = {},
      [5] = {},
      [6] = {},
      [7] = {},
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_elemental_mote_mana"
      }
    }
  }

  templates.class.SHAMAN = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 546,
          type = "buff",
          unit = "player"
        }, { -- Water Walking
          spell = 974,
          type = "buff",
          unit = "player",
          talent = 8
        }, { -- Earth Shield
          spell = 16256,
          type = "buff",
          unit = "player",
          talent = 30
        } }, -- Flurry
        icon = 135863
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 3600,
          type = "debuff",
          unit = "target"
        } }, -- Earthbind
        icon = 135813
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 131,
          type = "ability",
          buff = true,
          usable = true
        }, { -- Water Breathing
          spell = 324,
          type = "ability",
          buff = true
        }, { -- Lightning Shield
          spell = 331,
          type = "ability"
        }, { -- Healing Wave
          spell = 403,
          type = "ability",
          requireTarget = true
        }, { -- Lightning Bolt
          spell = 421,
          type = "ability",
          requireTarget = true
        }, { -- Chain Lightning
          spell = 546,
          type = "ability",
          buff = true,
          usable = true
        }, { -- Water Walking
          spell = 556,
          type = "ability"
        }, { -- Astral Recall
          spell = 1064,
          type = "ability"
        }, { -- Chain Heal
          spell = 1535,
          type = "ability",
          totem = true
        }, { -- Fire Nova Totem
          spell = 2008,
          type = "ability"
        }, { -- Ancestral Spirit
          spell = 2484,
          type = "ability",
          totem = true
        }, { -- Earthbind Totem
          spell = 2645,
          type = "ability",
          buff = true
        }, { -- Ghost Wolf
          spell = 2825,
          type = "ability",
          buff = true
        }, { -- Bloodlust
          spell = 3599,
          type = "ability",
          totem = true
        }, { -- Searing Totem
          spell = 5394,
          type = "ability",
          totem = true
        }, { -- Healing Stream Totem
          spell = 5675,
          type = "ability",
          totem = true
        }, { -- Mana Spring Totem
          spell = 5730,
          type = "ability",
          totem = true
        }, { -- Stoneclaw Totem
          spell = 6495,
          type = "ability",
          totem = true
        }, { -- Sentry Totem
          spell = 8142,
          type = "ability",
          requireTarget = true
        }, { -- Earth Shock
          spell = 8143,
          type = "ability",
          requireTarget = true,
          debuff = true
        }, { -- Frost Shock
          spell = 8017,
          type = "ability",
          weaponBuff = true
        }, { -- Rockbiter Weapon -- !! weaponBuff is not supported yet
          spell = 8024,
          type = "ability",
          weaponBuff = true
        }, { -- Flametongue Weapon
          spell = 8033,
          type = "ability",
          weaponBuff = true
        }, { -- Frostbrand Weapon
          spell = 8050,
          type = "ability",
          requireTarget = true,
          debuff = true
        }, { -- Flame Shock
          spell = 8071,
          type = "ability",
          totem = true
        }, { -- Stoneskin Totem
          spell = 8075,
          type = "ability",
          totem = true
        }, { -- Strength of Earth Totem
          spell = 8143,
          type = "ability",
          totem = true
        }, { -- Tremor Totem
          spell = 8166,
          type = "ability",
          totem = true
        }, { -- Poison Cleansing Totem
          spell = 8170,
          type = "ability",
          totem = true
        }, { -- Disease Cleansing Totem
          spell = 8177,
          type = "ability",
          totem = true
        }, { -- Grounding Totem
          spell = 8181,
          type = "ability",
          totem = true
        }, { -- Frost Resistance Totem
          spell = 8184,
          type = "ability",
          totem = true
        }, { -- Fire Resistance Totem
          spell = 8190,
          type = "ability",
          totem = true
        }, { -- Magma Totem
          spell = 8227,
          type = "ability",
          totem = true
        }, { -- Flametongue Totem
          spell = 8514,
          type = "ability",
          totem = true
        }, { -- Windfury Totem
          spell = 8835,
          type = "ability",
          totem = true
        }, { -- Grace of Air Totem
          spell = 10595,
          type = "ability",
          totem = true
        }, { -- Nature Resistance Totem
          spell = 15107,
          type = "ability",
          totem = true
        }, { -- Windwall Totem
          spell = 16188,
          type = "ability",
          buff = true,
          talent = 53
        }, { -- Nature Swiftness
          spell = 16190,
          type = "ability",
          totem = true,
          talent = 55
        }, { -- Mana Tide Totem
          spell = 17364,
          type = "ability",
          debuff = true,
          talent = 36
        }, { -- Stormstrike
          spell = 20608,
          type = "ability"
        }, { -- Reincarnation
          spell = 25908,
          type = "ability",
          totem = true
        } }, -- Tranquil Air Totem
        icon = 135963
      },
      [4] = {},
      [5] = {},
      [6] = {},
      [7] = {},
      [8] = {
        title = L["Resources"],
        args = {},
        icon = 135990
      }
    }
  }

  templates.class.MAGE = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 130,
          type = "buff",
          unit = "player"
        }, { -- Slow Fall
          spell = 543,
          type = "buff",
          unit = "player"
        }, { -- Fire Ward
          spell = 604,
          type = "buff",
          unit = "player"
        }, { -- Dampen Magic
          spell = 1008,
          type = "buff",
          unit = "player"
        }, { -- Amplify Magic
          spell = 1459,
          type = "buff",
          unit = "player"
        }, { -- Arcane Intellect
          spell = 1463,
          type = "buff",
          unit = "player"
        }, { -- Mana Shield
          spell = 6143,
          type = "buff",
          unit = "player"
        }, { -- Frost Ward
          spell = 12042,
          type = "buff",
          unit = "player"
        }, { -- Arcane Power
          spell = 12536,
          type = "buff",
          unit = "player"
        }, { -- Clearcasting
          spell = 45438,
          type = "buff",
          unit = "player"
        } }, -- Ice Block
        icon = 136096
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 122,
          type = "debuff",
          unit = "target"
        }, { -- Frost Nova
          spell = 118,
          type = "debuff",
          unit = "multi"
        }, { -- Polymorph
          spell = 11071,
          type = "debuff",
          unit = "target"
        }, { -- Frostbite
          spell = 11103,
          type = "debuff",
          unit = "target"
        }, { -- Impact
          spell = 11180,
          type = "debuff",
          unit = "target"
        } }, -- Winter's Chill
        icon = 135848
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 118,
          type = "ability",
          debuff = true,
          requireTarget = true
        }, { -- Polymorph
          spell = 120,
          type = "ability"
        }, { -- Cone of Cold
          spell = 122,
          type = "ability"
        }, { -- Frost Nova
          spell = 130,
          type = "ability",
          buff = true
        }, { -- Slow Fall
          spell = 475,
          type = "ability"
        }, { -- Remove Curse
          spell = 543,
          type = "ability",
          buff = true
        }, { -- Fire Ward
          spell = 1449,
          type = "ability"
        }, { -- Arcane Explosion
          spell = 1463,
          type = "ability",
          buff = true
        }, { -- Mana Shield
          spell = 1953,
          type = "ability"
        }, { -- Blink
          spell = 2120,
          type = "ability"
        }, { -- Flamestrike
          spell = 2136,
          type = "ability",
          requiresTarget = true
        }, { -- Fire Blast
          spell = 2139,
          type = "ability",
          requiresTarget = true
        }, { -- Counterspell
          spell = 2855,
          type = "ability",
          debuff = true,
          requireTarget = true
        }, { -- Detect Magic
          spell = 2948,
          type = "ability",
          requiresTarget = true
        }, { -- Scorch
          spell = 5143,
          type = "ability",
          requiresTarget = true
        }, { -- Arcane Missiles
          spell = 6143,
          type = "ability",
          buff = true
        }, { -- Frost Ward
          spell = 10187,
          type = "ability"
        }, { -- Blizzard
          spell = 11113,
          type = "ability",
          debuff = true,
          talent = 34
        }, { -- Blast Wave
          spell = 11129,
          type = "ability",
          buff = true,
          talent = 36
        }, { -- Combustion
          spell = 11426,
          type = "ability",
          buff = true,
          talent = 57
        }, { --ice Barrier
          spell = 11958,
          type = "ability",
          buff = true,
          talent = 54
        }, { -- Ice Block
          spell = 12042,
          type = "ability",
          buff = true,
          talent = 16
        }, { -- Arcane Power
          spell = 12043,
          type = "ability",
          buff = true,
          talent = 13
        }, { -- Presence of Mind
          spell = 12051,
          type = "ability"
        }, { -- Evocation
          spell = 12472,
          type = "ability",
          buff = true,
          talent = 49
        }, { -- Cold Snap
          spell = 18809,
          type = "ability",
          requiresTarget = true
        }, { -- Pyroblast
          spell = 25304,
          type = "ability",
          requiresTarget = true
        } }, -- Frostbolt
        icon = 136075
      },
      [4] = {},
      [5] = {},
      [6] = {},
      [7] = {},
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\spell_arcane_arcane01"
      }
    }
  }

  templates.class.WARLOCK = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 126,
          type = "buff",
          unit = "player"
        }, { -- Eye of Kilrogg
          spell = 687,
          type = "buff",
          unit = "player"
        }, { -- Demon Skin
          spell = 755,
          type = "buff",
          unit = "pet"
        }, { -- Health Funnel
          spell = 5697,
          type = "buff",
          unit = "player"
        }, { -- Unending Breath
          spell = 6229,
          type = "buff",
          unit = "player"
        }, { -- Shadow Ward
          spell = 7870,
          type = "buff",
          unit = "pet"
        }, { -- Lesser Invisibility
          spell = 18094,
          type = "buff",
          unit = "player"
        }, { -- Nightfall
          spell = 19028,
          type = "buff",
          unit = "player"
        }, { -- Soul Link
          spell = 20707,
          type = "buff",
          unit = "group"
        } }, -- Soulstone
        icon = 136210
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 172,
          type = "debuff",
          unit = "target"
        }, { -- Corruption
          spell = 603,
          type = "debuff",
          unit = "target"
        }, { -- Curse of Doom
          spell = 702,
          type = "debuff",
          unit = "target"
        }, { -- Curse of Weakness
          spell = 704,
          type = "debuff",
          unit = "target"
        }, { -- Curse of Recklessness
          spell = 710,
          type = "debuff",
          unit = "multi"
        }, { -- Banish
          spell = 980,
          type = "debuff",
          unit = "target"
        }, { -- Curse of Agony
          spell = 1098,
          type = "debuff",
          unit = "multi"
        }, { -- Enslave Demon
          spell = 1490,
          type = "debuff",
          unit = "target"
        }, { -- Curse of the Elements
          spell = 1714,
          type = "debuff",
          unit = "target"
        }, { -- Curse of Tongues
          spell = 6358,
          type = "debuff",
          unit = "target"
        }, { -- Seduction
          spell = 6789,
          type = "debuff",
          unit = "target",
          talent = 14
        }, { -- Mortal Coil
          spell = 6360,
          type = "debuff",
          unit = "target"
        }, { -- Whiplash
          spell = 17862,
          type = "debuff",
          unit = "target"
        }, { -- Curse of Shadow
          spell = 18223,
          type = "debuff",
          unit = "target"
        }, { -- Curse of Exhaustion
          spell = 18265,
          type = "debuff",
          unit = "target",
          talent = 6
        } }, -- Siphon Life
        icon = 136139
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 172,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Corruption
          spell = 348,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Immolate
          spell = 686,
          type = "ability",
          requiresTarget = true
        }, { -- Shadow Bolt
          spell = 698,
          type = "ability"
        }, { -- Ritual of Summoning
          spell = 710,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Banish
          spell = 980,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Agony
          spell = 1120,
          type = "ability",
          requiresTarget = true
        }, { -- Drain Soul
          spell = 3110,
          type = "ability",
          requiresTarget = true
        }, { -- Firebolt
          spell = 3716,
          type = "ability",
          requiresTarget = true
        }, { -- Consuming Shadows
          spell = 5138,
          type = "ability",
          requiresTarget = true
        }, { -- Drain Mana
          spell = 5484,
          type = "ability"
        }, { -- Howl of Terror
          spell = 5676,
          type = "ability",
          requiresTarget = true
        }, { -- Searing Pain
          spell = 5740,
          type = "ability"
        }, { -- Rain of Fire
          spell = 5782,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Fear
          spell = 6353,
          type = "ability",
          requiresTarget = true
        }, { -- Soul Fire
          spell = 6358,
          type = "ability",
          requiresTarget = true
        }, { -- Seduction
          spell = 6360,
          type = "ability",
          requiresTarget = true
        }, { -- Whiplash
          spell = 6789,
          type = "ability",
          requiresTarget = true,
          talent = 15
        }, { -- Mortal Coil
          spell = 7814,
          type = "ability",
          requiresTarget = true
        }, { -- Lash of Pain
          spell = 7870,
          type = "ability"
        }, { -- Lesser Invisibility
          spell = 17962,
          type = "ability",
          requiresTarget = true,
          usable = true,
          talent = 56
        }, { -- Conflagrate
          spell = 17926,
          type = "ability",
          requiresTarget = true
        }, { -- Death Coil
          spell = 18288,
          type = "ability",
          buff = true,
          talent = 9
        }, { -- Amplify Curse
          spell = 18708,
          type = "ability",
          talent = 28
        }, { -- Fel Domination
          spell = 18877,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 48
        } }, -- Shadowburn
        icon = 135808
      },
      [4] = {},
      [5] = {},
      [6] = {},
      [7] = {},
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_misc_gem_amethyst_02"
      }
    }
  }

  templates.class.DRUID = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 774,
          type = "buff",
          unit = "player",
          talent = 9
        }, { -- Rejuvenation
          spell = 5487,
          type = "buff",
          unit = "player"
        }, { -- Bear Form
          spell = 8936,
          type = "buff",
          unit = "player"
        }, { -- Regrowth
          spell = 783,
          type = "buff",
          unit = "player"
        }, { -- Travel Form
          spell = 768,
          type = "buff",
          unit = "player"
        }, { -- Cat Form
          spell = 22812,
          type = "buff",
          unit = "player"
        }, { -- Barkskin
          spell = 1850,
          type = "buff",
          unit = "player"
        }, { -- Dash
          spell = 5215,
          type = "buff",
          unit = "player"
        }, { -- Prowl
          spell = 29166,
          type = "buff",
          unit = "group"
        } }, -- Innervate
        icon = 136097
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 339,
          type = "debuff",
          unit = "multi"
        }, { -- Entangling Roots
          spell = 5211,
          type = "debuff",
          unit = "target",
          talent = 10
        }, { -- Mighty Bash
          spell = 1079,
          type = "debuff",
          unit = "target",
          talent = 7
        }, { -- Rip
          spell = 6795,
          type = "debuff",
          unit = "target"
        }, { -- Growl
          spell = 2637,
          type = "debuff",
          unit = "multi"
        } }, -- Hibernate
        icon = 132114
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 99,
          type = "ability",
          debuff = true
        }, { -- Demoralizing Roar
          spell = 339,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Entangling Roots
          spell = 740,
          type = "ability",
          duration = 10
        }, { -- Tranquility
          spell = 768,
          type = "ability"
        }, { -- Cat Form
          spell = 770,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Faerie Fire
          spell = 779,
          type = "ability",
          form = 3
        }, { -- Swipe
          spell = 783,
          type = "ability"
        }, { -- Travel Form
          spell = 1066,
          type = "ability"
        }, { -- Aquatic Form
          spell = 1079,
          type = "ability",
          requiresTarget = true,
          form = 3
        }, { -- Rip
          spell = 1082,
          type = "ability",
          requiresTarget = true,
          form = 3
        }, { -- Claw
          spell = 1822,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          form = 3
        }, { -- Rake
          spell = 1850,
          type = "ability",
          buff = true
        }, { -- Dash
          spell = 2637,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Hibernate
          spell = 2782,
          type = "ability"
        }, { -- Remove Curse
          spell = 2893,
          type = "ability"
        }, { -- Abolish Poison
          spell = 2908,
          type = "ability",
          requiresTarget = true
        }, { -- Soothe
          spell = 2912,
          type = "ability",
          requiresTarget = true
        }, { -- Starfire
          spell = 5176,
          type = "ability",
          requiresTarget = true
        }, { -- Wrath
          spell = 5209,
          type = "ability",
          form = 1
        }, { -- Challenging Roar
          spell = 5211,
          type = "ability",
          requiresTarget = true,
          talent = 6,
          form = 1
        }, { -- Mighty Bash
          spell = 5215,
          type = "ability",
          buff = true
        }, { -- Prowl
          spell = 5217,
          type = "ability",
          buff = true,
          form = 3
        }, { -- Tiger's Fury
          spell = 5221,
          type = "ability",
          requiresTarget = true,
          form = 3
        }, { -- Shred
          spell = 5229,
          type = "ability",
          buff = true,
          form = 1
        }, { -- Enrage
          spell = 5487,
          type = "ability"
        }, { -- Bear Form
          spell = 5570,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 47
        }, { -- Insect Swarm
          spell = 6785,
          type = "ability",
          requiresTarget = true,
          form = 1
        }, { -- Ravage
          spell = 6795,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          form = 1
        }, { -- Growl
          spell = 6807,
          type = "ability",
          form = 1
        }, { -- Maul
          spell = 8921,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, { -- Moonfire
          spell = 8946,
          type = "ability"
        }, { -- Cure Poison
          spell = 9005,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          form = 3
        }, { -- Pounce
          spell = 9634,
          type = "ability"
        }, { -- Dire Bear Form
          spell = 16689,
          type = "ability",
          buff = true,
          talent = 2
        }, { -- Nature's Grasp
          spell = 16914,
          type = "ability"
        }, { -- Hurricane
          spell = 16979,
          type = "ability",
          form = 1,
          talent = 27
        }, { -- Feral Charge
          spell = 17116,
          type = "ability",
          buff = true,
          talent = 51
        }, { -- Nature's Swiftness
          spell = 18562,
          type = "ability",
          talent = 55
        }, { -- Swiftmend
          spell = 22568,
          type = "ability",
          form = 3
        }, { -- Ferocious Bite
          spell = 22812,
          type = "ability",
          buff = true
        }, { -- Barkskin
          spell = 22842,
          type = "ability",
          buff = true
        }, { -- Frenzied Regeneration
          spell = 24858,
          type = "ability",
          talent = 16
        } }, -- Moonkin Form
        icon = 132134
      },
      [4] = {},
      [5] = {},
      [6] = {},
      [7] = {},
      [8] = {
        title = L["Resources and Shapeshift Form"],
        args = {},
        icon = "Interface\\Icons\\ability_druid_eclipseorange"
      }
    }
  } -- Arms -- In For The Kill -- Defensive Stance -- Die by the Sword -- Battle Shout -- Avatar -- Deadly Calm -- Victorious -- Bladestorm -- Sudden Death -- Berserker Rage -- Bounding Stride -- Overpower -- War Machine -- Rallying Cry -- Sweeping Strikes -- Mortal Wounds -- Rend -- Colossus Smash -- Charge -- Intimidating Shout -- Hamstring -- Taunt -- Deep Wounds -- Storm Bolt -- Charge -- Charge -- Charge -- Taunt -- Cleave -- Slam -- Whirlwind -- Hamstring -- Intimidating Shout -- Heroic Leap -- Pummel -- Battle Shout -- Overpower -- Overpower -- Mortal Strike -- Berserker Rage -- Victory Rush -- Heroic Throw -- Rallying Cry -- Storm Bolt -- Avatar -- Die by the Sword -- Ravager -- Execute -- Colossus Smash -- Impending Victory -- Defensive Stance -- Bladestorm -- Skullsplitter -- Sweeping Strikes -- Warbreaker -- Deadly Calm --Bury the Hatchet --Moment of Glory --Crushing Assault --Striking the Anvil --Gathering Storm --Test of Might --Intimidating Presence -- Duel -- Duel -- Spell Reflection -- Disarm -- Disarm -- War Banner -- War Banner -- Sharpen Blade -- Sharpen Blade -- Fury -- War Machine -- Victorious -- Frothing Berserker -- Furious Slash -- Berserker Rage -- Recklessness -- Bladestorm -- Bounding Stride -- Whirlwind -- Sudden Death -- Furious Charge -- Enrage -- Enraged Regeneration -- Battle Shout -- Rallying Cry -- Storm Bolt -- Dragon Roar -- Siegebreaker -- Charge -- Taunt -- Charge    !!TODO: add prefix or name or something when 2 times same talent -- Charge -- Taunt -- Recklessness -- Intimidating Shout -- Execute -- Heroic Leap -- Pummel -- Battle Shout -- Piercing Howl -- Berserker Rage -- Bloodthirst -- Bladestorm -- Heroic Throw -- Raging Blow -- Rallying Cry -- Furious Slash -- Storm Bolt -- Dragon Roar -- Enraged Regeneration -- Rampage -- Whirlwind -- Impending Victory -- Siegebreaker --Bury the Hatchet --Moment of Glory --Cold Steel, Hot Blood --Infinite Fury --Pulverizing Blows --Intimidating Presence -- Barbarian -- Battle Trance -- Thirst for Battle -- Death Wish -- Death Wish -- Disarm -- Disarm -- Spell Reflection -- Spell Reflection -- Protection -- Last Stand -- Bounding Stride -- Berserker Rage -- Vengeance: Revenge -- Shield Wall -- Ravager -- Vengeance: Ignore Pain -- Battle Shout -- Shield Block -- Into the Fray -- Rallying Cry -- Ignore Pain -- Spell Reflection -- Avatar -- Intervene -- Safeguard --Intimidating Presence -- Deep Wounds -- Demoralizing Shout -- Taunt -- Storm Bolt -- Charge -- Intimidating Shout -- Thunder Clap -- Shockwave -- Punish -- Shield Slam -- Taunt -- Shield Wall -- Demoralizing Shout -- Shield Block -- Intimidating Shout -- Thunder Clap -- Heroic Leap -- Pummel -- Revenge -- Battle Shout -- Last Stand -- Berserker Rage -- Devastate -- Spell Reflection -- Shield Slam -- Victory Rush -- Shockwave -- Heroic Throw -- Rallying Cry -- Storm Bolt -- Avatar -- Dragon Roar -- Intercept -- Impending Victory -- Ravager --Bury the Hatchet --Moment of Glory --Bloodsport --Brace for Impact --Callous Reprisal --Bastion of Might --Sword and Board -- Bodyguard -- Bodyguard -- Shield Bash -- Shield Bash -- Oppressor -- Oppressor -- Warpath -- Dragon Charge -- Disarm -- Disarm -- Holy -- Blessing of Protection -- Beacon of Light -- Blessing of Sacrifice -- Aura Mastery -- Aura of Mercy -- Avenging Wrath -- Divine Protection -- Devotion Aura -- Divine Shield -- Beacon of Virtue -- Beacon of Faith -- Infusion of Light -- Holy Avenger -- Avenging Crusader -- Rule of Law -- Aura of Sacrifice -- Blessing of Freedom -- Divine Steed -- Bestow Faith -- Consecration -- Blinding Light -- Hammer of Justice -- Judgment -- Judgment of Light -- Repentance -- Divine Protection -- Lay on Hands -- Divine Shield -- Hammer of Justice -- Blessing of Protection -- Blessing of Freedom -- Cleanse -- Blessing of Sacrifice -- Repentance -- Holy Shock -- Consecration -- Aura Mastery -- Avenging Wrath -- Crusader Strike -- Light of Dawn -- Holy Avenger -- Light's Hammer -- Holy Prism -- Blinding Light -- Divine Steed -- Beacon of Virtue -- Rule of Law -- Avenging Crusader -- Bestow Faith -- Judgment --Divine Revelations --Gallant Steed --Grace of the Justicar --Glimmer of Light --Radiant Incandescence --Stalwart Protector --Empyreal Ward -- Spreading the Word -- Light's Grace -- Divine Favor -- Divine Favor -- Darkest before the Dawn -- Protection -- Retribution Aura -- Shield of the Righteous -- Avenger's Valor -- Blessing of Freedom -- Blessing of Sacrifice -- Consecration -- Aegis of Light -- Ardent Defender -- Avenging Wrath -- Blessing of Spellwarding -- Seraphim -- Guardian of Ancient Kings -- Blessing of Protection -- Divine Steed -- Aegis of Light -- Divine Shield -- Redoubt -- Hand of Reckoning -- Consecration -- Judgment of Light -- Blinding Light -- Hammer of Justice -- Blessed Hammer -- Final Stand -- Avenger's Shield -- Repentance -- Lay on Hands -- Divine Shield -- Hammer of Justice -- Blessing of Protection -- Blessing of Freedom -- Blessing of Sacrifice -- Repentance -- Consecration -- Ardent Defender -- Avenging Wrath -- Avenger's Shield -- Hammer of the Righteous                  Couldn't find this spell -- Shield of the Righteous -- Hand of Reckoning -- Guardian of Ancient Kings -- Rebuke -- Blinding Light -- Seraphim -- Light of the Protector -- Divine Steed -- Blessing of Spellwarding -- Blessed Hammer -- Bastion of Light -- Aegis of Light -- Cleanse Toxins -- Hand of the Protector -- Judgment --Bulwark of Light --Gallant Steed --Grace of the Justicar --Inner Light --Inspiring Vanguard --Judicious Defense --Soaring Shield --Stalwart Protector --Empyreal Ward -- Guardian of the Forgotten Queen -- Guardian of the Forgotten Queen -- Guarded by the Light -- Cleansing Light -- Shield of Virtue -- Shield of Virtue -- Inquisition -- Inquisition -- Retribution -- Righteous Verdict -- Eye for an Eye -- Blessing of Protection -- Shield of Vengeance -- Divine Judgment -- Inquisition -- Greater Blessing of Kings -- Divine Steed -- Divine Shield -- Greater Blessing of Wisdom -- Selfless Healer -- Avenging Wrath -- Zeal -- Blade of Wrath -- Blessing of Freedom -- Fires of Justice -- Divine Purpose -- Retribution -- Hand of Reckoning -- Judgment -- Execution Sentence -- Blinding Light -- Hammer of Justice -- Hand of Hindrance -- Repentance -- Wake of Ashes -- Lay on Hands -- Divine Shield -- Hammer of Justice -- Blessing of Protection -- Blessing of Freedom -- Repentance -- Judgment -- Hammer of Wrath -- Avenging Wrath -- Crusader Strike -- Hand of Reckoning -- Rebuke -- Blinding Light -- Hand of Hindrance -- Blade of Justice -- Shield of Vengeance -- Divine Steed -- Eye for an Eye -- Consecration -- Word of Glory -- Cleanse Toxins -- Justiciar's Vengeance -- Wake of Ashes -- Execution Sentence --Avenger's Might --Empyrean Power --Expurgation --Gallant Steed --Grace of the Justicar --Relentless Inquisitor --Light's Decree --Stalwart Protector --Empyreal Ward -- Cleansing Light -- Hammer of Reckoning -- Hammer of Reckoning -- Vengeance Aura -- Blessing of Sanctuary -- Blessing of Sanctuary -- Ultimate Retribution -- Lawbringer -- Beast Master -- Barbed Shot -- Misdirection -- Trailblazer -- Aspect of the Cheetah -- Primal Rage -- Thrill of the Hunt -- Bestial Wrath -- Beast Cleave -- Predator's Thirst -- Posthaste -- Aspect of the Wild -- Feign Death -- Camouflage -- Dire Beast -- Aspect of the Turtle -- Eagle Eye -- Barbed Shot -- Prowl -- Frenzy -- Mend Pet -- Tar Trap -- Barbed Shot -- Binding Shot -- Freezing Trap -- Growl -- Intimidation -- Concussive Shot -- Disengage -- Flare -- Growl -- Concussive Shot -- Feign Death -- Claw -- Bestial Wrath -- Intimidation -- Prowl -- Kill Command -- Misdirection -- Chimaera Shot -- Binding Shot -- Exhilaration -- Barrage -- Dire Beast -- A Murder of Crows -- Counter Shot -- Aspect of the Cheetah -- Aspect of the Turtle -- Freezing Trap -- Tar Trap -- Aspect of the Wild -- Camouflage -- Stampede -- Barbed Shot -- Primal Rage -- Survival of the Fittest -- Spirit Mend -- Spirit Walk -- Spirit Shock --Cobra's Bite --Dance of Death --Duck and Cover --Flashing Fangs --Haze of Rage --Primal Instincts --Ride the Lightning --Rotting Jaws --Shellshock -- Wild Protector -- Dire Beast: Hawk -- Dire Beast: Basilisk -- Interlope -- Interlope -- Roar of Sacrifice -- Roar of Sacrifice -- Hi-Explosive Trap -- Scorpid Sting -- Scorpid Sting -- Spider Sting -- Spider Sting -- Viper Sting -- Viper Sting -- Marksmanship -- Misdirection -- Trailblazer -- Aspect of the Cheetah -- Primal Rage -- Lethal Shots -- Lock and Load -- Rapid Fire -- Lone Wolf -- Eagle Eye -- Trick Shots -- Trueshot -- Precise Shots -- Feign Death -- Double Tap -- Posthaste -- Aspect of the Turtle -- Steady Focus -- Predator's Thirst -- Camouflage -- Prowl -- Mend Pet -- Survival of the Fittest -- Tar Trap -- Concussive Shot -- Bursting Shot -- Freezing Trap -- Serpent Sting -- Hunter's Mark -- A Murder of Crows -- Disengage -- Flare -- Concussive Shot -- Feign Death -- Aimed Shot -- Misdirection -- Binding Shot -- Exhilaration -- Barrage -- A Murder of Crows -- Counter Shot -- Arcane Shot -- Aspect of the Cheetah -- Aspect of the Turtle -- Bursting Shot -- Freezing Trap -- Tar Trap -- Trueshot -- Piercing Shot -- Camouflage -- Explosive Shot -- Rapid Fire -- Multi-Shot -- Double Tap -- Primal Rage -- Survival of the Fittest --Arrowstorm --Duck and Cover --In The Rhythm --Ride the Lightning --Shellshock --Steady Aim --Unerring Vision -- Viper Sting -- Viper Sting -- Scorpid Sting -- Scorpid Sting -- Spider Sting -- Spider Sting -- Roar of Sacrifice -- Roar of Sacrifice -- Sniper Shot -- Sniper Shot -- Scatter Shot -- Scatter Shot -- Hi-Explosive Trap -- Survival -- Camouflage -- Misdirection -- Trailblazer -- Aspect of the Cheetah -- Primal Rage -- Mongoose Fury -- Sign of the Emissary -- Viper's Venom -- Predator -- Eagle Eye -- Predator's Thirst -- Coordinated Assault -- Feign Death -- Tip of the Spear -- Aspect of the Turtle -- Posthaste -- Terms of Engagement -- Aspect of the Eagle -- Predator's Thirst -- Coordinated Assault -- Catlike Reflexes -- Dash -- Mend Pet -- Predator -- Prowl -- Shrapnel Bomb -- Pheromone Bomb -- Intimidation -- Tar Trap -- Internal Bleeding -- Wing Clip -- Wildfire Bomb -- Steel Trap -- A Murder of Crows -- Kill Command -- Harpoon -- Steel Trap -- Growl -- Freezing Trap -- Serpent Sting -- Volatile Bomb -- Binding Shot -- Disengage -- Flare -- Growl -- Feign Death -- Claw -- Aimed Shot -- Intimidation -- Prowl -- Misdirection -- Dash -- Binding Shot -- Exhilaration -- A Murder of Crows -- Steel Trap -- Aspect of the Cheetah -- Aspect of the Turtle -- Aspect of the Eagle -- Freezing Trap -- Tar Trap -- Muzzle -- Carve -- Harpoon -- Camouflage -- Butchery -- Chakrams -- Kill Command -- Serpent Sting -- Wildfire Bomb -- Catlike Reflexes -- Primal Rage -- Coordinated Assault -- Flanking Strike -- Pheromone Bomb -- Shrapnel Bomb -- Volatile Bomb -- Primal Rage --Blur of Talons --Duck and Cover --Latent Poison --Ride the Lightning --Shellshock --Prime Intuition --Vigorous Wings --Whirling Rebound -- Spider Sting -- Spider Sting -- Scorpid Sting -- Scorpid Sting -- Tracker's Net -- Tracker's Net -- Viper Sting -- Viper Sting -- Mending Bandage -- Roar of Sacrifice -- Roar of Sacrifice -- Sticky Tar -- Hi-Explosive Trap -- Assassination -- Blindside -- Evasion -- Wound Poison -- Tricks of the Trade -- Leeching Poison -- Deadly Poison -- Elaborate Planning -- Subterfuge -- Shroud of Concealment -- Envenom -- Shadowstep -- Crimson Vial -- Hidden Blades -- Master Assassin -- Feint -- Stealth -- Cloak of Shadows -- Vanish -- Crippling Poison -- Sprint -- Cheating Death -- Marked for Death -- Garrote - Silence -- Iron Wire -- Internal Bleeding -- Cheap Shot -- Sap -- Prey on the Weak -- Garrote -- Toxic Blade -- Deadly Poison -- Crippling Poison -- Blind -- Kidney Shot -- Crimson Tempest -- Vendetta -- Rupture -- Wound Poison -- Cheated Death -- Kidney Shot -- Garrote -- Distract -- Sinister Strike / Mutilate -- Kick -- Stealth -- Cheap Shot -- Vanish -- Rupture -- Feint -- Blind -- Sprint -- Fan of Knives -- Tricks of the Trade -- Sap -- Evasion -- Cloak of Shadows -- Shadowstep -- Vendetta -- Shroud of Concealment -- Stealth -- Marked for Death -- Crimson Vial -- Envenom -- Exsanguinate -- Toxic Blade -- Tricks of the Trade --Footpad --Shrouded Mantle --Nothing Personal --Scent of Blood --Shrouded Suffocation --Lying in Wait -- Death from Above -- Maneuverability -- Shiv -- Shiv -- Mind-Numbing Poison -- System Shock -- Neurotoxin -- Neurotoxin -- Creeping Venom -- Smoke Bomb -- Smoke Bomb -- Outlaw -- Ruthless Precision -- Buried Treasure -- Grand Melee -- Killing Spree -- Shroud of Concealment -- Blade Rush -- Slice and Dice -- Adrenaline Rush -- True Bearing -- Skull and Crossbones -- Riposte -- Crimson Vial -- Sprint -- Feint -- Alacrity -- Stealth -- Cloak of Shadows -- Opportunity -- Vanish -- Blade Flurry -- Broadside -- Tricks of the Trade -- Cheating Death -- Prey on the Weak -- Between the Eyes -- Pistol Shot -- Cheap Shot -- Ghostly Strike -- Marked for Death -- Blind -- Gouge -- Sap -- Cheated Death -- Distract -- Sinister Strike -- Kick -- Gouge -- Stealth -- Vanish -- Feint -- Blind -- Dispatch -- Sprint -- Shroud of Concealment -- Adrenaline Rush -- Blade Flurry -- Cloak of Shadows -- Killing Spree -- Tricks of the Trade -- Restless Blades -- Shroud of Concealment -- Marked for Death -- Crimson Vial -- Pistol Shot -- Roll the Bones -- Grappling Hook -- Ghostly Strike -- Riposte -- Between the Eyes -- Blade Rush -- Tricks of the Trade --Brigand's Blitz --Deadshot --Footpad --Paradise Lost --Shrouded Mantle --Snake Eyes --Keep Your Wits About You --Lying in Wait -- Dismantle -- Dismantle -- Take Your Cut -- Drink Up Me Hearties -- Death from Above -- Maneuverability -- Boarding Party -- Smoke Bomb -- Smoke Bomb -- Turn the Tables -- Plunder Armor -- Plunder Armor -- Shiv -- Cheap Tricks -- Cheap Tricks -- Subtlety -- Master of Shadows -- Evasion -- Shadow Blades -- Symbols of Death -- Shadow Dance -- Subterfuge -- Shroud of Concealment -- Shot in the Dark -- Crimson Vial -- Shuriken Tornado -- Feint -- Alacrity -- Stealth -- Cloak of Shadows -- Stealth -- Vanish -- Shuriken Combo -- Sprint -- Tricks of the Trade -- Cheating Death -- Prey on the Weak -- Find Weakness -- Nightblade -- Blind -- Marked for Death -- Cheap Shot -- Shadow's Grasp -- Kidney Shot -- Sap -- Cheated Death -- Backstab -- Kidney Shot -- Distract -- Sinister Strike -- Kick -- Stealth -- Cheap Shot -- Vanish -- Feint -- Blind -- Sprint -- Evasion -- Tricks of the Trade -- Sap -- Cloak of Shadows -- Shadowstep -- Shuriken Toss -- Shroud of Concealment -- Stealth -- Shadow Blades -- Marked for Death -- Crimson Vial -- Shadow Dance -- Kidney Shot -- Nightblade -- Eviscerate -- Shuriken Storm -- Symbols of Death -- Shuriken Tornado -- Secret Technique -- Tricks of the Trade --Blade In The Shadows --Deadshot --Night's Vengeance --Perforate --Shrouded Mantle --The First Dance --Lying in Wait -- Dagger in the Dark -- Smoke Bomb -- Smoke Bomb -- Shadowy Duel -- Shadowy Duel -- Cold Blood -- Cold Blood -- Maneuverability -- Shiv -- Death from Above -- Veil of Midnight -- Discipline -- Fade -- Power of the Dark Side -- Atonement -- Power Word: Shield -- Twist of Fate -- Luminous Barrier -- Desperate Prayer -- Power Word: Fortitude -- Power Word: Barrier -- Pain Suppression -- Masochism -- Body and Soul -- Rapture -- Angelic Feather -- Mind Vision -- Levitate -- Focused Will -- Psychic Scream -- Shining Force -- Smite -- Purge the Wicked -- Mind Vision -- Schism -- Shadow Word: Pain -- Shackle Undead -- Purify -- Fade -- Flash Heal -- Psychic Scream -- Desperate Prayer -- Mass Dispel -- Pain Suppression -- Shadowfiend -- Rapture -- Penance -- Power Word: Barrier -- Leap of Faith -- Divine Star -- Halo -- Angelic Feather -- Mindbender -- Power Word: Solace -- Power Word: Radiance -- Shadow Covenant -- Shining Force -- Schism -- Evangelism -- Luminous Barrier --Depth of the Shadows --Sanctum --Death Denied --Sudden Revelation -- Dark Archangel -- Dark Archangel -- Premonition -- Archangel -- Archangel -- Holy -- Guardian Spirit -- Symbol of Hope -- Renew -- Mind Vision -- Divine Hymn -- Desperate Prayer -- Power Word: Fortitude -- Levitate -- Apotheosis -- Spirit of Redemption -- Echo of Light -- Surge of Light -- Angelic Feather -- Fade -- Prayer of Mending -- Focused Will -- Psychic Scream -- Holy Word: Chastise -- Holy Fire -- Mind Vision -- Shining Force -- Holy Word: Chastise -- Shackle Undead -- Purify -- Fade -- Holy Word: Serenity -- Flash Heal -- Psychic Scream -- Holy Fire -- Desperate Prayer -- Mass Dispel -- Prayer of Mending -- Holy Word: Sanctify -- Guardian Spirit -- Divine Hymn -- Symbol of Hope -- Leap of Faith -- Holy Word: Chastise -- Divine Star -- Halo -- Angelic Feather -- Apotheosis -- Shining Force -- Circle of Healing -- Holy Word: Salvation --Permeating Glow --Sanctum --Death Denied --Promise of Deliverance -- Spirit of the Redeemer -- Ray of Hope -- Ray of Hope -- Holy Ward -- Holy Ward -- Holy Word: Concentration -- Holy Word: Concentration -- Greater Fade -- Greater Fade -- Shadow -- Surrender to Madness -- Void Torrent -- Fade -- Mind Vision -- Vampiric Embrace -- Shadowy Insight -- Power Word: Shield -- Body and Soul -- Lingering Insanity -- Voidform -- Dispersion -- Shadowform -- Power Word: Fortitude -- Levitate -- Twist of Fate -- Mind Flay -- Mind Sear -- Mind Vision -- Mind Bomb -- Mind Bomb -- Void Torrent -- Silence -- Shadow Word: Pain -- Psychic Scream -- Vampiric Touch -- Shackle Undead -- Power Word: Shield -- Fade -- Mind Blast -- Psychic Scream -- Vampiric Embrace -- Silence -- Mass Dispel -- Shadow Word: Death -- Shadowfiend -- Dispersion -- Psychic Horror -- Leap of Faith -- Surrender to Madness -- Mindbender -- Shadow Word: Void -- Mind Bomb -- Shadow Crash -- Void Bolt -- Purify Disease -- Void Eruption -- Void Torrent -- Dark Void -- Dark Ascension --Chorus of Insanity --Depth of the Shadows --Harvested Thoughts --Sanctum --Whispers of the Damned --Death Denied -- Psyfiend -- Edge of Insanity -- Void Shift -- Mind Trauma -- Mind Trauma -- Greater Fade -- Elemental -- Wind Rush -- Resonance Totem -- Tailwind Totem -- Elemental Blast: Mastery -- Astral Shift -- Storm Totem -- Unlimited Power -- Ancestral Guidance -- Water Walking -- Ascendance -- Icefury -- Spirit Wolf -- Master of the Elements -- Stormkeeper -- Surge of Power -- Earth Shield -- Far Sight -- Ember Totem -- Elemental Blast: Haste -- Lava Surge -- Ghost Wolf -- Elemental Blast: Critical Strike -- Call Lightning -- Exposed Elements -- Static Charge -- Earthquake -- Flame Shock -- Thunderstorm -- Frost Shock -- Immolate -- Earthbind -- Eye of the Storm -- Pulverize -- Astral Recall -- Earthbind Totem -- Tremor Totem -- Heroism -- Bloodlust -- Thunderstorm -- Lava Burst -- Lava Burst -- Hex -- Cleanse Spirit -- Wind Shear -- Astral Shift -- Ancestral Guidance -- Ascendance -- Elemental Blast -- Flame Shock -- Stormkeeper -- Capacitor Totem -- Wind Rush Totem -- Liquid Magma Totem -- Storm Elemental -- Fire Elemental -- Earth Elemental -- Icefury --Ancestral Resonance --Astral Shift --Flames of the Forefathers --Lightningburn --Natural Harmony (Fire) --Natural Harmony (Frost) --Natural Harmony (Nature) --Pack Spirit --Tectonic Thunder --Synapse Shock --Volcanic Lightning --Ancient Ankh Talisman -- Lightning Lasso -- Lightning Lasso -- Control of Lava -- Skyfury Totem -- Skyfury Totem -- Grounding Totem -- Grounding Totem -- Counterstrike Totem -- Counterstrike Totem -- Enhancement -- Lightning Shield Overcharge -- Wind Rush -- Earth Shield -- Forceful Winds -- Crash Lightning -- Storm Totem -- Lightning Shield -- Astral Shift -- Far Sight -- Frostbrand -- Icy Edge -- Water Walking -- Ascendance -- Molten Weapon -- Landslide -- Tailwind Totem -- Spirit Walk -- Gathering Storms -- Crackling Surge -- Fury of Air -- Stormbringer -- Spirit Wolf -- Resonance Totem -- Ember Totem -- Ghost Wolf -- Hot Hand -- Flametongue -- Static Charge -- Sundering -- Frostbrand -- Molten Weapon -- Earthbind -- Earthen Spike -- Fury of Air -- Searing Assault -- Astral Recall -- Earthbind Totem -- Tremor Totem -- Stormstrike -- Heroism -- Bloodlust -- Hex -- Feral Spirit -- Cleanse Spirit -- Wind Shear -- Spirit Walk -- Astral Shift -- Ascendance -- Windstrike -- Lightning Bolt -- Crash Lightning -- Earthen Spike -- Capacitor Totem -- Wind Rush Totem -- Rockbiter -- Flametongue -- Feral Lunge -- Sundering -- Earth Elemental --Ancestral Resonance --Astral Shift --Electropotence --Lightning Conduit --Pack Spirit --Primal Primer --Roiling Storm --Storm's Eye --Strength of Earth --Synapse Shock --Ancient Ankh Talisman --Thunderaan's Fury -- Thundercharge -- Thundercharge -- Ethereal Form -- Ethereal Form -- Skyfury Totem -- Skyfury Totem -- Counterstrike Totem -- Counterstrike Totem -- Grounding Totem -- Grounding Totem -- Restoration -- Spiritwalker's Grace -- Ascendance -- Earth Shield -- Undulation -- Astral Shift -- Far Sight -- Ancestral Protection -- Unleash Life -- Water Walking -- Cloudburst Totem -- Spirit Wolf -- Riptide -- Spirit Link Totem -- Lava Surge -- Ancestral Vigor -- Earthen Wall -- Healing Rain -- Flash Flood -- Ghost Wolf -- Tidal Waves -- Static Charge -- Earthgrab -- Earthbind -- Flame Shock -- Astral Recall -- Earthbind Totem -- Healing Stream Totem -- Healing Stream Totem -- Tremor Totem -- Heroism -- Bloodlust -- Earthgrab Totem -- Lava Burst -- Lava Burst -- Hex -- Wind Shear -- Riptide -- Riptide -- Unleash Life -- Healing Rain -- Spiritwalker's Grace -- Spirit Link Totem -- Astral Shift -- Healing Tide Totem -- Ascendance -- Cloudburst Totem -- Flame Shock -- Capacitor Totem -- Wind Rush Totem -- Wellspring -- Earth Elemental -- Earthen Wall Totem -- Ancestral Protection Totem -- Downpour --Astral Shift --Ancestral Reach --Ancestral Resonance --Flames of the Forefathers --Overflowing Shores --Pack Spirit --Spouting Spirits --Surging Tides --Volcanic Lightning --Soothing Waters --Ancient Ankh Talisman -- Ancestral Gift -- Ancestral Gift -- Electrocute -- Spirit Link -- Tidebringer -- Grounding Totem -- Grounding Totem -- Skyfury Totem -- Skyfury Totem -- Counterstrike Totem -- Counterstrike Totem -- Arcane -- Greater Invisibility -- Ice Block -- Incanter's Flow -- Arcane Intellect -- Displacement Beacon -- Arcane Familiar -- Chrono Shift -- Rune of Power -- Slow Fall -- Clearcasting -- Prismatic Barrier -- Evocation -- Presence of Mind -- Rule of Threes -- Arcane Power -- Ring of Frost -- Nether Tempest -- Touch of the Magi -- Chrono Shift -- Slow -- Frost Nova -- Polymorph -- Frost Nova -- Remove Curse -- Arcane Explosion -- Blink -- Counterspell -- Arcane Missiles -- Arcane Power -- Evocation -- Arcane Barrage -- Ice Block -- Mirror Image -- Time Warp -- Greater Invisibility -- Ring of Frost -- Rune of Power -- Arcane Orb -- Supernova -- Conjure Refreshment -- Displacement -- Arcane Familiar -- Presence of Mind -- Charged Up -- Shimmer -- Prismatic Barrier --Arcane Pumeling --Brain Storm --Cauterizing Blink --Equipoise -- Temporal Shield -- Temporal Shield -- Prismatic Cloak -- Mass Invisibility -- Mass Invisibility -- Fire -- Frenetic Speed -- Incanter's Flow -- Pyroclasm -- Bonfire's Blessing -- Heating Up -- Rune of Power -- Blazing Barrier -- Ice Block -- Enhanced Pyrotechnics -- Combustion -- Invisibility -- Arcane Intellect -- Slow Fall -- Hot Streak! -- Dragon's Breath -- Flamestrike -- Meteor Burn -- Blast Wave -- Conflagration -- Living Bomb -- Ignite -- Ring of Frost -- Cauterize -- Cauterized -- Polymorph -- Invisibility -- Remove Curse -- Blink -- Flamestrike -- Counterspell -- Pyroblast -- Dragon's Breath -- Living Bomb -- Ice Block -- Mirror Image -- Time Warp -- Fire Blast -- Ring of Frost -- Rune of Power -- Meteor -- Blast Wave -- Combustion -- Conjure Refreshment -- Shimmer -- Blazing Barrier -- Phoenix Flames --Blaster Master --Cauterizing Blink --Firemind --Wildfire --Trailing Embers -- Temporal Shield -- Temporal Shield -- Flamecannon -- Tinder -- Prismatic Cloak -- Frost -- Glacial Spike! -- Ice Block -- Invisibility -- Incanter's Flow -- Arcane Intellect -- Ice Floes -- Chain Reaction -- Icy Veins -- Ice Barrier -- Slow Fall -- Icicles -- Freezing Rain -- Brain Freeze -- Rune of Power -- Fingers of Frost -- Bone Chilling -- Flurry -- Chilled -- Glacial Spike -- Ice Nova -- Winter's Chill -- Ray of Frost -- Frost Nova -- Ring of Frost -- Cone of Cold -- Polymorph -- Invisibility -- Cone of Cold -- Frost Nova -- Remove Curse -- Blink -- Counterspell -- Ice Barrier -- Icy Veins -- Ice Lance -- Summon Water Elemental -- Waterbolt -- Ice Block -- Mirror Image -- Time Warp -- Frozen Orb -- Ice Floes -- Ring of Frost -- Rune of Power -- Comet Storm -- Ice Nova -- Conjure Refreshment -- Blizzard -- Glacial SPike -- Ray of Frost -- Shimmer -- Cold Snap -- Ebonbolt --Cauterizing Blink --Frigid Grasp --Orbital Precision --Tunnel of Ice --Winter's Reach -- Prismatic Cloak -- Burst of Cold -- Ice Form -- Ice Form -- Temporal Shield -- Temporal Shield -- Frostbite -- Affliction -- Grimoire of Sacrifice -- Unending Resolve -- Eye of Kilrogg -- Dark Soul: Misery -- Demonic Circle -- Dark Pact -- Soul Leech -- Unending Breath -- Nightfall -- Burning Rush -- Soulstone -- Lesser Invisibility -- Threatening Presence -- Shadow Bulwark -- Health Funnel -- Unstable Affliction -- Seed of Corruption -- Banish -- Drain Life -- Seduction -- Shadowfury -- Mortal Coil -- Fear -- Drain Soul -- Suffering -- Whiplash -- Vile Taint -- Enslave Demon -- Haunt -- Shadow Embrace -- Corruption -- Phantom Singularity -- Siphon Life -- Agony -- Corruption -- Ritual of Summoning -- Banish -- Agony -- Firebolt -- Consuming Shadows -- Fear -- Seduction -- Whiplash -- Mortal Coil -- Lash of Pain -- Lesser Invisibility -- Suffering -- Shadow Bulwark -- Devour Magic -- Spell Lock -- Soulstone -- Seed of Corruption -- Create Soulwell -- Unstable Affliction -- Shadowfury -- Demonic Circle -- Demonic Circle: Teleport -- Haunt -- Shadow Bite -- Siphon Life -- Flee -- Singe Magic -- Unending Resolve -- Dark Pact -- Grimoire of Sacrifice -- Demonic Gateway -- Threatening Presence -- Dark Soul: Misery -- Spell Lock -- Phantom Singularity -- Summon Darkglare -- Shadow Bolt -- Drain Life -- Deathbolt -- Shadow Shield -- Vile Taint --Cascading Calamity --Desperate Power --Inevitable Demise --Lifeblood --Wracking Brilliance --Terror of the Mind -- Curse of Tongues -- Curse of Tongues -- Demon Armor -- Essence Drain -- Casting Circle -- Casting Circle -- Soulshatter -- Soulshatter -- Curse of Weakness -- Curse of Weakness -- Curse of Fragility -- Curse of Fragility -- Endless Affliction -- Nether Ward -- Nether Ward -- Curse of Shadows -- Curse of Shadows -- Demonology -- Unending Resolve -- Eye of Kilrogg -- Nether Portal -- Demonic Circle -- Dark Pact -- Soul Leech -- Demonic Calling -- Unending Breath -- Demonic Power -- Burning Rush -- Soulstone -- Demonic Core -- Threatening Presence -- Pursuit -- Demonic Strength -- Shadow Bulwark -- Felstorm -- Health Funnel -- From the Shadows -- Bile Spit -- Suffering -- Fear -- Shadowfury -- Axe Toss -- Mortal Coil -- Drain Life -- Legion Strike -- Whiplash -- Doom -- Banish -- Enslave Demon -- Seduction -- Shadow Bolt -- Ritual of Summoning -- Banish -- Consuming Shadows -- Fear -- Whiplash -- Mortal Coil -- Lash of Pain -- Lesser Invisibility -- Suffering -- Shadow Bulwark -- Devour Magic -- Spell Lock -- Soulstone -- Create Soulwell -- Pursuit -- Legion Strike -- Shadowfury -- Demonic Circle -- Demonic Circle: Teleport -- Shadow Bite -- Felstorm -- Axe Toss -- Flee -- Singe Magic -- Call Dreadstalkers -- Unending Resolve -- Hand of Gul'dan -- Dark Pact -- Demonic Gateway -- Grimoire: Felguard -- Threatening Presence -- Soul Strike -- Summon Vilefiend -- Power Siphon -- Demonbolt -- Shadow Shield -- Summon Demonic Tyrant -- Doom -- Demonic Strength -- Bilescourge Bombers -- Nether Portal -- Seduction --Desperate Power --Excoriate --Explosive Potential --Lifeblood --Shadow's Bite --Supreme Commander --Umbral Blaze --Terror of the Mind -- Call Observer -- Nether Ward -- Nether Ward -- Essence Drain -- Casting Circle -- Casting Circle -- Curse of Tongues -- Curse of Tongues -- Curse of Fragility -- Curse of Fragility -- Curse of Weakness -- Curse of Weakness -- Singe Magic -- Call Felhunter -- Call Fel Lord -- Destruction -- Unending Resolve -- Eye of Kilrogg -- Dark Soul: Instability -- Grimoire of Sacrifice -- Grimoire of Supremacy -- Soul Leech -- Reverse Entropy -- Unending Breath -- Demonic Circle -- Burning Rush -- Soulstone -- Dark Pact -- Backdraft -- Lesser Invisibility -- Threatening Presence -- Shadow Bulwark -- Soul Leech -- Health Funnel -- Immolate -- Infernal Awakening -- Conflagrate -- Suffering -- Fear -- Havoc -- Mortal Coil -- Eradication -- Drain Life -- Whiplash -- Shadowfury -- Banish -- Enslave Demon -- Seduction -- Immolate -- Ritual of Summoning -- Banish -- Summon Infernal -- Firebolt -- Consuming Shadows -- Rain of Fire -- Fear -- Soul Fire -- Whiplash -- Mortal Coil -- Lash of Pain -- Lesser Invisibility -- Suffering -- Shadow Bulwark -- Shadowburn -- Conflagrate -- Spell Lock -- Soulstone -- Incinerate -- Create Soulwell -- Shadowfury -- Demonic Circle -- Demonic Circle: Teleport -- Shadow Bite -- Havoc -- Flee -- Singe Magic -- Unending Resolve -- Dark Pact -- Grimoire of Sacrifice -- Demonic Gateway -- Threatening Presence -- Dark Soul: Instability -- Cataclysm -- Chaos Bolt -- Channel Demonfire -- Drain Life -- Shadow Shield -- Seduction --Chaos Shards --Bursting Flare --Chaotic Inferno --Desperate Power --Flashpoint --Lifeblood --Rolling Havoc --Crashing Chaos --Terror of the Mind -- Fel Fissure -- Entrenched in Flame -- Demon Armor -- Bane of Havoc -- Bane of Havoc -- Curse of Fragility -- Curse of Fragility -- Curse of Tongues -- Curse of Tongues -- Curse of Weakness -- Curse of Weakness -- Nether Ward -- Nether Ward -- Essence Drain -- Casting Circle -- Casting Circle -- Brewmaster -- Rushing Jade Wind -- Dampen Harm -- Chi Torpedo -- Elusive Brawler -- Blackout Combo -- Ironskin Brew -- Zen Meditation -- Guard -- Tiger's Lust -- Fortifying Brew -- Eye of the Tiger -- Transcendence -- Honorless Target -- Leg Sweep -- Eye of the Tiger -- Mystic Touch -- Paralysis -- Crackling Jade Lightning -- Keg Smash -- Provoke -- Heavy Stagger -- Moderate Stagger -- Light Stagger -- Transcendence -- Quaking Palm -- Roll -- Chi Torpedo -- Paralysis -- Chi Wave -- Zen Meditation -- Breath of Fire -- Fortifying Brew -- Guard -- Ironskin Brew -- Summon Black Ox Statue -- Black Ox Brew -- Provoke -- Spear Hand Strike -- Tiger's Lust -- Ring of Peace -- Rushing Jade Wind -- Leg Sweep -- Purifying Brew -- Transcendence: Transfer -- Keg Smash -- Dampen Harm -- Healing Elixir -- Chi Burst -- Zen Pilgrimage -- Invoke Niuzao, the Black Ox -- Blackout Strike -- Detox --Fit to Burst --Straight, No Chaser --Staggering Strikes --Strength of Spirit --Sweep the Leg --Training of Niuzao --Exit Strategy -- Mighty Ox Kick -- Double Barrel -- Double Barrel -- Craft: Nimble Brew -- Craft: Nimble Brew -- Avert Harm -- Avert Harm -- Admonishment -- Admonishment -- Incendiary Breath -- Mistweaver -- Renewing Mist -- Refreshing Jade Wind -- Diffuse Magic -- Thunder Focus Tea -- Fortifying Brew -- Enveloping Mist -- Tiger's Lust -- Mana Tea -- Essence Font -- Soothing Mist -- Chi Torpedo -- Teachings of the Monastery -- Dampen Harm -- Lifecycles (Enveloping Mist) -- Life Cocoon -- Transcendence -- Lifecycles (Vivify) -- Leg Sweep -- Paralysis -- Crackling Jade Lightning -- Provoke -- Mystic Touch -- Blackout Kick -- Transcendence -- Quaking Palm -- Rising Sun Kick -- Roll -- Chi Torpedo -- Paralysis -- Chi Wave -- Renewing Mist -- Revival -- Summon Jade Serpent Statue -- Detox -- Provoke -- Thunder Focus Tea                    -- add talent = 19 abilityChargeBuff -- Tiger's Lust -- Ring of Peace -- Life Cocoon -- Leg Sweep -- Transcendence: Transfer -- Dampen Harm -- Healing Elixir -- Diffuse Magic -- Chi Burst -- Zen Pilgrimage -- Essence Font -- Refreshing Jade Wind -- Mana Tea -- Invoke Chi-Ji, the Red Crane -- Song of Chi-Ji -- Fortifying Brew --Misty Peaks --Overflowing Mists --Strength of Spirit --Sunrise Technique --Sweep the Leg --Exit Strategy --Secret Infusion -- Way of the Crane -- Way of the Crane -- Grapple Weapon -- Grapple Weapon -- Healing Sphere -- Surging Mist -- Zen Focus Tea -- Zen Focus Tea -- Windwalker -- Dampen Harm -- Touch of Karma -- Chi Torpedo -- Serenity -- Rushing Jade Wind -- Transcendence -- Inner Strength -- Tiger's Lust -- Diffuse Magic -- Storm, Earth, and Fire -- Hit Combo -- Eye of the Tiger -- Windwalking -- Blackout Kick! -- Paralysis -- Provoke -- Touch of Death -- Mystic Touch -- Mark of the Crane -- Mortal Wounds -- Disable -- Crackling Jade Lightning -- Eye of the Tiger -- Touch of Karma -- Leg Sweep -- Flying Serpent Kick -- Tiger Palm -- Blackout Kick -- Flying Serpent Kick -- Spinning Crane Kick -- Transcendence -- Rising Sun Kick -- Roll -- Fists of Fury -- Chi Torpedo -- Paralysis -- Touch of Death -- Chi Wave -- Energizing Elixir -- Provoke -- Disable -- Spear Hand Strike -- Tiger's Lust -- Ring of Peace -- Leg Sweep -- Transcendence: Transfer -- Dampen Harm -- Touch of Karma -- Diffuse Magic -- Invoke Xuen, the White Tiger -- Chi Burst -- Zen Pilgrimage -- Storm, Earth, and Fire -- Serenity -- Whirling Dragon Punch -- Detox -- Rushing Jade Wind -- Fist of the White Tiger --Fury of Xuen --Open Palm Strikes --Sunrise Technique --Dance of Chi-Ji --Exit Strategy -- Grapple Weapon -- Grapple Weapon -- Alpha Tiger -- Alpha Tiger -- Turbo Fists -- Reverse Harm -- Ride the Wind -- Fortifying Brew -- Fortifying Brew -- Tigereye Brew -- Tigereye Brew -- Tigereye Brew -- Balance -- Starlord -- Frenzied Regeneration -- Moonkin Form -- Rejuvenation -- Warrior of Elune -- Lunar Empowerment -- Bear Form -- Regrowth -- Tiger Dash -- Celestial Alignment -- Starfall -- Incarnation: Chosen of Elune -- Solar Empowerment -- Travel Form -- Cat Form -- Stellar Drift -- Wild Growth -- Ironfur -- Barkskin -- Dash -- Prowl -- Innervate -- Rake -- Force of Nature -- Mass Entanglement -- Entangling Roots -- Mighty Bash -- Rip -- Sunfire -- Stellar Flare -- Typhoon -- Thrash -- Moonfire -- Growl -- Solar Beam -- Hibernate -- Cat Form -- Travel Form -- Dash -- Remove Corruption -- Soothe -- Mighty Bash -- Prowl -- Bear Form -- Growl -- Moonfire -- Wild Charge -- Swiftmend -- Rebirth -- Barkskin -- Frenzied Regeneration -- Moonkin Form -- Innervate -- Mangle -- Wild Growth -- Wild Charge -- Thrash -- Starsurge -- Solar Beam -- Sunfire -- Mass Entanglement -- Wild Charge -- Wild Charge -- Incarnation: Chosen of Elune -- Renewal -- Typhoon -- Solar Wrath -- Starfall -- Ironfur -- Lunar Strike -- Celestial Alignment -- Stellar Flare -- Warrior of Elune -- Fury of Elune -- Force of Nature -- Tiger Dash -- New Moon --Dawning Sun --Lively Spirit --Long Night --Reawakening --Streaking Stars --Arcanic Pulsar --Ursoc's Endurance --Switch Hitter -- Thorns -- Thorns -- Protector of the Grove -- Faerie Swarm -- Faerie Swarm -- Cyclone -- Cyclone -- Moon and Stars -- Moonkin Aura -- Feral -- Berserk -- Survival Instincts -- Frenzied Regeneration -- Prowl -- Rejuvenation -- Lunar Empowerment -- Bear Form -- Regrowth -- Bloodtalons -- Tiger Dash -- Savage Roar -- Wild Growth -- Stampeding Roar -- Tiger's Fury -- Jungle Stalker -- Solar Empowerment -- Travel Form -- Cat Form -- Predatory Swiftness -- Clearcasting -- Incarnation: King of the Jungle -- Ironfur -- Dash -- Moonkin Form -- Moonfire -- Mass Entanglement -- Thrash -- Entangling Roots -- Feral Frenzy -- Infected Wounds -- Rip -- Sunfire -- Typhoon -- Mighty Bash -- Moonfire -- Maim -- Growl -- Rake -- Hibernate -- Entangling Roots -- Cat Form -- Travel Form -- Hibernate -- Rake -- Dash -- Remove Corruption -- Soothe -- Mighty Bash -- Prowl -- Tiger's Fury -- Shred -- Bear Form -- Growl -- Moonfire -- Regrowth -- Rip -- Wild Charge -- Swiftmend -- Rebirth -- Ferocious Bite -- Maim -- Frenzied Regeneration -- Mangle -- Wild Growth -- Wild Charge -- Survival Instincts -- Mass Entanglement -- Wild Charge -- Incarnation: King of the Jungle -- Thrash -- Skull Bash -- Stampeding Roar -- Berserk -- Renewal -- Typhoon -- Ironfur -- Moonkin Form -- Starsurge -- Brutal Slash -- Tiger Dash -- Feral Frenzy --Iron Jaws --Primordial Rage --Reawakening --Jungle Fury --Ursoc's Endurance --Switch Hitter -- King of the Jungle -- Ferocious Wound -- Rip and Tear -- Leader of the Pack -- Heart of the Wild -- Cyclone -- Cyclone -- Thorns -- Thorns -- Guardian -- Bristling Fur -- Survival Instincts -- Frenzied Regeneration -- Prowl -- Rejuvenation -- Earthwarden -- Lunar Empowerment -- Bear Form -- Regrowth -- Gore -- Pulverize -- Guardian of Elune -- Incarnation: Guardian of Ursoc -- Galactic Guardian -- Wild Growth -- Stampeding Roar -- Travel Form -- Ironfur -- Solar Empowerment -- Moonkin Form -- Tiger Dash -- Barkskin -- Dash -- Cat Form -- Moonfire -- Mass Entanglement -- Entangling Roots -- Mighty Bash -- Typhoon -- Rip -- Sunfire -- Immobilized -- Rake -- Incapacitating Roar -- Intimidating Roar -- Growl -- Thrash -- Incapacitating Roar -- Cat Form -- Travel Form -- Soothe -- Dash -- Remove Corruption -- Mighty Bash -- Prowl -- Bear Form -- Growl -- Maul -- Moonfire -- Wild Charge -- Swiftmend -- Mass Entanglement -- Rebirth -- Barkskin -- Frenzied Regeneration -- Mangle -- Wild Growth -- Wild Charge -- Survival Instincts -- Thrash -- Stampeding Roar -- Pulverize -- Mass Entanglement -- Wild Charge -- Wild Charge -- Incarnation: Guardian of Ursoc -- Skull Bash -- Stampeding Roar -- Typhoon -- Bristling Fur -- Ironfur -- Moonkin Form -- Starsurge -- Lunar Beam -- Intimidating Roar -- Tiger Dash --Burst of Savagery --Grove Tending --Guardian's Wrath --Heartblood --Layered Mane --Masterful Instincts --Reawakening --Twisted Claws --Ursoc's Endurance --Switch Hitter -- Sharpened Claws -- Demoralizing Roar -- Demoralizing Roar -- Master Shapeshifter -- Master Shapeshifter -- Alpha Challenge -- Alpha Challenge -- Overrun -- Overrun -- Restoration -- Abundance -- Tranquility -- Innervate -- Cultivation -- Prowl -- Rejuvenation -- Rejuvenation (Germination) -- Lunar Empowerment -- Flourish -- Incarnation -- Bear Form -- Regrowth -- Moonkin Form -- Spring Blossoms -- Tiger Dash -- Barkskin -- Lifebloom -- Wild Charge -- Ironfur -- Frenzied Regeneration -- Incarnation: Tree of Life -- Solar Empowerment -- Travel Form -- Clearcasting -- Cenarion Ward -- Ironbark -- Dash -- Soul of the Forest -- Wild Growth -- Cat Form -- Ursol's Vortex -- Mass Entanglement -- Entangling Roots -- Mighty Bash -- Rip -- Sunfire -- Typhoon -- Thrash -- Moonfire -- Growl -- Rake -- Hibernate -- Tranquility -- Cat Form -- Travel Form -- Dash -- Hibernate -- Soothe -- Mighty Bash -- Prowl -- Bear Form -- Growl -- Swiftmend -- Rebirth -- Barkskin -- Frenzied Regeneration -- Innervate -- Incarnation: Tree of Life -- Mangle -- Wild Growth -- Thrash -- Nature's Cure -- Ironbark -- Cenarion Ward -- Mass Entanglement -- Wild Charge -- Ursol's Vortex -- Renewal -- Typhoon -- Ironfur -- Moonkin Form -- Starsurge -- Flourish -- Tiger Dash --Grove Tending --Lively Spirit --Reawakening --Rejuvenating Breath --Ursoc's Endurance --Switch Hitter -- Nourish -- Revitalize -- Entangling Bark -- Thorns -- Thorns -- Focused Growth -- Encroaching Vines -- Overgrowth -- Early Spring -- Cyclone -- Cyclone -- Master Shapeshifter -- Mark of the Wild -- Havoc -- Momentum -- Metamorphosis -- Prepared -- Blade Dance -- Blur -- Netherwalk -- Immolation Aura -- Glide -- Spectral Sight -- Darkness -- Chaos Brand -- Trail of Ruin -- Master of the Glaive -- Chaos Nova -- Torment -- Metamorphosis -- Nemesis -- Vengeful Retreat -- Dark Slash -- Fel Eruption -- Imprison -- Glide -- Chaos Nova -- Disrupt -- Throw Glaive -- Blade Dance -- Spectral Sight -- Metamorphosis -- Fel Rush -- Netherwalk -- Darkness -- Eye Beam -- Blur -- Vengeful Retreat -- Nemesis -- Death Sweep -- Fel Eruption -- Imprison -- Felblade -- Dark Slash -- Immolation Aura -- Fel Barrage -- Consume Magic -- Torment --Devour --Furious Gaze --Revolving Blades --Soulmonger --Thirsting Blades --Seething Power -- Reverse Magic -- Eye of Leotheras -- Eye of Leotheras -- Mana Rift -- Mana Break -- Mana Break -- Solitude -- Rain from Above -- Rain from Above -- Vengeance -- Metamorphosis -- Soul Barrier -- Feast of Souls -- Glide -- Soul Fragments -- Spectral Sight -- Demon Spikes -- Immolation Aura -- Fiery Brand -- Chaos Brand -- Sigil of Flame -- Void Reaver -- Sigil of Silence -- Sigil of Chains -- Fiery Brand -- Frailty -- Razor Spikes -- Sigil of Misery -- Torment -- Imprison -- Glide -- Immolation Aura -- Disrupt -- Torment -- Metamorphosis -- Spectral Sight -- Infernal Strike -- Sigil of Silence -- Sigil of Chains -- Sigil of Misery -- Demon Spikes -- Fiery Brand -- Throw Glaive -- Sigil of Flame -- Fel Devastation -- Imprison -- Soul Cleave -- Felblade -- Spirit Bomb -- Fracture -- Soul Barrier -- Consume Magic --Cycle of Binding --Devour --Hour of Reaping --Infernal Armor --Revel in Pain --Rigid Carapace --Seething Power --Soulmonger -- Demonic Trample -- Demonic Trample -- Everlasting Hunt -- Tormentor -- Tormentor -- Solitude -- Illidan's Grasp -- Illidan's Grasp -- Blood -- Dancing Rune Weapon -- Vampiric Blood -- Path of Frost -- Rune Tap -- Death's Advance -- Tombstone -- Death and Decay -- Hemostasis -- Anti-Magic Shell -- Crimson Scourge -- Bone Shield -- Bonestorm -- Voracious -- Unholy Strength -- Blood Shield -- Wraith Walk -- Icebound Fortitude -- Heart Strike -- Blooddrinker -- Asphyxiate -- Grip of the Dead -- Blood Plague -- Dark Command -- Death Grip -- Purgatory -- Path of Frost -- Death and Decay -- Mind Freeze -- Death's Advance -- Anti-Magic Shell -- Icebound Fortitude -- Dancing Rune Weapon -- Death Grip -- Blood Boil -- Death Gate -- Vampiric Blood -- Dark Command -- Raise Ally -- Gorefiend's Grasp -- Control Undead -- Rune Tap -- Bonestorm -- Marrowrend -- Death's Caress -- Heart Strike -- Blooddrinker -- Mark of Blood -- Rune Strike -- Wraith Walk -- Tombstone -- Asphyxiate -- Consumption -- Bloody Runeblade -- Bones of the Damned -- Eternal Rune Weapon -- Cold Hearted -- Death Chain -- Death Chain -- Blood for Blood -- Blood for Blood -- Murderous Intent -- Murderous Intent -- Strangulate -- Strangulate -- Walking Dead -- Necrotic Aura -- Decomposing Aura -- Anti-Magic Zone -- Anti-Magic Zone -- Dark Simulacrum -- Dark Simulacrum -- Dark Simulacrum -- Frost -- Path of Frost -- Frost Shield -- Breath of Sindragosa -- Rime -- Death's Advance -- Cold Heart -- Killing Machine -- Anti-Magic Shell -- Gathering Storm -- Pillar of Frost -- Wraith Walk -- Unholy Strength -- Remorseless Winter -- Empower Rune Weapon -- Icy Talons -- Icebound Fortitude -- Inexorable Assault -- Dark Succor -- Blinding Sleet -- Chains of Ice -- Razorice -- Dark Command -- Remorseless Winter -- Frost Fever -- Death Pact -- Path of Frost -- Chains of Ice -- Mind Freeze -- Empower Rune Weapon -- Anti-Magic Shell -- Death Pact -- Icebound Fortitude -- Obliterate -- Howling Blast -- Death Gate -- Pillar of Frost -- Dark Command -- Horn of Winter -- Raise Ally -- Control Undead -- Breath of Sindragosa -- Glacial Advance -- Remorseless Winter -- Blinding Sleet -- Frostscythe -- Wraith Walk -- Frostwyrm's Fury -- Icy Citadel -- Frostwhelp's Indignation -- Cadaverous Pallor -- Dark Simulacrum -- Dark Simulacrum -- Dark Simulacrum -- Anti-Magic Zone -- Anti-Magic Zone -- Necrotic Aura -- Dead of Winter -- Dead of Winter -- Heartstop Aura -- Lichborne -- Lichborne -- Transfusion -- Transfusion -- Deathchill -- Delirium -- Chill Streak -- Chill Streak -- Unholy -- Path of Frost -- Wraith Walk -- Anti-Magic Shell -- Unholy Strength -- Unholy Frenzy -- Death and Decay -- Unholy Blight -- Icebound Fortitude -- Army of the Dead -- Sudden Doom -- Death's Advance -- Runic Corruption -- Dark Transformation -- Dark Succor -- Chains of Ice -- Unholy Blight -- Gnaw -- Festering Wound -- Dark Command -- Outbreak -- Asphyxiate -- Grip of the Dead -- Soul Reaper -- Virulent Plague -- Path of Frost -- Army of the Dead -- Death and Decay -- Chains of Ice -- Raise Dead -- Claw -- Gnaw -- Huddle -- Mind Freeze -- Death Coil -- Death's Advance -- Anti-Magic Shell -- Death Pact -- Icebound Fortitude -- Summon Gargoyle -- Death Gate -- Scourge Strike -- Dark Command -- Raise Ally -- Dark Transformation -- Outbreak -- Festering Strike -- Asphyxiate -- Control Undead -- Unholy Blight -- Soul Reaper -- Defile -- Unholy Frenzy -- Clawing Shadows -- Wraith Walk -- Apocalypse -- Festering Doom -- Festermight -- Harrowing Decay -- Helchains -- Reanimation -- Transfusion -- Transfusion -- Dark Simulacrum -- Dark Simulacrum -- Dark Simulacrum -- Necromancer's Bargain -- Necrotic Aura -- Anti-Magic Zone -- Anti-Magic Zone -- Necrotic Strike -- Cadaverous Pallor -- Raise Abomination -- Lichborne -- Lichborne -- Decomposing Aura
else
  templates.class.WARRIOR = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 248622,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 197690,
          type = "buff",
          unit = "player",
          talent = 12
        }, {
          spell = 118038,
          type = "buff",
          unit = "player"
        }, {
          spell = 6673,
          type = "buff",
          unit = "player",
          forceOwnOnly = true,
          ownOnly = nil
        }, {
          spell = 107574,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 262228,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 32216,
          type = "buff",
          unit = "player",
          talent = 5
        }, {
          spell = 227847,
          type = "buff",
          unit = "player"
        }, {
          spell = 52437,
          type = "buff",
          unit = "player",
          talent = 2
        }, {
          spell = 18499,
          type = "buff",
          unit = "player"
        }, {
          spell = 202164,
          type = "buff",
          unit = "player",
          talent = 11
        }, {
          spell = 7384,
          type = "buff",
          unit = "player"
        }, {
          spell = 262232,
          type = "buff",
          unit = "player",
          talent = 1
        }, {
          spell = 97463,
          type = "buff",
          unit = "player"
        }, {
          spell = 260708,
          type = "buff",
          unit = "player"
        } },
        icon = 132333
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 115804,
          type = "debuff",
          unit = "target"
        }, {
          spell = 772,
          type = "debuff",
          unit = "target",
          talent = 9
        }, {
          spell = 208086,
          type = "debuff",
          unit = "target"
        }, {
          spell = 105771,
          type = "debuff",
          unit = "target"
        }, {
          spell = 5246,
          type = "debuff",
          unit = "target"
        }, {
          spell = 1715,
          type = "debuff",
          unit = "target"
        }, {
          spell = 355,
          type = "debuff",
          unit = "target"
        }, {
          spell = 262115,
          type = "debuff",
          unit = "target"
        }, {
          spell = 132169,
          type = "debuff",
          unit = "target",
          talent = 6
        } },
        icon = 132366
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 100,
          type = "ability",
          requiresTarget = true,
          talent = { 5, 6 }
        }, {
          spell = 100,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 100,
          type = "ability",
          charges = true,
          requiresTarget = true,
          talent = 4,
          titleSuffix = " (2 Charges)"
        }, {
          spell = 355,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 845,
          type = "ability",
          talent = 15
        }, {
          spell = 1464,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 1680,
          type = "ability"
        }, {
          spell = 1715,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 5246,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 6544,
          type = "ability"
        }, {
          spell = 6552,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 6673,
          type = "ability"
        }, {
          spell = 7384,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true,
          talent = { 19, 21 }
        }, {
          spell = 7384,
          type = "ability",
          charges = true,
          overlayGlow = true,
          requiresTarget = true,
          talent = 20,
          titleSuffix = " (2 Charges)"
        }, {
          spell = 12294,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 18499,
          type = "ability",
          buff = true
        }, {
          spell = 34428,
          type = "ability",
          usable = true,
          requiresTarget = true
        }, {
          spell = 57755,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 97462,
          type = "ability",
          buff = true
        }, {
          spell = 107570,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          talent = 6
        }, {
          spell = 107574,
          type = "ability",
          buff = true,
          talent = 17
        }, {
          spell = 118038,
          type = "ability",
          buff = true
        }, {
          spell = 152277,
          type = "ability",
          talent = 21
        }, {
          spell = 163201,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 167105,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 202168,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 212520,
          type = "ability",
          talent = 12
        }, {
          spell = 227847,
          type = "ability"
        }, {
          spell = 260643,
          type = "ability",
          requiresTarget = true,
          talent = 3
        }, {
          spell = 260708,
          type = "ability",
          buff = true
        }, {
          spell = 262161,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          talent = 14
        }, {
          spell = 262228,
          type = "ability",
          buff = true,
          talent = 18
        } },
        icon = 132355
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 280212,
          type = "buff",
          unit = "player"
        }, {
          spell = 280210,
          type = "buff",
          unit = "group"
        }, {
          spell = 278826,
          type = "buff",
          unit = "player"
        }, {
          spell = 288455,
          type = "buff",
          unit = "player"
        }, {
          spell = 273415,
          type = "buff",
          unit = "player"
        }, {
          spell = 275540,
          type = "buff",
          unit = "player"
        }, {
          spell = 288653,
          type = "debuff",
          unit = "target"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 236273,
          type = "ability",
          pvptalent = 5,
          titleSuffix = L["cooldown"]
        }, {
          spell = 236273,
          type = "debuff",
          unit = "target",
          pvptalent = 5,
          titleSuffix = L["debuff"]
        }, {
          spell = 216890,
          type = "ability",
          pvptalent = 6
        }, {
          spell = 236077,
          type = "ability",
          pvptalent = 9,
          titleSuffix = L["cooldown"]
        }, {
          spell = 236077,
          type = "debuff",
          unit = "target",
          pvptalent = 9,
          titleSuffix = L["debuff"]
        }, {
          spell = 236320,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 236321,
          type = "buff",
          unit = "player",
          pvptalent = 11,
          titleSuffix = L["buff"]
        }, {
          spell = 198817,
          type = "ability",
          pvptalent = 12,
          titleSuffix = L["cooldown"]
        }, {
          spell = 198817,
          type = "buff",
          unit = "player",
          pvptalent = 12,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\spell_misc_emotionangry"
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 262232,
          type = "buff",
          unit = "player",
          talent = 1
        }, {
          spell = 32216,
          type = "buff",
          unit = "player",
          talent = 5
        }, {
          spell = 215572,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 202539,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 18499,
          type = "buff",
          unit = "player"
        }, {
          spell = 1719,
          type = "buff",
          unit = "player"
        }, {
          spell = 46924,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 202164,
          type = "buff",
          unit = "player",
          talent = 11
        }, {
          spell = 85739,
          type = "buff",
          unit = "player"
        }, {
          spell = 280776,
          type = "buff",
          unit = "player",
          talent = 8
        }, {
          spell = 202225,
          type = "buff",
          unit = "player",
          talent = 10
        }, {
          spell = 184362,
          type = "buff",
          unit = "player"
        }, {
          spell = 184364,
          type = "buff",
          unit = "player"
        }, {
          spell = 6673,
          type = "buff",
          unit = "player",
          forceOwnOnly = true,
          ownOnly = nil
        }, {
          spell = 97463,
          type = "buff",
          unit = "player"
        } },
        icon = 136224
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 132169,
          type = "debuff",
          unit = "target",
          talent = 6
        }, {
          spell = 118000,
          type = "debuff",
          unit = "target",
          talent = 17
        }, {
          spell = 280773,
          type = "debuff",
          unit = "target",
          talent = 21
        }, {
          spell = 105771,
          type = "debuff",
          unit = "target"
        }, {
          spell = 355,
          type = "debuff",
          unit = "target"
        } },
        icon = 132154
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 100,
          type = "ability",
          requiresTarget = true,
          talent = { 5, 6 }
        }, {
          spell = 100,
          type = "ability",
          charges = true,
          requiresTarget = true,
          talent = 4
        }, {
          spell = 355,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 1719,
          type = "ability",
          buff = true
        }, {
          spell = 5246,
          type = "ability"
        }, {
          spell = 5308,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 6544,
          type = "ability"
        }, {
          spell = 6552,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 6673,
          type = "ability"
        }, {
          spell = 12323,
          type = "ability"
        }, {
          spell = 18499,
          type = "ability",
          buff = true
        }, {
          spell = 23881,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 46924,
          type = "ability",
          talent = 18
        }, {
          spell = 57755,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 85288,
          type = "ability",
          charges = true,
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 97462,
          type = "ability",
          buff = true
        }, {
          spell = 100130,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 107570,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          talent = 6
        }, {
          spell = 118000,
          type = "ability",
          talent = 17
        }, {
          spell = 184364,
          type = "ability",
          buff = true
        }, {
          spell = 184367,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 190411,
          type = "ability"
        }, {
          spell = 202168,
          type = "ability",
          requiresTarget = true,
          talent = 5
        }, {
          spell = 280772,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          talent = 21
        } },
        icon = 136012
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 280212,
          type = "buff",
          unit = "player"
        }, {
          spell = 280210,
          type = "buff",
          unit = "group"
        }, {
          spell = 288091,
          type = "buff",
          unit = "player"
        }, {
          spell = 278134,
          type = "buff",
          unit = "player"
        }, {
          spell = 275672,
          type = "buff",
          unit = "player"
        }, {
          spell = 288653,
          type = "debuff",
          unit = "target"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 280746,
          type = "buff",
          unit = "player",
          pvptalent = 5
        }, {
          spell = 213858,
          type = "buff",
          unit = "player",
          pvptalent = 6
        }, {
          spell = 199203,
          type = "buff",
          unit = "player",
          pvptalent = 7
        }, {
          spell = 199261,
          type = "ability",
          pvptalent = 9,
          titleSuffix = L["cooldown"]
        }, {
          spell = 199261,
          type = "buff",
          unit = "player",
          pvptalent = 9,
          titleSuffix = L["buff"]
        }, {
          spell = 236077,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 236077,
          type = "debuff",
          unit = "target",
          pvptalent = 11,
          titleSuffix = L["debuff"]
        }, {
          spell = 216890,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 216890,
          type = "buff",
          unit = "player",
          pvptalent = 13,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\spell_misc_emotionangry"
      }
    },
    [3] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 12975,
          type = "buff",
          unit = "player"
        }, {
          spell = 202164,
          type = "buff",
          unit = "player",
          talent = 5
        }, {
          spell = 18499,
          type = "buff",
          unit = "player"
        }, {
          spell = 202573,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 871,
          type = "buff",
          unit = "player"
        }, {
          spell = 227744,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 202574,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 6673,
          type = "buff",
          unit = "player",
          forceOwnOnly = true,
          ownOnly = nil
        }, {
          spell = 132404,
          type = "buff",
          unit = "player"
        }, {
          spell = 202602,
          type = "buff",
          unit = "player",
          talent = 1
        }, {
          spell = 97463,
          type = "buff",
          unit = "player"
        }, {
          spell = 190456,
          type = "buff",
          unit = "player"
        }, {
          spell = 23920,
          type = "buff",
          unit = "player"
        }, {
          spell = 107574,
          type = "buff",
          unit = "player"
        }, {
          spell = 147833,
          type = "buff",
          unit = "target"
        }, {
          spell = 223658,
          type = "buff",
          unit = "target",
          talent = 6
        }, {
          spell = 288653,
          type = "debuff",
          unit = "target"
        } },
        icon = 1377132
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 115767,
          type = "debuff",
          unit = "target"
        }, {
          spell = 1160,
          type = "debuff",
          unit = "target"
        }, {
          spell = 355,
          type = "debuff",
          unit = "target"
        }, {
          spell = 132169,
          type = "debuff",
          unit = "target",
          talent = 15
        }, {
          spell = 105771,
          type = "debuff",
          unit = "target"
        }, {
          spell = 5246,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6343,
          type = "debuff",
          unit = "target"
        }, {
          spell = 132168,
          type = "debuff",
          unit = "target"
        }, {
          spell = 275335,
          type = "debuff",
          unit = "target",
          talent = 2
        } },
        icon = 132090
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 23922,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 355,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 871,
          type = "ability",
          buff = true
        }, {
          spell = 1160,
          type = "ability",
          debuff = true
        }, {
          spell = 2565,
          type = "ability",
          charges = true,
          buff = true
        }, {
          spell = 5246,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 6343,
          type = "ability"
        }, {
          spell = 6544,
          type = "ability"
        }, {
          spell = 6552,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 6572,
          type = "ability",
          overlayGlow = true
        }, {
          spell = 6673,
          type = "ability"
        }, {
          spell = 12975,
          type = "ability",
          buff = true
        }, {
          spell = 18499,
          type = "ability",
          buff = true
        }, {
          spell = 20243,
          type = "ability",
          requiresTarget = true,
          talent = { 16, 17 }
        }, {
          spell = 23920,
          type = "ability",
          buff = true
        }, {
          spell = 23922,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 34428,
          type = "ability",
          usable = true,
          requiresTarget = true
        }, {
          spell = 46968,
          type = "ability"
        }, {
          spell = 57755,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 97462,
          type = "ability"
        }, {
          spell = 107570,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          talent = 15
        }, {
          spell = 107574,
          type = "ability",
          buff = true
        }, {
          spell = 118000,
          type = "ability",
          talent = 9
        }, {
          spell = 198304,
          type = "ability",
          charges = true,
          requiresTarget = true
        }, {
          spell = 202168,
          type = "ability",
          requiresTarget = true,
          talent = 3
        }, {
          spell = 228920,
          type = "ability",
          talent = 21
        } },
        icon = 134951
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 280212,
          type = "buff",
          unit = "player"
        }, {
          spell = 280210,
          type = "buff",
          unit = "group"
        }, {
          spell = 279194,
          type = "buff",
          unit = "player"
        }, {
          spell = 278124,
          type = "buff",
          unit = "player"
        }, {
          spell = 278999,
          type = "buff",
          unit = "player"
        }, {
          spell = 287379,
          type = "buff",
          unit = "player"
        }, {
          spell = 273445,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 213871,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["cooldown"]
        }, {
          spell = 213871,
          type = "buff",
          unit = "group",
          pvptalent = 6,
          titleSuffix = L["buff"]
        }, {
          spell = 198912,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 198912,
          type = "debuff",
          unit = "target",
          pvptalent = 8,
          titleSuffix = L["debuff"]
        }, {
          spell = 205800,
          type = "ability",
          pvptalent = 9,
          titleSuffix = L["cooldown"]
        }, {
          spell = 206891,
          type = "debuff",
          unit = "target",
          pvptalent = 9,
          titleSuffix = L["debuff"]
        }, {
          spell = 199085,
          type = "debuff",
          unit = "target",
          pvptalent = 10
        }, {
          spell = 206572,
          type = "ability",
          pvptalent = 11
        }, {
          spell = 236077,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 236077,
          type = "debuff",
          unit = "target",
          pvptalent = 13,
          titleSuffix = L["debuff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\spell_misc_emotionangry"
      }
    }
  }

  templates.class.PALADIN = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 1022,
          type = "buff",
          unit = "group"
        }, {
          spell = 53563,
          type = "buff",
          unit = "group"
        }, {
          spell = 6940,
          type = "buff",
          unit = "group"
        }, {
          spell = 31821,
          type = "buff",
          unit = "player"
        }, {
          spell = 183415,
          type = "buff",
          unit = "player",
          talent = 12
        }, {
          spell = 31884,
          type = "buff",
          unit = "player"
        }, {
          spell = 498,
          type = "buff",
          unit = "player"
        }, {
          spell = 210320,
          type = "buff",
          unit = "player",
          talent = 10
        }, {
          spell = 642,
          type = "buff",
          unit = "player"
        }, {
          spell = 200025,
          type = "buff",
          unit = "group",
          talent = 21
        }, {
          spell = 156910,
          type = "buff",
          unit = "group",
          talent = 20
        }, {
          spell = 54149,
          type = "buff",
          unit = "player"
        }, {
          spell = 105809,
          type = "buff",
          unit = "player"
        }, {
          spell = 216331,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 214202,
          type = "buff",
          unit = "player"
        }, {
          spell = 183416,
          type = "buff",
          unit = "player",
          talent = 11
        }, {
          spell = 1044,
          type = "buff",
          unit = "group"
        }, {
          spell = 221883,
          type = "buff",
          unit = "player"
        }, {
          spell = 223306,
          type = "buff",
          unit = "target",
          talent = 2
        } },
        icon = 135964
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 204242,
          type = "debuff",
          unit = "target"
        }, {
          spell = 105421,
          type = "debuff",
          unit = "target",
          talent = 9
        }, {
          spell = 853,
          type = "debuff",
          unit = "target"
        }, {
          spell = 214222,
          type = "debuff",
          unit = "target"
        }, {
          spell = 196941,
          type = "debuff",
          unit = "target",
          talent = 13
        }, {
          spell = 20066,
          type = "debuff",
          unit = "multi",
          talent = 8
        } },
        icon = 135952
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 498,
          type = "ability",
          buff = true
        }, {
          spell = 633,
          type = "ability"
        }, {
          spell = 642,
          type = "ability",
          buff = true
        }, {
          spell = 853,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 1022,
          type = "ability"
        }, {
          spell = 1044,
          type = "ability"
        }, {
          spell = 4987,
          type = "ability"
        }, {
          spell = 6940,
          type = "ability"
        }, {
          spell = 20066,
          type = "ability",
          requiresTarget = true,
          talent = 8
        }, {
          spell = 20473,
          type = "ability",
          overlayGlow = true
        }, {
          spell = 26573,
          type = "ability",
          totem = true
        }, {
          spell = 31821,
          type = "ability",
          buff = true
        }, {
          spell = 31884,
          type = "ability",
          buff = true,
          talent = { 16, 18 }
        }, {
          spell = 35395,
          type = "ability",
          charges = true,
          requiresTarget = true
        }, {
          spell = 85222,
          type = "ability",
          overlayGlow = true
        }, {
          spell = 105809,
          type = "ability",
          buff = true,
          talent = 15
        }, {
          spell = 114158,
          type = "ability",
          talent = 3
        }, {
          spell = 114165,
          type = "ability",
          talent = 14
        }, {
          spell = 115750,
          type = "ability",
          talent = 9
        }, {
          spell = 190784,
          type = "ability"
        }, {
          spell = 200025,
          type = "ability",
          talent = 21
        }, {
          spell = 214202,
          type = "ability",
          charges = true,
          buff = true
        }, {
          spell = 216331,
          type = "ability",
          buff = true,
          talent = 17
        }, {
          spell = 223306,
          type = "ability",
          talent = 2
        }, {
          spell = 275773,
          type = "ability",
          debuff = true,
          requiresTarget = true
        } },
        icon = 135972
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 275468,
          type = "buff",
          unit = "player"
        }, {
          spell = 280191,
          type = "buff",
          unit = "player"
        }, {
          spell = 278785,
          type = "buff",
          unit = "player"
        }, {
          spell = 287280,
          type = "buff",
          unit = "multi"
        }, {
          spell = 278145,
          type = "debuff",
          unit = "target"
        }, {
          spell = 274395,
          type = "buff",
          unit = "group"
        }, {
          spell = 287731,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 199507,
          type = "buff",
          unit = "group",
          pvptalent = 4
        }, {
          spell = 216328,
          type = "buff",
          unit = "target",
          pvptalent = 5
        }, {
          spell = 210294,
          type = "ability",
          pvptalent = 9,
          titleSuffix = L["cooldown"]
        }, {
          spell = 210294,
          type = "buff",
          unit = "player",
          pvptalent = 9,
          titleSuffix = L["buff"]
        }, {
          spell = 210391,
          type = "buff",
          unit = "player",
          pvptalent = 13
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_elemental_mote_mana"
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 203797,
          type = "buff",
          unit = "player",
          talent = 10
        }, {
          spell = 132403,
          type = "buff",
          unit = "player"
        }, {
          spell = 197561,
          type = "buff",
          unit = "player"
        }, {
          spell = 1044,
          type = "buff",
          unit = "group"
        }, {
          spell = 6940,
          type = "buff",
          unit = "group"
        }, {
          spell = 188370,
          type = "buff",
          unit = "player"
        }, {
          spell = 204150,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 31850,
          type = "buff",
          unit = "player"
        }, {
          spell = 31884,
          type = "buff",
          unit = "player"
        }, {
          spell = 204018,
          type = "buff",
          unit = "player",
          talent = 12
        }, {
          spell = 152262,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 86659,
          type = "buff",
          unit = "player"
        }, {
          spell = 1022,
          type = "buff",
          unit = "group"
        }, {
          spell = 221883,
          type = "buff",
          unit = "player"
        }, {
          spell = 204335,
          type = "buff",
          unit = "player"
        }, {
          spell = 642,
          type = "buff",
          unit = "player"
        }, {
          spell = 280375,
          type = "buff",
          unit = "player"
        } },
        icon = 236265
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 62124,
          type = "debuff",
          unit = "target"
        }, {
          spell = 204242,
          type = "debuff",
          unit = "target"
        }, {
          spell = 196941,
          type = "debuff",
          unit = "target",
          talent = 16
        }, {
          spell = 105421,
          type = "debuff",
          unit = "target",
          talent = 9
        }, {
          spell = 853,
          type = "debuff",
          unit = "target"
        }, {
          spell = 204301,
          type = "debuff",
          unit = "target"
        }, {
          spell = 204079,
          type = "debuff",
          unit = "target",
          talent = 13
        }, {
          spell = 31935,
          type = "debuff",
          unit = "target"
        }, {
          spell = 20066,
          type = "debuff",
          unit = "multi",
          talent = 8
        } },
        icon = 135952
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 633,
          type = "ability"
        }, {
          spell = 642,
          type = "ability",
          buff = true
        }, {
          spell = 853,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 1022,
          type = "ability",
          buff = true
        }, {
          spell = 1044,
          type = "ability",
          buff = true
        }, {
          spell = 6940,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          unit = "player"
        }, {
          spell = 20066,
          type = "ability",
          requiresTarget = true,
          talent = 8
        }, {
          spell = 26573,
          type = "ability",
          buff = true
        }, {
          spell = 31850,
          type = "ability",
          buff = true
        }, {
          spell = 31884,
          type = "ability",
          buff = true
        }, {
          spell = 31935,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 53595,
          type = "ability"
        }, {
          spell = 53600,
          type = "ability",
          charges = true,
          buff = true
        }, {
          spell = 62124,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 86659,
          type = "ability",
          buff = true
        }, {
          spell = 96231,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 115750,
          type = "ability",
          talent = 9
        }, {
          spell = 152262,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 184092,
          type = "ability"
        }, {
          spell = 190784,
          type = "ability"
        }, {
          spell = 204018,
          type = "ability",
          talent = 12
        }, {
          spell = 204019,
          type = "ability",
          charges = true,
          debuff = true
        }, {
          spell = 204035,
          type = "ability"
        }, {
          spell = 204150,
          type = "ability",
          buff = true
        }, {
          spell = 213644,
          type = "ability"
        }, {
          spell = 213652,
          type = "ability"
        }, {
          spell = 275779,
          type = "ability",
          debuff = true,
          requiresTarget = true
        } },
        icon = 135874
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 272979,
          type = "buff",
          unit = "player"
        }, {
          spell = 280191,
          type = "buff",
          unit = "player"
        }, {
          spell = 278785,
          type = "buff",
          unit = "group"
        }, {
          spell = 275481,
          type = "buff",
          unit = "player"
        }, {
          spell = 279397,
          type = "buff",
          unit = "player"
        }, {
          spell = 278574,
          type = "buff",
          unit = "player"
        }, {
          spell = 278954,
          type = "buff",
          unit = "player"
        }, {
          spell = 274395,
          type = "buff",
          unit = "group"
        }, {
          spell = 287731,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 228049,
          type = "ability",
          pvptalent = 5,
          titleSuffix = L["cooldown"]
        }, {
          spell = 228050,
          type = "buff",
          unit = "group",
          pvptalent = 5,
          titleSuffix = L["buff"]
        }, {
          spell = 216857,
          type = "buff",
          unit = "target",
          pvptalent = 6
        }, {
          spell = 236186,
          type = "ability",
          pvptalent = 9
        }, {
          spell = 215652,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 217824,
          type = "debuff",
          unit = "target",
          pvptalent = 11,
          titleSuffix = L["debuff"]
        }, {
          spell = 207028,
          type = "ability",
          pvptalent = 15,
          titleSuffix = L["cooldown"]
        }, {
          spell = 206891,
          type = "debuff",
          unit = "target",
          pvptalent = 15,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_elemental_mote_mana"
      }
    },
    [3] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 267611,
          type = "buff",
          unit = "player",
          talent = 2
        }, {
          spell = 205191,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 1022,
          type = "buff",
          unit = "group"
        }, {
          spell = 184662,
          type = "buff",
          unit = "player"
        }, {
          spell = 271581,
          type = "buff",
          unit = "player",
          talent = 10
        }, {
          spell = 84963,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 203538,
          type = "buff",
          unit = "group"
        }, {
          spell = 221883,
          type = "buff",
          unit = "player"
        }, {
          spell = 642,
          type = "buff",
          unit = "player"
        }, {
          spell = 203539,
          type = "buff",
          unit = "group"
        }, {
          spell = 114250,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 31884,
          type = "buff",
          unit = "player"
        }, {
          spell = 269571,
          type = "buff",
          unit = "player",
          talent = 1
        }, {
          spell = 281178,
          type = "buff",
          unit = "player",
          talent = 5
        }, {
          spell = 1044,
          type = "buff",
          unit = "group"
        }, {
          spell = 209785,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 223819,
          type = "buff",
          unit = "player",
          talent = 19
        }, {
          spell = 183436,
          type = "buff",
          unit = "player"
        } },
        icon = 135993
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 62124,
          type = "debuff",
          unit = "target"
        }, {
          spell = 197277,
          type = "debuff",
          unit = "target"
        }, {
          spell = 267799,
          type = "debuff",
          unit = "target",
          talent = 3
        }, {
          spell = 105421,
          type = "debuff",
          unit = "target"
        }, {
          spell = 853,
          type = "debuff",
          unit = "target"
        }, {
          spell = 183218,
          type = "debuff",
          unit = "target"
        }, {
          spell = 20066,
          type = "debuff",
          unit = "multi",
          talent = 8
        }, {
          spell = 255937,
          type = "debuff",
          unit = "target",
          talent = 12
        } },
        icon = 135952
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 633,
          type = "ability"
        }, {
          spell = 642,
          type = "ability",
          buff = true
        }, {
          spell = 853,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 1022,
          type = "ability",
          buff = true
        }, {
          spell = 1044,
          type = "ability",
          buff = true
        }, {
          spell = 20066,
          type = "ability",
          requiresTarget = true,
          talent = 8
        }, {
          spell = 20271,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 24275,
          type = "ability",
          talent = 6
        }, {
          spell = 31884,
          type = "ability",
          buff = true
        }, {
          spell = 35395,
          type = "ability",
          charges = true,
          requiresTarget = true
        }, {
          spell = 62124,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 96231,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 115750,
          type = "ability",
          talent = 9
        }, {
          spell = 183218,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 184575,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 184662,
          type = "ability",
          buff = true
        }, {
          spell = 190784,
          type = "ability"
        }, {
          spell = 205191,
          type = "ability",
          buff = true,
          talent = 15
        }, {
          spell = 205228,
          type = "ability",
          totem = true,
          talent = 11
        }, {
          spell = 210191,
          type = "ability",
          charges = true,
          talent = 18
        }, {
          spell = 213644,
          type = "ability"
        }, {
          spell = 215661,
          type = "ability",
          requiresTarget = true,
          talent = 17
        }, {
          spell = 255937,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          talent = 11
        }, {
          spell = 267798,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          talent = 3
        } },
        icon = 135891
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 272903,
          type = "buff",
          unit = "player"
        }, {
          spell = 286393,
          type = "buff",
          unit = "player"
        }, {
          spell = 273481,
          type = "buff",
          unit = "player"
        }, {
          spell = 280191,
          type = "buff",
          unit = "player"
        }, {
          spell = 278785,
          type = "buff",
          unit = "group"
        }, {
          spell = 279204,
          type = "buff",
          unit = "player"
        }, {
          spell = 286232,
          type = "buff",
          unit = "player"
        }, {
          spell = 274395,
          type = "buff",
          unit = "group"
        }, {
          spell = 287731,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 236186,
          type = "ability",
          pvptalent = 4
        }, {
          spell = 247675,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 247675,
          type = "buff",
          unit = "player",
          pvptalent = 8,
          titleSuffix = L["buff"]
        }, {
          spell = 210323,
          type = "buff",
          unit = "target",
          pvptalent = 9
        }, {
          spell = 210256,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 210256,
          type = "buff",
          unit = "target",
          pvptalent = 10,
          titleSuffix = L["buff"]
        }, {
          spell = 287947,
          type = "buff",
          unit = "player",
          pvptalent = 11
        }, {
          spell = 246807,
          type = "buff",
          unit = "target",
          pvptalent = 12
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\achievement_bg_winsoa"
      }
    }
  }

  templates.class.HUNTER = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 246851,
          type = "buff",
          unit = "player"
        }, {
          spell = 35079,
          type = "buff",
          unit = "player"
        }, {
          spell = 231390,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 186258,
          type = "buff",
          unit = "player"
        }, {
          spell = 264667,
          type = "buff",
          unit = "player"
        }, {
          spell = 257946,
          type = "buff",
          unit = "player"
        }, {
          spell = 19574,
          type = "buff",
          unit = "player"
        }, {
          spell = 268877,
          type = "buff",
          unit = "player"
        }, {
          spell = 264663,
          type = "buff",
          unit = "player"
        }, {
          spell = 118922,
          type = "buff",
          unit = "player",
          talent = 14
        }, {
          spell = 193530,
          type = "buff",
          unit = "player"
        }, {
          spell = 5384,
          type = "buff",
          unit = "player"
        }, {
          spell = 199483,
          type = "buff",
          unit = "player"
        }, {
          spell = 281036,
          type = "buff",
          unit = "player",
          talent = 3
        }, {
          spell = 186265,
          type = "buff",
          unit = "player"
        }, {
          spell = 6197,
          type = "buff",
          unit = "player"
        }, {
          spell = 246152,
          type = "buff",
          unit = "player"
        }, {
          spell = 24450,
          type = "buff",
          unit = "pet"
        }, {
          spell = 272790,
          type = "buff",
          unit = "pet"
        }, {
          spell = 136,
          type = "buff",
          unit = "pet"
        } },
        icon = 132242
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 135299,
          type = "debuff",
          unit = "target"
        }, {
          spell = 217200,
          type = "debuff",
          unit = "target"
        }, {
          spell = 117405,
          type = "debuff",
          unit = "target",
          talent = 15
        }, {
          spell = 3355,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 2649,
          type = "debuff",
          unit = "target"
        }, {
          spell = 24394,
          type = "debuff",
          unit = "target"
        }, {
          spell = 5116,
          type = "debuff",
          unit = "target"
        } },
        icon = 135860
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 781,
          type = "ability"
        }, {
          spell = 1543,
          type = "ability"
        }, {
          spell = 2649,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 5116,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 5384,
          type = "ability",
          buff = true
        }, {
          spell = 16827,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 19574,
          type = "ability",
          buff = true
        }, {
          spell = 19577,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 24450,
          type = "ability"
        }, {
          spell = 34026,
          type = "ability"
        }, {
          spell = 34477,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 53209,
          type = "ability",
          requiresTarget = true,
          talent = 6
        }, {
          spell = 109248,
          type = "ability",
          requiresTarget = true,
          talent = 15
        }, {
          spell = 109304,
          type = "ability"
        }, {
          spell = 120360,
          type = "ability",
          talent = 17
        }, {
          spell = 120679,
          type = "ability",
          requiresTarget = true,
          buff = true,
          talent = 3
        }, {
          spell = 131894,
          type = "ability",
          requiresTarget = true,
          talent = 12
        }, {
          spell = 147362,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 186257,
          type = "ability",
          buff = true
        }, {
          spell = 186265,
          type = "ability",
          buff = true
        }, {
          spell = 187650,
          type = "ability"
        }, {
          spell = 187698,
          type = "ability"
        }, {
          spell = 193530,
          type = "ability",
          buff = true
        }, {
          spell = 199483,
          type = "ability",
          talent = 9
        }, {
          spell = 201430,
          type = "ability",
          talent = 18
        }, {
          spell = 217200,
          type = "ability",
          charges = true,
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 264667,
          type = "ability",
          buff = true
        }, {
          spell = 264735,
          type = "ability",
          unit = "pet",
          buff = true
        }, {
          spell = 90361,
          type = "ability",
          unit = "pet",
          buff = true
        }, {
          spell = 58875,
          type = "ability",
          unit = "pet",
          buff = true
        }, {
          spell = 264265,
          type = "ability"
        } },
        icon = 135130
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 277916,
          type = "debuff",
          unit = "target"
        }, {
          spell = 274443,
          type = "buff",
          unit = "player"
        }, {
          spell = 280170,
          type = "buff",
          unit = "player"
        }, {
          spell = 269625,
          type = "buff",
          unit = "player"
        }, {
          spell = 273264,
          type = "buff",
          unit = "player"
        }, {
          spell = 279810,
          type = "buff",
          unit = "player"
        }, {
          spell = 263821,
          type = "buff",
          unit = "player"
        }, {
          spell = 264195,
          type = "buff",
          unit = "player"
        }, {
          spell = 274357,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 204205,
          type = "buff",
          unit = "player",
          pvptalent = 4
        }, {
          spell = 208652,
          type = "ability",
          pvptalent = 5
        }, {
          spell = 205691,
          type = "ability",
          pvptalent = 6
        }, {
          spell = 248518,
          type = "ability",
          pvptalent = 7,
          titleSuffix = L["cooldown"]
        }, {
          spell = 248519,
          type = "buff",
          unit = "group",
          pvptalent = 7,
          titleSuffix = L["buff"]
        }, {
          spell = 53480,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 53480,
          type = "buff",
          unit = "group",
          pvptalent = 10,
          titleSuffix = L["buff"]
        }, {
          spell = 236776,
          type = "ability",
          pvptalent = 11
        }, {
          spell = 202900,
          type = "ability",
          pvptalent = 12,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202900,
          type = "debuff",
          unit = "target",
          pvptalent = 12,
          titleSuffix = L["debuff"]
        }, {
          spell = 202914,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202914,
          type = "debuff",
          unit = "target",
          pvptalent = 13,
          titleSuffix = L["debuff"]
        }, {
          spell = 202797,
          type = "ability",
          pvptalent = 14,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202797,
          type = "debuff",
          unit = "target",
          pvptalent = 14,
          titleSuffix = L["debuff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\ability_hunter_focusfire"
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 35079,
          type = "buff",
          unit = "player"
        }, {
          spell = 231390,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 186258,
          type = "buff",
          unit = "player"
        }, {
          spell = 264667,
          type = "buff",
          unit = "player"
        }, {
          spell = 260395,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 194594,
          type = "buff",
          unit = "player",
          talent = 20
        }, {
          spell = 257044,
          type = "buff",
          unit = "player"
        }, {
          spell = 164273,
          type = "buff",
          unit = "player"
        }, {
          spell = 6197,
          type = "buff",
          unit = "player"
        }, {
          spell = 257622,
          type = "buff",
          unit = "player"
        }, {
          spell = 193526,
          type = "buff",
          unit = "player"
        }, {
          spell = 260242,
          type = "buff",
          unit = "player"
        }, {
          spell = 5384,
          type = "buff",
          unit = "player"
        }, {
          spell = 260402,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 118922,
          type = "buff",
          unit = "player",
          talent = 14
        }, {
          spell = 186265,
          type = "buff",
          unit = "player"
        }, {
          spell = 193534,
          type = "buff",
          unit = "player",
          talent = 10
        }, {
          spell = 264663,
          type = "buff",
          unit = "player"
        }, {
          spell = 199483,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 24450,
          type = "buff",
          unit = "pet"
        }, {
          spell = 136,
          type = "buff",
          unit = "pet"
        }, {
          spell = 264735,
          type = "ability",
          unit = "pet",
          buff = true
        } },
        icon = 461846
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 135299,
          type = "debuff",
          unit = "target"
        }, {
          spell = 5116,
          type = "debuff",
          unit = "target"
        }, {
          spell = 186387,
          type = "debuff",
          unit = "target"
        }, {
          spell = 3355,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 271788,
          type = "debuff",
          unit = "target"
        }, {
          spell = 257284,
          type = "debuff",
          unit = "target",
          talent = 12
        }, {
          spell = 131894,
          type = "debuff",
          unit = "target",
          talent = 3
        } },
        icon = 236188
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 781,
          type = "ability"
        }, {
          spell = 1543,
          type = "ability"
        }, {
          spell = 5116,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 5384,
          type = "ability",
          buff = true
        }, {
          spell = 19434,
          type = "ability",
          requiresTarget = true,
          charges = true,
          overlayGlow = true
        }, {
          spell = 34477,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 109248,
          type = "ability",
          requiresTarget = true,
          talent = 15
        }, {
          spell = 109304,
          type = "ability"
        }, {
          spell = 120360,
          type = "ability",
          talent = 17
        }, {
          spell = 131894,
          type = "ability",
          talent = 3
        }, {
          spell = 147362,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 185358,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 186257,
          type = "ability",
          buff = true
        }, {
          spell = 186265,
          type = "ability",
          buff = true
        }, {
          spell = 186387,
          type = "ability"
        }, {
          spell = 187650,
          type = "ability"
        }, {
          spell = 187698,
          type = "ability"
        }, {
          spell = 193526,
          type = "ability",
          buff = true
        }, {
          spell = 198670,
          type = "ability",
          talent = 21
        }, {
          spell = 199483,
          type = "ability",
          talent = 9
        }, {
          spell = 212431,
          type = "ability",
          talent = 6
        }, {
          spell = 257044,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 257620,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 260402,
          type = "ability",
          buff = true,
          talent = 18
        }, {
          spell = 264667,
          type = "ability",
          buff = true
        }, {
          spell = 264735,
          type = "ability",
          unit = "pet",
          buff = true
        } },
        icon = 132329
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 263814,
          type = "buff",
          unit = "player"
        }, {
          spell = 280170,
          type = "buff",
          unit = "player"
        }, {
          spell = 272733,
          type = "buff",
          unit = "player"
        }, {
          spell = 263821,
          type = "buff",
          unit = "player"
        }, {
          spell = 274357,
          type = "buff",
          unit = "player"
        }, {
          spell = 277959,
          type = "debuff",
          unit = "target"
        }, {
          spell = 274447,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 202797,
          type = "ability",
          pvptalent = 5,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202797,
          type = "debuff",
          unit = "target",
          pvptalent = 5,
          titleSuffix = L["debuff"]
        }, {
          spell = 202900,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202900,
          type = "debuff",
          unit = "target",
          pvptalent = 6,
          titleSuffix = L["debuff"]
        }, {
          spell = 202914,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202914,
          type = "debuff",
          unit = "target",
          pvptalent = 8,
          titleSuffix = L["debuff"]
        }, {
          spell = 53480,
          type = "ability",
          pvptalent = 9,
          titleSuffix = L["cooldown"]
        }, {
          spell = 53480,
          type = "buff",
          unit = "group",
          pvptalent = 9,
          titleSuffix = L["buff"]
        }, {
          spell = 203155,
          type = "ability",
          pvptalent = 12,
          titleSuffix = L["cooldown"]
        }, {
          spell = 203155,
          type = "buff",
          unit = "player",
          pvptalent = 12,
          titleSuffix = L["buff"]
        }, {
          spell = 213691,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 213691,
          type = "debuff",
          unit = "target",
          pvptalent = 13,
          titleSuffix = L["debuff"]
        }, {
          spell = 236776,
          type = "ability",
          pvptalent = 15
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\ability_hunter_focusfire"
      }
    },
    [3] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 199483,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 35079,
          type = "buff",
          unit = "player"
        }, {
          spell = 231390,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 186258,
          type = "buff",
          unit = "player"
        }, {
          spell = 264667,
          type = "buff",
          unit = "player"
        }, {
          spell = 259388,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 225788,
          type = "buff",
          unit = "player"
        }, {
          spell = 268552,
          type = "buff",
          unit = "player",
          talent = 1
        }, {
          spell = 260249,
          type = "buff",
          unit = "player"
        }, {
          spell = 6197,
          type = "buff",
          unit = "player"
        }, {
          spell = 264663,
          type = "buff",
          unit = "player"
        }, {
          spell = 266779,
          type = "buff",
          unit = "player"
        }, {
          spell = 5384,
          type = "buff",
          unit = "player"
        }, {
          spell = 260286,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 186265,
          type = "buff",
          unit = "player"
        }, {
          spell = 118922,
          type = "buff",
          unit = "player",
          talent = 14
        }, {
          spell = 265898,
          type = "buff",
          unit = "player",
          talent = 2
        }, {
          spell = 186289,
          type = "buff",
          unit = "player"
        }, {
          spell = 264663,
          type = "buff",
          unit = "pet"
        }, {
          spell = 266779,
          type = "buff",
          unit = "pet"
        }, {
          spell = 263892,
          type = "buff",
          unit = "pet"
        }, {
          spell = 61684,
          type = "buff",
          unit = "pet"
        }, {
          spell = 136,
          type = "buff",
          unit = "pet"
        }, {
          spell = 260249,
          type = "buff",
          unit = "pet"
        }, {
          spell = 24450,
          type = "buff",
          unit = "pet"
        } },
        icon = 1376044
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 270339,
          type = "debuff",
          unit = "target",
          talent = 20
        }, {
          spell = 270332,
          type = "debuff",
          unit = "target",
          talent = 20
        }, {
          spell = 24394,
          type = "debuff",
          unit = "target"
        }, {
          spell = 135299,
          type = "debuff",
          unit = "target"
        }, {
          spell = 270343,
          type = "debuff",
          unit = "target"
        }, {
          spell = 195645,
          type = "debuff",
          unit = "target"
        }, {
          spell = 269747,
          type = "debuff",
          unit = "target"
        }, {
          spell = 162487,
          type = "debuff",
          unit = "target",
          talent = 11
        }, {
          spell = 131894,
          type = "debuff",
          unit = "target",
          talent = 12
        }, {
          spell = 259277,
          type = "debuff",
          unit = "target",
          talent = 10
        }, {
          spell = 190927,
          type = "debuff",
          unit = "target"
        }, {
          spell = 162480,
          type = "debuff",
          unit = "target"
        }, {
          spell = 2649,
          type = "debuff",
          unit = "target"
        }, {
          spell = 3355,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 259491,
          type = "debuff",
          unit = "target"
        }, {
          spell = 271049,
          type = "debuff",
          unit = "target"
        }, {
          spell = 117405,
          type = "debuff",
          unit = "target",
          talent = 15
        } },
        icon = 132309
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 781,
          type = "ability"
        }, {
          spell = 1543,
          type = "ability"
        }, {
          spell = 2649,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 5384,
          type = "ability",
          buff = true
        }, {
          spell = 16827,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 19434,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 19577,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 24450,
          type = "ability"
        }, {
          spell = 34477,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 61684,
          type = "ability"
        }, {
          spell = 109248,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 109304,
          type = "ability"
        }, {
          spell = 131894,
          type = "ability",
          talent = 12
        }, {
          spell = 162488,
          type = "ability",
          talent = 11
        }, {
          spell = 186257,
          type = "ability",
          buff = true
        }, {
          spell = 186265,
          type = "ability",
          buff = true
        }, {
          spell = 186289,
          type = "ability",
          buff = true
        }, {
          spell = 187650,
          type = "ability"
        }, {
          spell = 187698,
          type = "ability"
        }, {
          spell = 187707,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 187708,
          type = "ability"
        }, {
          spell = 190925,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 199483,
          type = "ability",
          talent = 9
        }, {
          spell = 212436,
          type = "ability",
          charges = true,
          talent = 6
        }, {
          spell = 259391,
          type = "ability",
          requiresTarget = true,
          talent = 21
        }, {
          spell = 259489,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 259491,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 259495,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 263892,
          type = "ability"
        }, {
          spell = 264667,
          type = "ability",
          buff = true
        }, {
          spell = 266779,
          type = "ability",
          buff = true
        }, {
          spell = 269751,
          type = "ability",
          requiresTarget = true,
          talent = 18
        }, {
          spell = 270323,
          type = "ability",
          talent = 20
        }, {
          spell = 270335,
          type = "ability",
          talent = 20
        }, {
          spell = 271045,
          type = "ability",
          talent = 20
        }, {
          spell = 272678,
          type = "ability",
          buff = true
        } },
        icon = 236184
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 277969,
          type = "buff",
          unit = "player"
        }, {
          spell = 280170,
          type = "buff",
          unit = "player"
        }, {
          spell = 273286,
          type = "buff",
          unit = "player"
        }, {
          spell = 263821,
          type = "buff",
          unit = "player"
        }, {
          spell = 274357,
          type = "buff",
          unit = "player"
        }, {
          spell = 288573,
          type = "buff",
          unit = "player"
        }, {
          spell = 263818,
          type = "buff",
          unit = "player"
        }, {
          spell = 264199,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 202914,
          type = "ability",
          pvptalent = 5,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202914,
          type = "debuff",
          unit = "target",
          pvptalent = 5,
          titleSuffix = L["debuff"]
        }, {
          spell = 202900,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202900,
          type = "debuff",
          unit = "target",
          pvptalent = 6,
          titleSuffix = L["debuff"]
        }, {
          spell = 212638,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 212638,
          type = "debuff",
          unit = "target",
          pvptalent = 8,
          titleSuffix = L["debuff"]
        }, {
          spell = 202797,
          type = "ability",
          pvptalent = 9,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202797,
          type = "debuff",
          unit = "target",
          pvptalent = 9,
          titleSuffix = L["debuff"]
        }, {
          spell = 212640,
          type = "ability",
          pvptalent = 11
        }, {
          spell = 53480,
          type = "ability",
          pvptalent = 12,
          titleSuffix = L["cooldown"]
        }, {
          spell = 53480,
          type = "buff",
          unit = "group",
          pvptalent = 12,
          titleSuffix = L["buff"]
        }, {
          spell = 203268,
          type = "debuff",
          unit = "target",
          pvptalent = 13
        }, {
          spell = 236776,
          type = "ability",
          pvptalent = 15
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\ability_hunter_focusfire"
      }
    }
  }

  templates.class.ROGUE = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 121153,
          type = "buff",
          unit = "player"
        }, {
          spell = 5277,
          type = "buff",
          unit = "player"
        }, {
          spell = 8679,
          type = "buff",
          unit = "player"
        }, {
          spell = 57934,
          type = "buff",
          unit = "player"
        }, {
          spell = 108211,
          type = "buff",
          unit = "player",
          talent = 10
        }, {
          spell = 2823,
          type = "buff",
          unit = "player"
        }, {
          spell = 193641,
          type = "buff",
          unit = "player",
          talent = 2
        }, {
          spell = 115192,
          type = "buff",
          unit = "player",
          talent = 5
        }, {
          spell = 114018,
          type = "buff",
          unit = "player"
        }, {
          spell = 32645,
          type = "buff",
          unit = "player"
        }, {
          spell = 36554,
          type = "buff",
          unit = "player"
        }, {
          spell = 185311,
          type = "buff",
          unit = "player"
        }, {
          spell = 270070,
          type = "buff",
          unit = "player",
          talent = 20
        }, {
          spell = 256735,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 1966,
          type = "buff",
          unit = "player"
        }, {
          spell = 1784,
          type = "buff",
          unit = "player"
        }, {
          spell = 31224,
          type = "buff",
          unit = "player"
        }, {
          spell = 11327,
          type = "buff",
          unit = "player"
        }, {
          spell = 3408,
          type = "buff",
          unit = "player"
        }, {
          spell = 2983,
          type = "buff",
          unit = "player"
        }, {
          spell = 45182,
          type = "buff",
          unit = "player",
          talent = 11
        } },
        icon = 132290
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 137619,
          type = "debuff",
          unit = "target",
          talent = 9
        }, {
          spell = 1330,
          type = "debuff",
          unit = "target"
        }, {
          spell = 256148,
          type = "debuff",
          unit = "target",
          talent = 14
        }, {
          spell = 154953,
          type = "debuff",
          unit = "target",
          talent = 13
        }, {
          spell = 1833,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6770,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 255909,
          type = "debuff",
          unit = "target",
          talent = 15
        }, {
          spell = 703,
          type = "debuff",
          unit = "target"
        }, {
          spell = 245389,
          type = "debuff",
          unit = "target",
          talent = 17
        }, {
          spell = 2818,
          type = "debuff",
          unit = "target"
        }, {
          spell = 3409,
          type = "debuff",
          unit = "target"
        }, {
          spell = 2094,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 408,
          type = "debuff",
          unit = "target"
        }, {
          spell = 121411,
          type = "debuff",
          unit = "target",
          talent = 21
        }, {
          spell = 79140,
          type = "debuff",
          unit = "target"
        }, {
          spell = 1943,
          type = "debuff",
          unit = "target"
        }, {
          spell = 8680,
          type = "debuff",
          unit = "target"
        }, {
          spell = 45181,
          type = "debuff",
          unit = "player",
          talent = 11
        } },
        icon = 132302
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 408,
          type = "ability",
          requiresTarget = true,
          usable = true,
          debuff = true
        }, {
          spell = 703,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 1725,
          type = "ability"
        }, {
          spell = 1752,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 1766,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 1784,
          type = "ability",
          buff = true
        }, {
          spell = 1833,
          type = "ability",
          usable = true,
          requiresTarget = true,
          debuff = true
        }, {
          spell = 1856,
          type = "ability",
          buff = true
        }, {
          spell = 1943,
          type = "ability",
          requiresTarget = true,
          usable = true,
          debuff = true
        }, {
          spell = 1966,
          type = "ability",
          buff = true
        }, {
          spell = 2094,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 2983,
          type = "ability",
          buff = true
        }, {
          spell = 51723,
          type = "ability"
        }, {
          spell = 57934,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 6770,
          type = "ability",
          usable = true,
          requiresTarget = true,
          debuff = true
        }, {
          spell = 5277,
          type = "ability",
          buff = true
        }, {
          spell = 31224,
          type = "ability",
          buff = true
        }, {
          spell = 36554,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 79140,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 114018,
          type = "ability",
          usable = true,
          buff = true
        }, {
          spell = 115191,
          type = "ability",
          buff = true
        }, {
          spell = 137619,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 9
        }, {
          spell = 185311,
          type = "ability",
          buff = true
        }, {
          spell = 196819,
          type = "ability",
          requiresTarget = true,
          usable = true,
          debuff = true
        }, {
          spell = 200806,
          type = "ability",
          requiresTarget = true,
          usable = true,
          talent = 18
        }, {
          spell = 245388,
          type = "ability",
          requiresTarget = true,
          talent = 17
        }, {
          spell = 57934,
          type = "ability",
          requiresTarget = true,
          debuff = true
        } },
        icon = 132350
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 274695,
          type = "buff",
          unit = "group"
        }, {
          spell = 280200,
          type = "buff",
          unit = "player"
        }, {
          spell = 286581,
          type = "debuff",
          unit = "target"
        }, {
          spell = 277731,
          type = "buff",
          unit = "player"
        }, {
          spell = 279703,
          type = "buff",
          unit = "player"
        }, {
          spell = 288158,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 269513,
          type = "ability",
          pvptalent = 4
        }, {
          spell = 197003,
          type = "buff",
          unit = "target",
          pvptalent = 5
        }, {
          spell = 248744,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["cooldown"]
        }, {
          spell = 248744,
          type = "debuff",
          unit = "target",
          pvptalent = 6,
          titleSuffix = L["debuff"]
        }, {
          spell = 197051,
          type = "debuff",
          unit = "target",
          pvptalent = 8
        }, {
          spell = 198222,
          type = "debuff",
          unit = "target",
          pvptalent = 9
        }, {
          spell = 206328,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 197091,
          type = "debuff",
          unit = "target",
          pvptalent = 10,
          titleSuffix = L["debuff"]
        }, {
          spell = 198097,
          type = "debuff",
          unit = "target",
          pvptalent = 13
        }, {
          spell = 212182,
          type = "ability",
          pvptalent = 14,
          titleSuffix = L["cooldown"]
        }, {
          spell = 212183,
          type = "debuff",
          unit = "player",
          pvptalent = 14,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01"
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 193357,
          type = "buff",
          unit = "player"
        }, {
          spell = 199600,
          type = "buff",
          unit = "player"
        }, {
          spell = 193358,
          type = "buff",
          unit = "player"
        }, {
          spell = 51690,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 114018,
          type = "buff",
          unit = "player"
        }, {
          spell = 271896,
          type = "buff",
          unit = "player",
          talent = 20
        }, {
          spell = 5171,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 13750,
          type = "buff",
          unit = "player"
        }, {
          spell = 193359,
          type = "buff",
          unit = "player"
        }, {
          spell = 199603,
          type = "buff",
          unit = "player"
        }, {
          spell = 199754,
          type = "buff",
          unit = "player"
        }, {
          spell = 185311,
          type = "buff",
          unit = "player"
        }, {
          spell = 2983,
          type = "buff",
          unit = "player"
        }, {
          spell = 1966,
          type = "buff",
          unit = "player"
        }, {
          spell = 193538,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 1784,
          type = "buff",
          unit = "player"
        }, {
          spell = 31224,
          type = "buff",
          unit = "player"
        }, {
          spell = 195627,
          type = "buff",
          unit = "player"
        }, {
          spell = 11327,
          type = "buff",
          unit = "player"
        }, {
          spell = 13877,
          type = "buff",
          unit = "player"
        }, {
          spell = 193356,
          type = "buff",
          unit = "player"
        }, {
          spell = 57934,
          type = "buff",
          unit = "player"
        }, {
          spell = 45182,
          type = "buff",
          unit = "player",
          talent = 11
        } },
        icon = 132350
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 255909,
          type = "debuff",
          unit = "target",
          talent = 15
        }, {
          spell = 199804,
          type = "debuff",
          unit = "target"
        }, {
          spell = 185763,
          type = "debuff",
          unit = "target"
        }, {
          spell = 1833,
          type = "debuff",
          unit = "target"
        }, {
          spell = 196937,
          type = "debuff",
          unit = "target",
          talent = 3
        }, {
          spell = 137619,
          type = "debuff",
          unit = "target",
          talent = 9
        }, {
          spell = 2094,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 1776,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6770,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 45181,
          type = "debuff",
          unit = "player",
          talent = 11
        } },
        icon = 1373908
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 1725,
          type = "ability"
        }, {
          spell = 1752,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 1766,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 1776,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 1784,
          type = "ability",
          buff = true
        }, {
          spell = 1856,
          type = "ability",
          buff = true
        }, {
          spell = 1966,
          type = "ability",
          buff = true
        }, {
          spell = 2094,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 2098,
          type = "ability",
          requiresTarget = true,
          usable = true
        }, {
          spell = 2983,
          type = "ability",
          buff = true
        }, {
          spell = 8676,
          type = "ability",
          requiresTarget = true,
          usable = true
        }, {
          spell = 13750,
          type = "ability",
          buff = true
        }, {
          spell = 13877,
          type = "ability",
          buff = true,
          charges = true
        }, {
          spell = 31224,
          type = "ability",
          buff = true
        }, {
          spell = 51690,
          type = "ability",
          requiresTarget = true,
          talent = 21
        }, {
          spell = 57934,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 79096,
          type = "ability"
        }, {
          spell = 114018,
          type = "ability",
          usable = true,
          buff = true
        }, {
          spell = 137619,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 9
        }, {
          spell = 185311,
          type = "ability",
          buff = true
        }, {
          spell = 185763,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 193316,
          type = "ability",
          requiresTarget = true,
          usable = true
        }, {
          spell = 195457,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 196937,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 3
        }, {
          spell = 199754,
          type = "ability",
          buff = true
        }, {
          spell = 199804,
          type = "ability",
          usable = true,
          requiresTarget = true
        }, {
          spell = 271877,
          type = "ability",
          buff = true,
          talent = 20
        }, {
          spell = 57934,
          type = "ability",
          requiresTarget = true,
          debuff = true
        } },
        icon = 135610
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 277725,
          type = "buff",
          unit = "player"
        }, {
          spell = 272940,
          type = "buff",
          unit = "player"
        }, {
          spell = 274695,
          type = "buff",
          unit = "group"
        }, {
          spell = 278962,
          type = "buff",
          unit = "player"
        }, {
          spell = 280200,
          type = "buff",
          unit = "player"
        }, {
          spell = 275863,
          type = "buff",
          unit = "player"
        }, {
          spell = 288988,
          type = "buff",
          unit = "player"
        }, {
          spell = 288158,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 207777,
          type = "ability",
          pvptalent = 4,
          titleSuffix = L["cooldown"]
        }, {
          spell = 207777,
          type = "debuff",
          unit = "target",
          pvptalent = 4,
          titleSuffix = L["debuff"]
        }, {
          spell = 198368,
          type = "buff",
          unit = "player",
          pvptalent = 5
        }, {
          spell = 212210,
          type = "ability",
          pvptalent = 6
        }, {
          spell = 269513,
          type = "ability",
          pvptalent = 7
        }, {
          spell = 197003,
          type = "buff",
          unit = "target",
          pvptalent = 8
        }, {
          spell = 209754,
          type = "buff",
          unit = "player",
          pvptalent = 9
        }, {
          spell = 212182,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 212183,
          type = "debuff",
          unit = "player",
          pvptalent = 10,
          titleSuffix = L["buff"]
        }, {
          spell = 198027,
          type = "buff",
          unit = "player",
          pvptalent = 12
        }, {
          spell = 198529,
          type = "ability",
          pvptalent = 14,
          titleSuffix = L["cooldown"]
        }, {
          spell = 198529,
          type = "buff",
          unit = "player",
          pvptalent = 14,
          titleSuffix = L["debuff"]
        }, {
          spell = 248744,
          type = "debuff",
          unit = "target",
          pvptalent = 15
        }, {
          spell = 213995,
          type = "buff",
          unit = "player",
          pvptalent = 16,
          titleSuffix = L["buff"]
        }, {
          spell = 212150,
          type = "debuff",
          unit = "target",
          pvptalent = 16,
          titleSuffix = L["debuff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01"
      }
    },
    [3] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 196980,
          type = "buff",
          unit = "player",
          talent = 19
        }, {
          spell = 5277,
          type = "buff",
          unit = "player"
        }, {
          spell = 121471,
          type = "buff",
          unit = "player"
        }, {
          spell = 212283,
          type = "buff",
          unit = "player"
        }, {
          spell = 185422,
          type = "buff",
          unit = "player"
        }, {
          spell = 115192,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 114018,
          type = "buff",
          unit = "player"
        }, {
          spell = 257506,
          type = "buff",
          unit = "player"
        }, {
          spell = 185311,
          type = "buff",
          unit = "player"
        }, {
          spell = 277925,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 1966,
          type = "buff",
          unit = "player"
        }, {
          spell = 193538,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 1784,
          type = "buff",
          unit = "player"
        }, {
          spell = 31224,
          type = "buff",
          unit = "player"
        }, {
          spell = 115191,
          type = "buff",
          unit = "player"
        }, {
          spell = 11327,
          type = "buff",
          unit = "player"
        }, {
          spell = 245640,
          type = "buff",
          unit = "player"
        }, {
          spell = 2983,
          type = "buff",
          unit = "player"
        }, {
          spell = 57934,
          type = "buff",
          unit = "player"
        }, {
          spell = 45182,
          type = "buff",
          unit = "player",
          talent = 11
        } },
        icon = 376022
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 255909,
          type = "debuff",
          unit = "target",
          talent = 15
        }, {
          spell = 91021,
          type = "debuff",
          unit = "target",
          talent = 2
        }, {
          spell = 195452,
          type = "debuff",
          unit = "target"
        }, {
          spell = 2094,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 137619,
          type = "debuff",
          unit = "target"
        }, {
          spell = 1833,
          type = "debuff",
          unit = "target"
        }, {
          spell = 206760,
          type = "debuff",
          unit = "target",
          talent = 14
        }, {
          spell = 408,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6770,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 45181,
          type = "debuff",
          unit = "player",
          talent = 11
        } },
        icon = 136175
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 53,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 408,
          type = "ability",
          requiresTarget = true,
          usable = true,
          debuff = true
        }, {
          spell = 1725,
          type = "ability"
        }, {
          spell = 1752,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 1766,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 1784,
          type = "ability",
          buff = true
        }, {
          spell = 1833,
          type = "ability",
          usable = true,
          requiresTarget = true,
          debuff = true
        }, {
          spell = 1856,
          type = "ability",
          buff = true
        }, {
          spell = 1966,
          type = "ability",
          buff = true
        }, {
          spell = 2094,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 2983,
          type = "ability",
          buff = true
        }, {
          spell = 5277,
          type = "ability",
          buff = true
        }, {
          spell = 57934,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 6770,
          type = "ability",
          requiresTarget = true,
          usable = true,
          debuff = true
        }, {
          spell = 31224,
          type = "ability",
          buff = true
        }, {
          spell = 36554,
          type = "ability",
          charges = true,
          requiresTarget = true
        }, {
          spell = 114014,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 114018,
          type = "ability",
          usable = true,
          buff = true
        }, {
          spell = 115191,
          type = "ability",
          buff = true
        }, {
          spell = 121471,
          type = "ability",
          buff = true
        }, {
          spell = 137619,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 9
        }, {
          spell = 185311,
          type = "ability",
          buff = true
        }, {
          spell = 185313,
          type = "ability",
          charges = true,
          buff = true
        }, {
          spell = 185438,
          type = "ability",
          requiresTarget = true,
          usable = true
        }, {
          spell = 195452,
          type = "ability",
          usable = true,
          requiresTarget = true,
          debuff = true
        }, {
          spell = 196819,
          type = "ability",
          usable = true,
          requiresTarget = true
        }, {
          spell = 197835,
          type = "ability"
        }, {
          spell = 212283,
          type = "ability",
          buff = true
        }, {
          spell = 277925,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 280719,
          type = "ability",
          requiresTarget = true,
          usable = true,
          debuff = true,
          talent = 20
        }, {
          spell = 57934,
          type = "ability",
          requiresTarget = true,
          debuff = true
        } },
        icon = 236279
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 279754,
          type = "buff",
          unit = "player"
        }, {
          spell = 272940,
          type = "buff",
          unit = "player"
        }, {
          spell = 273424,
          type = "buff",
          unit = "player"
        }, {
          spell = 277720,
          type = "buff",
          unit = "player"
        }, {
          spell = 280200,
          type = "buff",
          unit = "player"
        }, {
          spell = 278981,
          type = "buff",
          unit = "player"
        }, {
          spell = 288158,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 198688,
          type = "debuff",
          unit = "target",
          pvptalent = 5
        }, {
          spell = 212182,
          type = "ability",
          pvptalent = 7,
          titleSuffix = L["cooldown"]
        }, {
          spell = 212183,
          type = "debuff",
          unit = "player",
          pvptalent = 7,
          titleSuffix = L["buff"]
        }, {
          spell = 207736,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 207736,
          type = "buff",
          unit = "player",
          pvptalent = 8,
          titleSuffix = L["buff"]
        }, {
          spell = 213981,
          type = "ability",
          pvptalent = 9,
          titleSuffix = L["cooldown"]
        }, {
          spell = 213981,
          type = "buff",
          unit = "player",
          pvptalent = 9,
          titleSuffix = L["buff"]
        }, {
          spell = 197003,
          type = "buff",
          unit = "player",
          pvptalent = 10
        }, {
          spell = 248744,
          type = "debuff",
          unit = "target",
          pvptalent = 11
        }, {
          spell = 269513,
          type = "ability",
          pvptalent = 13
        }, {
          spell = 199027,
          type = "buff",
          unit = "player",
          pvptalent = 14
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01"
      }
    }
  }

  templates.class.PRIEST = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 586,
          type = "buff",
          unit = "player"
        }, {
          spell = 198069,
          type = "buff",
          unit = "player"
        }, {
          spell = 194384,
          type = "buff",
          unit = "player"
        }, {
          spell = 17,
          type = "buff",
          unit = "target"
        }, {
          spell = 265258,
          type = "buff",
          unit = "player",
          talent = 2
        }, {
          spell = 271466,
          type = "buff",
          unit = "player",
          talent = 20
        }, {
          spell = 19236,
          type = "buff",
          unit = "player"
        }, {
          spell = 21562,
          type = "buff",
          unit = "player",
          forceOwnOnly = true,
          ownOnly = nil
        }, {
          spell = 81782,
          type = "buff",
          unit = "target"
        }, {
          spell = 33206,
          type = "buff",
          unit = "group"
        }, {
          spell = 193065,
          type = "buff",
          unit = "player",
          talent = 5
        }, {
          spell = 65081,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 47536,
          type = "buff",
          unit = "player"
        }, {
          spell = 121557,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 2096,
          type = "buff",
          unit = "player"
        }, {
          spell = 111759,
          type = "buff",
          unit = "player"
        }, {
          spell = 45243,
          type = "buff",
          unit = "player"
        } },
        icon = 135940
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 8122,
          type = "debuff",
          unit = "target"
        }, {
          spell = 204263,
          type = "debuff",
          unit = "target",
          talent = 12
        }, {
          spell = 208772,
          type = "debuff",
          unit = "target"
        }, {
          spell = 204213,
          type = "debuff",
          unit = "target",
          talent = 16
        }, {
          spell = 2096,
          type = "debuff",
          unit = "target"
        }, {
          spell = 214621,
          type = "debuff",
          unit = "target",
          talent = 3
        }, {
          spell = 589,
          type = "debuff",
          unit = "target"
        }, {
          spell = 9484,
          type = "debuff",
          unit = "multi"
        } },
        icon = 136207
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 527,
          type = "ability"
        }, {
          spell = 586,
          type = "ability",
          buff = true
        }, {
          spell = 2061,
          type = "ability",
          overlayGlow = true
        }, {
          spell = 8122,
          type = "ability"
        }, {
          spell = 19236,
          type = "ability",
          buff = true
        }, {
          spell = 32375,
          type = "ability"
        }, {
          spell = 33206,
          type = "ability"
        }, {
          spell = 34433,
          type = "ability",
          totem = true,
          requiresTarget = true
        }, {
          spell = 47536,
          type = "ability",
          buff = true
        }, {
          spell = 47540,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 62618,
          type = "ability"
        }, {
          spell = 73325,
          type = "ability"
        }, {
          spell = 110744,
          type = "ability",
          talent = 17
        }, {
          spell = 120517,
          type = "ability",
          talent = 18
        }, {
          spell = 121536,
          type = "ability",
          charges = true,
          buff = true,
          talent = 6
        }, {
          spell = 123040,
          type = "ability",
          totem = true,
          requiresTarget = true,
          talent = 8
        }, {
          spell = 129250,
          type = "ability",
          requiresTarget = true,
          talent = 9
        }, {
          spell = 194509,
          type = "ability",
          charges = true
        }, {
          spell = 204065,
          type = "ability",
          talent = 15
        }, {
          spell = 204263,
          type = "ability",
          talent = 12
        }, {
          spell = 214621,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 3
        }, {
          spell = 246287,
          type = "ability"
        }, {
          spell = 271466,
          type = "ability",
          talent = 20
        } },
        icon = 136224
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 275544,
          type = "buff",
          unit = "player"
        }, {
          spell = 274369,
          type = "buff",
          unit = "player"
        }, {
          spell = 287723,
          type = "buff",
          unit = "player"
        }, {
          spell = 287360,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 197871,
          type = "ability",
          pvptalent = 5,
          titleSuffix = L["cooldown"]
        }, {
          spell = 197871,
          type = "buff",
          unit = "player",
          pvptalent = 5,
          titleSuffix = L["buff"]
        }, {
          spell = 305498,
          type = "ability",
          pvptalent = 12
        }, {
          spell = 197862,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 197862,
          type = "buff",
          unit = "player",
          pvptalent = 13,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_elemental_mote_mana"
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 47788,
          type = "buff",
          unit = "target"
        }, {
          spell = 64901,
          type = "buff",
          unit = "player"
        }, {
          spell = 139,
          type = "buff",
          unit = "target"
        }, {
          spell = 2096,
          type = "buff",
          unit = "player"
        }, {
          spell = 64843,
          type = "buff",
          unit = "player"
        }, {
          spell = 19236,
          type = "buff",
          unit = "player"
        }, {
          spell = 21562,
          type = "buff",
          unit = "player",
          forceOwnOnly = true,
          ownOnly = nil
        }, {
          spell = 111759,
          type = "buff",
          unit = "player"
        }, {
          spell = 200183,
          type = "buff",
          unit = "player",
          talent = 20
        }, {
          spell = 27827,
          type = "buff",
          unit = "player"
        }, {
          spell = 77489,
          type = "buff",
          unit = "target"
        }, {
          spell = 114255,
          type = "buff",
          unit = "player",
          talent = 13
        }, {
          spell = 121557,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 586,
          type = "buff",
          unit = "player"
        }, {
          spell = 41635,
          type = "buff",
          unit = "group"
        }, {
          spell = 45243,
          type = "buff",
          unit = "player"
        } },
        icon = 135953
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 8122,
          type = "debuff",
          unit = "target"
        }, {
          spell = 200196,
          type = "debuff",
          unit = "target"
        }, {
          spell = 14914,
          type = "debuff",
          unit = "target"
        }, {
          spell = 2096,
          type = "debuff",
          unit = "target"
        }, {
          spell = 204263,
          type = "debuff",
          unit = "target"
        }, {
          spell = 200200,
          type = "debuff",
          unit = "target"
        }, {
          spell = 9484,
          type = "debuff",
          unit = "multi"
        } },
        icon = 135972
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 527,
          type = "ability"
        }, {
          spell = 586,
          type = "ability",
          buff = true
        }, {
          spell = 2050,
          type = "ability"
        }, {
          spell = 2061,
          type = "ability"
        }, {
          spell = 8122,
          type = "ability"
        }, {
          spell = 14914,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 19236,
          type = "ability",
          buff = true
        }, {
          spell = 32375,
          type = "ability"
        }, {
          spell = 33076,
          type = "ability"
        }, {
          spell = 34861,
          type = "ability"
        }, {
          spell = 47788,
          type = "ability"
        }, {
          spell = 64843,
          type = "ability",
          buff = true
        }, {
          spell = 64901,
          type = "ability",
          buff = true
        }, {
          spell = 73325,
          type = "ability"
        }, {
          spell = 88625,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 110744,
          type = "ability",
          talent = 17
        }, {
          spell = 120517,
          type = "ability",
          talent = 18
        }, {
          spell = 121536,
          type = "ability",
          charges = true,
          buff = true,
          talent = 6
        }, {
          spell = 200183,
          type = "ability",
          buff = true,
          talent = 20
        }, {
          spell = 204263,
          type = "ability",
          talent = 12
        }, {
          spell = 204883,
          type = "ability",
          talent = 15
        }, {
          spell = 265202,
          type = "ability",
          talent = 21
        } },
        icon = 135937
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 272783,
          type = "buff",
          unit = "target"
        }, {
          spell = 274369,
          type = "buff",
          unit = "player"
        }, {
          spell = 287723,
          type = "buff",
          unit = "player"
        }, {
          spell = 287340,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 215982,
          type = "ability",
          pvptalent = 6
        }, {
          spell = 197268,
          type = "ability",
          pvptalent = 7,
          titleSuffix = L["cooldown"]
        }, {
          spell = 232707,
          type = "buff",
          unit = "target",
          pvptalent = 7,
          titleSuffix = L["buff"]
        }, {
          spell = 213610,
          type = "ability",
          pvptalent = 9,
          titleSuffix = L["cooldown"]
        }, {
          spell = 213610,
          type = "buff",
          unit = "target",
          pvptalent = 9,
          titleSuffix = L["buff"]
        }, {
          spell = 289657,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 289655,
          type = "buff",
          unit = "player",
          pvptalent = 10,
          titleSuffix = L["buff"]
        }, {
          spell = 213602,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 213602,
          type = "buff",
          unit = "player",
          pvptalent = 11,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_elemental_mote_mana"
      }
    },
    [3] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 193223,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 263165,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 586,
          type = "buff",
          unit = "player"
        }, {
          spell = 2096,
          type = "buff",
          unit = "player"
        }, {
          spell = 15286,
          type = "buff",
          unit = "player"
        }, {
          spell = 124430,
          type = "buff",
          unit = "player",
          talent = 2
        }, {
          spell = 17,
          type = "buff",
          unit = "player"
        }, {
          spell = 65081,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 197937,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 194249,
          type = "buff",
          unit = "player"
        }, {
          spell = 47585,
          type = "buff",
          unit = "player"
        }, {
          spell = 232698,
          type = "buff",
          unit = "player"
        }, {
          spell = 21562,
          type = "buff",
          unit = "player",
          forceOwnOnly = true,
          ownOnly = nil
        }, {
          spell = 111759,
          type = "buff",
          unit = "player"
        }, {
          spell = 123254,
          type = "buff",
          unit = "player",
          talent = 7
        } },
        icon = 237566
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 15407,
          type = "debuff",
          unit = "target"
        }, {
          spell = 48045,
          type = "debuff",
          unit = "target"
        }, {
          spell = 2096,
          type = "debuff",
          unit = "target"
        }, {
          spell = 205369,
          type = "debuff",
          unit = "target",
          talent = 11
        }, {
          spell = 226943,
          type = "debuff",
          unit = "target",
          talent = 11
        }, {
          spell = 263165,
          type = "debuff",
          unit = "target",
          talent = 18
        }, {
          spell = 15487,
          type = "debuff",
          unit = "target"
        }, {
          spell = 589,
          type = "debuff",
          unit = "target"
        }, {
          spell = 8122,
          type = "debuff",
          unit = "target"
        }, {
          spell = 34914,
          type = "debuff",
          unit = "target"
        }, {
          spell = 9484,
          type = "debuff",
          unit = "multi"
        } },
        icon = 136207
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 17,
          type = "ability",
          buff = true
        }, {
          spell = 586,
          type = "ability",
          buff = true
        }, {
          spell = 8092,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 8122,
          type = "ability"
        }, {
          spell = 15286,
          type = "ability",
          buff = true
        }, {
          spell = 15487,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 32375,
          type = "ability"
        }, {
          spell = 32379,
          type = "ability",
          charges = true,
          usable = true,
          requiresTarget = true,
          talent = 14
        }, {
          spell = 34433,
          type = "ability",
          totem = true,
          requiresTarget = true
        }, {
          spell = 47585,
          type = "ability",
          buff = true
        }, {
          spell = 64044,
          type = "ability",
          requiresTarget = true,
          talent = 12
        }, {
          spell = 73325,
          type = "ability"
        }, {
          spell = 193223,
          type = "ability",
          usable = true,
          buff = true,
          talent = 21
        }, {
          spell = 200174,
          type = "ability",
          totem = true,
          requiresTarget = true,
          talent = 17
        }, {
          spell = 205351,
          type = "ability",
          charges = true,
          requiresTarget = true,
          talent = 3
        }, {
          spell = 205369,
          type = "ability",
          requiresTarget = true,
          talent = 11
        }, {
          spell = 205385,
          type = "ability",
          talent = 15
        }, {
          spell = 205448,
          type = "ability",
          usable = true,
          requiresTarget = true
        }, {
          spell = 213634,
          type = "ability"
        }, {
          spell = 228260,
          type = "ability",
          usable = true,
          requiresTarget = true
        }, {
          spell = 263165,
          type = "ability",
          usable = true,
          requiresTarget = true,
          talent = 18
        }, {
          spell = 263346,
          type = "ability",
          requiresTarget = true,
          talent = 9
        }, {
          spell = 280711,
          type = "ability",
          requiresTarget = true,
          talent = 20
        } },
        icon = 136230
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 279572,
          type = "buff",
          unit = "player"
        }, {
          spell = 275544,
          type = "buff",
          unit = "player"
        }, {
          spell = 273321,
          type = "buff",
          unit = "player"
        }, {
          spell = 274369,
          type = "buff",
          unit = "player"
        }, {
          spell = 275726,
          type = "buff",
          unit = "player"
        }, {
          spell = 287723,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 211522,
          type = "ability",
          pvptalent = 7
        }, {
          spell = 199412,
          type = "buff",
          unit = "player",
          pvptalent = 8
        }, {
          spell = 108968,
          type = "ability",
          pvptalent = 11
        }, {
          spell = 247776,
          type = "buff",
          unit = "player",
          pvptalent = 12,
          titleSuffix = L["buff"]
        }, {
          spell = 247777,
          type = "debuff",
          unit = "target",
          pvptalent = 12,
          titleSuffix = L["debuff"]
        }, {
          spell = 213602,
          type = "buff",
          unit = "target",
          pvptalent = 13
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\spell_priest_shadoworbs"
      }
    }
  }

  templates.class.SHAMAN = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 192082,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 202192,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 210659,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 173184,
          type = "buff",
          unit = "player",
          talent = 3
        }, {
          spell = 108271,
          type = "buff",
          unit = "player"
        }, {
          spell = 210652,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 272737,
          type = "buff",
          unit = "player",
          talent = 19
        }, {
          spell = 108281,
          type = "buff",
          unit = "player",
          talent = 14
        }, {
          spell = 546,
          type = "buff",
          unit = "player"
        }, {
          spell = 114050,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 210714,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 260881,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 260734,
          type = "buff",
          unit = "player",
          talent = 10
        }, {
          spell = 191634,
          type = "buff",
          unit = "player",
          talent = 20
        }, {
          spell = 285514,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 974,
          type = "buff",
          unit = "player",
          talent = 8
        }, {
          spell = 6196,
          type = "buff",
          unit = "player"
        }, {
          spell = 210658,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 173183,
          type = "buff",
          unit = "player",
          talent = 3
        }, {
          spell = 77762,
          type = "buff",
          unit = "player"
        }, {
          spell = 2645,
          type = "buff",
          unit = "player"
        }, {
          spell = 118522,
          type = "buff",
          unit = "player",
          talent = 3
        }, {
          spell = 157348,
          type = "buff",
          unit = "pet",
          talent = { 11, 17 }
        } },
        icon = 135863
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 269808,
          type = "debuff",
          unit = "target",
          talent = 1
        }, {
          spell = 118905,
          type = "debuff",
          unit = "target"
        }, {
          spell = 182387,
          type = "debuff",
          unit = "target"
        }, {
          spell = 188389,
          type = "debuff",
          unit = "target"
        }, {
          spell = 51490,
          type = "debuff",
          unit = "target"
        }, {
          spell = 196840,
          type = "debuff",
          unit = "target"
        }, {
          spell = 118297,
          type = "debuff",
          unit = "target"
        }, {
          spell = 3600,
          type = "debuff",
          unit = "target"
        }, {
          spell = 157375,
          type = "debuff",
          unit = "target"
        }, {
          spell = 118345,
          type = "debuff",
          unit = "target"
        } },
        icon = 135813
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 556,
          type = "ability"
        }, {
          spell = 2484,
          type = "ability",
          totem = true
        }, {
          spell = 8143,
          type = "ability",
          totem = true
        }, {
          spell = 32182,
          type = "ability",
          buff = true
        }, {
          spell = 2825,
          type = "ability",
          buff = true
        }, {
          spell = 51490,
          type = "ability"
        }, {
          spell = 51505,
          type = "ability",
          requiresTarget = true,
          talent = { 1, 3 },
          overlayGlow = true
        }, {
          spell = 51505,
          type = "ability",
          charges = true,
          requiresTarget = true,
          talent = 2,
          titleSuffix = " (2 Charges)",
          overlayGlow = true
        }, {
          spell = 51514,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 51886,
          type = "ability"
        }, {
          spell = 57994,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 108271,
          type = "ability",
          buff = true
        }, {
          spell = 108281,
          type = "ability",
          buff = true
        }, {
          spell = 114050,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 117014,
          type = "ability",
          requiresTarget = true,
          talent = 3
        }, {
          spell = 188389,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 191634,
          type = "ability",
          buff = true,
          talent = 20
        }, {
          spell = 192058,
          type = "ability",
          totem = true
        }, {
          spell = 192077,
          type = "ability",
          totem = true,
          talent = 15
        }, {
          spell = 192222,
          type = "ability",
          totem = true,
          talent = 12
        }, {
          spell = 192249,
          type = "ability",
          duration = 30,
          talent = 11
        }, {
          spell = 198067,
          type = "ability",
          duration = 30
        }, {
          spell = 198103,
          type = "ability",
          duration = 60
        }, {
          spell = 210714,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          talent = 18
        } },
        icon = 135963
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 277942,
          type = "buff",
          unit = "player"
        }, {
          spell = 263786,
          type = "buff",
          unit = "player"
        }, {
          spell = 264113,
          type = "buff",
          unit = "player"
        }, {
          spell = 263792,
          type = "buff",
          unit = "player"
        }, {
          spell = 279028,
          type = "buff",
          unit = "player"
        }, {
          spell = 279029,
          type = "buff",
          unit = "player"
        }, {
          spell = 279033,
          type = "buff",
          unit = "player"
        }, {
          spell = 280205,
          type = "buff",
          unit = "player"
        }, {
          spell = 286976,
          type = "buff",
          unit = "player"
        }, {
          spell = 277960,
          type = "buff",
          unit = "player"
        }, {
          spell = 272981,
          type = "buff",
          unit = "player"
        }, {
          spell = 287786,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 305483,
          type = "ability",
          pvptalent = 5,
          titleSuffix = L["cooldown"]
        }, {
          spell = 305485,
          type = "debuff",
          unit = "target",
          pvptalent = 5,
          titleSuffix = L["debuff"]
        }, {
          spell = 236746,
          type = "buff",
          unit = "player",
          pvptalent = 8
        }, {
          spell = 204330,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 208963,
          type = "buff",
          unit = "player",
          pvptalent = 10,
          titleSuffix = L["buff"]
        }, {
          spell = 204336,
          type = "ability",
          pvptalent = 12,
          titleSuffix = L["cooldown"]
        }, {
          spell = 8178,
          type = "buff",
          unit = "target",
          pvptalent = 12,
          titleSuffix = L["buff"]
        }, {
          spell = 204331,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 208997,
          type = "debuff",
          unit = "target",
          pvptalent = 13,
          titleSuffix = L["debuff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = 135990
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 273323,
          type = "buff",
          unit = "player",
          talent = 3
        }, {
          spell = 192082,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 974,
          type = "buff",
          unit = "player",
          talent = 8
        }, {
          spell = 262652,
          type = "buff",
          unit = "player",
          talent = 5
        }, {
          spell = 187878,
          type = "buff",
          unit = "player"
        }, {
          spell = 262397,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 192106,
          type = "buff",
          unit = "player",
          talent = 3
        }, {
          spell = 108271,
          type = "buff",
          unit = "player"
        }, {
          spell = 6196,
          type = "buff",
          unit = "player"
        }, {
          spell = 196834,
          type = "buff",
          unit = "player"
        }, {
          spell = 224126,
          type = "buff",
          unit = "player",
          talent = 19
        }, {
          spell = 546,
          type = "buff",
          unit = "player"
        }, {
          spell = 114051,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 224125,
          type = "buff",
          unit = "player",
          talent = 19
        }, {
          spell = 202004,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 262400,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 58875,
          type = "buff",
          unit = "player"
        }, {
          spell = 198300,
          type = "buff",
          unit = "player"
        }, {
          spell = 224127,
          type = "buff",
          unit = "player",
          talent = 19
        }, {
          spell = 197211,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 201846,
          type = "buff",
          unit = "player"
        }, {
          spell = 260881,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 262417,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 262399,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 2645,
          type = "buff",
          unit = "player"
        }, {
          spell = 215785,
          type = "buff",
          unit = "player",
          talent = 2
        }, {
          spell = 194084,
          type = "buff",
          unit = "player"
        } },
        icon = 136099
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 118905,
          type = "debuff",
          unit = "target"
        }, {
          spell = 197214,
          type = "debuff",
          unit = "target",
          talent = 18
        }, {
          spell = 147732,
          type = "debuff",
          unit = "target"
        }, {
          spell = 271924,
          type = "debuff",
          unit = "target",
          talent = 19
        }, {
          spell = 3600,
          type = "debuff",
          unit = "target"
        }, {
          spell = 188089,
          type = "debuff",
          unit = "target",
          talent = 20
        }, {
          spell = 197385,
          type = "debuff",
          unit = "target",
          talent = 17
        }, {
          spell = 268429,
          type = "debuff",
          unit = "target",
          talent = 10
        } },
        icon = 462327
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 556,
          type = "ability"
        }, {
          spell = 2484,
          type = "ability",
          totem = true
        }, {
          spell = 8143,
          type = "ability",
          totem = true
        }, {
          spell = 17364,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 32182,
          type = "ability",
          buff = true
        }, {
          spell = 2825,
          type = "ability",
          buff = true
        }, {
          spell = 51514,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 51533,
          type = "ability",
          duration = 15
        }, {
          spell = 51886,
          type = "ability"
        }, {
          spell = 57994,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 58875,
          type = "ability",
          buff = true
        }, {
          spell = 108271,
          type = "ability",
          buff = true
        }, {
          spell = 114051,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 115356,
          type = "ability",
          talent = 21
        }, {
          spell = 187837,
          type = "ability",
          requiresTarget = true,
          talent = 12
        }, {
          spell = 187874,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 188089,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          talent = 20
        }, {
          spell = 192058,
          type = "ability",
          totem = true
        }, {
          spell = 192077,
          type = "ability",
          totem = true,
          talent = 15
        }, {
          spell = 193786,
          type = "ability",
          charges = true,
          requiresTarget = true
        }, {
          spell = 193796,
          type = "ability",
          buff = true,
          requiresTarget = true
        }, {
          spell = 196884,
          type = "ability",
          requiresTarget = true,
          talent = 14
        }, {
          spell = 197214,
          type = "ability",
          talent = 18
        }, {
          spell = 198103,
          type = "ability",
          duration = 60
        } },
        icon = 1370984
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 277942,
          type = "buff",
          unit = "player"
        }, {
          spell = 263786,
          type = "buff",
          unit = "player"
        }, {
          spell = 264121,
          type = "buff",
          unit = "player"
        }, {
          spell = 275391,
          type = "buff",
          unit = "target"
        }, {
          spell = 280205,
          type = "buff",
          unit = "player"
        }, {
          spell = 273006,
          type = "buff",
          unit = "player"
        }, {
          spell = 279515,
          type = "buff",
          unit = "player"
        }, {
          spell = 263795,
          type = "buff",
          unit = "player"
        }, {
          spell = 273465,
          type = "buff",
          unit = "player"
        }, {
          spell = 277960,
          type = "buff",
          unit = "player"
        }, {
          spell = 287786,
          type = "buff",
          unit = "player"
        }, {
          spell = 287802,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 204366,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["cooldown"]
        }, {
          spell = 204366,
          type = "buff",
          unit = "player",
          pvptalent = 6,
          titleSuffix = L["buff"]
        }, {
          spell = 210918,
          type = "ability",
          pvptalent = 7,
          titleSuffix = L["cooldown"]
        }, {
          spell = 210918,
          type = "buff",
          unit = "player",
          pvptalent = 7,
          titleSuffix = L["buff"]
        }, {
          spell = 204330,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 208963,
          type = "buff",
          unit = "player",
          pvptalent = 10,
          titleSuffix = L["buff"]
        }, {
          spell = 204331,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 208997,
          type = "debuff",
          unit = "target",
          pvptalent = 11,
          titleSuffix = L["debuff"]
        }, {
          spell = 204336,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 8178,
          type = "buff",
          unit = "player",
          pvptalent = 13,
          titleSuffix = L["debuff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = 135990
      }
    },
    [3] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 79206,
          type = "buff",
          unit = "player"
        }, {
          spell = 114052,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 974,
          type = "buff",
          unit = "group",
          talent = 6
        }, {
          spell = 216251,
          type = "buff",
          unit = "player",
          talent = 2
        }, {
          spell = 108271,
          type = "buff",
          unit = "player"
        }, {
          spell = 6196,
          type = "buff",
          unit = "player"
        }, {
          spell = 207498,
          type = "buff",
          unit = "player",
          talent = 12
        }, {
          spell = 73685,
          type = "buff",
          unit = "player",
          talent = 3
        }, {
          spell = 546,
          type = "buff",
          unit = "player"
        }, {
          spell = 157504,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 260881,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 61295,
          type = "buff",
          unit = "target"
        }, {
          spell = 98007,
          type = "buff",
          unit = "player"
        }, {
          spell = 77762,
          type = "buff",
          unit = "player"
        }, {
          spell = 207400,
          type = "buff",
          unit = "target",
          talent = 10
        }, {
          spell = 201633,
          type = "buff",
          unit = "player",
          talent = 11
        }, {
          spell = 73920,
          type = "buff",
          unit = "player"
        }, {
          spell = 280615,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 2645,
          type = "buff",
          unit = "player"
        }, {
          spell = 53390,
          type = "buff",
          unit = "player"
        } },
        icon = 252995
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 118905,
          type = "debuff",
          unit = "target"
        }, {
          spell = 64695,
          type = "debuff",
          unit = "target",
          talent = 8
        }, {
          spell = 3600,
          type = "debuff",
          unit = "target"
        }, {
          spell = 188838,
          type = "debuff",
          unit = "target"
        } },
        icon = 135813
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 556,
          type = "ability"
        }, {
          spell = 2484,
          type = "ability",
          totem = true
        }, {
          spell = 5394,
          type = "ability",
          totem = true,
          talent = { 5, 6 }
        }, {
          spell = 5394,
          type = "ability",
          charges = true,
          totem = true,
          talent = 4,
          titleSuffix = " (2 Charges)"
        }, {
          spell = 8143,
          type = "ability",
          totem = true
        }, {
          spell = 32182,
          type = "ability",
          buff = true
        }, {
          spell = 2825,
          type = "ability",
          buff = true
        }, {
          spell = 51485,
          type = "ability",
          totem = true,
          talent = 8
        }, {
          spell = 51505,
          type = "ability",
          requiresTarget = true,
          talent = { 5, 6 }
        }, {
          spell = 51505,
          type = "ability",
          charges = true,
          requiresTarget = true,
          talent = 4,
          titleSuffix = " (2 Charges)"
        }, {
          spell = 51514,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 57994,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 61295,
          type = "ability",
          talent = { 5, 6 }
        }, {
          spell = 61295,
          type = "ability",
          charges = true,
          talent = 4,
          titleSuffix = " (2 Charges)"
        }, {
          spell = 73685,
          type = "ability",
          buff = true,
          talent = 3
        }, {
          spell = 73920,
          type = "ability",
          duration = 10
        }, {
          spell = 79206,
          type = "ability",
          buff = true
        }, {
          spell = 98008,
          type = "ability",
          totem = true
        }, {
          spell = 108271,
          type = "ability",
          buff = true
        }, {
          spell = 108280,
          type = "ability",
          totem = true
        }, {
          spell = 114052,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 157153,
          type = "ability",
          charges = true,
          totem = true,
          talent = 18
        }, {
          spell = 188838,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 192058,
          type = "ability",
          totem = true
        }, {
          spell = 192077,
          type = "ability",
          totem = true,
          talent = 15
        }, {
          spell = 197995,
          type = "ability",
          talent = 20
        }, {
          spell = 198103,
          type = "ability",
          duration = 60
        }, {
          spell = 198838,
          type = "ability",
          totem = true,
          talent = 11
        }, {
          spell = 207399,
          type = "ability",
          totem = true,
          talent = 12
        }, {
          spell = 207778,
          type = "ability",
          talent = 17
        } },
        icon = 135127
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 263786,
          type = "buff",
          unit = "player"
        }, {
          spell = 263790,
          type = "buff",
          unit = "player"
        }, {
          spell = 277942,
          type = "buff",
          unit = "player"
        }, {
          spell = 264113,
          type = "buff",
          unit = "player"
        }, {
          spell = 278095,
          type = "buff",
          unit = "group"
        }, {
          spell = 280205,
          type = "buff",
          unit = "player"
        }, {
          spell = 279505,
          type = "buff",
          unit = "group"
        }, {
          spell = 279187,
          type = "buff",
          unit = "target"
        }, {
          spell = 272981,
          type = "debuff",
          unit = "target"
        }, {
          spell = 273019,
          type = "buff",
          unit = "player"
        }, {
          spell = 287786,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 290254,
          type = "ability",
          pvptalent = 4,
          titleSuffix = L["cooldown"]
        }, {
          spell = 290641,
          type = "buff",
          unit = "player",
          pvptalent = 4,
          titleSuffix = L["buff"]
        }, {
          spell = 206647,
          type = "debuff",
          unit = "target",
          pvptalent = 5
        }, {
          spell = 204293,
          type = "buff",
          unit = "target",
          pvptalent = 6
        }, {
          spell = 236502,
          type = "buff",
          unit = "player",
          pvptalent = 7
        }, {
          spell = 204336,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 8178,
          type = "buff",
          unit = "player",
          pvptalent = 8,
          titleSuffix = L["buff"]
        }, {
          spell = 204330,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 208963,
          type = "buff",
          unit = "player",
          pvptalent = 10,
          titleSuffix = L["buff"]
        }, {
          spell = 204331,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 208997,
          type = "debuff",
          unit = "target",
          pvptalent = 11,
          titleSuffix = L["debuff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_elemental_mote_mana"
      }
    }
  }

  templates.class.MAGE = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 110960,
          type = "buff",
          unit = "player"
        }, {
          spell = 45438,
          type = "buff",
          unit = "player"
        }, {
          spell = 116267,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 1459,
          type = "buff",
          unit = "player",
          forceOwnOnly = true,
          ownOnly = nil
        }, {
          spell = 212799,
          type = "buff",
          unit = "player"
        }, {
          spell = 210126,
          type = "buff",
          unit = "player",
          talent = 3
        }, {
          spell = 236298,
          type = "buff",
          unit = "player",
          talent = 13
        }, {
          spell = 116014,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 130,
          type = "buff",
          unit = "player"
        }, {
          spell = 263725,
          type = "buff",
          unit = "player"
        }, {
          spell = 235450,
          type = "buff",
          unit = "player"
        }, {
          spell = 12051,
          type = "buff",
          unit = "player"
        }, {
          spell = 205025,
          type = "buff",
          unit = "player"
        }, {
          spell = 264774,
          type = "buff",
          unit = "player",
          talent = 2
        }, {
          spell = 12042,
          type = "buff",
          unit = "player"
        } },
        icon = 136096
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 82691,
          type = "debuff",
          unit = "target",
          talent = 15
        }, {
          spell = 114923,
          type = "debuff",
          unit = "target",
          talent = 18
        }, {
          spell = 210824,
          type = "debuff",
          unit = "target",
          talent = 17
        }, {
          spell = 236299,
          type = "debuff",
          unit = "target",
          talent = 13
        }, {
          spell = 31589,
          type = "debuff",
          unit = "target"
        }, {
          spell = 122,
          type = "debuff",
          unit = "target"
        }, {
          spell = 118,
          type = "debuff",
          unit = "multi"
        } },
        icon = 135848
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 122,
          type = "ability"
        }, {
          spell = 475,
          type = "ability"
        }, {
          spell = 1449,
          type = "ability",
          overlayGlow = true
        }, {
          spell = 1953,
          type = "ability"
        }, {
          spell = 2139,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 5143,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 12042,
          type = "ability",
          buff = true
        }, {
          spell = 12051,
          type = "ability",
          buff = true
        }, {
          spell = 44425,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 45438,
          type = "ability",
          buff = true
        }, {
          spell = 55342,
          type = "ability",
          talent = 8
        }, {
          spell = 80353,
          type = "ability",
          buff = true
        }, {
          spell = 110959,
          type = "ability",
          buff = true
        }, {
          spell = 113724,
          type = "ability",
          talent = 15
        }, {
          spell = 116011,
          type = "ability",
          charges = true,
          buff = true,
          talent = 9
        }, {
          spell = 153626,
          type = "ability",
          talent = 21
        }, {
          spell = 157980,
          type = "ability",
          requiresTarget = true,
          talent = 12
        }, {
          spell = 190336,
          type = "ability"
        }, {
          spell = 195676,
          type = "ability",
          usable = true
        }, {
          spell = 205022,
          type = "ability",
          talent = 3
        }, {
          spell = 205025,
          type = "ability",
          buff = true
        }, {
          spell = 205032,
          type = "ability",
          talent = 11
        }, {
          spell = 212653,
          type = "ability",
          charges = true,
          talent = 5
        }, {
          spell = 235450,
          type = "ability",
          buff = true
        } },
        icon = 136075
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 270670,
          type = "buff",
          unit = "player"
        }, {
          spell = 273330,
          type = "buff",
          unit = "player"
        }, {
          spell = 280177,
          type = "buff",
          unit = "player"
        }, {
          spell = 264353,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 198111,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 198111,
          type = "buff",
          unit = "player",
          pvptalent = 8,
          titleSuffix = L["buff"]
        }, {
          spell = 198065,
          type = "buff",
          unit = "player",
          pvptalent = 9
        }, {
          spell = 198158,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 198158,
          type = "buff",
          unit = "player",
          pvptalent = 13,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\spell_arcane_arcane01"
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 236060,
          type = "buff",
          unit = "player",
          talent = 13
        }, {
          spell = 116267,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 269651,
          type = "buff",
          unit = "player",
          talent = 20
        }, {
          spell = 45444,
          type = "buff",
          unit = "player"
        }, {
          spell = 48107,
          type = "buff",
          unit = "player"
        }, {
          spell = 116014,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 235313,
          type = "buff",
          unit = "player"
        }, {
          spell = 45438,
          type = "buff",
          unit = "player"
        }, {
          spell = 157644,
          type = "buff",
          unit = "player"
        }, {
          spell = 190319,
          type = "buff",
          unit = "player"
        }, {
          spell = 66,
          type = "buff",
          unit = "player"
        }, {
          spell = 1459,
          type = "buff",
          unit = "player",
          forceOwnOnly = true,
          ownOnly = nil
        }, {
          spell = 130,
          type = "buff",
          unit = "player"
        }, {
          spell = 48108,
          type = "buff",
          unit = "player"
        } },
        icon = 1035045
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 31661,
          type = "debuff",
          unit = "target"
        }, {
          spell = 2120,
          type = "debuff",
          unit = "target"
        }, {
          spell = 155158,
          type = "debuff",
          unit = "target",
          talent = 21
        }, {
          spell = 157981,
          type = "debuff",
          unit = "target",
          talent = 6
        }, {
          spell = 226757,
          type = "debuff",
          unit = "target",
          talent = 17
        }, {
          spell = 217694,
          type = "debuff",
          unit = "target",
          talent = 18
        }, {
          spell = 12654,
          type = "debuff",
          unit = "target"
        }, {
          spell = 82691,
          type = "debuff",
          unit = "target",
          talent = 15
        }, {
          spell = 87023,
          type = "debuff",
          unit = "player"
        }, {
          spell = 87024,
          type = "debuff",
          unit = "player"
        }, {
          spell = 118,
          type = "debuff",
          unit = "multi"
        } },
        icon = 135818
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 66,
          type = "ability",
          buff = true
        }, {
          spell = 475,
          type = "ability"
        }, {
          spell = 1953,
          type = "ability"
        }, {
          spell = 2120,
          type = "ability",
          overlayGlow = true
        }, {
          spell = 2139,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 11366,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 31661,
          type = "ability"
        }, {
          spell = 44457,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          talent = 18
        }, {
          spell = 45438,
          type = "ability",
          buff = true
        }, {
          spell = 55342,
          type = "ability",
          talent = 8
        }, {
          spell = 80353,
          type = "ability",
          buff = true
        }, {
          spell = 108853,
          type = "ability",
          charges = true
        }, {
          spell = 113724,
          type = "ability",
          talent = 15
        }, {
          spell = 116011,
          type = "ability",
          charges = true,
          buff = true,
          talent = 9
        }, {
          spell = 153561,
          type = "ability",
          talent = 21
        }, {
          spell = 157981,
          type = "ability",
          talent = 6
        }, {
          spell = 190319,
          type = "ability",
          buff = true
        }, {
          spell = 190336,
          type = "ability"
        }, {
          spell = 212653,
          type = "ability",
          charges = true,
          talent = 5
        }, {
          spell = 235313,
          type = "ability",
          buff = true
        }, {
          spell = 257541,
          type = "ability",
          charges = true,
          talent = 12
        } },
        icon = 610633
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 274598,
          type = "buff",
          unit = "player"
        }, {
          spell = 280177,
          type = "buff",
          unit = "player"
        }, {
          spell = 279715,
          type = "buff",
          unit = "player"
        }, {
          spell = 288800,
          type = "buff",
          unit = "player"
        }, {
          spell = 277703,
          type = "debuff",
          unit = "multi"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 198111,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["cooldown"]
        }, {
          spell = 198111,
          type = "buff",
          unit = "player",
          pvptalent = 6,
          titleSuffix = L["buff"]
        }, {
          spell = 203285,
          type = "buff",
          unit = "target",
          pvptalent = 7
        }, {
          spell = 203277,
          type = "buff",
          unit = "player",
          pvptalent = 13
        }, {
          spell = 198065,
          type = "buff",
          unit = "player",
          pvptalent = 14
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_elemental_mote_mana"
      }
    },
    [3] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 199844,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 45438,
          type = "buff",
          unit = "player"
        }, {
          spell = 66,
          type = "buff",
          unit = "player"
        }, {
          spell = 116267,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 1459,
          type = "buff",
          unit = "player",
          forceOwnOnly = true,
          ownOnly = nil
        }, {
          spell = 108839,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 278310,
          type = "buff",
          unit = "player",
          talent = 11
        }, {
          spell = 12472,
          type = "buff",
          unit = "player"
        }, {
          spell = 11426,
          type = "buff",
          unit = "player"
        }, {
          spell = 130,
          type = "buff",
          unit = "player"
        }, {
          spell = 205473,
          type = "buff",
          unit = "player"
        }, {
          spell = 270232,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 190446,
          type = "buff",
          unit = "player"
        }, {
          spell = 116014,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 44544,
          type = "buff",
          unit = "player"
        }, {
          spell = 205766,
          type = "buff",
          unit = "player",
          talent = 1
        } },
        icon = 236227
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 228354,
          type = "debuff",
          unit = "target"
        }, {
          spell = 205708,
          type = "debuff",
          unit = "target"
        }, {
          spell = 228600,
          type = "debuff",
          unit = "target",
          talent = 21
        }, {
          spell = 157997,
          type = "debuff",
          unit = "target",
          talent = 3
        }, {
          spell = 228358,
          type = "debuff",
          unit = "target"
        }, {
          spell = 205021,
          type = "debuff",
          unit = "target",
          talent = 20
        }, {
          spell = 122,
          type = "debuff",
          unit = "target"
        }, {
          spell = 82691,
          type = "debuff",
          unit = "target",
          talent = 15
        }, {
          spell = 212792,
          type = "debuff",
          unit = "target"
        }, {
          spell = 118,
          type = "debuff",
          unit = "multi"
        } },
        icon = 236208
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 66,
          type = "ability",
          buff = true
        }, {
          spell = 120,
          type = "ability"
        }, {
          spell = 122,
          type = "ability"
        }, {
          spell = 475,
          type = "ability"
        }, {
          spell = 1953,
          type = "ability"
        }, {
          spell = 2139,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 11426,
          type = "ability",
          buff = true
        }, {
          spell = 12472,
          type = "ability",
          buff = true
        }, {
          spell = 30455,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 31687,
          type = "ability"
        }, {
          spell = 31707,
          type = "ability"
        }, {
          spell = 45438,
          type = "ability",
          buff = true
        }, {
          spell = 55342,
          type = "ability",
          talent = 8
        }, {
          spell = 80353,
          type = "ability",
          buff = true
        }, {
          spell = 84714,
          type = "ability"
        }, {
          spell = 108839,
          type = "ability",
          charges = true,
          buff = true,
          talent = 6
        }, {
          spell = 113724,
          type = "ability",
          talent = 15
        }, {
          spell = 116011,
          type = "ability",
          charges = true,
          buff = true,
          talent = 9
        }, {
          spell = 153595,
          type = "ability",
          requiresTarget = true,
          talent = 18
        }, {
          spell = 157997,
          type = "ability",
          talent = 3
        }, {
          spell = 190336,
          type = "ability"
        }, {
          spell = 190356,
          type = "ability"
        }, {
          spell = 199786,
          type = "ability",
          usable = true,
          requiresTarget = true,
          overlayGlow = true,
          talent = 21
        }, {
          spell = 205021,
          type = "ability",
          requiresTarget = true,
          talent = 20
        }, {
          spell = 212653,
          type = "ability",
          charges = true,
          talent = 5
        }, {
          spell = 235219,
          type = "ability"
        }, {
          spell = 257537,
          type = "ability",
          requiresTarget = true,
          talent = 12
        } },
        icon = 629077
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 280177,
          type = "buff",
          unit = "player"
        }, {
          spell = 279684,
          type = "buff",
          unit = "player"
        }, {
          spell = 275517,
          type = "buff",
          unit = "player"
        }, {
          spell = 277904,
          type = "buff",
          unit = "player"
        }, {
          spell = 273347,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 198065,
          type = "buff",
          unit = "player",
          pvptalent = 5
        }, {
          spell = 206432,
          type = "buff",
          unit = "player",
          pvptalent = 7
        }, {
          spell = 198144,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 198144,
          type = "buff",
          unit = "player",
          pvptalent = 10,
          titleSuffix = L["buff"]
        }, {
          spell = 198111,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 198111,
          type = "buff",
          unit = "player",
          pvptalent = 11,
          titleSuffix = L["buff"]
        }, {
          spell = 198121,
          type = "debuff",
          unit = "target",
          pvptalent = 13
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_elemental_mote_mana"
      }
    }
  }

  templates.class.WARLOCK = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 196099,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 104773,
          type = "buff",
          unit = "player"
        }, {
          spell = 126,
          type = "buff",
          unit = "player"
        }, {
          spell = 113860,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 48018,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 108416,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 108366,
          type = "buff",
          unit = "player"
        }, {
          spell = 5697,
          type = "buff",
          unit = "player"
        }, {
          spell = 264571,
          type = "buff",
          unit = "player",
          talent = 1
        }, {
          spell = 111400,
          type = "buff",
          unit = "player",
          talent = 8
        }, {
          spell = 20707,
          type = "buff",
          unit = "group"
        }, {
          spell = 7870,
          type = "buff",
          unit = "pet"
        }, {
          spell = 112042,
          type = "buff",
          unit = "pet"
        }, {
          spell = 17767,
          type = "buff",
          unit = "pet"
        }, {
          spell = 755,
          type = "buff",
          unit = "pet"
        } },
        icon = 136210
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 233490,
          type = "debuff",
          unit = "target"
        }, {
          spell = 27243,
          type = "debuff",
          unit = "target"
        }, {
          spell = 710,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 234153,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6358,
          type = "debuff",
          unit = "target"
        }, {
          spell = 30283,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6789,
          type = "debuff",
          unit = "target",
          talent = 14
        }, {
          spell = 118699,
          type = "debuff",
          unit = "target"
        }, {
          spell = 198590,
          type = "debuff",
          unit = "target",
          talent = 2
        }, {
          spell = 17735,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6360,
          type = "debuff",
          unit = "target"
        }, {
          spell = 278350,
          type = "debuff",
          unit = "target",
          talent = 12
        }, {
          spell = 1098,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 48181,
          type = "debuff",
          unit = "target",
          talent = 17
        }, {
          spell = 32390,
          type = "debuff",
          unit = "target",
          talent = 16
        }, {
          spell = 146739,
          type = "debuff",
          unit = "target"
        }, {
          spell = 205179,
          type = "debuff",
          unit = "target",
          talent = 11
        }, {
          spell = 63106,
          type = "debuff",
          unit = "target",
          talent = 6
        }, {
          spell = 980,
          type = "debuff",
          unit = "target"
        } },
        icon = 136139
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 172,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 698,
          type = "ability"
        }, {
          spell = 710,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 980,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 3110,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 3716,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 5782,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 6358,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 6360,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 6789,
          type = "ability",
          requiresTarget = true,
          talent = 15
        }, {
          spell = 7814,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 7870,
          type = "ability"
        }, {
          spell = 17735,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 17767,
          type = "ability"
        }, {
          spell = 19505,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 19647,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 20707,
          type = "ability"
        }, {
          spell = 27243,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 29893,
          type = "ability"
        }, {
          spell = 30108,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 30283,
          type = "ability"
        }, {
          spell = 48018,
          type = "ability",
          talent = 15
        }, {
          spell = 48020,
          type = "ability",
          talent = 15
        }, {
          spell = 48181,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 17
        }, {
          spell = 54049,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 63106,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 6
        }, {
          spell = 89792,
          type = "ability"
        }, {
          spell = 89808,
          type = "ability"
        }, {
          spell = 104773,
          type = "ability",
          buff = true
        }, {
          spell = 108416,
          type = "ability",
          buff = true,
          talent = 9
        }, {
          spell = 108503,
          type = "ability",
          talent = 18
        }, {
          spell = 111771,
          type = "ability"
        }, {
          spell = 112042,
          type = "ability"
        }, {
          spell = 113860,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 119910,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 205179,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 11
        }, {
          spell = 205180,
          type = "ability",
          totem = true
        }, {
          spell = 232670,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 234153,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 264106,
          type = "ability",
          requiresTarget = true,
          talent = 3
        }, {
          spell = 264993,
          type = "ability"
        }, {
          spell = 278350,
          type = "ability",
          requiresTarget = true,
          talent = 12
        } },
        icon = 135808
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 275378,
          type = "buff",
          unit = "player"
        }, {
          spell = 280208,
          type = "buff",
          unit = "player"
        }, {
          spell = 273525,
          type = "buff",
          unit = "player"
        }, {
          spell = 274420,
          type = "buff",
          unit = "player"
        }, {
          spell = 272893,
          type = "buff",
          unit = "player"
        }, {
          spell = 287828,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 199890,
          type = "ability",
          pvptalent = 4,
          titleSuffix = L["cooldown"]
        }, {
          spell = 199890,
          type = "debuff",
          unit = "target",
          pvptalent = 4,
          titleSuffix = L["debuff"]
        }, {
          spell = 285933,
          type = "buff",
          unit = "player",
          pvptalent = 5
        }, {
          spell = 221715,
          type = "debuff",
          unit = "target",
          pvptalent = 6
        }, {
          spell = 221703,
          type = "ability",
          pvptalent = 7,
          titleSuffix = L["cooldown"]
        }, {
          spell = 221705,
          type = "buff",
          unit = "player",
          pvptalent = 7,
          titleSuffix = L["buff"]
        }, {
          spell = 212356,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 236471,
          type = "buff",
          unit = "player",
          pvptalent = 8,
          titleSuffix = L["buff"]
        }, {
          spell = 199892,
          type = "ability",
          pvptalent = 9,
          titleSuffix = L["cooldown"]
        }, {
          spell = 199892,
          type = "debuff",
          unit = "target",
          pvptalent = 9,
          titleSuffix = L["debuff"]
        }, {
          spell = 199954,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 199954,
          type = "debuff",
          unit = "target",
          pvptalent = 10,
          titleSuffix = L["debuff"]
        }, {
          spell = 305388,
          type = "debuff",
          unit = "target",
          pvptalent = 11
        }, {
          spell = 212295,
          type = "ability",
          pvptalent = 12,
          titleSuffix = L["cooldown"]
        }, {
          spell = 212295,
          type = "buff",
          unit = "player",
          pvptalent = 12,
          titleSuffix = L["buff"]
        }, {
          spell = 234877,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 234877,
          type = "debuff",
          unit = "target",
          pvptalent = 13,
          titleSuffix = L["debuff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_misc_gem_amethyst_02"
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 104773,
          type = "buff",
          unit = "player"
        }, {
          spell = 126,
          type = "buff",
          unit = "player"
        }, {
          spell = 267218,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 48018,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 108416,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 108366,
          type = "buff",
          unit = "player"
        }, {
          spell = 205146,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 5697,
          type = "buff",
          unit = "player"
        }, {
          spell = 265273,
          type = "buff",
          unit = "player"
        }, {
          spell = 111400,
          type = "buff",
          unit = "player",
          talent = 8
        }, {
          spell = 20707,
          type = "buff",
          unit = "group"
        }, {
          spell = 264173,
          type = "buff",
          unit = "player"
        }, {
          spell = 134477,
          type = "buff",
          unit = "pet"
        }, {
          spell = 30151,
          type = "buff",
          unit = "pet"
        }, {
          spell = 267171,
          type = "buff",
          unit = "pet",
          talent = 2
        }, {
          spell = 17767,
          type = "buff",
          unit = "pet"
        }, {
          spell = 89751,
          type = "buff",
          unit = "pet"
        }, {
          spell = 755,
          type = "buff",
          unit = "pet"
        } },
        icon = 1378284
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 270569,
          type = "debuff",
          unit = "target",
          talent = 10
        }, {
          spell = 267997,
          type = "debuff",
          unit = "target",
          talent = 3
        }, {
          spell = 17735,
          type = "debuff",
          unit = "target"
        }, {
          spell = 118699,
          type = "debuff",
          unit = "target"
        }, {
          spell = 30283,
          type = "debuff",
          unit = "target"
        }, {
          spell = 89766,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6789,
          type = "debuff",
          unit = "target",
          talent = 14
        }, {
          spell = 234153,
          type = "debuff",
          unit = "target"
        }, {
          spell = 30213,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6360,
          type = "debuff",
          unit = "target"
        }, {
          spell = 265412,
          type = "debuff",
          unit = "target",
          talent = 6
        }, {
          spell = 710,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 1098,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 6358,
          type = "debuff",
          unit = "target"
        } },
        icon = 136122
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 686,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 698,
          type = "ability"
        }, {
          spell = 710,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 3716,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 5782,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 6360,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 6789,
          type = "ability",
          requiresTarget = true,
          talent = 14
        }, {
          spell = 7814,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 7870,
          type = "ability"
        }, {
          spell = 17735,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 17767,
          type = "ability"
        }, {
          spell = 19505,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 19647,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 20707,
          type = "ability"
        }, {
          spell = 29893,
          type = "ability"
        }, {
          spell = 30151,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 30213,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 30283,
          type = "ability"
        }, {
          spell = 48018,
          type = "ability",
          talent = 15
        }, {
          spell = 48020,
          type = "ability",
          talent = 15
        }, {
          spell = 54049,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 89751,
          type = "ability"
        }, {
          spell = 89766,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 89792,
          type = "ability"
        }, {
          spell = 89808,
          type = "ability"
        }, {
          spell = 104316,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 104773,
          type = "ability",
          buff = true
        }, {
          spell = 105174,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 108416,
          type = "ability",
          buff = true,
          talent = 9
        }, {
          spell = 111771,
          type = "ability"
        }, {
          spell = 111898,
          type = "ability",
          requiresTarget = true,
          talent = 18
        }, {
          spell = 112042,
          type = "ability"
        }, {
          spell = 264057,
          type = "ability",
          requiresTarget = true,
          talent = 11
        }, {
          spell = 264119,
          type = "ability",
          talent = 12
        }, {
          spell = 264130,
          type = "ability",
          usable = true,
          talent = 5
        }, {
          spell = 264178,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 264993,
          type = "ability"
        }, {
          spell = 265187,
          type = "ability"
        }, {
          spell = 265412,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 6
        }, {
          spell = 267171,
          type = "ability",
          requiresTarget = true,
          talent = 2
        }, {
          spell = 267211,
          type = "ability",
          talent = 3
        }, {
          spell = 267217,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 6358,
          type = "ability",
          requiresTarget = true
        } },
        icon = 1378282
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 280208,
          type = "buff",
          unit = "player"
        }, {
          spell = 276027,
          type = "buff",
          unit = "player"
        }, {
          spell = 275398,
          type = "buff",
          unit = "player"
        }, {
          spell = 274420,
          type = "buff",
          unit = "player"
        }, {
          spell = 272945,
          type = "buff",
          unit = "player"
        }, {
          spell = 279885,
          type = "buff",
          unit = "player"
        }, {
          spell = 273526,
          type = "debuff",
          unit = "target"
        }, {
          spell = 287828,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 201996,
          type = "ability",
          pvptalent = 4
        }, {
          spell = 212295,
          type = "ability",
          pvptalent = 5,
          titleSuffix = L["cooldown"]
        }, {
          spell = 212295,
          type = "buff",
          unit = "player",
          pvptalent = 5,
          titleSuffix = L["buff"]
        }, {
          spell = 221715,
          type = "debuff",
          unit = "target",
          pvptalent = 6
        }, {
          spell = 221703,
          type = "ability",
          pvptalent = 7,
          titleSuffix = L["cooldown"]
        }, {
          spell = 221705,
          type = "buff",
          unit = "target",
          pvptalent = 7,
          titleSuffix = L["buff"]
        }, {
          spell = 199890,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 199890,
          type = "debuff",
          unit = "target",
          pvptalent = 8,
          titleSuffix = L["debuff"]
        }, {
          spell = 199954,
          type = "ability",
          pvptalent = 9,
          titleSuffix = L["cooldown"]
        }, {
          spell = 199954,
          type = "debuff",
          unit = "target",
          pvptalent = 9,
          titleSuffix = L["debuff"]
        }, {
          spell = 199892,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 199892,
          type = "debuff",
          unit = "target",
          pvptalent = 10,
          titleSuffix = L["debuff"]
        }, {
          spell = 212623,
          type = "ability",
          pvptalent = 11
        }, {
          spell = 212619,
          type = "ability",
          pvptalent = 12
        }, {
          spell = 212459,
          type = "ability",
          pvptalent = 14
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_misc_gem_amethyst_02"
      }
    },
    [3] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 104773,
          type = "buff",
          unit = "player"
        }, {
          spell = 126,
          type = "buff",
          unit = "player"
        }, {
          spell = 113858,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 196099,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 266091,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 108366,
          type = "buff",
          unit = "player"
        }, {
          spell = 266030,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 5697,
          type = "buff",
          unit = "player"
        }, {
          spell = 48018,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 111400,
          type = "buff",
          unit = "player",
          talent = 8
        }, {
          spell = 20707,
          type = "buff",
          unit = "group"
        }, {
          spell = 108416,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 117828,
          type = "buff",
          unit = "player"
        }, {
          spell = 7870,
          type = "buff",
          unit = "pet"
        }, {
          spell = 112042,
          type = "buff",
          unit = "pet"
        }, {
          spell = 17767,
          type = "buff",
          unit = "pet"
        }, {
          spell = 108366,
          type = "buff",
          unit = "pet"
        }, {
          spell = 755,
          type = "buff",
          unit = "pet"
        } },
        icon = 136150
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 157736,
          type = "debuff",
          unit = "target"
        }, {
          spell = 22703,
          type = "debuff",
          unit = "target"
        }, {
          spell = 265931,
          type = "debuff",
          unit = "target"
        }, {
          spell = 17735,
          type = "debuff",
          unit = "target"
        }, {
          spell = 118699,
          type = "debuff",
          unit = "target"
        }, {
          spell = 80240,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6789,
          type = "debuff",
          unit = "target",
          talent = 14
        }, {
          spell = 196414,
          type = "debuff",
          unit = "target",
          talent = 2
        }, {
          spell = 234153,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6360,
          type = "debuff",
          unit = "target"
        }, {
          spell = 30283,
          type = "debuff",
          unit = "target"
        }, {
          spell = 710,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 1098,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 6358,
          type = "debuff",
          unit = "target"
        } },
        icon = 135817
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 348,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 698,
          type = "ability"
        }, {
          spell = 710,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 1122,
          type = "ability",
          duration = 30
        }, {
          spell = 3110,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 3716,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 5740,
          type = "ability"
        }, {
          spell = 5782,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 6353,
          type = "ability",
          talent = 3
        }, {
          spell = 6360,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 6789,
          type = "ability",
          requiresTarget = true,
          talent = 14
        }, {
          spell = 7814,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 7870,
          type = "ability"
        }, {
          spell = 17735,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 17767,
          type = "ability"
        }, {
          spell = 17877,
          type = "ability",
          requiresTarget = true,
          charges = true,
          talent = 6
        }, {
          spell = 17962,
          type = "ability",
          requiresTarget = true,
          charges = true
        }, {
          spell = 19647,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 20707,
          type = "ability"
        }, {
          spell = 29722,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 29893,
          type = "ability"
        }, {
          spell = 30283,
          type = "ability"
        }, {
          spell = 48018,
          type = "ability",
          talent = 15
        }, {
          spell = 48020,
          type = "ability",
          talent = 15
        }, {
          spell = 54049,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 80240,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 89792,
          type = "ability"
        }, {
          spell = 89808,
          type = "ability"
        }, {
          spell = 104773,
          type = "ability",
          buff = true
        }, {
          spell = 108416,
          type = "ability",
          buff = true,
          talent = 9
        }, {
          spell = 108503,
          type = "ability",
          talent = 18
        }, {
          spell = 111771,
          type = "ability"
        }, {
          spell = 112042,
          type = "ability"
        }, {
          spell = 113858,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 152108,
          type = "ability",
          talent = 12
        }, {
          spell = 116858,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 196447,
          type = "ability",
          usable = true,
          talent = 20
        }, {
          spell = 234153,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 264993,
          type = "ability"
        }, {
          spell = 6358,
          type = "ability",
          requiresTarget = true
        } },
        icon = 135807
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 287660,
          type = "buff",
          unit = "player"
        }, {
          spell = 279913,
          type = "buff",
          unit = "player"
        }, {
          spell = 279673,
          type = "buff",
          unit = "player"
        }, {
          spell = 280208,
          type = "buff",
          unit = "player"
        }, {
          spell = 275429,
          type = "buff",
          unit = "player"
        }, {
          spell = 274420,
          type = "buff",
          unit = "player"
        }, {
          spell = 278931,
          type = "buff",
          unit = "player"
        }, {
          spell = 277706,
          type = "buff",
          unit = "player"
        }, {
          spell = 287828,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 200587,
          type = "debuff",
          unit = "target",
          pvptalent = 5
        }, {
          spell = 233582,
          type = "debuff",
          unit = "target",
          pvptalent = 6
        }, {
          spell = 285933,
          type = "buff",
          unit = "target",
          pvptalent = 7
        }, {
          spell = 200546,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 200548,
          type = "debuff",
          unit = "target",
          pvptalent = 8,
          titleSuffix = L["debuff"]
        }, {
          spell = 199954,
          type = "ability",
          pvptalent = 9,
          titleSuffix = L["cooldown"]
        }, {
          spell = 199954,
          type = "debuff",
          unit = "target",
          pvptalent = 9,
          titleSuffix = L["debuff"]
        }, {
          spell = 199890,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 199890,
          type = "debuff",
          unit = "target",
          pvptalent = 10,
          titleSuffix = L["debuff"]
        }, {
          spell = 199892,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 199892,
          type = "buff",
          unit = "target",
          pvptalent = 11,
          titleSuffix = L["debuff"]
        }, {
          spell = 212295,
          type = "ability",
          pvptalent = 12,
          titleSuffix = L["cooldown"]
        }, {
          spell = 212295,
          type = "buff",
          unit = "player",
          pvptalent = 12,
          titleSuffix = L["buff"]
        }, {
          spell = 221715,
          type = "debuff",
          unit = "target",
          pvptalent = 13
        }, {
          spell = 221703,
          type = "ability",
          pvptalent = 14,
          titleSuffix = L["cooldown"]
        }, {
          spell = 221705,
          type = "buff",
          unit = "target",
          pvptalent = 14,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_misc_gem_amethyst_02"
      }
    }
  }

  templates.class.MONK = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 116847,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 122278,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 119085,
          type = "buff",
          unit = "player",
          talent = 5
        }, {
          spell = 195630,
          type = "buff",
          unit = "player"
        }, {
          spell = 228563,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 215479,
          type = "buff",
          unit = "player"
        }, {
          spell = 115176,
          type = "buff",
          unit = "player"
        }, {
          spell = 115295,
          type = "buff",
          unit = "player",
          talent = 20
        }, {
          spell = 116841,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 120954,
          type = "buff",
          unit = "player"
        }, {
          spell = 196608,
          type = "buff",
          unit = "player",
          talent = 1
        }, {
          spell = 101643,
          type = "buff",
          unit = "player"
        }, {
          spell = 2479,
          type = "buff",
          unit = "player"
        } },
        icon = 613398
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 119381,
          type = "debuff",
          unit = "target"
        }, {
          spell = 196608,
          type = "debuff",
          unit = "target",
          talent = 1
        }, {
          spell = 113746,
          type = "debuff",
          unit = "target"
        }, {
          spell = 115078,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 117952,
          type = "debuff",
          unit = "target"
        }, {
          spell = 121253,
          type = "debuff",
          unit = "target"
        }, {
          spell = 116189,
          type = "debuff",
          unit = "target"
        }, {
          spell = 124273,
          type = "debuff",
          unit = "player"
        }, {
          spell = 124274,
          type = "debuff",
          unit = "player"
        }, {
          spell = 124275,
          type = "debuff",
          unit = "player"
        } },
        icon = 611419
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 101643,
          type = "ability"
        }, {
          spell = 107079,
          type = "ability"
        }, {
          spell = 109132,
          type = "ability",
          charges = true
        }, {
          spell = 115008,
          type = "ability",
          charges = true,
          talent = 5
        }, {
          spell = 115078,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 115098,
          type = "ability",
          talent = 2
        }, {
          spell = 115176,
          type = "ability",
          buff = true
        }, {
          spell = 115181,
          type = "ability"
        }, {
          spell = 115203,
          type = "ability",
          buff = true
        }, {
          spell = 115295,
          type = "ability",
          talent = 20
        }, {
          spell = 115308,
          type = "ability",
          charges = true,
          buff = true
        }, {
          spell = 115315,
          type = "ability",
          totem = true,
          totemNumber = 1,
          talent = 11
        }, {
          spell = 115399,
          type = "ability",
          talent = 9
        }, {
          spell = 115546,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 116705,
          type = "ability"
        }, {
          spell = 116841,
          type = "ability",
          talent = 3
        }, {
          spell = 116844,
          type = "ability",
          talent = 12
        }, {
          spell = 116847,
          type = "ability",
          buff = true,
          talent = 17
        }, {
          spell = 119381,
          type = "ability"
        }, {
          spell = 119582,
          type = "ability",
          charges = true
        }, {
          spell = 119996,
          type = "ability"
        }, {
          spell = 121253,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 122278,
          type = "ability",
          buff = true,
          talent = 15
        }, {
          spell = 122281,
          type = "ability",
          charges = true,
          buff = true,
          talent = 14
        }, {
          spell = 123986,
          type = "ability",
          talent = 3
        }, {
          spell = 126892,
          type = "ability"
        }, {
          spell = 132578,
          type = "ability",
          requiresTarget = true,
          talent = 18
        }, {
          spell = 205523,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 218164,
          type = "ability"
        } },
        icon = 133701
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 275893,
          type = "buff",
          unit = "player"
        }, {
          spell = 285959,
          type = "buff",
          unit = "player"
        }, {
          spell = 273469,
          type = "buff",
          unit = "player"
        }, {
          spell = 274774,
          type = "buff",
          unit = "player"
        }, {
          spell = 280187,
          type = "buff",
          unit = "player"
        }, {
          spell = 278767,
          type = "buff",
          unit = "player"
        }, {
          spell = 289324,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 202370,
          type = "ability",
          pvptalent = 5
        }, {
          spell = 202335,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202335,
          type = "buff",
          unit = "player",
          pvptalent = 6,
          titleSuffix = L["buff"]
        }, {
          spell = 213658,
          type = "ability",
          pvptalent = 7,
          titleSuffix = L["cooldown"]
        }, {
          spell = 213664,
          type = "buff",
          unit = "player",
          pvptalent = 7,
          titleSuffix = L["buff"]
        }, {
          spell = 202162,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202162,
          type = "buff",
          unit = "group",
          pvptalent = 8,
          titleSuffix = L["buff"]
        }, {
          spell = 207025,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 206891,
          type = "debuff",
          unit = "target",
          pvptalent = 13,
          titleSuffix = L["debuff"]
        }, {
          spell = 202274,
          type = "debuff",
          unit = "target",
          pvptalent = 14
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\monk_stance_drunkenox"
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 119611,
          type = "buff",
          unit = "target"
        }, {
          spell = 196725,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 122783,
          type = "buff",
          unit = "player",
          talent = 14
        }, {
          spell = 116680,
          type = "buff",
          unit = "player"
        }, {
          spell = 243435,
          type = "buff",
          unit = "player"
        }, {
          spell = 124682,
          type = "buff",
          unit = "target"
        }, {
          spell = 116841,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 197908,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 191840,
          type = "buff",
          unit = "player"
        }, {
          spell = 115175,
          type = "buff",
          unit = "target"
        }, {
          spell = 119085,
          type = "buff",
          unit = "player",
          talent = 5
        }, {
          spell = 202090,
          type = "buff",
          unit = "player"
        }, {
          spell = 122278,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 197919,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 116849,
          type = "buff",
          unit = "target"
        }, {
          spell = 101643,
          type = "buff",
          unit = "player"
        }, {
          spell = 197916,
          type = "buff",
          unit = "player",
          talent = 7
        } },
        icon = 627487
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 119381,
          type = "debuff",
          unit = "target"
        }, {
          spell = 115078,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 117952,
          type = "debuff",
          unit = "target"
        }, {
          spell = 116189,
          type = "debuff",
          unit = "target"
        }, {
          spell = 113746,
          type = "debuff",
          unit = "target"
        } },
        icon = 629534
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 100784,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 101643,
          type = "ability"
        }, {
          spell = 107079,
          type = "ability"
        }, {
          spell = 107428,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 109132,
          type = "ability",
          charges = true
        }, {
          spell = 115008,
          type = "ability",
          charges = true,
          talent = 5
        }, {
          spell = 115078,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 115098,
          type = "ability",
          talent = 2
        }, {
          spell = 115151,
          type = "ability",
          charges = true
        }, {
          spell = 115310,
          type = "ability"
        }, {
          spell = 115313,
          type = "ability",
          totem = true,
          totemNumber = 1,
          talent = 16
        }, {
          spell = 115540,
          type = "ability"
        }, {
          spell = 115546,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 116680,
          type = "ability",
          buff = true
        }, {
          spell = 116841,
          type = "ability",
          talent = 6
        }, {
          spell = 116844,
          type = "ability",
          talent = 12
        }, {
          spell = 116849,
          type = "ability"
        }, {
          spell = 119381,
          type = "ability"
        }, {
          spell = 119996,
          type = "ability"
        }, {
          spell = 122278,
          type = "ability",
          buff = true,
          talent = 15
        }, {
          spell = 122281,
          type = "ability",
          charges = true,
          buff = true,
          talent = 13
        }, {
          spell = 122783,
          type = "ability",
          buff = true,
          talent = 14
        }, {
          spell = 123986,
          type = "ability",
          talent = 3
        }, {
          spell = 126892,
          type = "ability"
        }, {
          spell = 191837,
          type = "ability"
        }, {
          spell = 196725,
          type = "ability",
          buff = true,
          talent = 17
        }, {
          spell = 197908,
          type = "ability",
          buff = true,
          talent = 9
        }, {
          spell = 198664,
          type = "ability",
          talent = 18
        }, {
          spell = 198898,
          type = "ability",
          talent = 11
        }, {
          spell = 243435,
          type = "ability",
          buff = true
        } },
        icon = 627485
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 276025,
          type = "buff",
          unit = "player"
        }, {
          spell = 273348,
          type = "buff",
          unit = "target"
        }, {
          spell = 274774,
          type = "buff",
          unit = "player"
        }, {
          spell = 273299,
          type = "debuff",
          unit = "target"
        }, {
          spell = 280187,
          type = "buff",
          unit = "player"
        }, {
          spell = 289324,
          type = "buff",
          unit = "player"
        }, {
          spell = 287837,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 216113,
          type = "ability",
          pvptalent = 5,
          titleSuffix = L["cooldown"]
        }, {
          spell = 216113,
          type = "buff",
          unit = "player",
          pvptalent = 5,
          titleSuffix = L["buff"]
        }, {
          spell = 233759,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["cooldown"]
        }, {
          spell = 233759,
          type = "debuff",
          unit = "target",
          pvptalent = 6,
          titleSuffix = L["debuff"]
        }, {
          spell = 205234,
          type = "ability",
          pvptalent = 8
        }, {
          spell = 227344,
          type = "buff",
          unit = "target",
          pvptalent = 9
        }, {
          spell = 209584,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 209584,
          type = "buff",
          unit = "player",
          pvptalent = 11,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\inv_elemental_mote_mana"
      }
    },
    [3] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 122278,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 125174,
          type = "buff",
          unit = "player"
        }, {
          spell = 119085,
          type = "buff",
          unit = "player",
          talent = 5
        }, {
          spell = 152173,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 261715,
          type = "buff",
          unit = "player",
          talent = 17
        }, {
          spell = 101643,
          type = "buff",
          unit = "player"
        }, {
          spell = 261769,
          type = "buff",
          unit = "player",
          talent = 13
        }, {
          spell = 116841,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 122783,
          type = "buff",
          unit = "player",
          talent = 14
        }, {
          spell = 137639,
          type = "buff",
          unit = "player"
        }, {
          spell = 196741,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 196608,
          type = "buff",
          unit = "player",
          talent = 1
        }, {
          spell = 166646,
          type = "buff",
          unit = "player"
        }, {
          spell = 116768,
          type = "buff",
          unit = "player"
        } },
        icon = 611420
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 115078,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 116189,
          type = "debuff",
          unit = "target"
        }, {
          spell = 115080,
          type = "debuff",
          unit = "target"
        }, {
          spell = 113746,
          type = "debuff",
          unit = "target"
        }, {
          spell = 228287,
          type = "debuff",
          unit = "target"
        }, {
          spell = 115804,
          type = "debuff",
          unit = "target"
        }, {
          spell = 116706,
          type = "debuff",
          unit = "target"
        }, {
          spell = 117952,
          type = "debuff",
          unit = "target"
        }, {
          spell = 196608,
          type = "debuff",
          unit = "target",
          talent = 1
        }, {
          spell = 122470,
          type = "debuff",
          unit = "target"
        }, {
          spell = 119381,
          type = "debuff",
          unit = "target"
        }, {
          spell = 123586,
          type = "debuff",
          unit = "target"
        } },
        icon = 629534
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 100780,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 100784,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 101545,
          type = "ability"
        }, {
          spell = 101546,
          type = "ability"
        }, {
          spell = 101643,
          type = "ability"
        }, {
          spell = 107428,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 109132,
          type = "ability",
          charges = true
        }, {
          spell = 113656,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 115008,
          type = "ability",
          charges = true,
          talent = 5
        }, {
          spell = 115078,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 115080,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 115098,
          type = "ability",
          talent = 2
        }, {
          spell = 115288,
          type = "ability",
          talent = 9
        }, {
          spell = 115546,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 116095,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 116705,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 116841,
          type = "ability",
          talent = 6
        }, {
          spell = 116844,
          type = "ability",
          talent = 12
        }, {
          spell = 119381,
          type = "ability"
        }, {
          spell = 119996,
          type = "ability"
        }, {
          spell = 122278,
          type = "ability",
          buff = true,
          talent = 15
        }, {
          spell = 122470,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 122783,
          type = "ability",
          buff = true,
          talent = 14
        }, {
          spell = 123904,
          type = "ability",
          requiresTarget = true,
          talent = 18
        }, {
          spell = 123986,
          type = "ability",
          talent = 3
        }, {
          spell = 126892,
          type = "ability"
        }, {
          spell = 137639,
          type = "ability",
          charges = true,
          buff = true
        }, {
          spell = 152173,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 152175,
          type = "ability",
          usable = true,
          talent = 20
        }, {
          spell = 218164,
          type = "ability"
        }, {
          spell = 261715,
          type = "ability",
          buff = true,
          talent = 17
        }, {
          spell = 261947,
          type = "ability",
          talent = 8
        } },
        icon = 627606
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 287062,
          type = "buff",
          unit = "player"
        }, {
          spell = 279922,
          type = "buff",
          unit = "player"
        }, {
          spell = 273299,
          type = "debuff",
          unit = "target"
        }, {
          spell = 286587,
          type = "buff",
          unit = "player"
        }, {
          spell = 289324,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 233759,
          type = "ability",
          pvptalent = 4,
          titleSuffix = L["cooldown"]
        }, {
          spell = 233759,
          type = "debuff",
          unit = "target",
          pvptalent = 4,
          titleSuffix = L["debuff"]
        }, {
          spell = 287504,
          type = "buff",
          unit = "player",
          pvptalent = 5,
          titleSuffix = L["buff"]
        }, {
          spell = 290512,
          type = "debuff",
          unit = "target",
          pvptalent = 5,
          titleSuffix = L["debuff"]
        }, {
          spell = 201787,
          type = "debuff",
          unit = "target",
          pvptalent = 7
        }, {
          spell = 287771,
          type = "ability",
          pvptalent = 9
        }, {
          spell = 201447,
          type = "buff",
          unit = "player",
          pvptalent = 11
        }, {
          spell = 201318,
          type = "ability",
          pvptalent = 12,
          titleSuffix = L["cooldown"]
        }, {
          spell = 201318,
          type = "buff",
          unit = "player",
          pvptalent = 12,
          titleSuffix = L["buff"]
        }, {
          spell = 247483,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 248646,
          type = "buff",
          unit = "player",
          pvptalent = 13,
          titleSuffix = L["buff"]
        }, {
          spell = 247483,
          type = "buff",
          unit = "player",
          pvptalent = 13,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\Icons\\ability_monk_healthsphere"
      }
    }
  }

  templates.class.DRUID = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 279709,
          type = "buff",
          unit = "player",
          talent = 14
        }, {
          spell = 22842,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 24858,
          type = "buff",
          unit = "player"
        }, {
          spell = 774,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 202425,
          type = "buff",
          unit = "player",
          talent = 2
        }, {
          spell = 164547,
          type = "buff",
          unit = "player"
        }, {
          spell = 5487,
          type = "buff",
          unit = "player"
        }, {
          spell = 8936,
          type = "buff",
          unit = "player"
        }, {
          spell = 252216,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 194223,
          type = "buff",
          unit = "player"
        }, {
          spell = 191034,
          type = "buff",
          unit = "player"
        }, {
          spell = 102560,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 164545,
          type = "buff",
          unit = "player"
        }, {
          spell = 783,
          type = "buff",
          unit = "player"
        }, {
          spell = 768,
          type = "buff",
          unit = "player"
        }, {
          spell = 202461,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 48438,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 192081,
          type = "buff",
          unit = "player",
          talent = 8
        }, {
          spell = 22812,
          type = "buff",
          unit = "player"
        }, {
          spell = 1850,
          type = "buff",
          unit = "player"
        }, {
          spell = 5215,
          type = "buff",
          unit = "player"
        }, {
          spell = 29166,
          type = "buff",
          unit = "group"
        } },
        icon = 136097
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 155722,
          type = "debuff",
          unit = "target",
          talent = 7
        }, {
          spell = 205644,
          type = "debuff",
          unit = "target",
          talent = 3
        }, {
          spell = 102359,
          type = "debuff",
          unit = "target",
          talent = 11
        }, {
          spell = 339,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 5211,
          type = "debuff",
          unit = "target",
          talent = 10
        }, {
          spell = 1079,
          type = "debuff",
          unit = "target",
          talent = 7
        }, {
          spell = 164815,
          type = "debuff",
          unit = "target"
        }, {
          spell = 202347,
          type = "debuff",
          unit = "target",
          talent = 18
        }, {
          spell = 61391,
          type = "debuff",
          unit = "target",
          talent = 12
        }, {
          spell = 192090,
          type = "debuff",
          unit = "target",
          talent = 8
        }, {
          spell = 164812,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6795,
          type = "debuff",
          unit = "target"
        }, {
          spell = 81261,
          type = "debuff",
          unit = "target"
        }, {
          spell = 2637,
          type = "debuff",
          unit = "multi"
        } },
        icon = 132114
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 768,
          type = "ability"
        }, {
          spell = 783,
          type = "ability"
        }, {
          spell = 1850,
          type = "ability",
          buff = true
        }, {
          spell = 2782,
          type = "ability"
        }, {
          spell = 2908,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 5211,
          type = "ability",
          requiresTarget = true,
          talent = 6
        }, {
          spell = 5215,
          type = "ability",
          buff = true
        }, {
          spell = 5487,
          type = "ability"
        }, {
          spell = 6795,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 8921,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 16979,
          type = "ability",
          requiresTarget = true,
          talent = 6
        }, {
          spell = 18562,
          type = "ability",
          talent = 9
        }, {
          spell = 20484,
          type = "ability"
        }, {
          spell = 22812,
          type = "ability",
          buff = true
        }, {
          spell = 22842,
          type = "ability",
          buff = true,
          talent = 8
        }, {
          spell = 24858,
          type = "ability"
        }, {
          spell = 29166,
          type = "ability",
          buff = true
        }, {
          spell = 33917,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 48438,
          type = "ability",
          talent = 9
        }, {
          spell = 49376,
          type = "ability",
          requiresTarget = true,
          talent = 6
        }, {
          spell = 77758,
          type = "ability",
          talent = 8
        }, {
          spell = 78674,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 78675,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 93402,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 102359,
          type = "ability",
          requiresTarget = true,
          talent = 11
        }, {
          spell = 102383,
          type = "ability",
          talent = 6
        }, {
          spell = 102401,
          type = "ability",
          talent = 6
        }, {
          spell = 102560,
          type = "ability",
          buff = true,
          talent = 15
        }, {
          spell = 108238,
          type = "ability",
          talent = 9
        }, {
          spell = 132469,
          type = "ability",
          talent = 12
        }, {
          spell = 190984,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 191034,
          type = "ability",
          duration = 8
        }, {
          spell = 192081,
          type = "ability",
          buff = true,
          talent = 8
        }, {
          spell = 194153,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 194223,
          type = "ability"
        }, {
          spell = 202347,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 202425,
          type = "ability",
          buff = true,
          talent = 2
        }, {
          spell = 202770,
          type = "ability",
          buff = true,
          talent = 20
        }, {
          spell = 205636,
          type = "ability",
          duration = 10,
          talent = 3
        }, {
          spell = 252216,
          type = "ability",
          buff = true,
          talent = 4
        }, {
          spell = 274281,
          type = "ability",
          requiresTarget = true,
          charges = true,
          target = true,
          talent = 21
        } },
        icon = 132134
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 276154,
          type = "buff",
          unit = "player"
        }, {
          spell = 279648,
          type = "buff",
          unit = "player"
        }, {
          spell = 269380,
          type = "buff",
          unit = "player"
        }, {
          spell = 274814,
          type = "buff",
          unit = "player"
        }, {
          spell = 272871,
          type = "buff",
          unit = "player"
        }, {
          spell = 287790,
          type = "buff",
          unit = "player"
        }, {
          spell = 280165,
          type = "buff",
          unit = "player"
        }, {
          spell = 287809,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 305497,
          type = "ability",
          pvptalent = 4,
          titleSuffix = L["cooldown"]
        }, {
          spell = 305497,
          type = "buff",
          unit = "target",
          pvptalent = 4,
          titleSuffix = L["buff"]
        }, {
          spell = 209731,
          type = "buff",
          unit = "player",
          pvptalent = 5
        }, {
          spell = 209749,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["cooldown"]
        }, {
          spell = 209749,
          type = "debuff",
          unit = "target",
          pvptalent = 6,
          titleSuffix = L["debuff"]
        }, {
          spell = 209753,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 209753,
          type = "debuff",
          unit = "target",
          pvptalent = 11,
          titleSuffix = L["debuff"]
        }, {
          spell = 234084,
          type = "buff",
          unit = "player",
          pvptalent = 14
        }, {
          spell = 209746,
          type = "buff",
          unit = "player",
          pvptalent = 15
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources and Shapeshift Form"],
        args = {},
        icon = "Interface\\Icons\\ability_druid_eclipseorange"
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 106951,
          type = "buff",
          unit = "player"
        }, {
          spell = 61336,
          type = "buff",
          unit = "player"
        }, {
          spell = 22842,
          type = "buff",
          unit = "player",
          talent = 8
        }, {
          spell = 5215,
          type = "buff",
          unit = "player"
        }, {
          spell = 774,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 164547,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 5487,
          type = "buff",
          unit = "player"
        }, {
          spell = 8936,
          type = "buff",
          unit = "player"
        }, {
          spell = 145152,
          type = "buff",
          unit = "player",
          talent = 20
        }, {
          spell = 252216,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 52610,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 48438,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 106898,
          type = "buff",
          unit = "player"
        }, {
          spell = 5217,
          type = "buff",
          unit = "player"
        }, {
          spell = 252071,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 164545,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 783,
          type = "buff",
          unit = "player"
        }, {
          spell = 768,
          type = "buff",
          unit = "player"
        }, {
          spell = 69369,
          type = "buff",
          unit = "player"
        }, {
          spell = 135700,
          type = "buff",
          unit = "player"
        }, {
          spell = 102543,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 192081,
          type = "buff",
          unit = "player",
          talent = 8
        }, {
          spell = 1850,
          type = "buff",
          unit = "player"
        }, {
          spell = 197625,
          type = "buff",
          unit = "player",
          talent = 7
        } },
        icon = 136170
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 164812,
          type = "debuff",
          unit = "target"
        }, {
          spell = 102359,
          type = "debuff",
          unit = "target",
          talent = 11
        }, {
          spell = 106830,
          type = "debuff",
          unit = "target"
        }, {
          spell = 339,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 274838,
          type = "debuff",
          unit = "target",
          talent = 21
        }, {
          spell = 58180,
          type = "debuff",
          unit = "target"
        }, {
          spell = 1079,
          type = "debuff",
          unit = "target"
        }, {
          spell = 164815,
          type = "debuff",
          unit = "target",
          talent = 7
        }, {
          spell = 61391,
          type = "debuff",
          unit = "target",
          talent = 12
        }, {
          spell = 5211,
          type = "debuff",
          unit = "target",
          talent = 10
        }, {
          spell = 155625,
          type = "debuff",
          unit = "target",
          talent = 7
        }, {
          spell = 203123,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6795,
          type = "debuff",
          unit = "target"
        }, {
          spell = 155722,
          type = "debuff",
          unit = "target"
        }, {
          spell = 2637,
          type = "debuff",
          unit = "multi"
        } },
        icon = 132152
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 339,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 768,
          type = "ability"
        }, {
          spell = 783,
          type = "ability"
        }, {
          spell = 2637,
          type = "ability"
        }, {
          spell = 1822,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 1850,
          type = "ability",
          buff = true
        }, {
          spell = 2782,
          type = "ability"
        }, {
          spell = 2908,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 5211,
          type = "ability",
          requiresTarget = true,
          talent = 10
        }, {
          spell = 5215,
          type = "ability",
          buff = true
        }, {
          spell = 5217,
          type = "ability",
          buff = true
        }, {
          spell = 5221,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 5487,
          type = "ability"
        }, {
          spell = 6795,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 8921,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 8936,
          type = "ability",
          overlayGlow = true
        }, {
          spell = 1079,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 16979,
          type = "ability",
          requiresTarget = true,
          talent = 6
        }, {
          spell = 18562,
          type = "ability",
          talent = 9
        }, {
          spell = 20484,
          type = "ability"
        }, {
          spell = 22568,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 22570,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 22842,
          type = "ability",
          buff = true,
          talent = 8
        }, {
          spell = 33917,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 48438,
          type = "ability",
          talent = 9
        }, {
          spell = 49376,
          type = "ability",
          requiresTarget = true,
          talent = 6
        }, {
          spell = 61336,
          type = "ability",
          charges = true,
          buff = true
        }, {
          spell = 102359,
          type = "ability",
          requiresTarget = true,
          talent = 11
        }, {
          spell = 102401,
          type = "ability",
          talent = 6
        }, {
          spell = 102543,
          type = "ability",
          buff = true,
          talent = 15
        }, {
          spell = 106830,
          type = "ability",
          overlayGlow = true
        }, {
          spell = 106839,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 106898,
          type = "ability",
          buff = true
        }, {
          spell = 106951,
          type = "ability"
        }, {
          spell = 108238,
          type = "ability",
          talent = 5
        }, {
          spell = 132469,
          type = "ability",
          talent = 12
        }, {
          spell = 192081,
          type = "ability",
          buff = true,
          talent = 8
        }, {
          spell = 197625,
          type = "ability",
          talent = 7
        }, {
          spell = 197626,
          type = "ability",
          requiresTarget = true,
          talent = 7
        }, {
          spell = 202028,
          type = "ability",
          charges = true,
          overlayGlow = true,
          talent = 17
        }, {
          spell = 252216,
          type = "ability",
          buff = true,
          talent = 4
        }, {
          spell = 274837,
          type = "ability",
          requiresTarget = true,
          talent = 21
        } },
        icon = 236149
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 276026,
          type = "buff",
          unit = "player"
        }, {
          spell = 272753,
          type = "buff",
          unit = "player"
        }, {
          spell = 274814,
          type = "buff",
          unit = "player"
        }, {
          spell = 274426,
          type = "buff",
          unit = "player"
        }, {
          spell = 280165,
          type = "buff",
          unit = "player"
        }, {
          spell = 287809,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 203059,
          type = "buff",
          unit = "player",
          pvptalent = 5
        }, {
          spell = 236021,
          type = "debuff",
          unit = "target",
          pvptalent = 6
        }, {
          spell = 203242,
          type = "ability",
          pvptalent = 8
        }, {
          spell = 202636,
          type = "buff",
          unit = "player",
          pvptalent = 9
        }, {
          spell = 209731,
          type = "buff",
          unit = "player",
          pvptalent = 10
        }, {
          spell = 33786,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 33786,
          type = "debuff",
          unit = "target",
          pvptalent = 13,
          titleSuffix = L["debuff"]
        }, {
          spell = 305497,
          type = "ability",
          pvptalent = 14,
          titleSuffix = L["cooldown"]
        }, {
          spell = 305497,
          type = "buff",
          unit = "group",
          pvptalent = 14,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources and Shapeshift Form"],
        args = {},
        icon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01"
      }
    },
    [3] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 155835,
          type = "buff",
          unit = "player",
          talent = 3
        }, {
          spell = 61336,
          type = "buff",
          unit = "player"
        }, {
          spell = 22842,
          type = "buff",
          unit = "player"
        }, {
          spell = 5215,
          type = "buff",
          unit = "player"
        }, {
          spell = 774,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 203975,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 164547,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 5487,
          type = "buff",
          unit = "player"
        }, {
          spell = 8936,
          type = "buff",
          unit = "player"
        }, {
          spell = 93622,
          type = "buff",
          unit = "player"
        }, {
          spell = 158792,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 213680,
          type = "buff",
          unit = "player",
          talent = 18
        }, {
          spell = 102558,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 213708,
          type = "buff",
          unit = "player",
          talent = 14
        }, {
          spell = 48438,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 77764,
          type = "buff",
          unit = "player"
        }, {
          spell = 783,
          type = "buff",
          unit = "player"
        }, {
          spell = 192081,
          type = "buff",
          unit = "player"
        }, {
          spell = 164545,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 197625,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 252216,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 22812,
          type = "buff",
          unit = "player"
        }, {
          spell = 1850,
          type = "buff",
          unit = "player"
        }, {
          spell = 768,
          type = "buff",
          unit = "player"
        } },
        icon = 1378702
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 164812,
          type = "debuff",
          unit = "target"
        }, {
          spell = 102359,
          type = "debuff",
          unit = "target",
          talent = 11
        }, {
          spell = 339,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 5211,
          type = "debuff",
          unit = "target",
          talent = 10
        }, {
          spell = 61391,
          type = "debuff",
          unit = "target",
          talent = 12
        }, {
          spell = 1079,
          type = "debuff",
          unit = "target",
          talent = 8
        }, {
          spell = 164815,
          type = "debuff",
          unit = "target",
          talent = 7
        }, {
          spell = 45334,
          type = "debuff",
          unit = "target",
          talent = 6
        }, {
          spell = 155722,
          type = "debuff",
          unit = "target",
          talent = 8
        }, {
          spell = 99,
          type = "debuff",
          unit = "target"
        }, {
          spell = 236748,
          type = "debuff",
          unit = "target",
          talent = 5
        }, {
          spell = 6795,
          type = "debuff",
          unit = "target"
        }, {
          spell = 192090,
          type = "debuff",
          unit = "target"
        } },
        icon = 451161
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 99,
          type = "ability"
        }, {
          spell = 768,
          type = "ability"
        }, {
          spell = 783,
          type = "ability"
        }, {
          spell = 2908,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 1850,
          type = "ability",
          buff = true
        }, {
          spell = 2782,
          type = "ability"
        }, {
          spell = 5211,
          type = "ability",
          requiresTarget = true,
          talent = 10
        }, {
          spell = 5215,
          type = "ability",
          buff = true
        }, {
          spell = 5487,
          type = "ability"
        }, {
          spell = 6795,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 6807,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 8921,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 16979,
          type = "ability",
          requiresTarget = true,
          talent = 6
        }, {
          spell = 18562,
          type = "ability",
          talent = 9
        }, {
          spell = 18576,
          type = "ability",
          requiresTarget = true,
          talent = 11
        }, {
          spell = 20484,
          type = "ability"
        }, {
          spell = 22812,
          type = "ability",
          buff = true
        }, {
          spell = 22842,
          type = "ability",
          charges = true,
          buff = true
        }, {
          spell = 33917,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 48438,
          type = "ability",
          talent = 9
        }, {
          spell = 49376,
          type = "ability",
          requiresTarget = true,
          talent = 6
        }, {
          spell = 61336,
          type = "ability",
          charges = true,
          buff = true
        }, {
          spell = 77758,
          type = "ability"
        }, {
          spell = 77761,
          type = "ability",
          buff = true
        }, {
          spell = 80313,
          type = "ability",
          buff = true,
          requiresTarget = true
        }, {
          spell = 102359,
          type = "ability",
          requiresTarget = true,
          talent = 11
        }, {
          spell = 102383,
          type = "ability",
          talent = 6
        }, {
          spell = 102401,
          type = "ability",
          talent = 6
        }, {
          spell = 102558,
          type = "ability",
          buff = true,
          talent = 15
        }, {
          spell = 106839,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 106898,
          type = "ability"
        }, {
          spell = 132469,
          type = "ability",
          talent = 12
        }, {
          spell = 155835,
          type = "ability",
          buff = true,
          talent = 3
        }, {
          spell = 192081,
          type = "ability",
          buff = true
        }, {
          spell = 197625,
          type = "ability",
          talent = 7
        }, {
          spell = 197626,
          type = "ability",
          requiresTarget = true,
          talent = 7
        }, {
          spell = 204066,
          type = "ability",
          talent = 20
        }, {
          spell = 236748,
          type = "ability",
          talent = 5
        }, {
          spell = 252216,
          type = "ability",
          buff = true,
          talent = 4
        } },
        icon = 236169
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 289315,
          type = "buff",
          unit = "player"
        }, {
          spell = 279793,
          type = "buff",
          unit = "player"
        }, {
          spell = 279541,
          type = "buff",
          unit = "player"
        }, {
          spell = 272764,
          type = "buff",
          unit = "player"
        }, {
          spell = 279555,
          type = "buff",
          unit = "player"
        }, {
          spell = 273349,
          type = "buff",
          unit = "player"
        }, {
          spell = 274814,
          type = "buff",
          unit = "player"
        }, {
          spell = 275909,
          type = "buff",
          unit = "player"
        }, {
          spell = 280165,
          type = "buff",
          unit = "player"
        }, {
          spell = 287809,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 279943,
          type = "buff",
          unit = "target",
          pvptalent = 4
        }, {
          spell = 201664,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 201664,
          type = "debuff",
          unit = "target",
          pvptalent = 8,
          titleSuffix = L["debuff"]
        }, {
          spell = 236187,
          type = "buff",
          unit = "player",
          pvptalent = 11,
          titleSuffix = L["buff"]
        }, {
          spell = 236185,
          type = "buff",
          unit = "player",
          pvptalent = 11,
          titleSuffix = L["buff"]
        }, {
          spell = 207017,
          type = "ability",
          pvptalent = 12,
          titleSuffix = L["cooldown"]
        }, {
          spell = 206891,
          type = "debuff",
          unit = "target",
          pvptalent = 12,
          titleSuffix = L["debuff"]
        }, {
          spell = 202246,
          type = "ability",
          pvptalent = 16,
          titleSuffix = L["cooldown"]
        }, {
          spell = 202244,
          type = "debuff",
          unit = "target",
          pvptalent = 16,
          titleSuffix = L["debuff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources and Shapeshift Form"],
        args = {},
        icon = "Interface\\Icons\\spell_misc_emotionangry"
      }
    },
    [4] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 207640,
          type = "buff",
          unit = "player",
          talent = 1
        }, {
          spell = 157982,
          type = "buff",
          unit = "player"
        }, {
          spell = 29166,
          type = "buff",
          unit = "player"
        }, {
          spell = 200389,
          type = "buff",
          unit = "player",
          talent = 14
        }, {
          spell = 5215,
          type = "buff",
          unit = "player"
        }, {
          spell = 774,
          type = "buff",
          unit = "target"
        }, {
          spell = 155777,
          type = "buff",
          unit = "target",
          talent = 20
        }, {
          spell = 164547,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 197721,
          type = "buff",
          unit = "target",
          talent = 21
        }, {
          spell = 117679,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 5487,
          type = "buff",
          unit = "player"
        }, {
          spell = 8936,
          type = "buff",
          unit = "target"
        }, {
          spell = 197625,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 207386,
          type = "buff",
          unit = "target",
          talent = 18
        }, {
          spell = 252216,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 22812,
          type = "buff",
          unit = "target"
        }, {
          spell = 33763,
          type = "buff",
          unit = "target"
        }, {
          spell = 102401,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 192081,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 22842,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 33891,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 164545,
          type = "buff",
          unit = "player",
          talent = 7
        }, {
          spell = 783,
          type = "buff",
          unit = "player"
        }, {
          spell = 16870,
          type = "buff",
          unit = "player"
        }, {
          spell = 102351,
          type = "buff",
          unit = "player",
          talent = 3
        }, {
          spell = 102342,
          type = "buff",
          unit = "player"
        }, {
          spell = 1850,
          type = "buff",
          unit = "player"
        }, {
          spell = 114108,
          type = "buff",
          unit = "player",
          talent = 13
        }, {
          spell = 48438,
          type = "buff",
          unit = "player"
        }, {
          spell = 768,
          type = "buff",
          unit = "player"
        } },
        icon = 136081
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 127797,
          type = "debuff",
          unit = "target"
        }, {
          spell = 102359,
          type = "debuff",
          unit = "target",
          talent = 11
        }, {
          spell = 339,
          type = "debuff",
          unit = "multi"
        }, {
          spell = 5211,
          type = "debuff",
          unit = "target",
          talent = 10
        }, {
          spell = 1079,
          type = "debuff",
          unit = "target",
          talent = 8
        }, {
          spell = 164815,
          type = "debuff",
          unit = "target"
        }, {
          spell = 61391,
          type = "debuff",
          unit = "target",
          talent = 12
        }, {
          spell = 192090,
          type = "debuff",
          unit = "target",
          talent = 9
        }, {
          spell = 164812,
          type = "debuff",
          unit = "target"
        }, {
          spell = 6795,
          type = "debuff",
          unit = "target"
        }, {
          spell = 155722,
          type = "debuff",
          unit = "target",
          talent = 8
        }, {
          spell = 2637,
          type = "debuff",
          unit = "multi"
        } },
        icon = 236216
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 740,
          type = "ability"
        }, {
          spell = 768,
          type = "ability"
        }, {
          spell = 783,
          type = "ability"
        }, {
          spell = 1850,
          type = "ability",
          buff = true
        }, {
          spell = 2637,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 2908,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 5211,
          type = "ability",
          requiresTarget = true,
          talent = 10
        }, {
          spell = 5215,
          type = "ability",
          buff = true
        }, {
          spell = 5487,
          type = "ability"
        }, {
          spell = 6795,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 18562,
          type = "ability"
        }, {
          spell = 20484,
          type = "ability"
        }, {
          spell = 22812,
          type = "ability",
          buff = true
        }, {
          spell = 22842,
          type = "ability",
          buff = true,
          talent = 9
        }, {
          spell = 29166,
          type = "ability",
          buff = true
        }, {
          spell = 33891,
          type = "ability",
          buff = true,
          talent = 15
        }, {
          spell = 33917,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 48438,
          type = "ability"
        }, {
          spell = 77758,
          type = "ability",
          talent = 9
        }, {
          spell = 88423,
          type = "ability"
        }, {
          spell = 102342,
          type = "ability"
        }, {
          spell = 102351,
          type = "ability",
          talent = 3
        }, {
          spell = 102359,
          type = "ability",
          requiresTarget = true,
          talent = 11
        }, {
          spell = 102401,
          type = "ability",
          talent = 6
        }, {
          spell = 102793,
          type = "ability"
        }, {
          spell = 108238,
          type = "ability",
          talent = 5
        }, {
          spell = 132469,
          type = "ability",
          talent = 12
        }, {
          spell = 192081,
          type = "ability",
          buff = true,
          talent = 9
        }, {
          spell = 197625,
          type = "ability",
          talent = 7
        }, {
          spell = 197626,
          type = "ability",
          requiresTarget = true,
          talent = 7
        }, {
          spell = 197721,
          type = "ability",
          talent = 21
        }, {
          spell = 252216,
          type = "ability",
          buff = true,
          talent = 4
        } },
        icon = 236153
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 279793,
          type = "buff",
          unit = "target"
        }, {
          spell = 279648,
          type = "buff",
          unit = "player"
        }, {
          spell = 274814,
          type = "buff",
          unit = "player"
        }, {
          spell = 269498,
          type = "buff",
          unit = "player"
        }, {
          spell = 280165,
          type = "buff",
          unit = "player"
        }, {
          spell = 287809,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 289022,
          type = "ability",
          pvptalent = 4
        }, {
          spell = 203407,
          type = "buff",
          unit = "target",
          pvptalent = 5
        }, {
          spell = 247563,
          type = "buff",
          unit = "group",
          pvptalent = 6
        }, {
          spell = 305497,
          type = "ability",
          pvptalent = 7,
          titleSuffix = L["cooldown"]
        }, {
          spell = 305497,
          type = "buff",
          unit = "group",
          pvptalent = 7,
          titleSuffix = L["buff"]
        }, {
          spell = 203554,
          type = "buff",
          unit = "target",
          pvptalent = 9
        }, {
          spell = 200947,
          type = "debuff",
          unit = "target",
          pvptalent = 10
        }, {
          spell = 203651,
          type = "ability",
          pvptalent = 11
        }, {
          spell = 290213,
          type = "buff",
          unit = "target",
          pvptalent = 12
        }, {
          spell = 33786,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["cooldown"]
        }, {
          spell = 33786,
          type = "debuff",
          unit = "target",
          pvptalent = 13,
          titleSuffix = L["debuff"]
        }, {
          spell = 236187,
          type = "buff",
          unit = "player",
          pvptalent = 14
        }, {
          spell = 289318,
          type = "buff",
          unit = "group",
          pvptalent = 15
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources and Shapeshift Form"],
        args = {},
        icon = "Interface\\Icons\\inv_elemental_mote_mana"
      }
    }
  }

  templates.class.DEMONHUNTER = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 208628,
          type = "buff",
          unit = "player",
          talent = 20
        }, {
          spell = 162264,
          type = "buff",
          unit = "player"
        }, {
          spell = 203650,
          type = "buff",
          unit = "player",
          talent = 20
        }, {
          spell = 188499,
          type = "buff",
          unit = "player"
        }, {
          spell = 212800,
          type = "buff",
          unit = "player"
        }, {
          spell = 196555,
          type = "buff",
          unit = "player",
          talent = 12
        }, {
          spell = 258920,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 131347,
          type = "buff",
          unit = "player"
        }, {
          spell = 188501,
          type = "buff",
          unit = "player"
        }, {
          spell = 209426,
          type = "buff",
          unit = "player"
        } },
        icon = 1247266
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 1490,
          type = "debuff",
          unit = "target"
        }, {
          spell = 258883,
          type = "debuff",
          unit = "target",
          talent = 7
        }, {
          spell = 213405,
          type = "debuff",
          unit = "target",
          talent = 17
        }, {
          spell = 179057,
          type = "debuff",
          unit = "target"
        }, {
          spell = 281854,
          type = "debuff",
          unit = "target"
        }, {
          spell = 200166,
          type = "debuff",
          unit = "target"
        }, {
          spell = 206491,
          type = "debuff",
          unit = "target",
          talent = 21
        }, {
          spell = 198813,
          type = "debuff",
          unit = "target"
        }, {
          spell = 258860,
          type = "debuff",
          unit = "target",
          talent = 15
        }, {
          spell = 211881,
          type = "debuff",
          unit = "target",
          talent = 18
        }, {
          spell = 217832,
          type = "debuff",
          unit = "multi"
        } },
        icon = 1392554
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 131347,
          type = "ability"
        }, {
          spell = 179057,
          type = "ability"
        }, {
          spell = 183752,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 185123,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 188499,
          type = "ability"
        }, {
          spell = 188501,
          type = "ability"
        }, {
          spell = 191427,
          type = "ability",
          buff = true
        }, {
          spell = 195072,
          type = "ability",
          charges = true
        }, {
          spell = 196555,
          type = "ability",
          buff = true,
          talent = 12
        }, {
          spell = 196718,
          type = "ability"
        }, {
          spell = 198013,
          type = "ability"
        }, {
          spell = 198589,
          type = "ability",
          buff = true
        }, {
          spell = 198793,
          type = "ability"
        }, {
          spell = 206491,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 210152,
          type = "ability"
        }, {
          spell = 211881,
          type = "ability",
          talent = 18
        }, {
          spell = 217832,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 232893,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true,
          talent = 3
        }, {
          spell = 258860,
          type = "ability",
          debuff = true,
          requiresTarget = true,
          talent = 15
        }, {
          spell = 258920,
          type = "ability",
          buff = true,
          talent = 6
        }, {
          spell = 258925,
          type = "ability",
          talent = 9
        }, {
          spell = 278326,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 281854,
          type = "ability",
          debuff = true,
          requiresTarget = true
        } },
        icon = 1305156
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 272794,
          type = "buff",
          unit = "player"
        }, {
          spell = 273232,
          type = "buff",
          unit = "player"
        }, {
          spell = 279584,
          type = "buff",
          unit = "player"
        }, {
          spell = 274346,
          type = "buff",
          unit = "player"
        }, {
          spell = 278736,
          type = "buff",
          unit = "player"
        }, {
          spell = 275936,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 205604,
          type = "ability",
          pvptalent = 5
        }, {
          spell = 206649,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["cooldown"]
        }, {
          spell = 206649,
          type = "debuff",
          unit = "target",
          pvptalent = 6,
          titleSuffix = L["debuff"]
        }, {
          spell = 235903,
          type = "ability",
          pvptalent = 7
        }, {
          spell = 203704,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 203704,
          type = "debuff",
          unit = "target",
          pvptalent = 8,
          titleSuffix = L["debuff"]
        }, {
          spell = 211510,
          type = "buff",
          unit = "target",
          pvptalent = 13
        }, {
          spell = 206803,
          type = "ability",
          pvptalent = 14,
          titleSuffix = L["cooldown"]
        }, {
          spell = 206803,
          type = "buff",
          unit = "player",
          pvptalent = 14,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = 1344651
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 187827,
          type = "buff",
          unit = "player"
        }, {
          spell = 263648,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 207693,
          type = "buff",
          unit = "player",
          talent = 4
        }, {
          spell = 131347,
          type = "buff",
          unit = "player"
        }, {
          spell = 203981,
          type = "buff",
          unit = "player"
        }, {
          spell = 188501,
          type = "buff",
          unit = "player"
        }, {
          spell = 203819,
          type = "buff",
          unit = "player"
        }, {
          spell = 178740,
          type = "buff",
          unit = "player"
        } },
        icon = 1247263
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 207744,
          type = "debuff",
          unit = "target"
        }, {
          spell = 1490,
          type = "debuff",
          unit = "target"
        }, {
          spell = 204598,
          type = "debuff",
          unit = "target"
        }, {
          spell = 268178,
          type = "debuff",
          unit = "target",
          talent = 20
        }, {
          spell = 204490,
          type = "debuff",
          unit = "target"
        }, {
          spell = 204843,
          type = "debuff",
          unit = "target",
          talent = 15
        }, {
          spell = 207771,
          type = "debuff",
          unit = "target",
          talent = 6
        }, {
          spell = 247456,
          type = "debuff",
          unit = "target",
          talent = 17
        }, {
          spell = 210003,
          type = "debuff",
          unit = "target",
          talent = 3
        }, {
          spell = 207685,
          type = "debuff",
          unit = "target"
        }, {
          spell = 185245,
          type = "debuff",
          unit = "target"
        }, {
          spell = 217832,
          type = "debuff",
          unit = "multi"
        } },
        icon = 1344647
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 131347,
          type = "ability"
        }, {
          spell = 178740,
          type = "ability",
          buff = true
        }, {
          spell = 183752,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 185245,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 187827,
          type = "ability",
          buff = true
        }, {
          spell = 188501,
          type = "ability"
        }, {
          spell = 189110,
          type = "ability",
          charges = true
        }, {
          spell = 202137,
          type = "ability"
        }, {
          spell = 202138,
          type = "ability",
          talent = 15
        }, {
          spell = 202140,
          type = "ability"
        }, {
          spell = 203720,
          type = "ability",
          charges = true,
          buff = true
        }, {
          spell = 204021,
          type = "ability",
          debuff = true,
          requiresTarget = true
        }, {
          spell = 204157,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 204513,
          type = "ability"
        }, {
          spell = 212084,
          type = "ability",
          talent = 18
        }, {
          spell = 217832,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 228477,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 232893,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true,
          talent = 9
        }, {
          spell = 247454,
          type = "ability",
          usable = true,
          talent = 17
        }, {
          spell = 263642,
          type = "ability",
          charges = true,
          talent = 12
        }, {
          spell = 263648,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 278326,
          type = "ability",
          requiresTarget = true
        } },
        icon = 1344650
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 278769,
          type = "buff",
          unit = "player"
        }, {
          spell = 272794,
          type = "buff",
          unit = "player"
        }, {
          spell = 288882,
          type = "buff",
          unit = "player"
        }, {
          spell = 273238,
          type = "buff",
          unit = "player"
        }, {
          spell = 272987,
          type = "buff",
          unit = "player"
        }, {
          spell = 275351,
          type = "buff",
          unit = "player"
        }, {
          spell = 275936,
          type = "buff",
          unit = "player"
        }, {
          spell = 274346,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 205629,
          type = "ability",
          pvptalent = 5,
          titleSuffix = L["cooldown"]
        }, {
          spell = 213491,
          type = "debuff",
          unit = "target",
          pvptalent = 5,
          titleSuffix = L["debuff"]
        }, {
          spell = 208769,
          type = "buff",
          unit = "player",
          pvptalent = 7
        }, {
          spell = 207029,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 206891,
          type = "debuff",
          unit = "target",
          pvptalent = 11,
          titleSuffix = L["debuff"]
        }, {
          spell = 211510,
          type = "buff",
          unit = "target",
          pvptalent = 12
        }, {
          spell = 205630,
          type = "ability",
          pvptalent = 14,
          titleSuffix = L["cooldown"]
        }, {
          spell = 205630,
          type = "debuff",
          unit = "target",
          pvptalent = 14,
          titleSuffix = L["debuff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = 1247265
      }
    }
  }

  templates.class.DEATHKNIGHT = {
    [1] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 81256,
          type = "buff",
          unit = "player"
        }, {
          spell = 55233,
          type = "buff",
          unit = "player"
        }, {
          spell = 3714,
          type = "buff",
          unit = "player"
        }, {
          spell = 194679,
          type = "buff",
          unit = "player",
          talent = 12
        }, {
          spell = 48265,
          type = "buff",
          unit = "player"
        }, {
          spell = 219809,
          type = "buff",
          unit = "player",
          talent = 9
        }, {
          spell = 188290,
          type = "buff",
          unit = "player"
        }, {
          spell = 273947,
          type = "buff",
          unit = "player",
          talent = 5
        }, {
          spell = 48707,
          type = "buff",
          unit = "player"
        }, {
          spell = 81141,
          type = "buff",
          unit = "player"
        }, {
          spell = 195181,
          type = "buff",
          unit = "player"
        }, {
          spell = 194844,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 274009,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 53365,
          type = "buff",
          unit = "player"
        }, {
          spell = 77535,
          type = "buff",
          unit = "player"
        }, {
          spell = 212552,
          type = "buff",
          unit = "player",
          talent = 15
        }, {
          spell = 48792,
          type = "buff",
          unit = "player"
        } },
        icon = 237517
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 206930,
          type = "debuff",
          unit = "target"
        }, {
          spell = 206931,
          type = "debuff",
          unit = "target",
          talent = 2
        }, {
          spell = 221562,
          type = "debuff",
          unit = "target"
        }, {
          spell = 273977,
          type = "debuff",
          unit = "target",
          talent = 13
        }, {
          spell = 55078,
          type = "debuff",
          unit = "target"
        }, {
          spell = 56222,
          type = "debuff",
          unit = "target"
        }, {
          spell = 51399,
          type = "debuff",
          unit = "target"
        }, {
          spell = 114556,
          type = "debuff",
          unit = "player",
          talent = 19
        } },
        icon = 237514
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 3714,
          type = "ability",
          buff = true
        }, {
          spell = 43265,
          type = "ability",
          buff = true,
          buffId = 188290,
          overlayGlow = true
        }, {
          spell = 47528,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 48265,
          type = "ability",
          buff = true
        }, {
          spell = 48707,
          type = "ability",
          buff = true
        }, {
          spell = 48792,
          type = "ability",
          buff = true
        }, {
          spell = 49028,
          type = "ability",
          buff = true
        }, {
          spell = 49576,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 50842,
          type = "ability",
          charges = true
        }, {
          spell = 50977,
          type = "ability"
        }, {
          spell = 55233,
          type = "ability",
          buff = true
        }, {
          spell = 56222,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 61999,
          type = "ability"
        }, {
          spell = 108199,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 111673,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          unit = "pet"
        }, {
          spell = 194679,
          type = "ability",
          charges = true,
          buff = true,
          talent = 12
        }, {
          spell = 194844,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 195182,
          type = "ability",
          buff = true,
          buffId = 195181,
          requiresTarget = true
        }, {
          spell = 195292,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 206930,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 206931,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 2
        }, {
          spell = 206940,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 18
        }, {
          spell = 210764,
          type = "ability",
          requiresTarget = true,
          charges = true,
          talent = 3
        }, {
          spell = 212552,
          type = "ability",
          buff = true,
          talent = 15
        }, {
          spell = 219809,
          type = "ability",
          usable = true,
          buff = true,
          talent = 9
        }, {
          spell = 221562,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 274156,
          type = "ability",
          talent = 6
        } },
        icon = 136120
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 289349,
          type = "buff",
          unit = "player"
        }, {
          spell = 279503,
          type = "buff",
          unit = "player"
        }, {
          spell = 278543,
          type = "buff",
          unit = "player"
        }, {
          spell = 288426,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 203173,
          type = "ability",
          pvptalent = 4,
          titleSuffix = L["cooldown"]
        }, {
          spell = 203173,
          type = "debuff",
          unit = "target",
          pvptalent = 4,
          titleSuffix = L["buff"]
        }, {
          spell = 233411,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["cooldown"]
        }, {
          spell = 233411,
          type = "buff",
          unit = "player",
          pvptalent = 6,
          titleSuffix = L["buff"]
        }, {
          spell = 207018,
          type = "ability",
          pvptalent = 7
        }, {
          spell = 206891,
          type = "debuff",
          unit = "target",
          pvptalent = 7
        }, {
          spell = 47476,
          type = "ability",
          pvptalent = 8,
          titleSuffix = L["cooldown"]
        }, {
          spell = 47476,
          type = "debuff",
          unit = "target",
          pvptalent = 8,
          titleSuffix = L["buff"]
        }, {
          spell = 212610,
          type = "debuff",
          unit = "target",
          pvptalent = 9
        }, {
          spell = 214968,
          type = "debuff",
          unit = "target",
          pvptalent = 11
        }, {
          spell = 199721,
          type = "debuff",
          unit = "target",
          pvptalent = 12
        }, {
          spell = 51052,
          type = "ability",
          pvptalent = 13,
          titleSuffix = L["Cooldown"]
        }, {
          spell = 145629,
          type = "buff",
          unit = "player",
          pvptalent = 13,
          titleSuffix = L["buff"]
        }, {
          spell = 77606,
          type = "ability",
          pvptalent = 14,
          titleSuffix = L["cooldown"]
        }, {
          spell = 77606,
          type = "debuff",
          unit = "target",
          pvptalent = 14,
          titleSuffix = L["debuff"]
        }, {
          spell = 77616,
          type = "buff",
          unit = "player",
          pvptalent = 14,
          titleSuffix = L["buff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-SingleRune"
      }
    },
    [2] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 3714,
          type = "buff",
          unit = "player"
        }, {
          spell = 207203,
          type = "buff",
          unit = "player"
        }, {
          spell = 152279,
          type = "buff",
          unit = "player",
          talent = 21
        }, {
          spell = 59052,
          type = "buff",
          unit = "player"
        }, {
          spell = 48265,
          type = "buff",
          unit = "player"
        }, {
          spell = 281209,
          type = "buff",
          unit = "player",
          talent = 3
        }, {
          spell = 51124,
          type = "buff",
          unit = "player"
        }, {
          spell = 48707,
          type = "buff",
          unit = "player"
        }, {
          spell = 211805,
          type = "buff",
          unit = "player",
          talent = 16
        }, {
          spell = 51271,
          type = "buff",
          unit = "player"
        }, {
          spell = 212552,
          type = "buff",
          unit = "player",
          talent = 14
        }, {
          spell = 53365,
          type = "buff",
          unit = "player"
        }, {
          spell = 196770,
          type = "buff",
          unit = "player"
        }, {
          spell = 47568,
          type = "buff",
          unit = "player"
        }, {
          spell = 194879,
          type = "buff",
          unit = "player",
          talent = 2
        }, {
          spell = 48792,
          type = "buff",
          unit = "player"
        }, {
          spell = 253595,
          type = "buff",
          unit = "player",
          talent = 1
        }, {
          spell = 178819,
          type = "buff",
          unit = "player"
        } },
        icon = 135305
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 207167,
          type = "debuff",
          unit = "target",
          talent = 9
        }, {
          spell = 45524,
          type = "debuff",
          unit = "target"
        }, {
          spell = 51714,
          type = "debuff",
          unit = "target"
        }, {
          spell = 56222,
          type = "debuff",
          unit = "target"
        }, {
          spell = 211793,
          type = "debuff",
          unit = "target"
        }, {
          spell = 55095,
          type = "debuff",
          unit = "target"
        }, {
          spell = 48743,
          type = "debuff",
          unit = "player"
        } },
        icon = 237522
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 3714,
          type = "ability",
          buff = true
        }, {
          spell = 45524,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 47528,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 47568,
          type = "ability",
          buff = true
        }, {
          spell = 48707,
          type = "ability",
          buff = true
        }, {
          spell = 48743,
          type = "ability",
          debuff = true,
          unit = "player",
          talent = 15
        }, {
          spell = 48792,
          type = "ability",
          buff = true
        }, {
          spell = 49020,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 49184,
          type = "ability",
          requiresTarget = true,
          overlayGlow = true
        }, {
          spell = 50977,
          type = "ability"
        }, {
          spell = 51271,
          type = "ability",
          buff = true
        }, {
          spell = 56222,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 57330,
          type = "ability",
          talent = 6
        }, {
          spell = 61999,
          type = "ability"
        }, {
          spell = 111673,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          unit = "pet"
        }, {
          spell = 152279,
          type = "ability",
          buff = true,
          talent = 21
        }, {
          spell = 194913,
          type = "ability"
        }, {
          spell = 196770,
          type = "ability",
          buff = true
        }, {
          spell = 207167,
          type = "ability",
          talent = 9
        }, {
          spell = 207230,
          type = "ability",
          talent = 12
        }, {
          spell = 212552,
          type = "ability",
          buff = true,
          talent = 14
        }, {
          spell = 279302,
          type = "ability",
          talent = 18
        } },
        icon = 135372
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 272723,
          type = "buff",
          unit = "player"
        }, {
          spell = 287338,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 213726,
          type = "debuff",
          unit = "player",
          pvptalent = 4
        }, {
          spell = 77606,
          type = "ability",
          pvptalent = 5,
          titleSuffix = L["cooldown"]
        }, {
          spell = 77606,
          type = "debuff",
          unit = "target",
          pvptalent = 5,
          titleSuffix = L["debuff"]
        }, {
          spell = 77616,
          type = "buff",
          unit = "player",
          pvptalent = 5,
          titleSuffix = L["buff"]
        }, {
          spell = 51052,
          type = "ability",
          pvptalent = 6,
          titleSuffix = L["Cooldown"]
        }, {
          spell = 145629,
          type = "buff",
          unit = "target",
          pvptalent = 6,
          titleSuffix = L["buff"]
        }, {
          spell = 214968,
          type = "debuff",
          unit = "target",
          pvptalent = 7
        }, {
          spell = 289959,
          type = "debuff",
          unit = "target",
          pvptalent = 8,
          titleSuffix = L["slow debuff"]
        }, {
          spell = 287254,
          type = "debuff",
          unit = "target",
          pvptalent = 8,
          titleSuffix = L["stun debuff"]
        }, {
          spell = 228579,
          type = "buff",
          unit = "target",
          pvptalent = 9
        }, {
          spell = 287081,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 287081,
          type = "buff",
          unit = "player",
          pvptalent = 10,
          titleSuffix = L["buff"]
        }, {
          spell = 288977,
          type = "ability",
          pvptalent = 11,
          titleSuffix = L["cooldown"]
        }, {
          spell = 288977,
          type = "buff",
          unit = "player",
          pvptalent = 11,
          titleSuffix = L["buff"]
        }, {
          spell = 233395,
          type = "debuff",
          unit = "target",
          pvptalent = 12
        }, {
          spell = 233397,
          type = "debuff",
          unit = "target",
          pvptalent = 13
        }, {
          spell = 305392,
          type = "ability",
          pvptalent = 14,
          titleSuffix = L["cooldown"]
        }, {
          spell = 204206,
          type = "debuff",
          unit = "target",
          pvptalent = 14,
          titleSuffix = L["debuff"]
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-SingleRune"
      }
    },
    [3] = {
      [1] = {
        title = L["Buffs"],
        args = { {
          spell = 3714,
          type = "buff",
          unit = "player"
        }, {
          spell = 212552,
          type = "buff",
          unit = "player",
          talent = 14
        }, {
          spell = 48707,
          type = "buff",
          unit = "player"
        }, {
          spell = 53365,
          type = "buff",
          unit = "player"
        }, {
          spell = 207289,
          type = "buff",
          unit = "player"
        }, {
          spell = 188290,
          type = "buff",
          unit = "player"
        }, {
          spell = 115989,
          type = "buff",
          unit = "player",
          talent = 6
        }, {
          spell = 48792,
          type = "buff",
          unit = "player"
        }, {
          spell = 42650,
          type = "buff",
          unit = "player"
        }, {
          spell = 81340,
          type = "buff",
          unit = "player"
        }, {
          spell = 48265,
          type = "buff",
          unit = "player"
        }, {
          spell = 51460,
          type = "buff",
          unit = "player"
        }, {
          spell = 63560,
          type = "buff",
          unit = "pet"
        }, {
          spell = 178819,
          type = "buff",
          unit = "player"
        } },
        icon = 136181
      },
      [2] = {
        title = L["Debuffs"],
        args = { {
          spell = 45524,
          type = "debuff",
          unit = "target"
        }, {
          spell = 115994,
          type = "debuff",
          unit = "target",
          talent = 6
        }, {
          spell = 91800,
          type = "debuff",
          unit = "target"
        }, {
          spell = 194310,
          type = "debuff",
          unit = "target"
        }, {
          spell = 56222,
          type = "debuff",
          unit = "target"
        }, {
          spell = 196782,
          type = "debuff",
          unit = "target"
        }, {
          spell = 108194,
          type = "debuff",
          unit = "target",
          talent = 9
        }, {
          spell = 273977,
          type = "debuff",
          unit = "target"
        }, {
          spell = 130736,
          type = "debuff",
          unit = "target",
          talent = 12
        }, {
          spell = 191587,
          type = "debuff",
          unit = "target"
        } },
        icon = 1129420
      },
      [3] = {
        title = L["Abilities"],
        args = { {
          spell = 3714,
          type = "ability",
          buff = true
        }, {
          spell = 42650,
          type = "ability",
          buff = true
        }, {
          spell = 43265,
          type = "ability",
          buff = true,
          buffId = 188290
        }, {
          spell = 45524,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 46584,
          type = "ability"
        }, {
          spell = 47468,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 47481,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 47484,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 47528,
          type = "ability",
          requiresTarget = true
        }, {
          spell = 47541,
          type = "ability",
          requiresTarget = true,
          usable = true,
          overlayGlow = true
        }, {
          spell = 48265,
          type = "ability",
          buff = true
        }, {
          spell = 48707,
          type = "ability",
          buff = true
        }, {
          spell = 48743,
          type = "ability",
          debuff = true,
          unit = "player",
          talent = 15
        }, {
          spell = 48792,
          type = "ability",
          buff = true
        }, {
          spell = 49206,
          type = "ability",
          requiresTarget = true,
          talent = 21
        }, {
          spell = 50977,
          type = "ability"
        }, {
          spell = 55090,
          type = "ability",
          requiresTarget = true,
          talent = { 1, 2 }
        }, {
          spell = 56222,
          type = "ability",
          requiresTarget = true,
          debuff = true
        }, {
          spell = 61999,
          type = "ability"
        }, {
          spell = 63560,
          type = "ability",
          buff = true,
          unit = "pet"
        }, {
          spell = 77575,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          buffId = 191587
        }, {
          spell = 85948,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          buffId = 194310
        }, {
          spell = 108194,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 9
        }, {
          spell = 111673,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          unit = "pet"
        }, {
          spell = 115989,
          type = "ability",
          buff = true,
          talent = 6
        }, {
          spell = 130736,
          type = "ability",
          requiresTarget = true,
          debuff = true,
          talent = 12
        }, {
          spell = 152280,
          type = "ability",
          buff = true,
          buffId = 188290,
          talent = 17
        }, {
          spell = 207289,
          type = "ability",
          buff = true,
          talent = 20
        }, {
          spell = 207311,
          type = "ability",
          requiresTarget = true,
          talent = 3
        }, {
          spell = 212552,
          type = "ability",
          buff = true,
          talent = 14
        }, {
          spell = 275699,
          type = "ability",
          usable = true,
          requiresTarget = true
        } },
        icon = 136144
      },
      [4] = {},
      [5] = {
        title = L["Specific Azerite Traits"],
        args = { {
          spell = 272738,
          type = "buff",
          unit = "player"
        }, {
          spell = 274373,
          type = "buff",
          unit = "player"
        }, {
          spell = 275931,
          type = "debuff",
          unit = "target"
        }, {
          spell = 286979,
          type = "buff",
          unit = "player"
        } },
        icon = 135349
      },
      [6] = {},
      [7] = {
        title = L["PvP Talents"],
        args = { {
          spell = 210128,
          type = "ability",
          pvptalent = 4
        }, {
          spell = 288977,
          type = "ability",
          pvptalent = 5,
          titleSuffix = L["cooldown"]
        }, {
          spell = 288977,
          type = "buff",
          unit = "player",
          pvptalent = 5,
          titleSuffix = L["buff"]
        }, {
          spell = 77606,
          type = "ability",
          pvptalent = 7,
          titleSuffix = L["cooldown"]
        }, {
          spell = 77606,
          type = "debuff",
          unit = "target",
          pvptalent = 7,
          titleSuffix = L["debuff"]
        }, {
          spell = 77616,
          type = "buff",
          unit = "player",
          pvptalent = 7,
          titleSuffix = L["buff"]
        }, {
          spell = 288849,
          type = "debuff",
          unit = "target",
          pvptalent = 8
        }, {
          spell = 214968,
          type = "buff",
          unit = "target",
          pvptalent = 9
        }, {
          spell = 51052,
          type = "ability",
          pvptalent = 10,
          titleSuffix = L["cooldown"]
        }, {
          spell = 145629,
          type = "buff",
          unit = "player",
          pvptalent = 10,
          titleSuffix = L["buff"]
        }, {
          spell = 223929,
          type = "debuff",
          unit = "target",
          pvptalent = 11
        }, {
          spell = 213726,
          type = "debuff",
          unit = "player",
          pvptalent = 12
        }, {
          spell = 288853,
          type = "ability",
          pvptalent = 13
        }, {
          spell = 287081,
          type = "ability",
          pvptalent = 14,
          titleSuffix = L["cooldown"]
        }, {
          spell = 287081,
          type = "buff",
          unit = "player",
          pvptalent = 14,
          titleSuffix = L["buff"]
        }, {
          spell = 199721,
          type = "debuff",
          unit = "target",
          pvptalent = 15
        } },
        icon = "Interface\\Icons\\Achievement_BG_winWSG"
      },
      [8] = {
        title = L["Resources"],
        args = {},
        icon = "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-SingleRune"
      }
    }
  }
end

-- General Section
tinsert(templates.general.args, {
  title = L["Health"],
  icon = "Interface\\Icons\\inv_alchemy_70_red",
  type = "health"
})
tinsert(templates.general.args, {
  title = L["Cast"],
  icon = 136209,
  type = "cast"
})
tinsert(templates.general.args, {
  title = L["Always Active"],
  icon = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura78",
  triggers = {
    [1] = {
      trigger = {
        type = "status",
        event = "Conditions",
        unevent = "auto",
        use_alwaystrue = true
      }
    }
  }
})

tinsert(templates.general.args, {
  title = L["Pet alive"],
  icon = "Interface\\Icons\\ability_hunter_pet_raptor",
  triggers = {
    [1] = {
      trigger = {
        type = "status",
        event = "Conditions",
        unevent = "auto",
        use_HasPet = true
      }
    }
  }
})

tinsert(templates.general.args, {
  title = L["Pet Behavior"],
  icon = "Interface\\Icons\\Ability_hunter_pet_assist",
  triggers = {
    [1] = {
      trigger = {
        type = "status",
        event = "Pet Behavior",
        unevent = "auto",
        use_behavior = true,
        behavior = "assist"
      }
    }
  }
})

tinsert(templates.general.args, {
  spell = 2825,
  type = "buff",
  unit = "player",
  forceOwnOnly = true,
  ownOnly = nil,
  overideTitle = L["Bloodlust/Heroism"],
  spellIds = { 2825, 32182, 80353, 264667 }
})

-- Items section
if not WeakAuras.IsClassic() then
  templates.items[1] = {
    title = L["Enchants"],
    args = { {
      spell = 268905,
      type = "buff",
      unit = "player"
    }, { --Deadly Navigation
      spell = 267612,
      type = "buff",
      unit = "player"
    }, { --Gale-Force Striking
      spell = 268899,
      type = "buff",
      unit = "player"
    }, { --Masterful Navigation
      spell = 268887,
      type = "buff",
      unit = "player"
    }, { --Quick Navigation
      spell = 268911,
      type = "buff",
      unit = "player"
    }, { --Stalwart Navigation
      spell = 267685,
      type = "buff",
      unit = "player"
    }, { --Torrent of Elements
      spell = 268854,
      type = "buff",
      unit = "player"
    }, -- Machinist's Brilliance --Versatile Navigation
    {
      spell = 300693,
      type = "buff",
      unit = "player"
    }, { -- Int
      spell = 300761,
      type = "buff",
      unit = "player"
    }, { -- Haste
      spell = 300762,
      type = "buff",
      unit = "player"
    }, { -- Mastery
      spell = 298431,
      type = "buff",
      unit = "player"
    }, -- Force Multiplier -- Crit
    {
      spell = 300809,
      type = "buff",
      unit = "player"
    }, { -- Mastery
      spell = 300802,
      type = "buff",
      unit = "player"
    }, { -- Haste
      spell = 300801,
      type = "buff",
      unit = "player"
    }, { -- Crit
      spell = 300691,
      type = "buff",
      unit = "player"
    }, { -- Strength
      spell = 300893,
      type = "buff",
      unit = "player"
    }, -- Oceanic Restoration -- Agility
    {
      spell = 298512,
      type = "buff",
      unit = "player"
    }, -- Naga Hide
    {
      spell = 298466,
      type = "buff",
      unit = "player"
    }, { -- Agility
      spell = 298461,
      type = "buff",
      unit = "player"
    }, { -- Absorb
      spell = 300800,
      type = "buff",
      unit = "player"
    } } -- Strength
  }

  templates.items[2] = {
    title = L["On Use Trinkets (Aura)"],
    args = { {
      spell = 278383,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161377
    }, {
      spell = 278385,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161379
    }, {
      spell = 278227,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161411
    }, {
      spell = 278086,
      type = "buff",
      unit = "player",
      titleItemPrefix = 160649
    }, { --heal
      spell = 278317,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161462
    }, {
      spell = 278364,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161463
    }, {
      spell = 281543,
      type = "buff",
      unit = "player",
      titleItemPrefix = 163936
    }, {
      spell = 265954,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158319
    }, {
      spell = 266018,
      type = "buff",
      unit = "target",
      titleItemPrefix = 158320
    }, { --heal
      spell = 271054,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158368
    }, { --heal
      spell = 268311,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159614
    }, { --heal
      spell = 271115,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159615
    }, {
      spell = 271107,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159617
    }, {
      spell = 265946,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159618
    }, { --tank
      spell = 271465,
      type = "debuff",
      unit = "target",
      titleItemPrefix = 159624
    }, {
      spell = 268836,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159625
    }, {
      spell = 266047,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159627
    }, {
      spell = 268998,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159630
    }, {
      spell = 273935,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158162
    }, {
      spell = 273955,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158163
    }, {
      spell = 273942,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158164
    }, {
      spell = 268550,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158215
    }, {
      spell = 274472,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161117
    }, {
      spell = 288267,
      type = "buff",
      unit = "player",
      titleItemPrefix = 165574
    }, {
      spell = 291170,
      type = "debuff",
      unit = "player",
      titleItemPrefix = 165578
    }, { --heal
      spell = 288156,
      type = "buff",
      unit = "player",
      titleItemPrefix = 165580
    }, {
      spell = 287568,
      type = "buff",
      unit = "player",
      titleItemPrefix = 165569
    } } --tank
  }

  templates.items[3] = {
    title = L["On Use Trinkets (CD)"],
    args = { {
      spell = 161377,
      type = "item"
    }, {
      spell = 161379,
      type = "item"
    }, {
      spell = 161411,
      type = "item"
    }, {
      spell = 160649,
      type = "item"
    }, { --heal
      spell = 161462,
      type = "item"
    }, {
      spell = 161463,
      type = "item"
    }, {
      spell = 163936,
      type = "item"
    }, {
      spell = 158319,
      type = "item"
    }, {
      spell = 158320,
      type = "item"
    }, { --heal
      spell = 158368,
      type = "item"
    }, { --heal
      spell = 159614,
      type = "item"
    }, { --heal
      spell = 159615,
      type = "item"
    }, {
      spell = 159617,
      type = "item"
    }, {
      spell = 159618,
      type = "item"
    }, { --tank
      spell = 159624,
      type = "item"
    }, {
      spell = 159625,
      type = "item"
    }, {
      spell = 159627,
      type = "item"
    }, {
      spell = 159630,
      type = "item"
    }, {
      spell = 159611,
      type = "item"
    }, {
      spell = 158367,
      type = "item"
    }, {
      spell = 158162,
      type = "item"
    }, {
      spell = 158163,
      type = "item"
    }, {
      spell = 158164,
      type = "item"
    }, {
      spell = 158215,
      type = "item"
    }, {
      spell = 158216,
      type = "item"
    }, {
      spell = 158224,
      type = "item"
    }, {
      spell = 161117,
      type = "item"
    }, {
      spell = 165574,
      type = "item"
    }, {
      spell = 165568,
      type = "item"
    }, {
      spell = 165578,
      type = "item"
    }, { --heal
      spell = 165580,
      type = "item"
    }, {
      spell = 165576,
      type = "item"
    }, {
      spell = 165572,
      type = "item"
    }, {
      spell = 165569,
      type = "item"
    } } --tank
  }

  templates.items[4] = {
    title = L["On Procc Trinkets (Aura)"],
    args = { {
      spell = 278143,
      type = "buff",
      unit = "player",
      titleItemPrefix = 160648
    }, {
      spell = 278070,
      type = "buff",
      unit = "player",
      titleItemPrefix = 160652
    }, {
      spell = 278110,
      type = "debuff",
      unit = "multi",
      titleItemPrefix = 160655
    }, { --debuff?
      spell = 278155,
      type = "buff",
      unit = "player",
      titleItemPrefix = 160656
    }, {
      spell = 278379,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161376
    }, {
      spell = 278381,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161378
    }, {
      spell = 278862,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161380
    }, {
      spell = 278388,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161381
    }, {
      spell = 278225,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161412
    }, {
      spell = 278288,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161419
    }, {
      spell = 278359,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161461
    }, {
      spell = 281546,
      type = "buff",
      unit = "player",
      titleItemPrefix = 163935
    }, {
      spell = 276132,
      type = "debuff",
      unit = "target",
      titleItemPrefix = 159126
    }, { --debuff?
      spell = 267325,
      type = "buff",
      unit = "player",
      titleItemPrefix = 155881
    }, {
      spell = 267327,
      type = "buff",
      unit = "player",
      titleItemPrefix = 155881
    }, {
      spell = 267330,
      type = "buff",
      unit = "player",
      titleItemPrefix = 155881
    }, {
      spell = 267179,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158374
    }, {
      spell = 271103,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158712
    }, {
      spell = 268439,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159612
    }, {
      spell = 271105,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159616
    }, {
      spell = 268194,
      type = "debuff",
      unit = "multi",
      titleItemPrefix = 159619
    }, { --debuff?
      spell = 271071,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159620
    }, {
      spell = 268756,
      type = "debuff",
      unit = "multi",
      titleItemPrefix = 159623
    }, { --debuff?
      spell = 268062,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159626
    }, {
      spell = 271194,
      type = "buff",
      unit = "player",
      titleItemPrefix = 159628
    }, {
      spell = 278159,
      type = "buff",
      unit = "player",
      titleItemPrefix = 160653
    }, { --tank
      spell = 268518,
      type = "buff",
      unit = "player",
      titleItemPrefix = 155568
    }, {
      spell = 273992,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158154
    }, {
      spell = 273988,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158155
    }, {
      spell = 268532,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158218
    }, { --tank
      spell = 268528,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158556
    }, {
      spell = 273974,
      type = "buff",
      unit = "player",
      titleItemPrefix = 158153
    }, {
      spell = 274430,
      type = "buff",
      unit = "player",
      spellIds = { 274430, 274431 },
      titleItemPrefix = 161113
    }, {
      spell = 274459,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161115
    }, {
      spell = 288194,
      type = "debuff",
      unit = "player",
      titleItemPrefix = 165577
    }, { --tank
      spell = 288305,
      type = "buff",
      unit = "player",
      titleItemPrefix = 165581
    }, {
      spell = 288024,
      type = "buff",
      unit = "player",
      titleItemPrefix = 165573
    }, { --tank
      spell = 289526,
      type = "debuff",
      unit = "target",
      titleItemPrefix = 165570
    }, {
      spell = 289524,
      type = "buff",
      unit = "player",
      titleItemPrefix = 165571
    }, {
      spell = 289523,
      type = "buff",
      unit = "player",
      titleItemPrefix = 165571
    }, {
      spell = 288330,
      type = "debuff",
      unit = "target",
      titleItemPrefix = 165579
    }, {
      spell = 290042,
      type = "buff",
      unit = "player",
      titleItemPrefix = 165572
    } }
  }

  templates.items[5] = {
    title = L["PVP Trinkets (Aura)"],
    args = { {
      spell = 278812,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161472
    }, {
      spell = 278806,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161473
    }, {
      spell = 278819,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161474
    }, { -- on use
      spell = 277179,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161674
    }, { -- on use
      spell = 277181,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161676
    }, {
      spell = 277187,
      type = "buff",
      unit = "player",
      titleItemPrefix = 161675
    } } -- on use
  }

  templates.items[6] = {
    title = L["PVP Trinkets (CD)"],
    args = { {
      spell = 161474,
      type = "item"
    }, { --on use
      spell = 161674,
      type = "item"
    }, { --on use
      spell = 161675,
      type = "item"
    } } --on use
  }
end

-- Meta template for Power triggers
local function createSimplePowerTemplate(powertype)
  local power = {
    title = powerTypes[powertype].name,
    icon = powerTypes[powertype].icon,
    type = "power",
    powertype = powertype
  }
  return power
end

------------------------------
-- PVP Talents
-------------------------------

if not WeakAuras.IsClassic() then
  for _, class in pairs(templates.class) do
    for _, spec in pairs(class) do
      if spec[7] and spec[7].args then
        tinsert(spec[7].args, {
          spell = 208683,
          type = "ability",
          pvptalent = 1
        }) -- Gladiator's Medallion
      end
    end
  end

  for _, class in pairs(templates.class) do
    for _, spec in pairs(class) do
      spec[4] = {
        title = L["General Azerite Traits"],
        args = CopyTable(generalAzeriteTraits),
        icon = 2065624
      }
      spec[6] = {
        title = L["PvP Azerite Traits"],
        args = CopyTable(pvpAzeriteTraits),
        icon = 236396
      }
    end
  end
end

-------------------------------
-- Hardcoded trigger templates
-------------------------------

if not WeakAuras.IsClassic() then
  -- Warrior
  for i = 1, 3 do
    tinsert(templates.class.WARRIOR[i][8].args, createSimplePowerTemplate(1))
  end

  -- Paladin
  tinsert(templates.class.PALADIN[3][8].args, createSimplePowerTemplate(9))
  for i = 1, 3 do
    tinsert(templates.class.PALADIN[i][8].args, createSimplePowerTemplate(0))
  end

  -- Hunter
  for i = 1, 3 do
    tinsert(templates.class.HUNTER[i][8].args, createSimplePowerTemplate(2))
  end

  -- Rogue
  for i = 1, 3 do
    tinsert(templates.class.ROGUE[i][8].args, createSimplePowerTemplate(3))
    tinsert(templates.class.ROGUE[i][8].args, createSimplePowerTemplate(4))
  end

  -- Priest
  for i = 1, 3 do
    tinsert(templates.class.PRIEST[i][8].args, createSimplePowerTemplate(0))
  end
  tinsert(templates.class.PRIEST[3][8].args, createSimplePowerTemplate(13))

  -- Shaman
  for i = 1, 3 do
    tinsert(templates.class.SHAMAN[i][8].args, createSimplePowerTemplate(0))
  end
  for i = 1, 2 do
    tinsert(templates.class.SHAMAN[i][8].args, createSimplePowerTemplate(11))
  end

  -- Mage
  tinsert(templates.class.MAGE[1][8].args, createSimplePowerTemplate(16))
  for i = 1, 3 do
    tinsert(templates.class.MAGE[i][8].args, createSimplePowerTemplate(0))
  end

  -- Warlock
  for i = 1, 3 do
    tinsert(templates.class.WARLOCK[i][8].args, createSimplePowerTemplate(0))
    tinsert(templates.class.WARLOCK[i][8].args, createSimplePowerTemplate(7))
  end

  -- Monk
  tinsert(templates.class.MONK[1][8].args, createSimplePowerTemplate(3))
  tinsert(templates.class.MONK[2][8].args, createSimplePowerTemplate(0))
  tinsert(templates.class.MONK[3][8].args, createSimplePowerTemplate(3))
  tinsert(templates.class.MONK[3][8].args, createSimplePowerTemplate(12))

  templates.class.MONK[1][9] = {
    title = L["Ability Charges"],
    args = { {
      spell = 115072,
      type = "ability",
      charges = true
    } }, -- Expel Harm
    icon = 627486
  }

  templates.class.MONK[2][9] = {
    title = L["Ability Charges"],
    args = {},
    icon = 1242282
  }

  templates.class.MONK[3][9] = {
    title = L["Ability Charges"],
    args = {},
    icon = 606543
  }

  -- Druid
  for i = 1, 4 do
    -- Shapeshift Form
    tinsert(templates.class.DRUID[i][8].args, {
      title = L["Shapeshift Form"],
      icon = 132276,
      triggers = {
        [1] = {
          trigger = {
            type = "status",
            event = "Stance/Form/Aura",
            unevent = "auto"
          }
        }
      }
    })
  end
  for j, id in ipairs({ 5487, 768, 783, 114282, 1394966 }) do
    local title, _, icon = GetSpellInfo(id)
    if title then
      for i = 1, 4 do
        tinsert(templates.class.DRUID[i][8].args, {
          title = title,
          icon = icon,
          triggers = {
            [1] = {
              trigger = {
                type = "status",
                event = "Stance/Form/Aura",
                unevent = "auto",
                use_form = true,
                form = { single = j }
              }
            }
          }
        })
      end
    end
  end

  -- Astral Power
  tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(8))

  for i = 1, 4 do
    tinsert(templates.class.DRUID[i][8].args, createSimplePowerTemplate(0)) -- Mana
    tinsert(templates.class.DRUID[i][8].args, createSimplePowerTemplate(1)) -- Rage
    tinsert(templates.class.DRUID[i][8].args, createSimplePowerTemplate(3)) -- Energy
    tinsert(templates.class.DRUID[i][8].args, createSimplePowerTemplate(4)) -- Combo Points
  end

  -- Efflorescence aka Mushroom
  tinsert(templates.class.DRUID[4][3].args, {
    spell = 145205,
    type = "totem"
  })

  -- Demon Hunter
  tinsert(templates.class.DEMONHUNTER[1][8].args, createSimplePowerTemplate(17))
  tinsert(templates.class.DEMONHUNTER[2][8].args, createSimplePowerTemplate(18))

  -- Death Knight
  for i = 1, 3 do
    tinsert(
      templates.class.DEATHKNIGHT[i][8].args,
      createSimplePowerTemplate(6)
    )

    tinsert(templates.class.DEATHKNIGHT[i][8].args, {
      title = L["Runes"],
      icon = "Interface\\Icons\\spell_deathknight_frozenruneweapon",
      triggers = {
        [1] = {
          trigger = {
            type = "status",
            event = "Death Knight Rune",
            unevent = "auto"
          }
        }
      }
    })
  end
  -- Warrior

  -- Shapeshift Form
else
  tinsert(templates.class.WARRIOR[1][8].args, {
    title = L["Stance"],
    icon = 132349,
    triggers = {
      [1] = {
        trigger = {
          type = "status",
          event = "Stance/Form/Aura",
          unevent = "auto"
        }
      }
    }
  })
  for j, id in ipairs({ 2457, 71, 2458 }) do
    local title, _, icon = GetSpellInfo(id)
    if title then
      tinsert(templates.class.WARRIOR[1][8].args, {
        title = title,
        icon = icon,
        triggers = {
          [1] = {
            trigger = {
              type = "status",
              event = "Stance/Form/Aura",
              unevent = "auto",
              use_form = true,
              form = { single = j }
            }
          }
        }
      })
    end
  end

  tinsert(templates.class.WARRIOR[1][8].args, createSimplePowerTemplate(1))
  tinsert(templates.class.PALADIN[1][8].args, createSimplePowerTemplate(0))
  tinsert(templates.class.HUNTER[1][8].args, createSimplePowerTemplate(0))
  tinsert(templates.class.ROGUE[1][8].args, createSimplePowerTemplate(3))
  tinsert(templates.class.ROGUE[1][8].args, createSimplePowerTemplate(4))
  tinsert(templates.class.PRIEST[1][8].args, createSimplePowerTemplate(0))
  tinsert(templates.class.SHAMAN[1][8].args, createSimplePowerTemplate(0))
  tinsert(templates.class.MAGE[1][8].args, createSimplePowerTemplate(0))
  tinsert(templates.class.WARLOCK[1][8].args, createSimplePowerTemplate(0))
  tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(0))
  tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(1))
  tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(3))
  tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(4))

  tinsert(templates.class.DRUID[1][8].args, {
    title = L["Shapeshift Form"],
    icon = 132276,
    triggers = {
      [1] = {
        trigger = {
          type = "status",
          event = "Stance/Form/Aura",
          unevent = "auto"
        }
      }
    }
  })
  for j, id in ipairs({ 5487, 768, 783, 114282, 1394966 }) do
    local title, _, icon = GetSpellInfo(id)
    if title then
      tinsert(templates.class.DRUID[1][8].args, {
        title = title,
        icon = icon,
        triggers = {
          [1] = {
            trigger = {
              type = "status",
              event = "Stance/Form/Aura",
              unevent = "auto",
              use_form = true,
              form = { single = j }
            }
          }
        }
      })
    end
  end
end

------------------------------
-- Hardcoded race templates
-------------------------------

-- Every Man for Himself
tinsert(templates.race.Human, {
  spell = 59752,
  type = "ability"
})
-- Stoneform
tinsert(templates.race.Dwarf, {
  spell = 20594,
  type = "ability",
  titleSuffix = L["cooldown"]
})
tinsert(templates.race.Dwarf, {
  spell = 65116,
  type = "buff",
  unit = "player",
  titleSuffix = L["buff"]
})
-- Shadow Meld
tinsert(templates.race.NightElf, {
  spell = 58984,
  type = "ability",
  titleSuffix = L["cooldown"]
})
tinsert(templates.race.NightElf, {
  spell = 58984,
  type = "buff",
  titleSuffix = L["buff"]
})
-- Escape Artist
tinsert(templates.race.Gnome, {
  spell = 20589,
  type = "ability"
})
-- Gift of the Naaru
tinsert(templates.race.Draenei, {
  spell = 28880,
  type = "ability",
  titleSuffix = L["cooldown"]
})
tinsert(templates.race.Draenei, {
  spell = 28880,
  type = "buff",
  unit = "player",
  titleSuffix = L["buff"]
})
-- Dark Flight
tinsert(templates.race.Worgen, {
  spell = 68992,
  type = "ability",
  titleSuffix = L["cooldown"]
})
tinsert(templates.race.Worgen, {
  spell = 68992,
  type = "buff",
  unit = "player",
  titleSuffix = L["buff"]
})
-- Quaking Palm
tinsert(templates.race.Pandaren, {
  spell = 107079,
  type = "ability",
  titleSuffix = L["cooldown"]
})
tinsert(templates.race.Pandaren, {
  spell = 107079,
  type = "buff",
  titleSuffix = L["buff"]
})
-- Blood Fury
tinsert(templates.race.Orc, {
  spell = 20572,
  type = "ability",
  titleSuffix = L["cooldown"]
})
tinsert(templates.race.Orc, {
  spell = 20572,
  type = "buff",
  unit = "player",
  titleSuffix = L["buff"]
})
--Cannibalize
tinsert(templates.race.Scourge, {
  spell = 20577,
  type = "ability",
  titleSuffix = L["cooldown"]
})
tinsert(templates.race.Scourge, {
  spell = 20578,
  type = "buff",
  unit = "player",
  titleSuffix = L["buff"]
})
-- War Stomp
tinsert(templates.race.Tauren, {
  spell = 20549,
  type = "ability",
  titleSuffix = L["cooldown"]
})
tinsert(templates.race.Tauren, {
  spell = 20549,
  type = "buff",
  titleSuffix = L["buff"]
})
--Beserking
tinsert(templates.race.Troll, {
  spell = 26297,
  type = "ability",
  titleSuffix = L["cooldown"]
})
tinsert(templates.race.Troll, {
  spell = 26297,
  type = "buff",
  unit = "player",
  titleSuffix = L["buff"]
})
-- Arcane Torment
tinsert(templates.race.BloodElf, {
  spell = 69179,
  type = "ability",
  titleSuffix = L["cooldown"]
})
tinsert(templates.race.BloodElf, {
  spell = 69179,
  type = "buff",
  titleSuffix = L["buff"]
})
-- Pack Hobgoblin
tinsert(templates.race.Goblin, {
  spell = 69046,
  type = "ability"
})
-- Rocket Barrage
tinsert(templates.race.Goblin, {
  spell = 69041,
  type = "ability"
})

-- Arcane Pulse
tinsert(templates.race.Nightborne, {
  spell = 260364,
  type = "ability"
})
-- Cantrips
tinsert(templates.race.Nightborne, {
  spell = 255661,
  type = "ability"
})
-- Light's Judgment
tinsert(templates.race.LightforgedDraenei, {
  spell = 255647,
  type = "ability"
})
-- Forge of Light
tinsert(templates.race.LightforgedDraenei, {
  spell = 259930,
  type = "ability"
})
-- Bull Rush
tinsert(templates.race.HighmountainTauren, {
  spell = 255654,
  type = "ability"
})
--Spatial Rift
tinsert(templates.race.VoidElf, {
  spell = 256948,
  type = "ability"
})

------------------------------
-- Helper code for options
-------------------------------

-- Enrich items from spell, set title
local function handleItem(item)
  local waitingForItemInfo = false
  if item.spell then
    local name, icon, _
    if (item.type == "item") then
      name, _, _, _, _, _, _, _, _, icon = GetItemInfo(item.spell)
      if (name == nil) then
        name = L["Unknown Item"] .. " " .. tostring(item.spell)
        waitingForItemInfo = true
      end
    else
      name, _, icon = GetSpellInfo(item.spell)
      if (name == nil) then
        name = L["Unknown Spell"] .. " " .. tostring(item.spell)
      end
    end
    if (icon and not item.icon) then
      item.icon = icon
    end

    item.title = item.overideTitle or name or ""
    if item.titleSuffix then
      item.title = item.title .. " " .. item.titleSuffix
    end
    if item.titlePrefix then
      item.title = item.titlePrefix .. item.title
    end
    if item.titleItemPrefix then
      local prefix = GetItemInfo(item.titleItemPrefix)
      if prefix then
        item.title = prefix .. "-" .. item.title
      else
        waitingForItemInfo = true
      end
    end
    if (item.type ~= "item") then
      local spell = Spell:CreateFromSpellID(item.spell)
      if not spell:IsSpellEmpty() then
        spell:ContinueOnSpellLoad(function()
          item.description = GetSpellDescription(spell:GetSpellID())
        end)
      end
      item.description = GetSpellDescription(item.spell)
    end
  end
  if item.talent then
    item.load = item.load or {}
    if type(item.talent) == "table" then
      item.load.talent = {
        multi = {}
      }
      for _, v in pairs(item.talent) do
        item.load.talent.multi[v] = true
      end
      item.load.use_talent = false
    else
      item.load.talent = {
        single = item.talent,
        multi = {}
      }
      item.load.use_talent = true
    end
  end
  if item.pvptalent then
    item.load = item.load or {}
    item.load.use_pvptalent = true
    item.load.pvptalent = {
      single = item.pvptalent,
      multi = {}
    }
  end
  -- form field is lazy handled by a usable condition
  if item.form then
    item.usable = true
  end
  return waitingForItemInfo
end

local function addLoadCondition(item, loadCondition)
  -- No need to deep copy here, templates are read-only
  item.load = item.load or {}
  for k, v in pairs(loadCondition) do
    item.load[k] = v
  end
end

local delayedEnrichDatabase = false
local itemInfoReceived = CreateFrame("frame")

local enrichTries = 0
local function enrichDatabase()
  if (enrichTries > 3) then return end
  enrichTries = enrichTries + 1

  local waitingForItemInfo = false
  for className, class in pairs(templates.class) do
    for specIndex, spec in pairs(class) do
      for _, section in pairs(spec) do
        local loadCondition = {
          use_class = true,
          class = {
            single = className,
            multi = {}
          },
          use_spec = true,
          spec = {
            single = specIndex,
            multi = {}
          }
        }
        if WeakAuras.IsClassic() then
          loadCondition.use_spec = nil
          loadCondition.spec = nil
        end
        for itemIndex, item in pairs(section.args or {}) do
          local handle = handleItem(item)
          if handle then
            waitingForItemInfo = true
          end
          addLoadCondition(item, loadCondition)
        end
      end
    end
  end

  for raceName, race in pairs(templates.race) do
    local loadCondition = {
      use_race = true,
      race = {
        single = raceName,
        multi = {}
      }
    }
    for _, item in pairs(race) do
      local handle = handleItem(item)
      if handle then
        waitingForItemInfo = true
      end
      if handle ~= nil then
        addLoadCondition(item, loadCondition)
      end
    end
  end

  for _, item in pairs(templates.general.args) do
    if handleItem(item) then
      waitingForItemInfo = true
    end
  end

  for _, section in pairs(templates.items) do
    for _, item in pairs(section.args) do
      if handleItem(item) then
        waitingForItemInfo = true
      end
    end
  end

  if waitingForItemInfo then
    itemInfoReceived:RegisterEvent("GET_ITEM_INFO_RECEIVED")
  else
    itemInfoReceived:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
  end
end

if not WeakAuras.IsClassic() then
  local function fixupIcons()
    for className, class in pairs(templates.class) do
      for specIndex, spec in pairs(class) do
        for _, section in pairs(spec) do
          for _, item in pairs(section.args) do
            if (item.spell and (not item.type ~= "item")) then
              local icon = select(3, GetSpellInfo(item.spell))
              if icon then
                item.icon = icon
              end
            end
          end
        end
      end
    end
  end

  local fixupIconsFrame = CreateFrame("frame")
  fixupIconsFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
  fixupIconsFrame:SetScript("OnEvent", fixupIcons)
end

enrichDatabase()

itemInfoReceived:SetScript("OnEvent", function()
  if not delayedEnrichDatabase then
    delayedEnrichDatabase = true
    C_Timer.After(2, function()
      enrichDatabase()
      delayedEnrichDatabase = false
    end)
  end
end)

-- Enrich Display templates with default values
for regionType, regionData in pairs(WeakAuras.regionOptions) do
  if regionData.templates then
    for _, item in ipairs(regionData.templates) do
      for k, v in pairs(WeakAuras.regionTypes[regionType].default) do
        if (item.data[k] == nil) then
          item.data[k] = v
        end
      end
    end
  end
end

if WeakAuras.IsClassic() then
  templates.race.Draenei = nil
  templates.race.Worgen = nil
  templates.race.Pandaren = nil
  templates.race.BloodElf = nil
  templates.race.Goblin = nil
  templates.race.Nightborne = nil
  templates.race.LightforgedDraenei = nil
  templates.race.HighmountainTauren = nil
  templates.race.VoidElf = nil
  powerTypes[99] = nil
  powerTypes[18] = nil
  powerTypes[17] = nil
  powerTypes[16] = nil
  powerTypes[13] = nil
  powerTypes[12] = nil
  powerTypes[11] = nil
  powerTypes[9] = nil
  powerTypes[8] = nil
  powerTypes[7] = nil
  powerTypes[6] = nil
  wipe(generalAzeriteTraits)
  wipe(pvpAzeriteTraits)
end

WeakAuras.triggerTemplates = templates