# Changelog

All notable changes to **Camper Schorsingscalculator** are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/), versioning per [SemVer](https://semver.org/).

The version in `package.json` is the source of truth and is mirrored in the HTML
`<meta name="app-version">` and the page footer at every release.

## [Unreleased]

### Added
- **Kenteken-lookup via RDW open data** — profielinvoer is herontworpen rond `opendata.rdw.nl` (datasets `m9d7-ebf2` + `8ys7-d773`, gejoind op kenteken). Knop "Ophalen" haalt merk, model, DET, datum tenaamstelling, eigen massa, toegestane max. massa, voertuigsoort, inrichting, voertuigcategorie, brandstof en EURO-emissieniveau op. Geen DigiD nodig. Streepjes/spaties in het kenteken worden automatisch genegeerd.
- **Provincie-dropdown** — alle 12 provincies plus "Niet-ingezetenen", voor de juiste opcenten.
- **Volledige MRB-rekenkern (Belastingdienst-tarieven 2026 + bevroren 1995-grondslag voor opcenten)** — hoofdsom personenauto per gewichtschijf (artikel 23 lid 1), brandstoftoeslag voor diesel/LPG/aardgas-G3-R115 (artikel 23 lid 2-3), halftarief-multiplier 0,5 voor kampeerauto's (artikel 23a, **vanaf 1 jan 2026** — was kwarttarief in 2025), **provinciale opcenten over de gefixeerde 1995-tabel** (artikel 222 Provinciewet — bron CVDR60304 Noord-Holland, identiek voor alle 12 provincies), fijnstoftoeslag 19 % van de hoofdsom (artikel 23 lid 4) voor oude diesels.
- **Schijfafronding xx51..xx50 → xx00** — Belastingdienst hanteert 100kg-brackets met breakpoints op xx50/xx51 (massa 2890 → bracket 2851-2950 → bedrag op schijf 2900). JS: `Math.floor((m + 49) / 100) * 100`. Geldt voor 2026-hoofdsom, brandstoftoeslag én 1995-grondslag.
- **MRB_1995-constantsblok** — Staatsblad 1995, 152: schijven 500-1000 kg op €14,50 / €17,33 / €20,40 / €26,98 / €34,12 / €45,81; daarboven +€11,68 per schijf van 100 kg. Conversie NLG → EUR via 2,20371. Bevroren — verandert niet bij 2026-tariefverhogingen.
- **Auto-detectie fijnstoftoeslag** — strikt per artikel 23 lid 4 Wet MRB '94: (a) RDW-veld `uitstoot_deeltjes_licht` > 0,005 g/km → toeslag aan; (b) ontbrekend fijnstof-veld + DET vóór 1 sept 2009 → toeslag aan. Geen EURO-klasse-heuristiek meer (gaf vals-positieven). Handmatig overschrijven mogelijk via geavanceerd-paneel.
- **MRB-validatieveld** — invoer voor het werkelijke MRB-bedrag op de aanslag; toont een banner met afwijking en kleur (groen ≤ €0,50, oranje ≤ €5, rood daarboven) zodat kalibratie tegen een echte aanslag in één blik zichtbaar is.
- **Live RDW-validatie in zelftest** — fetcht de anchor-fixture live en checkt alle vier aanslag-componenten end-to-end (basisbedrag €204,82, brandstoftoeslag €242,20, opcenten €109,90, totaal €556,92).
- **Bron-referentie `docs/sources/opcenten-mrb-1995-grondslag.md`** — volledige documentatie van de 1995-grondslag-tabel, schijfafronding, opcenten-formule, en CVDR-links per provincie (alle 12 verordeningen + niet-ingezetenen-tarief). Auditstap voor jaarlijks onderhoud.
- **MRB-breakdown in profiel** — collapsible "Hoe is dit MRB-bedrag opgebouwd?" toont elke stap (hoofdsom, opcenten, brandstoftoeslag, fijnstoftoeslag, totaal) zodat de berekening verifieerbaar is.
- **Soft warning bij niet-kampeerwagen-inrichting** — RDW-data tonen waarschuwing als `inrichting` niet "kampeerwagen" is, maar blokkeert niet (relevante voor recente ombouw).
- **Geavanceerde overrides** — collapsible details-blok met: handmatige fijnstof-checkbox, handmatige MRB-bedrag, en uitschakelbare "behandelen als kampeerauto"-toggle (voor wie geen kampeerauto-registratie heeft).
- **Self-test uitgebreid met MRB-fixtures** — 12 testcases incl. anchor-fixture de anchor-fixture (matcht echte aanslag op de cent), schijfgrens-cases 850/851 kg en 1450/1451 kg (xx51..xx50-overgang), brandstoftypes, provincies, fijnstof-randgevallen. Tolerantie €0,02 op afronding. Draait samen met de bestaande datum-tests én de live RDW-fetch.
- **Constants-blok** `MRB_2026` met alle Belastingdienst-tarieven 2026 + opcenten 12 provincies — één plek voor het jaarlijkse onderhoud (1995-tabel apart in `MRB_1995`, bevroren).

### Changed
- **Profiel-tab herontworpen** — handmatige velden voor DET / massa / kentekensoort / MRB-per-kwartaal vervangen door kenteken + provincie. De handmatige MRB-override is verplaatst naar het geavanceerde paneel.
- **Help-tab uitgebreid** met sectie "MRB-berekening 2026 (camper, halftarief)" en bronvermelding (Belastingdienst-memo B/CAP/Auto/GWH, CBS-tabel 80889ned, RDW open-data datasets).
- **`<meta name="app-version">`** is geen vervanging meer voor de breakdown — versie blijft wel als single source-of-truth in `package.json`.

### Migrated
- **localStorage v1 → v2** — bestaande profielen met `det`/`mass`/`reg`/`mrbPerKwartaal` worden niet stilletjes leeggegooid: de oude MRB-waarde wordt automatisch in het handmatige-override-veld gezet zodat downstream-berekeningen blijven werken. De gebruiker kan vervolgens een kenteken invoeren om over te stappen op auto-berekening.

### Fixed
- **Opcenten structureel verkeerd berekend (€168,16 i.p.v. €109,90 voor de anchor-fixture)** — root cause: opcenten werden geheven over de actuele 2026-hoofdsom, terwijl artikel 222 Provinciewet ze koppelt aan een **bevroren tarief vastgesteld op 1 april 1995**. Verordening Noord-Holland CVDR60304 zegt letterlijk: "een percentage van de (gefixeerde) hoofdsom motorrijtuigenbelasting, zoals het tarief daarvan is vastgesteld op 1 april 1995". Sinds '95 is het rijksdeel met ~53 % verhoogd; die verhoging telt niet mee voor opcenten. De 1995-tabel staat in Staatsblad 1995, 152 (artikel 23 lid 1 in toenmalige guldens) en is nu apart geconstrueerd in `MRB_1995`. Verifieerbaar tegen de anchor-fixture-aanslag: 1995-hoofdsom @ 2900 = €267,73 → halftarief €133,87 → NH 82,1 % = €109,90 ✓ exact.
- **Schijfafronding fout** — eerdere code gebruikte eerst `Math.ceil(m/100)*100` (overschatte randgevallen), daarna lineair-per-kg (onderschatte randgevallen). Beide structureel fout. Belastingdienst hanteert 100kg-brackets met breakpoints op xx50/xx51: bracket 2851 t/m 2950 → schijf 2900 (gebruiker-bevestigd via aanslag-uitsplitsing). Correcte formule: `Math.floor((m + 49) / 100) * 100`.
- **Pseudo-fix "chassis-massa-override" teruggedraaid** — de v0.2.0-rc2 hypothese dat BD een aparte chassis-massa (~2078 kg pre-camperombouw) gebruikt voor opcenten was ongefundeerd; de eigen-massa-override leek de €109,90 te raken maar brak basisbedrag/brandstoftoeslag. Herleidbaar nu vanuit één RDW-massa (2890 kg) plus de 1995-grondslag — het override-veld is verwijderd uit de UI en het profiel-schema. Bestaande profielen met `eigenMassaOverride` worden bij het inlezen genegeerd (geen migratie nodig — was geen geldig dataveld).
- **Vals-positieve fijnstoftoeslag op post-2009 EURO 4 diesels** — root cause: de auto-suggestie gebruikte een EURO-klasse-heuristiek (`euroClass ≤ 4 → aan`), maar artikel 23 lid 4 Wet MRB '94 koppelt de toeslag uitsluitend aan (a) geregistreerde fijnstofuitstoot > 0,005 g/km of (b) DET vóór 1 sept 2009 zonder geregistreerde uitstoot. Voor de anchor-fixture (DET 2012, EURO 4, geen `uitstoot_deeltjes_licht`) firede de heuristiek wel, terwijl de echte aanslag géén toeslag bevat. Logica vervangen door directe lezing van `uitstoot_deeltjes_licht` met DET-fallback alleen als dat veld ontbreekt.

## [0.1.0] — 2026-05-04

Eerste publieke release. Functioneel gelijk aan de live versie op
[mycamper.app/schorsing](https://mycamper.app/schorsing).

### Added
- **Profiel-tab** — DET, massa, kentekensoort (M1 / niet-M1) en MRB-per-kwartaal als invoer; afgeleid: huidig schorsingstarief, MRB per dag/maand/jaar, datum overgang naar laag tarief (DET + 15 jaar).
- **Tab 1 — Vroegst ontschorsen** — minimumduur RDW-schorsing (1 kalendermaand + 1 dag).
- **Tab 2 — Tussen vakanties** — loont schorsen tussen twee vakantieperiodes, inclusief leges + 8/91-dagen ondergrens en €5 niet-uitkeerbare-restitutie-grens.
- **Tab 3 — Jaarplanning** — meerdere vakanties, totale netto-besparing per jaar.
- **Tab 4 — Lange termijn** — kostenoptimum bij langdurige stilstand (1-jaar aanvraag vs. jaarverlengingen).
- **Tab Regels & uitleg** — RDW-tarieven 2026, MRB-mechaniek, bronnen en zelftest met groene/rode resultaatregels.
- **Dark mode** via `prefers-color-scheme: dark` met eigen tokenset.
- **localStorage**-persistentie voor profiel en jaarplanning.
- **a11y** — `role="tablist"` / `aria-selected` op tabs, `aria-live` op zelftest-output.
- **Date-inputs** met expliciet `dd/mm/jjjj`-formaat (geen native `<input type="date">`).
- **MIT-licentie** (`LICENSE`) + Syquens B.V.-footer.
- **Privacy-guard git hooks** (`hooks/pre-commit`, `hooks/pre-push`) — scannen staged/pushed content op persoonlijke identifiers en blokkeren bij hits. Patronen in `hooks/check-personal-info.sh`. Installer: `scripts/install-hooks.ps1` / `scripts/install-hooks.sh`.
- **`.gitattributes`** voor consistente line-endings.
- **Hosted deploy** naar `https://mycamper.app/schorsing` (statisch nginx-container op monkey.syquens.com; stack-config in MyServers-repo).

### Domeinregels (peildatum 2026)
- RDW-minimum schorsing: 1 kalendermaand + 1 dag.
- Hoog tarief: M1 + < 15 jaar oud + ≤ 3500 kg. Anders laag tarief.
- Tariefovergang: DET + 15 jaar.
- 2026 RDW-leges: hoog €88,05 (1y aanvraag) + €29,10/jaar verlenging; laag €29,10 vlak.
- MRB per dag = kwartaalbedrag / 91,25.
- Restituties < €5 worden niet uitbetaald.

### Known Issues
- BPM, fijnstoftoeslag en provinciale opcenten worden niet apart gemodelleerd — gebruiker baked die in zijn handmatig ingevoerde MRB-per-kwartaal. (Wegnemen in een volgende minor met RDW-API + opcenten-tabel.)
- Geen koppeling met RDW of DigiD.
