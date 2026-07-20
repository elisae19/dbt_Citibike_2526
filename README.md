# Citibike Analytics — dbt project

## Structure

```
models/
  staging/citibike/        -> nettoyage 1:1 de la source (vue, pas de coût de stockage)
  intermediate/             -> dédup, enrichissement, dimension station
  marts/mobility/           -> dim_stations, fct_trips (incremental), agrégats journaliers/horaires
```

## Maîtriser le coût BigQuery en dev

1. **Crée un dataset échantillon une seule fois** (ex: 1 mois de données ou un `TABLESAMPLE`) :
   ```sql
   create table `ton_projet.raw_citibike_sample.trips_raw` as
   select * from `ton_projet.raw_citibike.trips_raw`
   where started_at between '2026-06-01' and '2026-06-30';
   ```
2. Dans `profiles.yml`, définis (au moins) deux targets : `dev` et `prod`.
   La macro `macros/get_citibike_dataset.sql` bascule automatiquement
   `stg_citibike__trips` sur `raw_citibike_sample` en dev et sur
   `raw_citibike` (8.9 Go) en prod/CI.
3. Travaille, preview et teste exclusivement en target `dev` au quotidien.
   Ne lance un `dbt build -t prod` que ponctuellement, pour valider le
   pipeline complet.
4. Ajoute un garde-fou dans `profiles.yml` :
   ```yaml
   dev:
     type: bigquery
     ...
     maximum_bytes_billed: 1000000000   # 1 Go, la requête échoue avant d'être facturée si dépassé
   ```

## Commandes utiles pour limiter le scope

```bash
# ne construire que ce qui a changé depuis le dernier run
dbt build --select state:modified+ --state ./target_last_run

# ne lancer qu'une couche
dbt run --select staging.citibike
dbt run --select marts.mobility
```

## Tests

- **staging** : unicité/`not_null` des clés, `accepted_values` sur les catégoriels, plages de coordonnées.
- **intermediate** : plages de durée de trajet, relations vers la dimension station.
- **marts** : unicité `ride_id`, relations `fct_trips` ↔ `dim_stations`, cohérence des agrégats.
