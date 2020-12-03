--1--Să se afişeze identificatorul și data de încheiere pentru comenzile alcătuite din zece produse.
SELECT id_comanda, TO_CHAR(data, 'DD/MM/YYYY') data_comanda, COUNT(id_produs) 
FROM rand_comenzi INNER JOIN comenzi 
USING (id_comanda)
GROUP BY id_comanda, data
HAVING COUNT(id_produs)=10;

--2--Sã se afiseze valoarea fiecarei comenzi incheiate in anul 2018 
SELECT id_comanda, TO_CHAR(data, 'DD/MM/YYYY') data_comanda, SUM(pret*cantitate) Valoare
FROM rand_comenzi INNER JOIN comenzi 
USING (id_comanda)
WHERE EXTRACT(YEAR FROM data) = 2018
GROUP BY id_comanda, data;

--3--Să se afișeze informații despre angajații care au salariul mai mare decât salariul mediu. 
SELECT *
FROM angajati
WHERE salariul>(SELECT AVG(salariul) FROM angajati);

--4--Să se afişeze câte comenzi a dat fiecare client. 
--Se vor afişa şi numele clientilor care nu au dat comenzi. 
SELECT id_client, nume_client, COUNT(id_comanda) nr_comenzi
FROM clienti LEFT JOIN comenzi
USING (id_client)
GROUP BY id_client, nume_client
ORDER BY nr_comenzi;

--5--Să se afişeze numărul de comenzi încheiate în fiecare lună a anului
SELECT TO_CHAR(data, 'month') luna_comanda, count(id_comanda) nr_comenzi
FROM comenzi
GROUP BY TO_CHAR(data, 'month');

--6--nume, prenume, denumirea functiei, bonus ->pe baza functiei detinute de angajat
SELECT id_angajat, prenume, nume, id_functie, denumire_functie
FROM angajati INNER JOIN functii
USING (id_functie)
CASE salariul* expr WHEN cond THEN rez ... ELSE rez END
CASE expr WHEN cond THEN rez ... ELSE rez END
ORDER BY id_angajat;

SELECT a.nume, a.prenume, f.denumire_functie, a.salariul, CASE
WHEN a.id_functie='IT_PROG' THEN salariul*0.05
WHEN a.id_functie='AD_PRES' THEN salariul*0.1
ELSE salariul*0.01
END bonus
FROM angajati a, functii f
WHERE a.id_functie=f.id_functie;

--cu decode
SELECT a.nume, a.prenume, f.denumire_functie, a.salariul,
DECODE (a.id_functie, 'IT_PROG', 0.05, 'AD_PRES', 0.1, 0.01)*salariul BONUS
FROM angajati a, functii f
WHERE a.id_functie=f.id_functie;

--Sã se afiseze numele, prenumele, functia si salariul angajatilor, iar pe baza vechimii
--fiecãrui salariat sã se acorde un bonus, astfel: 
--pentru vechime<5 ani atunci 0.3, pentru vechime intre 5-10 --0.4, altfel 0.5. 
SELECT a.nume, a.prenume, f.denumire_functie, a.salariul, extract(year from sysdate)
CASE
WHEN extract(year from sysdate)- extract(year from a.data_angajare) BETWEEN (0,5) THEN salariul*0.3
WHEN extract(year from sysdate)-extract(year from a.data_angajare) BETWEEN (5,10) THEN salariul*0.4
ELSE salariul*0.5
END bonus
FROM angajati a, functii f
WHERE a.id_functie=f.id_functie;

--cu decode
SELECT a.nume, a.prenume, f.denumire_functie, a.salariul,
DECODE (a.id_functie, 'IT_PROG', 0.05, 'AD_PRES', 0.1, 0.01)*salariul BONUS
FROM angajati a, functii f
WHERE a.id_functie=f.id_functie;

--Să se afişeze nr_comanda si SUM(pret * cantitate) pentru cea mai valoroasă comandă. 
SELECT ROWNUM, id_comanda, SUM(pret*cantitate)
FROM (SELECT id_comanda
FROM rand_comenzi
--ORDER BY  SUM(pret*cantitate) DESC
)
WHERE ROWNUM <= 1;

select id_comanda , sum(pret*cantitate) 
from rand_comenzi group by id_comanda 
having sum(pret*cantitate)=( select max(sum(pret*cantitate)) 
from rand_comenzi 
group by id_comanda) ; 

--sa se majoreze salariul angajatilor pe baza functiei detinute
UPDATE angajati SET salariul=
--SELECT a.nume, a.prenume, f.denumire_functie, a.salariul, 
CASE
WHEN id_functie='IT_PROG' THEN  salariul*105/100
WHEN id_functie='AD_PRES' THEN  salariul*110/100
ELSE  salariul*101/100
END;
ROLLBACK;

