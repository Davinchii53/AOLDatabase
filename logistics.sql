-- ============================================================================
-- LOGISTICS DATABASE SYSTEM - THIRD NORMAL FORM (3NF)
-- ============================================================================
-- Database: Logistics Shipment Management
-- Created: January 2026
-- Description: Normalized database structure for logistics company operations
-- Normalized from UNF to 3NF to eliminate data anomalies and redundancy
-- ============================================================================

-- Drop tables if they exist (for clean re-run)
DROP TABLE IF EXISTS TrackingEvents;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Consignment;
DROP TABLE IF EXISTS Courier;

-- ============================================================================
-- TABLE 1: COURIER
-- Description: Master data for couriers who handle shipments
-- Primary Key: CourierID
-- ============================================================================

CREATE TABLE Courier (
    CourierID INTEGER PRIMARY KEY,
    CourierName VARCHAR(100) NOT NULL
);

-- Insert sample data (minimum 5 rows as per requirement)
INSERT INTO Courier (CourierID, CourierName) VALUES
(1, 'Ravi'),
(2, 'Arjun'),
(3, 'Vikram'),
(4, 'Kumar'),
(5, 'Sanjay');

-- ============================================================================
-- TABLE 2: CONSIGNMENT
-- Description: Main transaction table for shipment orders
-- Primary Key: ConsignmentNo
-- Foreign Key: CourierID references Courier(CourierID)
-- ============================================================================

CREATE TABLE Consignment (
    ConsignmentNo INTEGER PRIMARY KEY,
    SenderCity VARCHAR(100) NOT NULL,
    ReceiverCity VARCHAR(100) NOT NULL,
    BookingMode VARCHAR(50) NOT NULL,
    DateOfBooking DATE NOT NULL,
    ChargeAmount DECIMAL(10,2) NOT NULL,
    ChargeWeight DECIMAL(5,2) NOT NULL,
    ShipmentType VARCHAR(50) NOT NULL,
    CourierID INTEGER NOT NULL,
    FOREIGN KEY (CourierID) REFERENCES Courier(CourierID)
);

-- Insert sample data (minimum 5 rows as per requirement)
INSERT INTO Consignment (ConsignmentNo, SenderCity, ReceiverCity, BookingMode, DateOfBooking, ChargeAmount, ChargeWeight, ShipmentType, CourierID) VALUES
(1001, 'Mumbai', 'Chennai', 'Air', '2017-05-20', 250.00, 2.0, 'Documents', 1),
(1002, 'Delhi', 'Mumbai', 'Train', '2017-05-21', 150.00, 3.0, 'Food', 2),
(1003, 'Kolkata', 'Bangalore', 'Air', '2017-05-22', 350.00, 4.0, 'Electronics', 3),
(1004, 'Chennai', 'Hyderabad', 'Surface', '2017-05-20', 200.00, 5.0, 'Clothes', 1),
(1005, 'Jaipur', 'Delhi', 'Train', '2017-05-25', 100.00, 2.0, 'Documents', 4),
(1006, 'Bangalore', 'Pune', 'Air', '2017-05-24', 300.00, 3.0, 'Electronics', 3),
(1007, 'Hyderabad', 'Mumbai', 'Surface', '2017-05-23', 180.00, 4.0, 'Household', 2),
(1008, 'Pune', 'Chennai', 'Train', '2017-05-26', 210.00, 3.0, 'Industrial', 1),
(1009, 'Delhi', 'Kolkata', 'Air', '2017-05-27', 400.00, 5.0, 'Electronics', 4),
(1010, 'Lucknow', 'Jaipur', 'Surface', '2017-05-21', 160.00, 2.0, 'Clothes', 2);

-- ============================================================================
-- TABLE 3: ITEM
-- Description: Detail of items contained in each shipment
-- Primary Key: ItemID
-- Foreign Key: ConsignmentNo references Consignment(ConsignmentNo)
-- ============================================================================

CREATE TABLE Item (
    ItemID INTEGER PRIMARY KEY,
    ConsignmentNo INTEGER NOT NULL,
    ItemName VARCHAR(100) NOT NULL,
    FOREIGN KEY (ConsignmentNo) REFERENCES Consignment(ConsignmentNo)
);

-- Insert sample data (minimum 5 rows as per requirement)
INSERT INTO Item (ItemID, ConsignmentNo, ItemName) VALUES
(1, 1001, 'Passport'),
(2, 1001, 'Legal Papers'),
(3, 1002, 'Snacks'),
(4, 1003, 'Laptop'),
(5, 1003, 'Charger'),
(6, 1004, 'Shirts'),
(7, 1004, 'Pants'),
(8, 1005, 'Certificates'),
(9, 1006, 'Phone'),
(10, 1006, 'Powerbank'),
(11, 1007, 'Small Table'),
(12, 1008, 'Machine Part'),
(13, 1009, 'Camera'),
(14, 1009, 'Lens'),
(15, 1010, 'Jacket');

-- ============================================================================
-- TABLE 4: TRACKINGEVENTS
-- Description: Tracking history and status updates for each shipment
-- Primary Key: TrackingID
-- Foreign Key: ConsignmentNo references Consignment(ConsignmentNo)
-- ============================================================================

CREATE TABLE TrackingEvents (
    TrackingID INTEGER PRIMARY KEY,
    ConsignmentNo INTEGER NOT NULL,
    TrackingStatus VARCHAR(50) NOT NULL,
    FOREIGN KEY (ConsignmentNo) REFERENCES Consignment(ConsignmentNo)
);

-- Insert sample data (minimum 5 rows as per requirement)
INSERT INTO TrackingEvents (TrackingID, ConsignmentNo, TrackingStatus) VALUES
(1, 1001, 'Picked Up'),
(2, 1001, 'In Transit'),
(3, 1001, 'Delivered'),
(4, 1002, 'Picked Up'),
(5, 1002, 'Warehouse'),
(6, 1003, 'Picked Up'),
(7, 1003, 'In Transit'),
(8, 1004, 'Picked Up'),
(9, 1005, 'Picked Up'),
(10, 1005, 'Delivered'),
(11, 1006, 'Picked Up'),
(12, 1006, 'In Transit'),
(13, 1006, 'Delivered'),
(14, 1007, 'Picked Up'),
(15, 1007, 'Warehouse'),
(16, 1007, 'Delivered'),
(17, 1008, 'Picked Up'),
(18, 1008, 'In Transit'),
(19, 1009, 'Picked Up'),
(20, 1009, 'In Transit'),
(21, 1009, 'Delivered'),
(22, 1010, 'Picked Up');

-- ============================================================================
-- VERIFICATION QUERIES
-- Run these to verify data has been inserted correctly
-- ============================================================================

-- Count rows in each table
SELECT 'Courier' AS TableName, COUNT(*) AS RowCount FROM Courier
UNION ALL
SELECT 'Consignment', COUNT(*) FROM Consignment
UNION ALL
SELECT 'Item', COUNT(*) FROM Item
UNION ALL
SELECT 'TrackingEvents', COUNT(*) FROM TrackingEvents;

-- Sample query: Get shipment details with courier name
SELECT 
    c.ConsignmentNo,
    c.SenderCity,
    c.ReceiverCity,
    c.BookingMode,
    c.DateOfBooking,
    c.ChargeAmount,
    cr.CourierName
FROM Consignment c
JOIN Courier cr ON c.CourierID = cr.CourierID
ORDER BY c.ConsignmentNo;

-- Sample query: Get all items in a specific consignment
SELECT 
    c.ConsignmentNo,
    i.ItemName,
    c.ShipmentType
FROM Consignment c
JOIN Item i ON c.ConsignmentNo = i.ConsignmentNo
WHERE c.ConsignmentNo = 1001;

-- Sample query: Get tracking history for a shipment
SELECT 
    c.ConsignmentNo,
    c.SenderCity,
    c.ReceiverCity,
    t.TrackingStatus
FROM Consignment c
JOIN TrackingEvents t ON c.ConsignmentNo = t.ConsignmentNo
WHERE c.ConsignmentNo = 1001
ORDER BY t.TrackingID;
