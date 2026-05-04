# Provinciale opcenten — gefixeerde 1995-grondslag

Deze referentie documenteert hoe de provinciale opcenten op de
motorrijtuigenbelasting (MRB) worden berekend in de schorsingscalculator.
Bron-bevinding: opcenten worden niet over het actuele 2026-tarief geheven,
maar over een **bevroren** rijksbelasting-grondslag, vastgesteld per
**1 april 1995**.

## De wettelijke grond

> "De provinciale opcenten zijn een percentage van de **(gefixeerde)
> hoofdsom van de motorrijtuigenbelasting**, zoals het tarief daarvan is
> **vastgesteld op 1 april 1995**."

Bron: Verordening Opcenten MRB Noord-Holland, geconsolideerde versie —
[lokaleregelgeving.overheid.nl/CVDR60304/2](https://lokaleregelgeving.overheid.nl/CVDR60304/2).

Deze regel is wettelijk uniform voor alle 12 provincies (artikel 222
Provinciewet jo. artikel 23 Wet MRB '94). Het door de provincie zelf
vastgestelde **percentage** verschilt per provincie en per jaar; de
**grondslag** (de 1995-tabel) is dezelfde.

## De 1995-grondslag-tabel personenauto

Bron-document: [Staatsblad 1995, 152](https://zoek.officielebekendmakingen.nl/stb-1995-152.html)
— wijziging Wet op de motorrijtuigenbelasting 1994 (artikel 23 lid 1).

De 1995-amendementen vervingen de 1994-bedragen door (in guldens):
`f 31,95 / 38,20 / 44,95 / 59,45 / 75,20 / 100,95` plus een per-100kg
increment van `f 25,75`. Conversie naar euro's (`1 EUR = 2,20371 NLG`):

| Eigen massa-schijf | NLG 1995 | EUR 1995 |
|--------------------|----------|----------|
| schijf 500 (≤550 kg)        | f 31,95  | €14,50  |
| schijf 600 (551–650)        | f 38,20  | €17,33  |
| schijf 700 (651–750)        | f 44,95  | €20,40  |
| schijf 800 (751–850)        | f 59,45  | €26,98  |
| schijf 900 (851–950)        | f 75,20  | €34,12  |
| schijf 1000 (951–1050)      | f 100,95 | €45,81  |
| **per +100 kg boven 1000**  | f 25,75  | **+€11,68** |

### Schijfafronding (xx51 t/m xx50 → xx00)

De Belastingdienst gebruikt 100kg-brackets met breakpoints op `xx51` /
`xx50`. Voorbeelden bevestigd via aanslag-uitsplitsing:

- Massa 2890 → bracket `2851 t/m 2950` → schijf **2900**.
- Massa 2820 → bracket `2751 t/m 2850` → schijf **2800**.
- Massa 850 → bracket `751 t/m 850` → schijf **800**.
- Massa 851 → bracket `851 t/m 950` → schijf **900**.

JS-formule: `const schijf = Math.floor((m + 49) / 100) * 100;`

### Voorbeelden 1995-grondslag personenauto

- 2900 kg: €45,81 + 19 × €11,68 = **€267,73**
- 2500 kg: €45,81 + 15 × €11,68 = €221,01
- 1500 kg: €45,81 +  5 × €11,68 = €104,21
- 1100 kg: €45,81 +  1 × €11,68 = €57,49

## Volledige opcenten-formule (kampeerauto, 2026)

```text
schijf       = Math.floor((massaKg + 49) / 100) * 100        // BD-bracket xx51..xx50
hoofdsom1995 = lookupHoofdsom1995(schijf)                    // 1995-tabel (boven)
multiplier   = isKamper ? 0.5 : 1.0                          // halftarief artikel 23a (vanaf 1-1-2026)
opcentenPct  = MRB_2026.opcenten[provincie] / 100            // huidige percentage (per provincie)
opcenten     = opcentenPct × multiplier × hoofdsom1995
```

**Validatie tegen werkelijke aanslag** (dieselcamper 2890 kg, Noord-Holland, post-2009 EURO 4):
- schijf 2890 → 2900
- 1995-hoofdsom @ 2900 = €267,73
- × 0,5 (halftarief) = €133,87
- × 0,821 (NH 2026) = **€109,90** ✓ exact

## Per-provincie verordeningen (CVDR-bronnen)

Alle CVDR-pagina's op [lokaleregelgeving.overheid.nl](https://lokaleregelgeving.overheid.nl).
Het percentage 2026 staat in de tool-constants (`MRB_2026.opcenten`); deze
links zijn de wettelijke audit-trail per provincie.

| Provincie       | 2026 % | Verordening (CVDR)                                                                               |
|-----------------|-------:|--------------------------------------------------------------------------------------------------|
| Groningen       |  95,7  | [CVDR209802](https://lokaleregelgeving.overheid.nl/CVDR209802/12)                                |
| Friesland       |  92,1  | [CVDR664625](https://lokaleregelgeving.overheid.nl/CVDR664625/1)                                 |
| Drenthe         |  92,0  | [CVDR92875](https://lokaleregelgeving.overheid.nl/CVDR92875/7)                                   |
| Overijssel      |  82,2  | [CVDR707383](https://lokaleregelgeving.overheid.nl/CVDR707383/1) (Belastingverordening 2024)     |
| Flevoland       |  84,7  | [CVDR122557](https://lokaleregelgeving.overheid.nl/CVDR122557/6)                                 |
| Gelderland      |  98,3  | [CVDR629684](https://lokaleregelgeving.overheid.nl/CVDR629684/1)                                 |
| Utrecht         |  86,4  | [zoekportaal Utrecht](https://lokaleregelgeving.overheid.nl/?q=opcenten+Utrecht)  |
| Noord-Holland   |  82,1  | [CVDR60304](https://lokaleregelgeving.overheid.nl/CVDR60304/2) ★ bron-citaat                     |
| Zuid-Holland    | 104,4  | [CVDR72398](https://lokaleregelgeving.overheid.nl/CVDR72398/4)                                   |
| Zeeland         |  84,4  | [CVDR121749](https://lokaleregelgeving.overheid.nl/CVDR121749/3)                                 |
| Noord-Brabant   |  87,0  | [CVDR703053](https://lokaleregelgeving.overheid.nl/CVDR703053/1) (Heffingsverordening 2024)      |
| Limburg         |  88,5  | [CVDR373221](https://lokaleregelgeving.overheid.nl/CVDR373221) (Verordening 2015, geactualiseerd)|

Niet-ingezetenen-tarief in de tool = laagste provincie-tarief (NH 82,1 %).

> **Verificatie 2026-percentages**: alle 12 percentages hierboven zijn op
> 2026-05-04 één-op-één bevestigd tegen [CBS 80889ned](https://www.cbs.nl/nl-nl/cijfers/detail/80889ned)
> (voorlopige cijfers volgens CBS — kunnen marginaal worden bijgesteld).
> De berekeningsformule is wettelijk identiek voor alle 12 provincies; het
> enige wat per provincie verschilt is het hardcoded percentage in
> `MRB_2026.opcenten`.

## Belangrijke vervolgcontroles

1. **Jaarwisseling**: percentages bij CBS [tabel 80889ned](https://www.cbs.nl/nl-nl/cijfers/detail/80889ned)
   verifiëren en in `MRB_2026.opcenten` aanpassen. De 1995-grondslag
   verandert niet (is wettelijk bevroren).
2. **Wetwijziging**: indien artikel 222 Provinciewet of artikel 23 Wet MRB
   '94 wordt aangepast op een manier die de 1995-grondslag herijkt of
   afschaft, moet `MRB_1995.hoofdsom` herzien worden. Het ambtelijk
   rapport [Verkenning Opcenten onder betalen-naar-gebruik
   (25-11-2022)](https://www.eerstekamer.nl/overig/20230907/ambtelijk_rapport_verkenning/document)
   beschrijft mogelijke toekomstige stelselwijzigingen.

## Onderscheid grondslagen — samenvatting

| Component                | Tabel-jaar | Schijfafronding         | Multiplier kamper |
|--------------------------|------------|-------------------------|-------------------|
| Basisbedrag (hoofdsom)   | **2026**   | xx51..xx50 → xx00        | × 0,5 (halftarief)|
| Brandstoftoeslag         | **2026**   | xx51..xx50 → xx00        | × 0,5 (halftarief)|
| Fijnstoftoeslag          | **2026**   | 19 % × hoofdsom-2026     | × 0,5 (halftarief)|
| **Provinciale opcenten** | **1995**   | xx51..xx50 → xx00        | × 0,5 (halftarief)|

De fijnstoftoeslag wordt niet over de opcenten of de brandstoftoeslag
geheven — alleen over de hoofdsom (artikel 23 lid 4 Wet MRB '94).
