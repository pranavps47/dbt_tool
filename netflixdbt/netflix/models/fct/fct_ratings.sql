{{
  config(
    materialized = 'incremental',
    on_schema_change='fail'
  )
}}

WITH src_ratings AS (
  SELECT * FROM {{ ref('src_ratings') }}
)
 -- this model will fail if the schema of the original table changes i.e the table defination changes like a new col is added
--this config will overwrite anything mentioned in  our dbt_project.ym;


SELECT
  user_id,
  movie_id,
  rating,
  rating_timestamp
FROM src_ratings
WHERE rating IS NOT NULL

{% if is_incremental() %}
  AND rating_timestamp > (SELECT MAX(rating_timestamp) FROM {{ this }})
{% endif %}
 --whenver the src table is updated which in this cases is src_ratings
  --his this refers to the table which will be created by this fct_rating model
--so if src_rating is updated and the condition on this fct_rating table is true then it updates incrementally

--but here the base table src_ratings is a veiw so we cannot directly add or remove records so we have two options now,
--either changes the raw table so that view sec_rating  changes or change the materialzation of src_rating to table so that we can modify it
--so let change it to table as we dont wanna mess with raw data
--now that we have changed it to a table lets insert a new row with latest timestamp and see the incremental materialzation on action

--something like this
--insert into src_ratings(user_id,movie_id,rating,rating_timestamp)
--values(87587,'7151','4','2015-03-31 23:40:02.000 -0700')

--now run this model