--1. Să se afișeze denumirea și categoria produselor care nu au fost comandate

SELECT id_produs, denumire_produs, categorie
FROM produse
MINUS
SELECT p.id_produs, denumire_produs, categorie
FROM produse p, rand_comenzi r
WHERE p.id_produs=r.id_produs;

SELECT r.id_produs, denumire_produs, categorie
FROM produse p, rand_comenzi r
WHERE p.id_produs=r.id_produs (+) AND r.id_produs IS NULL;

SELECT id_produs, denumire_produs, categorie
FROM produse
WHERE id_produs NOT IN (SELECT DISTINCT id_produs FROM rand_comenzi)

--sa se afiseze denumirea departamentelor care nu au angajatului
SELECT denumire_departament --, id_departament
FROM departamente
WHERE id_departament NOT IN (SELECT DISTINCT id_departament FROM angajati WHERE id_departament IS NOT NULL)

--2. Să se afişeze numele angajatului, denumirea functiei detinute şi, pe baza acesteia, 
--comisionul aplicat la valorea comenzilor date, astfel: pentru IT_PROG – 5%, pentru AD_PRES – 3%, 
--pentru celelalte funcţii – 1%
SELECT nume, denumire_functie, SUM(pret*cantitate) valoare,
CASE
    WHEN a.id_functie='IT_PROG' THEN 0.05
    WHEN a.id_functie='AD_PRES' THEN 0.03
    ELSE 0.01
END * SUM(pret*cantitate) bonus
FROM angajati a, functii f, rand_comenzi r, comenzi c
WHERE a.id_functie=f.id_functie 
    AND a.id_angajat=c.id_angajat 
    AND r.id_comanda=c.id_comanda
GROUP BY a.id_angajat, a.id_functie, a.nume, f.denumire_functie;

UPDATE angajati
SET id_functie='IT_PROG' 
WHERE nume='Tuvault'; 

SELECT nume, denumire_functie, SUM(pret*cantitate) valoare,
DECODE (a.id_functie, 'IT_PROG', 0.05, 'AD_PRES', 0.03, 0.01)* SUM(pret*cantitate) bonus
FROM angajati a, functii f
WHERE a.id_functie=f.id_functie 
    AND a.id_angajat=c.id_angajat 
    AND r.id_comanda=c.id_comanda
GROUP BY a.id_angajat, a.id_functie, a.nume, f.denumire_functie;

--3. Să se afişeze numele, prenumele, funcţia şi venitul total al angajaţilor, iar pe baza anului 
--angajarii fiecărui salariat să se acorde un bonus,
--astfel: pentru an angajare < 2016 atunci 0.3, pentru an intre 2016-2019 --0.4, altfel 0.5
SELECT nume, prenume, denumire_functie, (salariul*12+NVL(comision,0)*salariul) venit,
CASE
    --WHEN TO_CHAR(data_angajare, 'yyyy')
    WHEN EXTRACT(YEAR FROM data_angajare)<2016 THEN 0.3
    WHEN EXTRACT(YEAR FROM data_angajare) IN BETWEEN (2016,2019) THEN 0.4
    ELSE 0.5
END *salariul bonus
FROM angajati a, functii f
WHERE a.id_functie=f.id_functie ;
--GROUP BY a.id_angajat, a.id_functie, a.nume, f.denumire_functie;

select nume, prenume, denumire_functie, (salariul*12+nvl(comision,0)*salariul) as venit, 
case 
when extract (year from data_angajare)<2016 then 0.3 
when extract(year from data_angajare) between 2016 and 2019 then 0.4 
else 0.5 
end *salariul as bonus 
from angajati a, functii f 
where a.id_functie=f.id_functie; 

--4. sã se afiseze salariile minime, maxime si medii pentru departamentele 60, 70 si 80, 
--cu conditia ca media salariilor sã fie peste 5000
SELECT a.id_departament, denumire_departament, MIN(salariul), MAX(salariul), TRUNC(AVG(salariul),2)
FROM departamente d, angajati a
--USING (id_departament)
WHERE d.id_departament = a.id_departament AND a.id_departament IN (60,70,80)
GROUP BY a.id_departament, denumire_departament
HAVING AVG(salariul)>5000;


--5. Să se afișeze denumirea și categoria produselor care nu au fost comandate

--6. Să se afișeze angajații cu salariul mai mic decat salariul mediu
SELECT *
FROM angajati
WHERE salariul<(SELECT AVG(salariul) FROM angajati);

--sa se afiseze ang cu sal mai mic decat sal mediu al dep din care fac parte
SELECT *
FROM angajati a
WHERE salariul<(SELECT AVG(salariul) FROM angajati WHERE id_departament=a.id_departament); --subcerere care depinde de parinte

--7. Să se afișeze angajații cu salariul mai mic decat salariul mediu al departamentului din care fac parte
