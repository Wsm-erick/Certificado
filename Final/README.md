# Proyecto Final: Arquitectura de Datos E-commerce en Google Cloud

Este repositorio contiene la implementación de una arquitectura end-to-end para un caso de e-commerce en Google Cloud Platform. El flujo integra ingesta batch, streaming, procesamiento con Dataflow, almacenamiento en BigQuery, visualización en Looker Studio, entrenamiento con BigQuery ML e inferencia online con Vertex AI.

## Enlaces principales

- Repositorio: <https://github.com/Wsm-erick/Certificado/tree/main/Final>
- Dashboard Looker Studio: <https://datastudio.google.com/reporting/63d4486c-b05e-4c78-a333-cd320dcde35b>

## Estructura del repositorio

```text
Final/
  data/        Dataset CSV usado como fuente batch y para simular eventos streaming.
  notebook/    Notebooks para publicar eventos en Pub/Sub y probar Vertex AI.
  sql/         Consultas de creación de tablas, vistas, validaciones y BigQuery ML.
  img/         Capturas de evidencia del proyecto.
  dashboard/   Recursos o notas del tablero de Looker Studio.
  README.md    Guía de navegación del repositorio.
  images_description.md  Descripción de las capturas incluidas en img/.
  .gitignore   Reglas para excluir credenciales y archivos temporales.
```

## Flujo del proyecto

1. **Batch:** el dataset histórico se conserva en Cloud Storage y se estructura en BigQuery.
2. **Streaming:** un notebook Python publica eventos JSON en Pub/Sub.
3. **Procesamiento:** Dataflow consume Pub/Sub, aplica una UDF JavaScript y escribe en BigQuery.
4. **Analytics:** BigQuery almacena tablas históricas, streaming y transformadas.
5. **Visualización:** Looker Studio consume BigQuery para KPIs, tabla de eventos, ventas por país y serie temporal.
6. **ML:** BigQuery ML entrena `return_prediction_model`.
7. **Vertex AI:** el modelo se registra como `return-prediction-bqml` y se despliega en un endpoint para inferencia online.
8. **FinOps:** al finalizar, se cancelan jobs de Dataflow y se desimplementa el modelo del endpoint.

## Archivos importantes

- `notebook/`: contiene los notebooks de publicación streaming y prueba del endpoint.
- `sql/`: contiene las consultas SQL usadas para crear tablas, vistas, validaciones y modelo.
- `img/`: contiene evidencia visual. Ver `images_description.md` para una descripción de cada captura.
- `reporte_ecommerce_end_to_end_resumido.tex`: reporte LaTeX breve con el flujo y las evidencias principales.

## Seguridad

El archivo de credenciales `credentials.json` no se incluye en el repositorio. Debe colocarse localmente en la raíz del proyecto cuando se ejecuten notebooks que usen Google Cloud:

```python
import os
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "../credentials.json"
```

Desde notebooks ubicados en `notebook/`, el CSV se referencia como:

```python
pd.read_csv("../data/data_ecommerce.csv", encoding="ISO-8859-1")
```

## Limpieza FinOps

Al terminar la demostración:

1. Cancelar jobs de Dataflow.
2. Anular la implementación del modelo en Vertex AI.
3. Verificar que el endpoint quede con `Modelos = 0`.
4. Confirmar que `credentials.json` no aparece en `git status`.
