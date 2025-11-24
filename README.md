# Cronometro - Applicazione Flutter

**Sviluppatore:** Camillo della Corte
**Repository:** https://github.com/camillodellacorte/dellaCorteCamillo_stopwatch.git

## Descrizione del Progetto

Applicazione cronometro sviluppata in Flutter che utilizza gli **Stream** per gestire eventi periodici e aggiornare l'interfaccia in tempo reale. Il cronometro mostra i minuti e secondi trascorsi, e conta i "tick" generati ogni 200 millisecondi mentre è attivo.

## Funzionalità Principali

- **Display cronometro**: visualizzazione in formato MM:SS (minuti:secondi)
- **Contatore tick**: mostra quanti eventi tick (ogni 200ms) sono stati generati
- **Controllo START/STOP**: pulsante per avviare e fermare il cronometro
- **Controllo PAUSE/RESUME**: pulsante per mettere in pausa e riprendere
- **Funzione RESET**: per azzerare il cronometro dopo averlo fermato

## Architettura e Scelte Tecniche

### 1. Gestione degli Stream

**Due Stream indipendenti ma sincronizzati:**

- **Stream Tick** (200ms): genera eventi ogni 200 millisecondi usando `Timer.periodic`
- **Stream Secondi** (1000ms): genera eventi ogni secondo per aggiornare il display

**Motivazione:** Ho utilizzato `StreamController` per creare stream personalizzati che possono essere facilmente controllati (avviati, fermati, messi in pausa). Questo approccio permette di separare la logica di generazione degli eventi dalla loro visualizzazione.

### 2. Correlazione tra gli Stream

Gli stream sono correlati tramite i **Timer** e le **variabili di stato** (`_isRunning`, `_isPaused`):

- Quando premo START, entrambi i timer partono contemporaneamente
- Quando premo PAUSE, entrambi i timer vengono cancellati e lo stato viene salvato
- Quando premo RESUME, i timer ripartono dai valori salvati
- Quando premo STOP, i timer vengono cancellati ma i valori rimangono visibili
- Quando premo RESET, tutto viene azzerato

**Motivazione:** Questa sincronizzazione garantisce che tick e secondi si fermino e ripartano insieme, mantenendo la coerenza dei dati.

### 3. Gestione dello Stato

Ho utilizzato un **StatefulWidget** con variabili di stato locali:

- `_tickCount`: contatore dei tick
- `_seconds`: contatore dei secondi
- `_isRunning`: indica se il cronometro è in esecuzione
- `_isPaused`: indica se il cronometro è in pausa

### 4. Logica dei Pulsanti

- **Pulsante 1 (START/STOP):**
  - Verde "START" quando è fermo e azzerato
  - Rosso "STOP" quando è in esecuzione o in pausa

- **Pulsante 2 (PAUSE/RESUME/RESET):**
  - Blu "PAUSE" quando è in esecuzione
  - Arancione "RESUME" quando è in pausa
  - Grigio "RESET" quando è fermo con tempo visualizzato

## Come Eseguire l'Applicazione

1. Assicurati di avere Flutter installato:
```bash
flutter --version
```

2. Scarica le dipendenze:
```bash
flutter pub get
```

3. Esegui l'applicazione:
```bash
flutter run
```

4. Per il web:
```bash
flutter run -d chrome
```

## Struttura del Progetto

```
lib/
└── main.dart          # File principale con tutta la logica dell'app
```

## Tecnologie Utilizzate

- **Flutter**: framework per lo sviluppo cross-platform
- **Dart**: linguaggio di programmazione
- **Stream & StreamController**: per la programmazione reattiva
- **Timer.periodic**: per generare eventi periodici
