# chase_sling — Weapon Sling / Weaponscarry pro QBox

Zobrazuje zbraně na zádech hráče jako 3D objekty přichycené na peda. Kompatibilní s **QBox**, **ox_inventory** a **ox_lib**.

---

## Závislosti

- `ox_lib`
- `ox_inventory`

---

## Instalace

1. Zkopíruj složku `chase_sling` do `resources/`
2. Přidej do `server.cfg`:
   ```
   ensure chase_sling
   ```
3. Restartuj server

---

## Jak to funguje

- Zbraně se zobrazí na zádech pokud jsou ve **slotu 1–5** v ox_inventory hotbaru
- Zbraň **zmizí z popruhu** když ji vytáhneš do ruky
- Zbraň se **vrátí na popruh** když ji schováš
- Zbraně mimo slot 1–5 (v normálním inventáři) se **nezobrazují**

---

## Konfigurace

### `data/weapons.lua`
Definuje které zbraně se zobrazují a na jakém místě těla.

```lua
WeaponsConfig = {
    weapon_carbinerifle = { slot = 4 },  -- záda vlevo
    weapon_pumpshotgun  = { slot = 5 },  -- záda vpravo
    weapon_bat          = { slot = 2 },  -- pas
}
```

#### Dostupné sloty
| Číslo | Pozice |
|-------|--------|
| 1 | Stehno pravé |
| 2 | Pas |
| 3 | Záda (střed) |
| 4 | Záda vlevo |
| 5 | Záda vpravo |

### `data/carry.lua`
Konfigurace carry itemů (tašky, batohy apod.).

---

## Struktura souborů

```
chase_sling/
├── data/
│   ├── weapons.lua      ← konfigurace zbraní
│   └── carry.lua        ← konfigurace carry itemů
├── modules/
│   ├── utils.lua        ← pomocné funkce, slot systém
│   ├── weapons.lua      ← zobrazení zbraní ostatních hráčů
│   ├── carry.lua        ← carry itemy (tašky apod.)
│   ├── vehicles.lua     ← zbraně ve vozidlech
│   └── inventory.lua    ← hlavní logika přichycení zbraní
├── server.lua
├── fxmanifest.lua
└── README.md
```

---

## Přidání nové zbraně

V `data/weapons.lua` přidej:
```lua
weapon_novazBran = { slot = 4 },
```
Název musí být **lowercase** a odpovídat názvu itemu v ox_inventory.
