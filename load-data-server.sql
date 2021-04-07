COPY unsplash_photos
FROM PROGRAM 'awk FNR-1 /tmp/photos.tsv* | cat'
WITH (
  FORMAT csv,
  DELIMITER E'\t',
  HEADER false
);

COPY unsplash_keywords
FROM PROGRAM 'awk FNR-1 /tmp/keywords.tsv* | cat'
WITH (
  FORMAT csv,
  DELIMITER E'\t',
  HEADER false
);

COPY unsplash_collections
FROM PROGRAM 'awk FNR-1 /tmp/collections.tsv* | cat'
WITH (
  FORMAT csv,
  DELIMITER E'\t',
  HEADER false
);

COPY unsplash_conversions
FROM PROGRAM 'awk FNR-1 /tmp/conversions.tsv* | cat'
WITH (
  FORMAT csv,
  DELIMITER E'\t',
  HEADER false
);

COPY unsplash_colors
FROM PROGRAM 'awk FNR-1 /tmp/colors.tsv* | cat'
WITH (
  FORMAT csv,
  DELIMITER E'\t',
  HEADER false
);
