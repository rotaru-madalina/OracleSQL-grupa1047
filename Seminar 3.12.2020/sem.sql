--1. Să se afișeze angajații cu salariul mai mic decat salariul mediu al departamentului din care fac parte 
SELECT *
FROM angajati b
WHERE salariul<(SELECT AVG(salariul) FROM angajati a WHERE a.id_departament=b.id_departament);

--2. Sa se mareasca cu 10 unitati salariul angajatilor care lucreaza in departamentul Executive 
UPDATE angajati
SET salariul=salariul+10
WHERE id_departament IN (SELECT id_departament FROM departamente WHERE UPPER (denumire_departament)='EXECUTIVE'); --in loc de IN poate fi si =

--3. Sa se modifice tabela angajati astfel: 
--salariul creste cu 5% pentru angajatii care au incheiat mai mult de 10 comenzi,
--scade cu 5% pentru cei care nu au dat comenzi deloc si ramane nemodificat pentru restul 
UPDATE angajati a
SET salariul = CASE
WHEN(
    SELECT COUNT(id_comanda)
    FROM comenzi c
    WHERE c.id_angajat = a.id_angajat
    )>10 THEN 1.05*salariul
WHEN (
    SELECT COUNT(id_comanda)
    FROM comenzi c
    WHERE c.id_angajat = a.id_angajat
    ) = 0 THEN 0.95*salariul
ELSE salariul
END;
--alta varianta
UPDATE angajati a 
SET salariul = CASE 
WHEN id_angajat IN ( 
    SELECT id_angajat 
    FROM comenzi 
    GROUP BY id_angajat 
    HAVING COUNT (id_comanda) >10 ) THEN 1.05* salariul 
WHEN ( id_angajat NOT IN (
    SELECT id_angajat 
    FROM comenzi 
    WHERE id_angajat IS NOT NULL) ) THEN 0.95*salariul 
ELSE salariul 
END; 

--angajati care au dat mai mult de 10 comenzi
SELECT id_angajat, COUNT(id_comanda) nr_comenzi
FROM comenzi 
GROUP BY id_angajat
HAVING COUNT(id_comanda) > 10;

--angajati care nu au procesat comenzi
SELECT id_angajat
FROM angajati
WHERE id_angajat NOT IN (SELECT id_angajat FROM comenzi WHERE id_angajat IS NOT NULL);

--sa se afiseze pt fiecare ang numele, den_dep si nr de ang din dep respectiv
SELECT nume, denumire_departament, (SELECT COUNT(id_angajat) 
                                    FROM angajati
                                    WHERE id_departament = a.id_departament) Total_Ang_Dep
FROM angajati a, departamente b
WHERE a.id_departament = b.id_departament;

SELECT COUNT(id_angajat)
FROM angajati
WHERE id_departament = 90;

-- Sa se afiseze numarul de angajati care au intermediat încheierea de comenzi, 
--precum si cel al angajatilor care nu au intermediat nicio comanda 
SELECT COUNT(id_angajat) C
FROM comenzi
WHERE id_angajat IN (SELECT id_angajat FROM comenzi WHERE id_angajat IS NOT NULL)
UNION
SELECT COUNT(id_angajat) F
FROM angajati
WHERE id_angajat NOT IN (SELECT id_angajat FROM comenzi WHERE id_angajat IS NOT NULL);

--varianta buna
SELECT
    (SELECT COUNT(DISTINCT id_angajat) FROM comenzi WHERE id_angajat IS NOT NULL) Au_Intermediat,
    (SELECT COUNT(a.id_angajat) FROM angajati a WHERE a.id_angajat NOT IN (
        SELECT DISTINCT c.id_angajat FROM comenzi c WHERE c.id_angajat IS NOT NULL
    )) Nu_Au_Intermediat
FROM dual;

--6. Sa se afiseze angajati si managerii acestora
SELECT a.id_angajat, a.nume, b.nume Nume_Manager
FROM angajati a LEFT JOIN angajati b ON a.id_manager = b.id_angajat
ORDER BY a.id_angajat;

--alta rezolvare
SELECT a.id_angajat, a.nume, (
        SELECT b.nume 
        FROM angajati b
        WHERE b.id_angajat = a.id_manager
)
FROM angajati a;

--sa se afiseze primele 5 comenzi cu cele mai multe produse
SELECT id_comanda, COUNT(id_produs) produse
FROM rand_comenzi
GROUP BY id_comanda
ORDER BY COUNT(id_produs) DESC
FETCH FIRST 5 ROWS ONLY;
--ROWNUM <=5;
--alta varianta
SELECT*
FROM
(SELECT id_comanda, COUNT(id_produs) produse
FROM rand_comenzi
GROUP BY id_comanda
ORDER BY COUNT(id_produs) DESC)
WHERE ROWNUM <=5;
