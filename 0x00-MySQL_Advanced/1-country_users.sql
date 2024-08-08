-- This script creates a 'users' table if it does not already exist.
-- The table has four columns:
-- 1. 'id' (integer, never null, auto increment, primary key): Automatically increments with each new record to uniquely identify each row.
-- 2. 'email' (string, 255 characters, never null, unique): Stores the user's email address, ensures that each email is unique and not null.
-- 3. 'name' (string, 255 characters): Stores the user's name, can be null.
-- 4. 'country' (enumeration of 'US', 'CO', 'TN', never null): Stores the user's country, defaults to 'US' if not provided.

CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    country ENUM('US', 'CO', 'TN') NOT NULL DEFAULT 'US'
);
