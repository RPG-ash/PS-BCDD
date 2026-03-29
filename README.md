# PS-BCDD
Business Card Dungeon Delve designed by Melv Lee - PowerShell edition

[https://melvinli.itch.io/business-card-dungeon-Delve](https://melvinli.itch.io/business-card-dungeon-delve)

[https://www.youtube.com/watch?v=eRA9du4eBWA&t=871s](https://www.youtube.com/watch?v=eRA9du4eBWA&t=871s)

---

## How to play Business Card Dungeon Delve

- Character Sheet
    - Stats
        - HP (Health)
        - STR (Strength)
        - DEX (Dexterity)
        - INT (Intelligence)
        - ATK (Attack)
    - Rations (cutlery icon)
    - Torch (torch icon)
    - Potions (potion icon)
    - Scrolls (book icon)
    - Gold ($ bag icon)
    - XP (lightning icon)
    - 

start with 1 Attack

start with 12 Health

start with Rations 6 (used when travelling)

start with 6 Torches (used in dingeons)

---

roll 1 d6 a potion

- potions list (1d6)
  - 1 = Healing (+3 HP)
  - 2 = Invisability (Sneak pass location)
  - 3 = Accelerate (-3 or +3 journeys or dungeons)
  - 4 = Strength (+2 STR or +2 ATK against next test or monster)
  - 5 = Invisibility (auto pass a test)
  - 6 = Rock Skin (+2 DEF for next fight)

---

roll 1 d6 for a scroll

- scrolls list (1d6)
  - 1 = Healing Hands (restore d6 HP)
  - 2 = Fire Ball (damage d3 HP)
  - 3 = Light (add d6 torches)
  - 4 = Lightning (damage 2x d3 HP)
  - 5 = Morphing (temporary +d3 Stats for d3 tests)
  - 6 = Teleport (teleport to setelment)

---

roll 1 d6 for Gold

visit shop to buy items

- Settlement items
  - 2G = +2 Rations or +2 Torches
  - 3G = Restore 1 HP
  - 6G = +1 Potion (+3 HP)
  - 15G = +1 Spell
  - 25G = Training (+5 XP)
  - 30G = Reurrection (return to life at the Settelement when at zero HP)

---

Obtain Quest

- Quest list (1d6)
  - 1 = Hunt - Return 4 rations (+3 XP & +2 d6 Gold)
  - 2 = Deliver - Pass 3 NPC tests (+3 XP & 10 Gold)
  - 3 = Scout - Explore 5 rooms (+3 XP & 15 Gold)
  - 4 = Destory - D6 + 3 Dungeon or Wildernsss (+3 XP & 25 Gold)
  - 5 = Map - Journey through 3 Swamps (+6 XP & 35 Gold)
  - 6 = Retrieve - 3 Tomes (+6 XP & +50 Gold)

---

roll 1d6 for journeys (wilderness encounters until dungeon)

- Journys (1d6)
  - 1-2 = 3
  - 3-4 = 4
  - 5-6 = 5

---

roll xd6 (3, 4 or 5) for each journey (wilderness encounters)

Wilderness encounters (tests)

- Wilderness list (1d6)
  - 1 = Plains
  - 2 = Forest - INT 3, +2 Rations, -1 Rations
  - 3 = River - DEX 3, -1 HP, +1 Gold
  - 4 = Campsite - STR 3, -2 Gold, +2 HP or +2 Torch
  - 5 = Hill - DEX 4, -2 Rations, +2 XP
  - 6 = Swamp - STR 5, -2 HP, +5 Gold

---

visit first journy - wilderness (test)

roll higher than encounter test amount to pass, otherwise fail.

adjust pass/fail values

always an encounter after a Wilderness visit

Enter an Encounter after Wilderness (test)

roll 1d6 for encounter

- Encounter list (1d6)
  - 1 = Enemy x1
  - 2 = Enemy x2
  - 3 = Lost (Journey +1)
  - 4 = Hunting (STR 3, -2 HP, +2 Rations or +2 Torches)
  - 5 = NPC (roll on Wilderness NPC test list)
  - 6 = Settelment (buy item(s) - see Settelment list above)

if Enemy, fight.

roll 1 or 2d6 to determine enemy type

Enemy

- Enemy list (1d6) (attack, HP, reward)
  - 1 = Boar (1, 3, 2 Rations)
  - 2 = Vagabond (2, 2, 1 Gold)
  - 3 = Thug (3, 2, 3 Gold)
  - 4 = Bear (4, 6, 4 Rations)
  - 5 = Raider (4, 2d3, 4 Gold)
  - 6 = Wyvern (5, 3d3, 4 XP)

player always attacks first.

roll to attack, roll more than enemy attack to hit = -1 Health to enemy.

roll to defend, roll higher than enemy attack to defend, otherwise -1 Health to you.

adjust reward

+1 xp for each kill.

if 2 Enemy, fight one after another.

every 6 XP gain 1 level, or 6, 12, 18 per level?

choose +1 to STR, DEX or INT

Max stats is +3.

if test, roll for pass/fail

if NPC, roll on Wilderness NPC list (test)

- Wilderness NPC (tests)
  - 1 = Wizard (INT 3, -5 XP, +1 Spell Scroll?)
  - 2 = Thief (DEX 3, -5 Gold, +1 XP)
  - 3 = Merchant (INT 3, -10 Gold, +5 Gold)
  - 4 = Wrench (STR 3, -2 XP, +2 XP)
  - 5 = Knight (STR 4, -1 ATK, +2 XP)
  - 6 = Assassin (DEX 5, -2 HP, +1 Treasure) -------- Treasure is potion or scroll?????


if Settelment, buy items.

-1 Ration per journey

if journeys > 0, repeat Wildernesss encounter

if journeys = 0, visit dungeon

---

dungeon

roll 1d6 for dungeon size

- Dungeon size (1d6)
  - 1-2 = 3 Rooms
  - 3-4 = 4 Rooms
  - 5-6 = 5 Rooms

---

if zero torches, game over (lost in dungeon).

roll xd6 (3, 4 or 5) for each dungeon room

Dungeon room

- Dungeon list (1d6)
  - 1 = Passage (Encounter only)
  - 2 = Prison (Enemy x1 ATK +1)
  - 3 = Armory (Treasure +1 potion or spell)
  - 4 = Crypts (Hazard +2 tests)
  - 5 = Library (NPC x2 tests)
  - 6 = Throne (Enemy x2)

Dungeon Encounter

if Passage, encounter only

- Encounter list (1d6)
  - 1 = Enemy x1
  - 2 = Enemy x2
  - 3 = NPC
  - 4 = Empty
  - 5 = Hazard (test)
  - 6 = Treasure

if Enemy, fight

- Enemy list (1d6) (attack, HP, reward)
  - 1 = 
  - 2 = 
  - 3 = 
  - 4 = 
  - 5 = 
  - 6 = 


if Hazard, test

Hazards

- Hazard list (1d6)
  - 1 = 
  - 2 = 
  - 3 = 
  - 4 = 
  - 5 = 
  - 6 = 

if Treasure, roll for Treasure

Treasure

- Treasure list (1d6)
  - See Potion and Scroll lists above

if NPC, roll on Dungeon NPC list (test)

- Dungeon NPC (tests)
  - 1 = 
  - 2 = 
  - 3 = 
  - 4 = 
  - 5 = 
  - 6 = 


-1 Torch per dungeon room

if dungeon rooms > 0, repeat dungeon room

if dungeon rooms = 0, visit settlement?

---













