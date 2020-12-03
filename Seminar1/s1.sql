--crearea tabelei Abonati cu indicarea restrictiilor in-line (la nivel de coloana)
CREATE TABLE abonati (
    id_abonat CHAR(3) CONSTRAINT pk_abonati PRIMARY KEY,
    cnp CHAR(13) CONSTRAINT uq_cnp UNIQUE,
    nume VARCHAR2(25) CONSTRAINT nn_nume NOT NULL,
    prenume VARCHAR2(25) NOT NULL,
    adresa VARCHAR2(30)
);

--crearea tabelei Fise cu indicarea restrictiilor out-of-line (la nivel de tabela)
CREATE TABLE fise (
    id_fisa          NUMBER,
    data_completare  DATE,
    id_abonat        CHAR(3),
    CONSTRAINT pk_fise PRIMARY KEY (id_fisa),
    CONSTRAINT nn_data CHECK (data_completare IS NOT NULL),
    CONSTRAINT fk_abonati FOREIGN KEY (id_abonat) REFERENCES abonati(id_abonat)
);

CREATE TABLE carti (
    ISBN   CHAR(10) CONSTRAINT pk_isbn PRIMARY KEY,
    titlu_carte  VARCHAR2(20) NOT NULL,
    autori  VARCHAR2(20) NOT NULL
);

CREATE TABLE detalii_fise (
    ISBN CHAR(10) CONSTRAINT fk_carti REFERENCES carti(ISBN), --definirea in-line a restrictiei de cheie externa !! FARA indicarea explicita a tipului de restrictie FOREIGN KEY
    nr_fisa NUMBER,
    data_retur Date,
    CONSTRAINT fk_fise FOREIGN KEY (nr_fisa) REFERENCES fise(id_fisa), --definirea out-of-line a restrictiei de cheie externa
    CONSTRAINT pk_detalii PRIMARY KEY (ISBN, nr_fisa) -- definirea cheii primare compuse !! se poate numai out-of-line
);

--LDD> ALTER, DROP
--ALTER TABLE numetabela CLAUZE SPECIFICE;

ALTER TABLE abonati
ADD (email VARCHAR2(20), telefon VARCHAR2(15));

ALTER TABLE abonati
MODIFY adresa VARCHAR2(40); --adaugam alte restrictii

ALTER TABLE abonati
RENAME COLUMN nume TO nume_abonati;

ALTER TABLE abonati
DROP COLUMN adresa; --stergem coloana

ALTER TABLE abonati
MODIFY email NOT NULL;

ALTER TABLE abonati
ADD CONSTRAINT mail_unic UNIQUE (email);

ALTER TABLE abonati
ADD CONSTRAINT format_valid CHECK (email LIKE '%@%.%');

ALTER TABLE abonati
--ADD CONSTRAINT verificare_nr CHECK (telefon LIKE '__________'); _ de 10 ori
ADD CONSTRAINT ver_nr CHECK (LENGTH(telefon)=10);

ALTER TABLE abonati
--DISABLE CONSTRAINT ver_nr;
ENABLE CONSTRAINT ver_nr;

ALTER TABLE abonati
RENAME TO abonati_biblioteca;

ALTER TABLE abonati_biblioteca
RENAME TO abonati;

--DROP TABLE numetabela

DROP TABLE abonati CASCADE CONSTRAINTS; --a fost stearsa tabela
FLASHBACK TABLE abonati TO BEFORE DROP;

ALTER TABLE abonati
RENAME CONSTRAINT "BIN$BNRxaBW6TMCbLnog0ZsfMQ==$0" TO format_email;

--comenzi LMD: INSERT, UPDATE, DELETE, SELECT

-- INSERT INTO numetabela VALUES (....., ....., ....);

DESCRIBE abonati;

INSERT INTO abonati VALUES ('123', '123456', 'Ionescu', 'Ion', 'aaa@.ro', '1222222222');

INSERT INTO abonati (id_abonat, prenume, email)
VALUES ('125', 'Ionescu', 'Ioana', 'acb@.ro');

ALTER TABLE abonati
MODIFY nume_abonat DEFAULT 'Anonim'; 

INSERT INTO abonati (id_abonat, prenume, email) --& = variabila de substitutie
VALUES ('&id', '&pren', '&email'); --ne cere noua sa introducem valori

/*
UPDATE numetabela
SET coloana = valoare, coloana1 = val2
WHERE conditii;
*/

UPDATE abonati
SET cnp = '1234567896'
WHERE id_abonat = 124;

UPDATE abonati
SET nume_abonati = 'x'
WHERE telefon IS NULL;

-- DELETE FROM numetabela
--    WHERE conditii;

DELETE FROM abonati
WHERE email LIKE '&.ro';

ROLLBACK; --anulam efectul unor comenzi
COMMIT; --salvam efectul unor comenzi

--stergem tot

drop table detalii_fise CASCADE CONSTRAINTS;
