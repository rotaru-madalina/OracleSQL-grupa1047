/* JONCTIUNI: interne, externe
- implementarea in SQL standard: ANSI SQL
- implementarea in SQL-Oracle
*/

-- SA SE AFISEZE pt fiecare angajat numele si denumirea departamentului
-- implementarea INNER JOIN in SQL standard: ANSI SQL

SELECT nume, denumire_departament
FROM angajati a INNER JOIN departamente d --sunt redenumite tabelele prin a si d
ON a.id_departament = d.id_departament
ORDER BY id_angajat;

--varianta 2
SELECT nume, denumire_departament
FROM angajati /*INNER*/ JOIN departamente --nu mai avem nevoie de a si d
USING (id_departament) --doar daca coloana de legatura are aceeasi denumire in ambele tabele
ORDER BY id_angajat;

--JONCTIUNE NATURALA -> nu e recomandata
SELECT nume, denumire_departament
FROM angajati NATURAL JOIN departamente --testeaza intre toate coloanele cu aceeasi denumire
ORDER BY id_angajat;

-- implementarea INNER JOIN in SQL -Oracle
SELECT nume, denumire_departament
FROM angajati a, departamente d 
WHERE a.id_departament = d.id_departament AND salariul < 10000
ORDER BY id_angajat; --coloana asta nu e solicitata in select

-------------------------produs cartezian
SELECT nume, denumire_departament
FROM angajati a, departamente d 
ORDER BY id_angajat; --asa NU, se face produs cartezian

SELECT nume, denumire_departament
FROM angajati a INNER JOIN departamente d ON a.id_departament = d.id_departament
WHERE salariul < 10000
ORDER BY id_angajat;

----------------
--sa se afiseze pt fiecare angajat numele, denumirea functiei si denumirea departamentului
SELECT nume, denumire_functie, denumire_departament
FROM angajati a, functii f, departamente d
WHERE a.id_departament = d.id_departament AND a.id_functie = f.id_functie
ORDER BY id_angajat;

--varianta SQL standardizat
SELECT nume, denumire_functie, denumire_departament 
FROM angajati a JOIN departamente d ON a.id_departament = d.id_departament 
                JOIN functii f ON a.id_functie = f.id_functie 
ORDER BY id_angajat; --daca vrem sa jonctionam 3 coloane va trebui sa avem 2 JOIN

--Implementarea OUTER JOIN (la stanga, la dreapta, completa) in SQL standard: ANSI SQL
---Sa se afiseze pt fiecare angajat: numele si denumirea departamentului + toti ceilalti angajati fara dep
SELECT nume, denumire_departament
FROM angajati a LEFT OUTER JOIN departamente d 
ON a.id_departament = d.id_departament
ORDER BY id_angajat;

---Sa se afiseze pt fiecare angajat: numele si denumirea departamentului + totate celelalte dep fara ang
SELECT nume, denumire_departament
FROM angajati a RIGHT OUTER JOIN departamente d 
ON a.id_departament = d.id_departament
ORDER BY id_angajat;

---Sa se afiseze pt fiecare angajat: numele si denumirea departamentului + totate celelalte dep fara ang + ang fara dep
SELECT nume, denumire_departament
FROM angajati a FULL OUTER JOIN departamente d 
ON a.id_departament = d.id_departament
ORDER BY id_angajat;

--il afisam doar pe Grant care are denumire dep NULL
SELECT nume, denumire_departament
FROM angajati a LEFT OUTER JOIN departamente d 
ON a.id_departament = d.id_departament
MINUS
SELECT nume, denumire_departament
FROM angajati a INNER JOIN departamente d 
ON a.id_departament = d.id_departament
ORDER BY id_angajat;

--implementarea in SQL Oracle
SELECT nume, denumire_departament
FROM angajati a, departamente d 
WHERE a.id_departament = d.id_departament (+) --LEFT JOIN!! adauga in plus valori null
ORDER BY id_angajat;

--totul din departamente, iar el comple
SELECT nume, denumire_departament
FROM angajati a, departamente d 
WHERE a.id_departament (+) = d.id_departament  --RIGHT JOIN!! adauga in plus valori null
ORDER BY id_angajat;

--afisam tot
-- full join NU -- DOAR reuniune de right + left
SELECT nume, denumire_departament
FROM angajati a, departamente d 
WHERE a.id_departament = d.id_departament (+)
UNION
SELECT nume, denumire_departament
FROM angajati a, departamente d 
WHERE a.id_departament (+) = d.id_departament;

---------------
--sa se afiseze pt fiecare angajat: id_angajat, nume, salariul, id_manager
SELECT id_angajat, nume, salariul, id_manager
FROM angajati;

--SELF JOIN
--sa se afiseze id_angajat, nume, salariul, id_manager si nume manager
SELECT ang.id_angajat, ang.nume, ang.salariul, ang.id_manager, man.id_angajat, man.nume
FROM angajati ang, angajati man --LEFT JOIN in loc de WHERE
WHERE ang.id_manager = man.id_angajat (+) --ON in loc de WHERE
ORDER BY ang.id_angajat;

--1. afisati cantitatea totala comandata din fiecare produs din categoriile hardware 2 sau hardware 3
--id_produs, denumirea prod si categoria, cantitatea
SELECT p.id_produs, denumire_produs, categorie, SUM(cantitate)
FROM produse p JOIN rand_comenzi r ON p.id_produs = r.id_produs
WHERE UPPER(categorie) IN('HARDWARE2','HARDWARE3')
GROUP BY p.id_produs, denumire_produs, categorie;

--2. pt fiecare comanda ->val totala pt fiecare comanda daca ea a fost incheiata in 2004
--de afisat id_comanda, data, valoarea comenzii
SELECT c.id_comanda, data, SUM(pret * cantitate) AS valoare_totala
FROM comenzi c JOIN rand_comenzi r ON c.id_comanda = r.id_comanda
WHERE EXTRACT(YEAR FROM data) = 2019
GROUP BY c.id_comanda, data;

--tema curs
SELECT
 (SELECT COUNT(id_angajat) FROM angajati WHERE id_angajat IS NOT NULL) NR_TOTAL,
 (SELECT COUNT(id_angajat) FROM angajati WHERE TO_CHAR(data_angajare,'yyyy')='2016') AS "2016",
 (SELECT COUNT(id_angajat) FROM angajati WHERE TO_CHAR(data_angajare,'yyyy')='2017') AS "2017",
 (SELECT COUNT(id_angajat) FROM angajati WHERE TO_CHAR(data_angajare,'yyyy')='2018') AS "2018"
FROM DUAL;

