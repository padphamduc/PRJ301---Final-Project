USE master
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'DentalClinicDB')
BEGIN
    DROP DATABASE DentalClinicDB
END
GO

CREATE DATABASE DentalClinicDB
GO

USE DentalClinicDB
GO

-- 1. Create Users Table
CREATE TABLE Users (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    fullName NVARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('customer', 'receptionist', 'doctor', 'admin')),
    email VARCHAR(100),
    phone VARCHAR(15)
);
GO

-- 2. Create Doctors Table
CREATE TABLE Doctors (
    username VARCHAR(50) PRIMARY KEY FOREIGN KEY REFERENCES Users(username) ON DELETE CASCADE,
    specialty NVARCHAR(100) NOT NULL,
    room NVARCHAR(50) NOT NULL
);
GO

-- 3. Create Services Table
CREATE TABLE Services (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description NVARCHAR(500)
);
GO

-- 4. Create Medicines Table
CREATE TABLE Medicines (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    unit NVARCHAR(20) NOT NULL,
    stockQuantity INT NOT NULL DEFAULT 0
);
GO

-- 5. Create Appointments Table
CREATE TABLE Appointments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    customerUsername VARCHAR(50) FOREIGN KEY REFERENCES Users(username) ON DELETE SET NULL,
    customerName NVARCHAR(100) NOT NULL,
    customerPhone VARCHAR(15) NOT NULL,
    doctorUsername VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Doctors(username),
    appointmentDate DATE NOT NULL,
    timeSlot VARCHAR(50) NOT NULL, -- e.g., '08:00 - 09:00', '09:00 - 10:00', etc.
    status VARCHAR(20) NOT NULL CHECK (status IN ('Pending', 'CheckedIn', 'Examining', 'Completed', 'Paid', 'Cancelled')),
    symptoms NVARCHAR(250),
    diagnosis NVARCHAR(500),
    assignedRoom NVARCHAR(50)
);
GO

-- 6. Create AppointmentServices Table
CREATE TABLE AppointmentServices (
    appointmentId INT FOREIGN KEY REFERENCES Appointments(id) ON DELETE CASCADE,
    serviceId INT FOREIGN KEY REFERENCES Services(id) ON DELETE CASCADE,
    PRIMARY KEY (appointmentId, serviceId)
);
GO

-- 7. Create Prescriptions Table
CREATE TABLE Prescriptions (
    appointmentId INT FOREIGN KEY REFERENCES Appointments(id) ON DELETE CASCADE,
    medicineId INT FOREIGN KEY REFERENCES Medicines(id) ON DELETE CASCADE,
    quantity INT NOT NULL,
    boughtQuantity INT NOT NULL DEFAULT 0,
    instructions NVARCHAR(250),
    PRIMARY KEY (appointmentId, medicineId)
);
GO

-- ============================================================================
-- Seed Mock Data
-- ============================================================================

-- Users: Admin, Receptionist, Doctors, and Customers
INSERT INTO Users (username, password, fullName, role, email, phone) VALUES
('admin', '123', N'Nguyễn Quản Trị', 'admin', 'admin@dental.com', '0911111111'),
('recept', '123', N'Trần Tiếp Đón', 'receptionist', 'recept@dental.com', '0922222222'),
('doc_minh', '123', N'Bác sĩ Lê Minh Dũng', 'doctor', 'minh.dung@dental.com', '0933333333'),
('doc_kien', '123', N'Bác sĩ Nguyễn Văn Kiên', 'doctor', 'van.kien@dental.com', '0944444444'),
('cus_duc', '123', N'Phạm Anh Đức', 'customer', 'cus.duc@gmail.com', '0988888888'),
('cus_quang', '123', N'Mai Thế Quang', 'customer', 'cus.quang@gmail.com', '0977777777');
GO

-- Doctors mapping
INSERT INTO Doctors (username, specialty, room) VALUES
('doc_minh', N'Nha khoa tổng quát & Cấy ghép Implant', N'Phòng Khám 101 (Tầng 1)'),
('doc_kien', N'Chỉnh nha & Bọc răng sứ thẩm mỹ', N'Phòng Khám 202 (Tầng 2)');
GO

-- Services
INSERT INTO Services (name, price, description) VALUES
(N'Khám tổng quát & Tư vấn', 50000.00, N'Khám định kỳ, kiểm tra tình trạng răng miệng tổng quát.'),
(N'Lấy cao răng & Đánh bóng', 150000.00, N'Làm sạch các mảng bám và cao răng bằng sóng siêu âm.'),
(N'Trám răng thẩm mỹ', 250000.00, N'Hàn trám răng sâu bằng vật liệu composite thẩm mỹ cao.'),
(N'Nhổ răng khôn (Răng số 8)', 1200000.00, N'Phẫu thuật nhổ răng khôn mọc lệch, mọc ngầm không đau.'),
(N'Tẩy trắng răng nhanh tại phòng khám', 2000000.00, N'Tẩy trắng răng công nghệ Laser Whitening bật tông nhanh.'),
(N'Bọc răng sứ titan', 250000.00, N'Phục hình răng sứt mẻ hoặc mất răng bằng sứ titan bền chắc.');
GO

-- Medicines with stockQuantity
INSERT INTO Medicines (name, price, unit, stockQuantity) VALUES
(N'Paracetamol 500mg (Giảm đau)', 2000.00, N'Viên', 500),
(N'Amoxicillin 500mg (Kháng sinh)', 3000.00, N'Viên', 300),
(N'Ibuprofen 400mg (Kháng viêm)', 2500.00, N'Viên', 400),
(N'Nước súc miệng diệt khuẩn Kin', 120000.00, N'Chai', 100),
(N'Gel bôi nhiệt miệng Kamistad', 85000.00, N'Tuýp', 150);
GO

-- Sample Appointments
-- 1. Completed appointment (cus_duc visited doc_minh)
INSERT INTO Appointments (customerUsername, customerName, customerPhone, doctorUsername, appointmentDate, timeSlot, status, symptoms, diagnosis, assignedRoom) VALUES
('cus_duc', N'Phạm Anh Đức', '0988888888', 'doc_minh', '2026-07-10', '09:00 - 10:00', 'Paid', N'Đau răng buốt khi uống nước lạnh', N'Sâu răng hàm số 36', N'Phòng Khám 101 (Tầng 1)');
GO

DECLARE @AppId1 INT = SCOPE_IDENTITY();
-- Prescribe a service (Trám răng)
INSERT INTO AppointmentServices (appointmentId, serviceId) VALUES (@AppId1, 3);
-- Prescribe medicines
INSERT INTO Prescriptions (appointmentId, medicineId, quantity, boughtQuantity, instructions) VALUES
(@AppId1, 1, 10, 10, N'Uống 1 viên sau ăn khi đau, tối đa 3 viên/ngày'),
(@AppId1, 4, 1, 1, N'Súc miệng 2-3 lần/ngày sau khi đánh răng');
GO

-- 2. Pending appointment (cus_quang booked online for doc_kien)
INSERT INTO Appointments (customerUsername, customerName, customerPhone, doctorUsername, appointmentDate, timeSlot, status, symptoms, diagnosis, assignedRoom) VALUES
('cus_quang', N'Mai Thế Quang', '0977777777', 'doc_kien', '2026-07-15', '14:00 - 15:00', 'Pending', N'Muốn tư vấn niềng răng', NULL, NULL);
GO
