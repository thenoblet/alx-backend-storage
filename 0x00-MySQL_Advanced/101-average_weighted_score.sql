-- This script creates a stored procedure named ComputeAverageWeightedScoreForUsers.
-- The procedure calculates the average weighted score for all students and updates their average_score in the users table.

DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    -- Declare variables to hold total weighted score and total weight for each user
    DECLARE v_user_id INT;
    DECLARE v_total_weighted_score FLOAT;
    DECLARE v_total_weight INT;
    DECLARE v_avg_weighted_score FLOAT;
    
    -- Declare a cursor to iterate over each user
    DECLARE user_cursor CURSOR FOR 
        SELECT id FROM users;

    -- Declare a handler for when there are no more rows to fetch from the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET @done = TRUE;

    -- Create a temporary table to hold the results
    CREATE TEMPORARY TABLE temp_avg_scores (
        user_id INT PRIMARY KEY,
        avg_weighted_score FLOAT
    );

    -- Open the cursor
    OPEN user_cursor;

    -- Fetch the first user_id from the cursor
    FETCH user_cursor INTO v_user_id;

    -- Loop through all users
    WHILE NOT @done DO
        -- Initialize variables
        SET v_total_weighted_score = 0;
        SET v_total_weight = 0;
        
        -- Calculate the total weighted score and total weight for the current user
        SELECT SUM(c.score * p.weight) INTO v_total_weighted_score
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = v_user_id;
        
        SELECT SUM(p.weight) INTO v_total_weight
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = v_user_id;
        
        -- Calculate the average weighted score
        IF v_total_weight > 0 THEN
            SET v_avg_weighted_score = v_total_weighted_score / v_total_weight;
        ELSE
            SET v_avg_weighted_score = 0; -- Default to 0 if no weight is found
        END IF;

        -- Insert the result into the temporary table
        INSERT INTO temp_avg_scores (user_id, avg_weighted_score)
        VALUES (v_user_id, v_avg_weighted_score)
        ON DUPLICATE KEY UPDATE avg_weighted_score = VALUES(avg_weighted_score);
        
        -- Fetch the next user_id from the cursor
        FETCH user_cursor INTO v_user_id;
    END WHILE;

    -- Close the cursor
    CLOSE user_cursor;

    -- Update the average_score field in the users table for all users
    UPDATE users u
    JOIN temp_avg_scores t ON u.id = t.user_id
    SET u.average_score = t.avg_weighted_score;

    -- Drop the temporary table
    DROP TEMPORARY TABLE IF EXISTS temp_avg_scores;

END $$

DELIMITER ;

