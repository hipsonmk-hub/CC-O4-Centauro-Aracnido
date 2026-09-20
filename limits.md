# limits.md — Nodo Móstoles / Fase 0

Valores que rompen piezas. No son marketing.

## Polímero
- PETG-CF en cajeado de 624ZZ: **tope operativo 65 °C**.
- Por encima: parar. El módulo cae y el rodamiento ovaliza el asiento.

## Tornillería
- M4 en rosca FDM: **1,2 – 1,5 N·m**. Rotura típica ~2,0 N·m.
- Junta de cintura CC-O4-W0 (aluminio 6082-T6): **M8 a 24 – 26 N·m**.
- No usar el par de la brida en una pata impresa.

## Watchdog (Ancla)
- WD_KICK periodo máximo **50 ms**.
- Latch a **100 ms** sin kick: ENABLE de drivers a bajo, TORSO_HOLD alto.
- Rearme solo con llave en la base. El SoC de aplicación no se rearma solo.

## Rodamiento / eje
- 624ZZ (4 × 13 × 5) sobre eje 4 mm.
- `bearing_od_fit` FDM: **0,20 mm** (ya en el repo).
- Tuerca cautiva DIN 934 donde el SCAD lo pida.

## Cintura CC-O4-W0
- Ø220 / PCD 190 / 8×M8 / pasadores Ø8 PCD 150 / arnés Ø70.
- Masa de diseño sobre la junta: **80 kg**.
- Ver `docs/CC-O4-W0_ICD_Cintura.pdf`.
