--------------------------------------------------------
--  File creato - venerdì-aprile-03-2026   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View VW_ACN_ASSET_CRITICI
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PEGASO_PROD"."VW_ACN_ASSET_CRITICI" ("TAG_ACN", "ID_ASSET", "NOME_ASSET", "DESCRIZIONE", "TIPO_ASSET", "NATURA_ASSET", "INDIRIZZO_IP", "MAC_ADDRESS", "CRITICITA_ASSET", "OWNER_ASSET", "CUSTODE_ASSET", "ASSEGNATO_A", "REPARTI_ASSOCIATI") AS 
  SELECT
    ta.tag_acn,
    a.id AS id_asset,
    a.nome AS nome_asset,
    a.descrizione,
    tpa.nome AS tipo_asset,
    CASE 
        WHEN tpa.fisico = 1 THEN 'Fisico'
        ELSE 'Logico'
    END AS natura_asset,
    a.indirizzo_ip,
    a.mac_address,
    cr.nome AS criticita_asset,
    so.nome || ' ' || so.cognome AS owner_asset,
    sc.nome || ' ' || sc.cognome AS custode_asset,
    sa.nome || ' ' || sa.cognome AS assegnato_a,
    LISTAGG(DISTINCT r.nome_reparto, ', ')
        WITHIN GROUP (ORDER BY r.nome_reparto) AS reparti_associati
FROM asset a
JOIN tipi_acn ta
    ON ta.id = a.tipo_acn
JOIN tipi_asset tpa
    ON tpa.id = a.id_tipo
JOIN criticita cr
    ON cr.id = a.livello_criticita
JOIN soggetti so
    ON so.id = a.id_soggetto_owner
JOIN soggetti sc
    ON sc.id = a.id_soggetto_custode
LEFT JOIN soggetti sa
    ON sa.id = a.id_soggetto_assegnato_a
LEFT JOIN asset_reparti ar
    ON ar.id_asset = a.id
   AND ar.attivo = 1
LEFT JOIN reparti r
    ON r.id = ar.id_reparto
   AND r.attivo = 1
WHERE a.attivo = 1
GROUP BY
    ta.tag_acn,
    a.id,
    a.nome,
    a.descrizione,
    tpa.nome,
    tpa.fisico,
    a.indirizzo_ip,
    a.mac_address,
    cr.nome,
    so.nome,
    so.cognome,
    sc.nome,
    sc.cognome,
    sa.nome,
    sa.cognome
;
--------------------------------------------------------
--  DDL for View VW_ACN_DIP_ASSET_FORNITORI
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PEGASO_PROD"."VW_ACN_DIP_ASSET_FORNITORI" ("ID_ASSET", "ASSET_DIPENDENTE", "TAG_ACN", "CRITICITA_ASSET", "ID_FORNITORE", "FORNITORE", "CODICE_FISCALE", "INDIRIZZO_EMAIL", "NUMERO_TELEFONO", "NOME_COMUNE", "NOME_PROVINCIA", "NOME_STATO", "INDIRIZZO_SEDE") AS 
  SELECT
    a.id AS id_asset,
    a.nome AS asset_dipendente,
    ta.tag_acn,
    cr.nome AS criticita_asset,
    f.id AS id_fornitore,
    f.ragione_sociale AS fornitore,
    f.codice_fiscale,
    f.indirizzo_email,
    f.numero_telefono,
    c.nome_comune,
    p.nome_provincia,
    st.nome_stato,
    f.indirizzo_sede
FROM dipendenze_asset_fornitore daf
JOIN asset a
    ON a.id = daf.id_asset_dipendente
JOIN tipi_acn ta
    ON ta.id = a.tipo_acn
JOIN criticita cr
    ON cr.id = a.livello_criticita
JOIN fornitori f
    ON f.id = daf.id_fornitore_supporto
JOIN comuni c
    ON c.id = f.id_comune_sede
JOIN province p
    ON p.id = c.id_provincia
JOIN stati st
    ON st.id = p.id_stato
WHERE daf.attivo = 1
  AND a.attivo = 1
  AND f.attivo = 1
;
--------------------------------------------------------
--  DDL for View VW_ACN_DIP_SERVIZI_FORNITORI
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PEGASO_PROD"."VW_ACN_DIP_SERVIZI_FORNITORI" ("ID_SERVIZIO", "SERVIZIO_DIPENDENTE", "TAG_ACN", "CRITICITA_SERVIZIO", "ID_FORNITORE", "FORNITORE", "CODICE_FISCALE", "INDIRIZZO_EMAIL", "NUMERO_TELEFONO", "NOME_COMUNE", "NOME_PROVINCIA", "NOME_STATO", "INDIRIZZO_SEDE") AS 
  SELECT
    sv.id AS id_servizio,
    sv.nome AS servizio_dipendente,
    ta.tag_acn,
    cr.nome AS criticita_servizio,
    f.id AS id_fornitore,
    f.ragione_sociale AS fornitore,
    f.codice_fiscale,
    f.indirizzo_email,
    f.numero_telefono,
    c.nome_comune,
    p.nome_provincia,
    st.nome_stato,
    f.indirizzo_sede
FROM dipendenze_servizi_fornitore dsf
JOIN servizi sv
    ON sv.id = dsf.id_servizio_dipendente
JOIN tipi_acn ta
    ON ta.id = sv.tipo_acn
JOIN criticita cr
    ON cr.id = sv.livello_criticita
JOIN fornitori f
    ON f.id = dsf.id_fornitore_supporto
JOIN comuni c
    ON c.id = f.id_comune_sede
JOIN province p
    ON p.id = c.id_provincia
JOIN stati st
    ON st.id = p.id_stato
WHERE dsf.attivo = 1
  AND sv.attivo = 1
  AND f.attivo = 1
;
--------------------------------------------------------
--  DDL for View VW_ACN_ORGANIZZAZIONE_RESP
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PEGASO_PROD"."VW_ACN_ORGANIZZAZIONE_RESP" ("ID", "RAGIONE_SOCIALE", "CODICE_FISCALE", "ORGANIZZAZIONE_PADRE", "RESPONSABILE_ORGANIZZAZIONE", "INDIRIZZO_EMAIL", "NUMERO_TELEFONO", "ATTIVO") AS 
  SELECT 
    o.id,
    o.ragione_sociale,
    o.codice_fiscale,
    op.ragione_sociale AS organizzazione_padre,
    s.nome || ' ' || s.cognome AS responsabile_organizzazione,
    s.indirizzo_email,
    s.numero_telefono,
    o.attivo
FROM organizzazioni o
LEFT JOIN organizzazioni op
    ON op.id = o.org_padre_id
LEFT JOIN soggetti s
    ON s.id = o.id_soggetto_responsabile
WHERE o.attivo = 1
;
--------------------------------------------------------
--  DDL for View VW_ACN_REPARTI_REFERENTI
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PEGASO_PROD"."VW_ACN_REPARTI_REFERENTI" ("RAGIONE_SOCIALE", "NOME_SEDE", "ID_REPARTO", "NOME_REPARTO", "DESCRIZIONE_REPARTO", "RESPONSABILE_REPARTO", "EMAIL_RESPONSABILE", "REFERENTE_NIS", "EMAIL_REFERENTE_NIS") AS 
  SELECT
    o.ragione_sociale,
    se.nome_sede,
    r.id AS id_reparto,
    r.nome_reparto,
    r.descrizione_reparto,
    sr.nome || ' ' || sr.cognome AS responsabile_reparto,
    sr.indirizzo_email AS email_responsabile,
    sn.nome || ' ' || sn.cognome AS referente_nis,
    sn.indirizzo_email AS email_referente_nis
FROM reparti r
JOIN sedi se
    ON se.id = r.id_sede
JOIN organizzazioni o
    ON o.id = se.id_org
JOIN soggetti sr
    ON sr.id = r.id_soggetto_responsabile
JOIN soggetti sn
    ON sn.id = r.id_soggetto_referente_nis
WHERE r.attivo = 1
  AND se.attivo = 1
  AND o.attivo = 1
;
--------------------------------------------------------
--  DDL for View VW_ACN_RESPONSABILITA
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PEGASO_PROD"."VW_ACN_RESPONSABILITA" ("AMBITO", "ID_OGGETTO", "OGGETTO", "RESPONSABILE", "INDIRIZZO_EMAIL") AS 
  SELECT 'ORGANIZZAZIONE' AS ambito,
       o.id AS id_oggetto,
       o.ragione_sociale AS oggetto,
       s.nome || ' ' || s.cognome AS responsabile,
       s.indirizzo_email
FROM organizzazioni o
JOIN soggetti s
    ON s.id = o.id_soggetto_responsabile
WHERE o.attivo = 1

UNION ALL

SELECT 'SEDE' AS ambito,
       se.id AS id_oggetto,
       se.nome_sede AS oggetto,
       s.nome || ' ' || s.cognome AS responsabile,
       s.indirizzo_email
FROM sedi se
JOIN soggetti s
    ON s.id = se.id_soggetto_responsabile
WHERE se.attivo = 1

UNION ALL

SELECT 'REPARTO' AS ambito,
       r.id AS id_oggetto,
       r.nome_reparto AS oggetto,
       s.nome || ' ' || s.cognome AS responsabile,
       s.indirizzo_email
FROM reparti r
JOIN soggetti s
    ON s.id = r.id_soggetto_responsabile
WHERE r.attivo = 1

UNION ALL

SELECT 'SERVIZIO' AS ambito,
       sv.id AS id_oggetto,
       sv.nome AS oggetto,
       s.nome || ' ' || s.cognome AS responsabile,
       s.indirizzo_email
FROM servizi sv
JOIN soggetti s
    ON s.id = sv.id_soggetto_responsabile
WHERE sv.attivo = 1

UNION ALL

SELECT 'ASSET_OWNER' AS ambito,
       a.id AS id_oggetto,
       a.nome AS oggetto,
       s.nome || ' ' || s.cognome AS responsabile,
       s.indirizzo_email
FROM asset a
JOIN soggetti s
    ON s.id = a.id_soggetto_owner
WHERE a.attivo = 1

UNION ALL

SELECT 'ASSET_CUSTODE' AS ambito,
       a.id AS id_oggetto,
       a.nome AS oggetto,
       s.nome || ' ' || s.cognome AS responsabile,
       s.indirizzo_email
FROM asset a
JOIN soggetti s
    ON s.id = a.id_soggetto_custode
WHERE a.attivo = 1
;
--------------------------------------------------------
--  DDL for View VW_ACN_SERVIZI_CRITICI
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PEGASO_PROD"."VW_ACN_SERVIZI_CRITICI" ("TAG_ACN", "ID_SERVIZIO", "NOME_SERVIZIO", "DESCRIZIONE", "TIPO_SERVIZIO", "CATEGORIA_SERVIZIO", "CRITICITA_SERVIZIO", "RESPONSABILE_SERVIZIO", "INDIRIZZO_EMAIL", "REPARTI_COINVOLTI") AS 
  SELECT
    ta.tag_acn,
    sv.id AS id_servizio,
    sv.nome AS nome_servizio,
    sv.descrizione,
    CASE 
        WHEN sv.tipo_servizio = 'I' THEN 'Interno'
        WHEN sv.tipo_servizio = 'E' THEN 'Esterno'
        ELSE sv.tipo_servizio
    END AS tipo_servizio,
    cs.nome AS categoria_servizio,
    cr.nome AS criticita_servizio,
    s.nome || ' ' || s.cognome AS responsabile_servizio,
    s.indirizzo_email,
    LISTAGG(DISTINCT r.nome_reparto, ', ') 
        WITHIN GROUP (ORDER BY r.nome_reparto) AS reparti_coinvolti
FROM servizi sv
JOIN tipi_acn ta
    ON ta.id = sv.tipo_acn
JOIN categoria_servizi cs
    ON cs.id = sv.id_categoria_servizio
JOIN criticita cr
    ON cr.id = sv.livello_criticita
JOIN soggetti s
    ON s.id = sv.id_soggetto_responsabile
LEFT JOIN reparti_servizi rs
    ON rs.id_servizio = sv.id
   AND rs.attivo = 1
LEFT JOIN reparti r
    ON r.id = rs.id_reparto
   AND r.attivo = 1
WHERE sv.attivo = 1
GROUP BY
    ta.tag_acn,
    sv.id,
    sv.nome,
    sv.descrizione,
    sv.tipo_servizio,
    cs.nome,
    cr.nome,
    s.nome,
    s.cognome,
    s.indirizzo_email
;
