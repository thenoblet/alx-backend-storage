-- This procedure calculates the average score for a given user and
-- updates their record with the computed average score.

DELIMITER $$

CREATE PROCEDURE ComputeAverageScoreForUser(
    IN userId INT
)
BEGIN
    DECLARE avg_score DECIMAL(10,2);

    -- Calculate the average score from the 'corrections' table for the given user_id
    SELECT AVG(score) INTO avg_score
    FROM corrections
    WHERE user_id = userId;

    -- Update the 'users' table with the calculated average score for the given user_id
    UPDATE users
    SET average_score = avg_score
    WHERE id = userId;

END $$

DELIMITER ;

