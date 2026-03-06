{% snapshot snap_tags %}

{{
config(
    target_schema='snapshots',
    unique_key=['user_id','movie_id','tag'],
    strategy = 'timestamp',
    updated_at='tag_timestamp',
    invalidate_hard_deletes=True
)
}}

select
{{dbt_utils.generate_surrogate_key(['user_id','movie_id','tag'])}} as raw_key,
user_id,
movie_id,
tag,
cast(tag_timestamp as timestamp_ntz) as tag_timestamp
from {{ref('src_tags')}}
limit 100

{% endsnapshot %}

--place where we want our snapshots to live
--primary keys,the keys whose combination differentiates each row uniquely ,if these are also not sufficient we can create surrogate key which is
--nothing but your own version of primary key  this can be done using the dbt utils.generate_surrogate_key
--there are 2 kinds of stratgies available,here strategy is timestamp and expectation is timestamp is in timestamp_ntz format
--the column which we are keeping track of

--here we have imported the generate surrogate key logic form dbt_utils library but we have not mentioned its import anywhere here so we need to create a packages.yml file
--in the root folder of our project which in this case is netflix and import this package there