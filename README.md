# Camper Schorsingscalculator

Een Nederlandse single-page rekentool die helpt bepalen of, wanneer en hoe lang
je je camper bij de RDW kunt schorsen om motorrijtuigenbelasting (MRB) te besparen.

## Gebruik

Open `camper-schorsingscalculator.html` rechtstreeks in een browser. Geen build,
geen dependencies. Profiel- en jaarplanninggegevens worden lokaal in
`localStorage` bewaard.

## Functies

- **Profiel** — DET, massa, kentekensoort, MRB/kwartaal → tarief en MRB-per-dag.
- **1. Vroegst ontschorsen** — minimumduur (1 maand + 1 dag) vanaf een schorsingsdatum.
- **2. Tussen vakanties** — loont schorsen tussen twee vakantieperiodes?
- **3. Jaarplanning** — meerdere vakanties, totale besparing per jaar.
- **4. Lange termijn** — kostenoptimum bij langdurige stilstand.
- **Regels & uitleg** — RDW-tarieven 2026, MRB-mechaniek, bronnen, zelftest.

## Bijdragen / contributing

Na clone één keer de privacy-guard hooks activeren:

```powershell
# Windows
.\scripts\install-hooks.ps1
```

```sh
# macOS / Linux
sh scripts/install-hooks.sh
```

Dit zet `core.hooksPath` op `hooks/`, waarna `pre-commit` en `pre-push` elke
commit en push scannen op persoonsgegevens en blokkeren als er een match is.
Patronen staan in `hooks/check-personal-info.sh`.

## Disclaimer

Indicatieve berekening op basis van publiek beschikbare RDW- en
Belastingdienst-informatie (peildatum 2026). Geen koppeling met RDW of DigiD.
Verifieer altijd via [rdw.nl](https://www.rdw.nl/) en de Belastingdienst voor
definitieve bedragen.
