WITH a as(WITH
  base_data AS (
    SELECT
      `Location Codes` AS intersection_id_raw,
      `Ward Number`,
      `Charges Laid by Location & Year` AS location_original,
      UPPER(REPLACE(TRIM(SPLIT(SPLIT(REPLACE(`Charges Laid by Location & Year`, ' & ', ' and '), '/')[SAFE_OFFSET(0)], ' and ')[SAFE_OFFSET(0)]), '.', '')) AS street_1_clean,
      UPPER(REPLACE(TRIM(SPLIT(SPLIT(REPLACE(`Charges Laid by Location & Year`, ' & ', ' and '), '/')[SAFE_OFFSET(0)], ' and ')[SAFE_OFFSET(1)]), '.', '')) AS street_2_clean,
      `Enforcement Start Date`,
      `2007`, `2008`, `2009`, `2010`, `2011`, `2012`, `2013`, `2014`, `2015`, `2016`, `2017`, `2018`, `2019`, `2020`,
      SAFE_CAST(`2021` AS INT64) AS `2021`,
      `2022`, `2023`, `2024`, `2025`
    FROM `lunar-carving-457020-h5.YuseiSQL.Toronto Red Light`
    WHERE NOT CONTAINS_SUBSTR(`Charges Laid by Location & Year`, '*')
  ),
  unpivoted_data AS (
    SELECT *
    FROM base_data
    UNPIVOT(charges FOR year IN (`2007`, `2008`, `2009`, `2010`, `2011`, `2012`, `2013`, `2014`, `2015`, `2016`, `2017`, `2018`, `2019`, `2020`, `2021`, `2022`, `2023`, `2024`, `2025`))
  ),
  location_lookup AS (
    SELECT
      INTERSECTION_ID,
      UPPER(REPLACE(SPLIT(CLIENT_STREET_1, '/')[SAFE_OFFSET(0)], '.', '')) AS l_street_1,
      UPPER(REPLACE(SPLIT(CLIENT_STREET_2, '/')[SAFE_OFFSET(0)], '.', '')) AS l_street_2,
      TRIM(REGEXP_REPLACE(UPPER(REPLACE(SPLIT(CLIENT_STREET_1, '/')[SAFE_OFFSET(0)], '.', '')), r'\b(W|E|N|S)\b', '')) AS l_street_1_no_dir,
      TRIM(REGEXP_REPLACE(UPPER(REPLACE(SPLIT(CLIENT_STREET_2, '/')[SAFE_OFFSET(0)], '.', '')), r'\b(W|E|N|S)\b', '')) AS l_street_2_no_dir,
      geometry
    FROM `lunar-carving-457020-h5.YuseiSQL.Red Light Location`
  ),
  extra_lookup AS (
    -- extra location テーブルから location_original に一致する座標を取得
    SELECT 
      location_original,
      ST_GEOGFROMGEOJSON(geojson_multipoint) AS extra_geometry
    FROM `lunar-carving-457020-h5.YuseiSQL.extra location`
  ),
  final_merged AS (
    SELECT
      u.*,
      ST_GEOGFROMGEOJSON(l.geometry) AS matched_geometry,
      el.extra_geometry,
      ST_GEOGFROMGEOJSON(w.geometry) AS ward_geometry
    FROM unpivoted_data u
    LEFT JOIN location_lookup l
      ON (
        (u.street_1_clean = l.l_street_1 AND u.street_2_clean = l.l_street_2) OR
        (u.street_1_clean = l.l_street_2 AND u.street_2_clean = l.l_street_1) OR
        (TRIM(REGEXP_REPLACE(u.street_1_clean, r'\b(W|E|N|S)\b', '')) = l.l_street_1_no_dir AND 
         TRIM(REGEXP_REPLACE(u.street_2_clean, r'\b(W|E|N|S)\b', '')) = l.l_street_2_no_dir) OR
        (TRIM(REGEXP_REPLACE(u.street_1_clean, r'\b(W|E|N|S)\b', '')) = l.l_street_2_no_dir AND 
         TRIM(REGEXP_REPLACE(u.street_2_clean, r'\b(W|E|N|S)\b', '')) = l.l_street_1_no_dir)
      )
    -- extra location との一致
    LEFT JOIN extra_lookup el
      ON u.location_original = el.location_original
    LEFT JOIN `lunar-carving-457020-h5.clean.wards` w
      ON u.`Ward Number` = w.AREA_SHORT_CODE
  )
SELECT
  * EXCEPT(matched_geometry, extra_geometry),
  COALESCE(
    matched_geometry,
    extra_geometry,
    CASE 
      WHEN CONTAINS_SUBSTR(location_original, 'Eastern Ave') AND CONTAINS_SUBSTR(location_original, 'Coxwell Ave') 
      THEN ST_GEOGPOINT(-79.3162150008697, 43.6654930038606)
    END
  ) AS intersection_geometry
FROM final_merged)
-----------------------
SELECT 
  location_original
FROM a
WHERE intersection_geometry IS NULL
GROUP BY 1
