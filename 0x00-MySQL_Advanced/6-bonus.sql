-- This script creates a stored procedure named AddBonus.
-- The procedure will:
-- 1. Check if the project exists; if not, insert a new project.
-- 2. Insert a new correction entry for a student with the given user_id, project_name, and score.

-- Change the delimiter to $$ to handle multi-statement procedure definitions
DELIMITER $$

-- Create the stored procedure AddBonus
CREATE PROCEDURE AddBonus (
    IN user_id INT,
    IN project_name VARCHAR(255),
    IN score INT
BEGIN
    -- Declare variables to hold project ID and the count of projects with the given name
    DECLARE project_id INT;
    DECLARE project_count INT;

    -- Count the number of projects with the specified name
    SELECT COUNT(*) INTO project_count
    FROM projects
    WHERE name = project_name;

    -- If no project with the specified name exists, insert the new project and get the new project's ID
    IF project_count = 0 THEN
        INSERT INTO projects (name) VALUES (project_name);
        -- Retrieve the ID of the newly inserted project
        SET project_id = LAST_INSERT_ID();
    ELSE
        -- Retrieve the ID of the existing project with the specified name
        SELECT id INTO project_id
        FROM projects
        WHERE name = project_name;
    END IF;

    -- Insert a new correction record into the corrections table
    INSERT INTO corrections (user_id, project_id, score)
    VALUES (user_id, project_id, score);
    -- Note: We assume that user_id exists in the users table and project_id exists in the projects table

END$$

DELIMITER ;
