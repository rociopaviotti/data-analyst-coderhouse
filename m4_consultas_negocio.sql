SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE 
        WHEN SUM(cantidad * precio_unitario) > (
            SELECT AVG(total_mes)
            FROM (
                SELECT SUM(cantidad * precio_unitario) AS total_mes
                FROM ventas
                GROUP BY MONTH(fecha_venta)
            ) AS totales_por_mes
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- 1. El producto 1 es el más vendido en facturación: generó $3600 con solo 3 unidades,
--    lo que indica un precio unitario alto (producto premium) más que un alto volumen.

-- 2. Los 5 clientes cargados son recurrentes (cada uno realizó exactamente 2 pedidos),
--    lo que sugiere una base de clientes fidelizada. El cliente 1 es el de mayor gasto
--    acumulado, con $2640.

-- 3. Al tener datos únicamente de marzo, el mes coincide con el promedio general,
--    por lo que la comparación lo marca como "Por debajo" (no supera estrictamente
--    el promedio). Con más meses cargados, esta métrica cobraría más sentido para
--    detectar estacionalidad.