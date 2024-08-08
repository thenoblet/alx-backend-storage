-- This script creates a 'users' table if it does not already exist. 
-- The table has three columns:
-- 1. 'id' (integer, never null, auto increment, primary key)
-- 2. 'email' (string, 255 characters, never null, unique)
-- 3. 'name' (string, 255 characters)

CREATE TABLE IF NOT EXISTS users (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	email VARCHAR(255) NOT NULL UNIQUE,
	name VARCHAR(255)
);
