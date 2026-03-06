 SELECT
     movie_id,
     tag_id,
     relevance_score
 FROM {{ ref('fct_genome_scores') }}
 WHERE relevance_score <= 0

--to ensure no single row in the table has relevance score less than 0