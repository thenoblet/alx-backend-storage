-- This script creates a view named need_meeting.
-- The view lists students who have a score strictly less than 80 and either have no last_meeting date
-- or their last meeting was more than one month ago.

-- Drop the view if it already exists
DROP VIEW IF EXISTS need_meeting;

-- Create the view need_meeting
CREATE VIEW need_meeting AS
SELECT name
FROM students
WHERE score < 80
AND (last_meeting IS NULL
     OR last_meeting < CURDATE() - INTERVAL 1 MONTH);

