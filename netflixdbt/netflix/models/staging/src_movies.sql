WITH raw_movies AS(
select * from MOVIELENS.RAW.RAW_MOVIES
)

SELECT movieId as movie_id,
title,
genres
from raw_movies

