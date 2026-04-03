
 Basi di Dati per PW – Rubens Babolin

 Descrizione del progetto
Questo repository contiene la documentazione e gli script SQL relativi al progetto di basi di dati sviluppato per la prova finale.  
L’obiettivo del progetto è la realizzazione di un database relazionale per la gestione strutturata delle informazioni necessarie alla compilazione dei profili ACN, con particolare attenzione ad asset, servizi, soggetti, responsabilità organizzative e dipendenze.

---

 Struttura delle cartelle

 DOCUMENTI
In questa cartella sono presenti i documenti di supporto al progetto, utili per descrivere e comprendere la struttura della base dati.

Contenuto:
- Diagramma E-R in formato PNG → diagramma er.png
- Data Dictionary del database → Data Dictionary.xlsx
- Schema relazionale del database → Schema relazionale.pdf

---

 EXPORTDB
In questa cartella sono presenti gli export generati a partire dalle viste create nel database.  
Gli export possono essere utilizzati per consultazione, verifica dei dati e supporto alla produzione dei profili richiesti.

---

 SCRIPTSQL
In questa cartella sono presenti tutti i file .sql necessari per la creazione e il popolamento del database.

Contenuto:
- 1 - Creazione utente.sql  
  Contiene lo script per la creazione dell’utente/schema dedicato al progetto.

- 2 - Script creazione tabelle.sql  
  Contiene gli script di creazione delle tabelle, dei vincoli, delle chiavi esterne, degli indici e dei trigger.

- 3 - Inserimento dati per test.sql  
  Contiene gli INSERT INTO per il caricamento dei dati di prova, utilizzati per verificare il corretto funzionamento della struttura e delle query.

- 4 - Creazione viste.sql  
  Contiene gli script per la creazione delle viste utilizzate per l’estrazione e l’organizzazione dei dati.

----------

 Istruzioni per la replica del database

Per replicare correttamente l’ambiente di lavoro è necessario predisporre un’istanza Oracle in Docker, creare l’utente dedicato al progetto ed eseguire gli script SQL nell’ordine corretto.

 Replica del database con Oracle XE

1. Installare Oracle Database XE.
2. Aprire SQL Developer e collegarsi con l’utente system usando:
   - Host: localhost
   - Porta: 1521
   - Service name: XEPDB1
3. Eseguire lo script 1 - Creazione utente.sql.
4. Creare una nuova connessione con l’utente di progetto.
5. Eseguire nell’ordine:
   - 2 - Script creazione tabelle.sql
   - 3 - Inserimento dati per test.sql
   - 4 - Creazione viste.sql



