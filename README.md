# Camper Schorsingscalculator

Single-page Nederlandse rekentool die helpt bepalen of, wanneer en hoe lang
je je camper bij de RDW kunt schorsen om motorrijtuigenbelasting (MRB) te
besparen — én die zelfstandig de MRB voor je uitrekent op basis van een
RDW-kentekenlookup.

**Live:** [mycamper.app/schorsing](https://mycamper.app/schorsing)
**Repo:** [github.com/VinceVerbon/schorsingscalculator](https://github.com/VinceVerbon/schorsingscalculator)
**Licentie:** MIT

## Gebruik

Open `camper-schorsingscalculator.html` rechtstreeks in een browser. Geen build,
geen dependencies. Profiel + jaarplanning worden lokaal in `localStorage`
bewaard. Geen DigiD, geen account, geen serverside.

## Functies

### Profiel
- **Kentekenlookup** via [opendata.rdw.nl](https://opendata.rdw.nl/) (gratis,
  geen DigiD). Haalt merk, model, datum eerste toelating, datum tenaamstelling,
  leeggewicht, max. massa, voertuigsoort, inrichting, brandstof en
  EURO-emissieniveau op.
- **Provincie-dropdown** — alle 12 provincies plus niet-ingezetenen, met de
  juiste opcenten 2026.
- **Volledige MRB-berekening** voor kampeerauto's vanaf 1 januari 2026
  (halftarief, was kwarttarief in 2025):
  - basisbedrag op leeggewicht (Belastingdienst-tarief 2026, schijven van 100 kg)
  - brandstoftoeslag voor diesel / LPG / aardgas
  - **provinciale opcenten over de bevroren 1995-grondslag** (artikel 222
    Provinciewet — uniform voor alle 12 provincies; alleen het percentage
    verschilt)
  - fijnstoftoeslag voor oudere diesels (auto-detectie via RDW-veld
    `uitstoot_deeltjes_licht` met DET-fallback voor pre-1-9-2009 voertuigen)
  - aanslagbedrag naar beneden afgerond op hele euro's, exact zoals op de aanslag
- **Validatieveld** — vul je werkelijke aanslag in en de tool toont match/diff.
- **Geavanceerde overrides** — handmatig fijnstof-toggle, handmatig MRB-bedrag,
  uitschakelbare "behandelen als kampeerauto"-toggle.

### Vier rekenscenario's
1. **Vroegst ontschorsen** — minimumduur RDW-schorsing (1 kalendermaand + 1 dag).
2. **Tussen vakanties** — loont schorsen tussen twee vakantieperiodes,
   inclusief leges + 8/91-dagen ondergrens en €5 niet-uitkeerbare-restitutie-grens.
3. **Jaarplanning** — meerdere vakanties, totale netto-besparing per jaar.
4. **Lange termijn** — kostenoptimum bij langdurige stilstand
   (1-jaar aanvraag vs. jaarverlengingen).

### Regels & uitleg
- RDW-schorsingsregels, 2026-tarieven en MRB-mechaniek in mensentaal.
- Bronnenlijst met klikbare links (RDW, Belastingdienst, CBS, Provinciewet, NKC).
- Zelftest-blok met groen/rood resultaat over alle gewichtschijven, brandstoftypes,
  provincies en fijnstof-randgevallen + datum-arithmetiek.

### UX-fundament
- Dark mode via `prefers-color-scheme: dark` met eigen tokenset.
- Date-inputs in `dd/mm/jjjj` (geen native `<input type="date">`, voor
  consistente Nederlandse formattering).
- a11y: `role="tablist"` / `aria-selected` op tabs, `aria-live` op zelftest-output.
- Versionering: SemVer in `package.json`, gemirrord in HTML-meta en footer.

## Project-layout

```
.
├── camper-schorsingscalculator.html   single-page app (HTML+CSS+JS, geen build)
├── package.json                        SemVer source-of-truth
├── CHANGELOG.md                        Keep-a-Changelog
├── README.md                           dit bestand
├── LICENSE                             MIT
├── .gitattributes                      cross-platform line-endings
├── docs/
│   ├── releaselog.md                   bilingual EN/NL one-row-per-version index
│   ├── release-notes/                  per-versie narratieve release notes
│   └── sources/
│       └── opcenten-mrb-1995-grondslag.md  audit-trail voor opcenten-formule
│                                            + CVDR-link per provincie
├── hooks/
│   ├── pre-commit                      privacy-guard scanner
│   ├── pre-push                        idem, force-push-tolerant
│   └── check-personal-info.sh          patronen
└── scripts/
    ├── install-hooks.ps1               Windows hook-installer
    └── install-hooks.sh                POSIX hook-installer
```

## Onderhoud / jaarwisseling

Bij elk nieuw jaar:
1. Belastingdienst-memo "Tarieven motorrijtuigenbelasting per [jaar]" binnenhalen
   en `MRB_2026.hoofdsom` / `MRB_2026.diesel` / `MRB_2026.lpg` /
   `MRB_2026.aardgasG3` herijken in `camper-schorsingscalculator.html`.
2. CBS-tabel [80889ned](https://www.cbs.nl/nl-nl/cijfers/detail/80889ned) checken
   en de 12 percentages in `MRB_2026.opcenten` bijwerken.
3. RDW-leges 2026 (`RDW_FEES_2026`) checken — verandert zelden.
4. `MRB_1995.hoofdsom` is wettelijk bevroren — nooit aanpassen tenzij de
   wet zelf (artikel 222 Provinciewet) gewijzigd wordt.
5. Zelftest-fixtures opnieuw doorrekenen tegen de nieuwe tarieven; eventueel
   nieuwe schijfgrens-cases toevoegen.
6. Verwijzing naar het peildatum-jaar in `CLAUDE.md` updaten.

Volledige formule-onderbouwing: [`docs/sources/opcenten-mrb-1995-grondslag.md`](docs/sources/opcenten-mrb-1995-grondslag.md).

## Bijdragen

Na clone één keer de privacy-guard hooks activeren:

```powershell
# Windows
.\scripts\install-hooks.ps1
```

```sh
# macOS / Linux
sh scripts/install-hooks.sh
```

Dit zet `core.hooksPath` op `hooks/`. `pre-commit` en `pre-push` scannen
elke commit en push op persoonsgegevens (e-mailadressen, GitHub-tokens,
1Password-references, kenteken-patronen, persoonlijke paden) en blokkeren
bij een match. Patronen staan in [`hooks/check-personal-info.sh`](hooks/check-personal-info.sh).

## Hosted deployment

Statische nginx-container op `monkey.syquens.com` achter Traefik. Routine
deploy na elke push:

```bash
ssh monkey-automation 'cd /srv/containers/schorsing/repo && git pull --ff-only && cp camper-schorsingscalculator.html ../site/index.html'
```

Browser-cache `max-age=300` (max 5 min stale). Stack-config (compose,
Traefik labels, nginx.conf, security headers) leeft in de **MyServers**-repo,
niet hier — deze repo bevat alleen de HTML/CSS/JS-payload.

## Disclaimer

Indicatieve berekening op basis van publiek beschikbare RDW- en
Belastingdienst-informatie (peildatum 2026). Geen koppeling met RDW of
DigiD. Verifieer altijd via [rdw.nl](https://www.rdw.nl/) en de
[Belastingdienst](https://www.belastingdienst.nl/) voor definitieve bedragen.

Niet in scope: BPM (aanschafbelasting), verzekering, APK-planning,
oldtimer-overgangsregeling artikel 84a — gebruik daarvoor de handmatige
MRB-override in het profiel.
