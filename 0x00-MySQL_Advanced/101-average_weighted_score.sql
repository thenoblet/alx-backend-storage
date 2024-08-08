-- This script creates a stored procedure named ComputeAverageWeightedScoreForUsers
-- The procedure calculates the average weighted score for all students and updates their records.

-- Drop the procedure if it already exists to avoid conflicts
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;

DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    -- Update the average_score for each user
    UPDATE users u
    SET average_score = (
        -- Compute the weighted average score for the user
        SELECT SUM(c.score * p.weight) / NULLIF(SUM(p.weight), 0)
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = u.id
    );
END $$

DELIMITER ;
