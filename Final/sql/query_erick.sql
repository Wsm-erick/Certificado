-- Validación de registros

SELECT count(1)
FROM `bueno-398402.ecommerce_ds.streaming_ecommerce_sales`;

-- Muestra de registros

SELECT *
FROM `bueno-398402.ecommerce_ds.streaming_ecommerce_sales`
LIMIT 100;

-- Eliminar mensaje de prueba

DELETE FROM `bueno-398402.ecommerce_ds.streaming_ecommerce_sales` WHERE InvoiceNo = "900001";

-- Vista de tabla streaming para creación del dashboard de streaming

CREATE OR REPLACE VIEW `bueno-398402.ecommerce_ds.v_streaming_sales_dashboard` AS
SELECT
  InvoiceNo,
  StockCode,
  Description,
  Quantity,
  InvoiceDate,
  UnitPrice,
  CustomerID,
  Country,
  Quantity * UnitPrice AS TotalAmount,

  SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', InvoiceDate) AS InvoiceTimestamp,

  TIMESTAMP_TRUNC(
    SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', InvoiceDate),
    HOUR
  ) AS InvoiceHour

FROM `bueno-398402.ecommerce_ds.streaming_ecommerce_sales`;

-- Predicción del modelo

SELECT *
FROM ML.PREDICT(
  MODEL `bueno-398402.ecommerce_ds.return_prediction_model`,
  (
    SELECT
      InvoiceNo,
      StockCode,
      Description,
      Quantity,
      InvoiceDate,
      UnitPrice,
      CustomerID,
      Country
    FROM `bueno-398402.ecommerce_ds.streaming_ecommerce_sales`
    LIMIT 100
  )
);

-- Tabla con transformación durante el streaming

CREATE OR REPLACE TABLE `bueno-398402.ecommerce_ds.streaming_sales_transformed` (
  InvoiceNo STRING,
  StockCode STRING,
  Description STRING,
  Quantity INT64,
  InvoiceDate STRING,
  InvoiceTimestamp TIMESTAMP,
  InvoiceHour TIMESTAMP,
  UnitPrice FLOAT64,
  CustomerID STRING,
  Country STRING,
  TotalAmount FLOAT64,
  Source STRING,
  IsHighValue BOOL
);

SELECT COUNT(1)
FROM `bueno-398402.ecommerce_ds.streaming_sales_transformed`;

SELECT * FROM `bueno-398402.ecommerce_ds.streaming_sales_transformed`;

SELECT * FROM `bueno-398402.ecommerce_ds.historical_ecommerce_sales` LIMIT 10;

SELECT Description, sum(Quantity * UnitPrice) as amount FROM `bueno-398402.ecommerce_ds.streaming_ecommerce_sales` GROUP BY 1 ORDER BY amount DESC LIMIT 10;