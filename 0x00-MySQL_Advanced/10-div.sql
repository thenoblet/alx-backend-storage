-- This script creates a SQL function named SafeDiv
-- The SafeDiv function performs division of two integers, handling division by zero by returning 0.
-- The script also ensures that any existing SafeDiv function is dropped before creating a new one

DROP FUNCTION IF EXISTS SafeDiv;

-- Define the function SafeDiv
DELIMITER $$

CREATE FUNCTION SafeDiv(a INT, b INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    -- Check if the denominator is zero
    IF b = 0 THEN
        -- Return 0 if denominator is zero to avoid division by zero error
        RETURN 0;
    ELSE
        -- Perform division and return the result
        RETURN a / b;
    END IF;
END $$

DELIMITER ;
