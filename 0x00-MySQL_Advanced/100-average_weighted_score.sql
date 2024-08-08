-- This script creates a stored procedure named ComputeAverageWeightedScoreForUser.
-- The procedure calculates the average weighted score for a student and updates their average_score in the users table.

DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUser(
    IN userId INT
)
BEGIN
    -- Declare variables to hold the total weighted score, total weight, and the computed average weighted score
    DECLARE total_weighted_score FLOAT;
    DECLARE total_weight INT;
    DECLARE avg_weighted_score FLOAT;

    -- Initialize variables
    SET total_weighted_score = 0;
    SET total_weight = 0;

    -- Calculate the total weighted score and total weight for the user
    SELECT SUM(c.score * p.weight) INTO total_weighted_score
    FROM corrections c
    JOIN projects p ON c.project_id = p.id
    WHERE c.user_id = userId;

    -- Calculate the total weight for the user's projects
    SELECT SUM(p.weight) INTO total_weight
    FROM corrections c
    JOIN projects p ON c.project_id = p.id
    WHERE c.user_id = userId;

    -- Calculate the average weighted score
    IF total_weight > 0 THEN
        SET avg_weighted_score = total_weighted_score / total_weight;
    ELSE
        SET avg_weighted_score = 0; -- Default to 0 if no weight is found
    END IF;

    -- Update the average_score field in the users table for the specified user
    UPDATE users
    SET average_score = avg_weighted_score
    WHERE id = userId;

END $$

DELIMITER ;
