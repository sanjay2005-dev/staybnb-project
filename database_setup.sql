-- Create database
CREATE DATABASE IF NOT EXISTS staybnb_db;
USE staybnb_db;

-- Create properties table
CREATE TABLE properties (
    property_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    price_per_night DECIMAL(10, 2) NOT NULL,
    max_guests INT NOT NULL,
    bedrooms INT,
    bathrooms INT,
    property_type VARCHAR(50),
    main_image VARCHAR(500),
    available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create bookings table
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT,
    user_email VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'confirmed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

-- Create reviews table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT,
    user_email VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

-- Create amenities table
CREATE TABLE amenities (
    amenity_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    icon VARCHAR(100)
);

-- Create property_amenities junction table
CREATE TABLE property_amenities (
    property_id INT,
    amenity_id INT,
    PRIMARY KEY (property_id, amenity_id),
    FOREIGN KEY (property_id) REFERENCES properties(property_id),
    FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id)
);

-- Insert sample amenities
INSERT INTO amenities (name, icon) VALUES
('WiFi', 'fa-wifi'),
('Kitchen', 'fa-utensils'),
('Parking', 'fa-car'),
('Pool', 'fa-swimmer'),
('Gym', 'fa-dumbbell'),
('Pet Friendly', 'fa-paw'),
('Air Conditioning', 'fa-snowflake'),
('Heating', 'fa-fire'),
('TV', 'fa-tv'),
('Washing Machine', 'fa-tshirt');

-- Insert sample properties
INSERT INTO properties (title, description, location, city, state, country, price_per_night, max_guests, bedrooms, bathrooms, property_type, main_image) VALUES
('Luxury Beach Villa', 'Beautiful beachfront villa with stunning ocean views', 'Malibu Beach', 'Malibu', 'California', 'USA', 450.00, 8, 4, 3, 'Villa', 'images/house-1.png'),
('Cozy Mountain Cabin', 'Rustic cabin in the mountains perfect for a getaway', 'Rocky Mountains', 'Aspen', 'Colorado', 'USA', 220.00, 6, 3, 2, 'Cabin', 'images/house-2.png'),
('Modern City Apartment', 'Stylish apartment in the heart of the city', 'Downtown', 'New York', 'New York', 'USA', 180.00, 4, 2, 1, 'Apartment', 'images/house-3.png'),
('Historic Townhouse', 'Charming historic townhouse with modern amenities', 'French Quarter', 'New Orleans', 'Louisiana', 'USA', 160.00, 6, 3, 2, 'Townhouse', 'images/house-4.png'),
('Beachside Bungalow', 'Cozy bungalow steps away from the beach', 'Santa Monica', 'Los Angeles', 'California', 'USA', 280.00, 4, 2, 1, 'Bungalow', 'images/house-5.png'),
('Lakefront Lodge', 'Spacious lodge with panoramic lake views', 'Lake Tahoe', 'South Lake Tahoe', 'California', 'USA', 320.00, 10, 5, 3, 'Lodge', 'images/house-1.png'),
('Urban Loft', 'Industrial loft in trendy neighborhood', 'SoHo', 'New York', 'New York', 'USA', 250.00, 4, 2, 2, 'Loft', 'images/house-2.png'),
('Country Farmhouse', 'Peaceful farmhouse surrounded by nature', 'Countryside', 'Nashville', 'Tennessee', 'USA', 190.00, 8, 4, 3, 'Farmhouse', 'images/house-3.png');

-- Insert sample property amenities
INSERT INTO property_amenities (property_id, amenity_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 7),
(2, 1), (2, 2), (2, 3), (2, 8), (2, 9),
(3, 1), (3, 2), (3, 7), (3, 9), (3, 10),
(4, 1), (4, 2), (4, 7), (4, 9),
(5, 1), (5, 2), (5, 3), (5, 7), (5, 9),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 8), (6, 9),
(7, 1), (7, 2), (7, 7), (7, 9), (7, 10),
(8, 1), (8, 2), (8, 3), (8, 6), (8, 8), (8, 9);

-- Insert sample reviews
INSERT INTO reviews (property_id, user_email, user_name, rating, comment) VALUES
(1, 'john@example.com', 'John Smith', 5, 'Amazing villa with breathtaking views!'),
(1, 'sarah@example.com', 'Sarah Johnson', 4, 'Great location and clean property'),
(2, 'mike@example.com', 'Mike Brown', 5, 'Perfect mountain retreat, very peaceful'),
(3, 'emily@example.com', 'Emily Davis', 4, 'Convenient location, modern amenities'),
(4, 'david@example.com', 'David Wilson', 5, 'Beautiful historic property with charm'),
(5, 'lisa@example.com', 'Lisa Miller', 4, 'Great beach access, loved the location'),
(6, 'tom@example.com', 'Tom Anderson', 5, 'Spectacular lake views, highly recommend'),
(7, 'anna@example.com', 'Anna Taylor', 4, 'Trendy loft in great neighborhood');

-- Create indexes for better performance
CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_properties_price ON properties(price_per_night);
CREATE INDEX idx_properties_available ON properties(available);
CREATE INDEX idx_bookings_property ON bookings(property_id);
CREATE INDEX idx_bookings_dates ON bookings(check_in_date, check_out_date);
CREATE INDEX idx_reviews_property ON reviews(property_id);