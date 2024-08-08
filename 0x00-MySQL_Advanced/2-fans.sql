-- This script ranks country origins of bands based on the total number of non-unique fans.
-- The result is ordered by the number of fans in descending order.

-- Assuming the metal_bands table has columns 'origin' and 'fans', this script computes the
-- total number of fans per origin and orders the results by the number of fans.

SELECT origin, 
    SUM(fans) AS nb_fans
FROM metal_bands
GROUP BY origin
ORDER BY nb_fans DESC;

