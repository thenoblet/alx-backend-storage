-- This script defines a stored procedure named AddBonus.
-- The procedure checks if a project exists; if not, it adds the project to the projects table.
-- It then inserts or updates a score for a user in the corrections table based on the user_id and project_name.

DELIMITER $$

-- Create the stored procedure AddBonus with parameters for user_id, project_name, and score
CREATE PROCEDURE AddBonus (
    IN user_id INT,
    IN project_name VARCHAR(255),
    IN score INT
)
BEGIN
    -- Declare a variable to count existing projects with the given name
    DECLARE project_count INT;

    -- Count how many projects exist with the specified name
    SELECT COUNT(*) INTO project_count
    FROM projects
    WHERE name = project_name;

    -- If the project does not exist, add it to the projects table
    IF project_count = 0 THEN
        INSERT INTO projects (name) VALUES (project_name);
    END IF;

    -- Insert a new correction record into the corrections table or update the score if a duplicate key exists
    INSERT INTO corrections (user_id, project_name, score)
    VALUES (user_id, project_name, score)
    ON DUPLICATE KEY UPDATE score = VALUES(score);

END$$

DELIMITER ;

