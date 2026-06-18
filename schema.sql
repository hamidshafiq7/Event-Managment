-- =========================================================================
-- DATABASE ARCHITECTURE SETUP SCRIPT
-- Target Engine: MariaDB / MySQL (XAMPP Stack deployment)
-- Default System Port Connection Configuration: 3307
-- =========================================================================

CREATE DATABASE IF NOT EXISTS EventManagementSystem;
USE EventManagementSystem;

-- Clear previous relational structures to maintain a clean compilation path
DROP TABLE IF EXISTS event_services;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS venues;

-- 1. Create Venues Table (Structural Location Inventory)
CREATE TABLE venues (
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    capacity INT NOT NULL,
    cost_per_day DECIMAL(10, 2) NOT NULL
);

-- 2. Create Users Table (Administrative Accounts & Identity Control)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    user_role ENUM('Admin', 'Organizer', 'Client') NOT NULL,
    phone VARCHAR(15)
);

-- 3. Create Services Table (Core Operational Add-ons & Resource Assets)
CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL
);

-- 4. Create Events Table (Primary Transaction Matrix Linking Users & Venues)
CREATE TABLE events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    venue_id INT,
    organizer_id INT,
    FOREIGN KEY (venue_id) REFERENCES venues(venue_id) ON DELETE SET NULL,
    FOREIGN KEY (organizer_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- 5. Create Event_Services Table (Associative M:N Junction Bridge Entity)
CREATE TABLE event_services (
    event_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT DEFAULT 1,
    agreed_price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (event_id, service_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE
);

-- =========================================================================
-- CORE OPERATIONAL DATA SEEDING SCRIPTS
-- =========================================================================

-- Seed Venues
INSERT INTO venues (venue_name, address, capacity, cost_per_day) VALUES
('Royal Palm Banquet Hall', '123 Luxury Road, City Center', 500, 1500.00),
('Crystal Marquee', '456 Elite Avenue, Suburbs', 300, 1200.00),
('Elegance Garden', '789 Green Meadow Lane', 1000, 2500.00);

-- Seed System User Personas
INSERT INTO users (first_name, last_name, email, user_role, phone) VALUES
('Malik', 'Hamid', 'malik@cybersecurity.edu', 'Organizer', '555-0192'),
('Haris', 'Yasin', 'haris@eventsbyhy.com', 'Admin', '555-0143'),
('Sarah', 'Khan', 'sarah.k@gmail.com', 'Client', '555-0177');

-- Seed Core Asset Catalog Inventory
INSERT INTO services (service_name, base_price) VALUES
('Premium Floral Stage Decor', 600.00),
('Gourmet Buffet Catering (per head)', 25.00),
('Cinematic Photography & Video', 800.00),
('Concert Sound & Lighting Setup', 450.00);

-- Seed Initial Active Event Transaction
INSERT INTO events (title, event_type, start_date, end_date, venue_id, organizer_id) VALUES
('Sarah Wedding Reception', 'Wedding', '2026-08-15 18:00:00', '2026-08-15 23:30:00', 1, 1);

-- Link Specific Provisioned Sub-Services to Event ID 1
INSERT INTO event_services (event_id, service