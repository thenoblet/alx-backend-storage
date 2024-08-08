-- This script lists all bands with 'Glam rock' as their main style, ranked by their longevity (lifespan in years until 2022).
-- It calculates the lifespan using the 'formed' and 'split' years, or defaults to 2022 if the band is still active.

SELECT band_name, 
    CASE 
        WHEN split IS NOT NULL THEN split - formed 
        ELSE 2022 - formed 
    END AS lifespan
FROM metal_bands
WHERE style LIKE '%Glam rock%'
ORDER BY lifespan DESC;

