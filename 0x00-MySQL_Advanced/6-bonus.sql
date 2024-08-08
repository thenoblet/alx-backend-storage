-- This script creates a stored procedure named AddBonus.
-- The procedure will:
-- 1. Check if the project exists; if not, insert a new project.
-- 2. Insert a new correction entry for a student with the given user_id, project_name, and score.

DELIMITER $$

CREATE PROCEDURE AddBonus(
    IN user_id INT,
    IN project_name VARCHAR(255),
    IN score INT
)
BEGIN
    DECLARE project_id INT;

    -- Attempt to find the project by name and store its ID
    SELECT id INTO project_id
    FROM projects
    WHERE name = project_name;

    -- If the project does not exist, create a new entry in the projects table
    IF project_id IS NULL THEN
        INSERT INTO projects (name) VALUES (project_name);
        -- Update project_id with the ID of the newly created project
        SET project_id = LAST_INSERT_ID();
    END IF;

    -- Insert the correction record into the corrections table
    INSERT INTO corrections (user_id, project_id, score)
    VALUES (user_id, project_id, score);

END $$

DELIMITER ;
