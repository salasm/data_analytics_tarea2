#NIVEL 1 
#Ejercicio 1: tansólo necesitamos importar los scripts y visualizar las tablas con diagrama. En el pdf tengo screenshots con todo lo que se pide en este ejercicio

#Ejercicio 2.1: listado de países que están haciendo compras
SELECT DISTINCT c.country
FROM transaction t
JOIN company c ON t.company_id = c.id;

#Ej. 2.3: Desde cuántos países se realizan las compras
SELECT COUNT(DISTINCT c.country) AS total_countries
FROM transaction t
JOIN company c ON t.company_id = c.id;

#Ej. 2.3: compañía con mayor promedio de ventas 
SELECT c.company_name, ROUND(AVG(t.amount), 2) AS average_sales
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE declined = 0
GROUP BY c.company_name
ORDER BY average_sales DESC
LIMIT 1;

# Ej. 3.1: Mostrar todas las transacciones realizadas por empresas de Alemania
SELECT *
FROM transaction
WHERE company_id IN (
    SELECT id
    FROM company
    WHERE country = 'Germany'
);

#Ej. 3.2: Mostrar empresas con transacciones de importe superior al promedio de todas las transacciones
SELECT company_name
FROM company
WHERE id IN (
    SELECT company_id
    FROM transaction
    WHERE amount > (
	SELECT AVG(amount)
        FROM transaction
	)
);

#Ej. 3.3: Listado de empresas sin transacciones realizadas
SELECT company_name
FROM company
WHERE id NOT IN (
    SELECT DISTINCT company_id
    FROM transaction
);

# NIVEL 2
# Ejercicio 1: Identificar los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas y mostrar la fecha de cada transacción junto con el total 
# de las ventas.
SELECT DATE(timestamp) AS date, SUM(amount) AS total_sales
FROM transaction 
WHERE declined = 0
GROUP BY DATE(timestamp)
ORDER BY total_sales DESC
LIMIT 5;

#Ejercicio 2: ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor promedio.
SELECT c.country, ROUND(AVG(t.amount), 2) AS average_sales
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE declined = 0
GROUP BY c.country
ORDER BY average_sales DESC;

#Ejercicio 3:  lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que 'Non Institute'.
# Mostrar el listado aplicando JOIN y subconsultas:
SELECT *
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE c.country = (
    SELECT country
    FROM company
    WHERE company_name = 'Non Institute'
);

#Mostrar el listado aplicando sólo subconsultas:
SELECT *
FROM transaction
WHERE company_id IN (
    SELECT id
    FROM company
    WHERE country = (
        SELECT country
        FROM company
        WHERE company_name = 'Non Institute'
	)
);

#NIVEL 3
#Ejercicio 1: Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones con un valor comprendido entre 100 y 200 euros 
# y en alguna de estas fechas: 29 de abril de 2021, 20 de julio de 2021 y 13 de marzo de 2022. Ordena los resultados de mayor a menor cantidad.

SELECT c.company_name, c.phone, c.country, DATE(t.timestamp) AS date, t.amount
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.amount BETWEEN 100 AND 200
      AND DATE(t.timestamp) IN ('2021-04-29', '2021-07-20', '2022-03-13')
ORDER BY t.amount DESC;

#Ejercicio 2:  listado de las empresas donde especifiques si tienen más de 4 o menos transacciones.
SELECT c.company_name,
	CASE WHEN COUNT(t.id) > 4 THEN 'More than 4'
	     WHEN COUNT(t.id) <= 4 THEN 'less than 4'
	END AS 'Number of transactions'
FROM transaction t
JOIN company c ON t.company_id = c.id
GROUP BY c.company_name
		



