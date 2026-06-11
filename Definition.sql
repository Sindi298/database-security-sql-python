USE CyberSecurityDB;
GO


-- Drop tables in child-first order
DROP TABLE IF EXISTS Security_Training;
DROP TABLE IF EXISTS Security_Logs;
DROP TABLE IF EXISTS Incident_Threats;
DROP TABLE IF EXISTS Incidents;
DROP TABLE IF EXISTS Vulnerabilities;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Systems;
DROP TABLE IF EXISTS Threats;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
GO

CREATE TABLE Departments (
    department_id INT PRIMARY KEY IDENTITY(1,1),
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);
GO


CREATE TABLE Employees (
    employee_id INT PRIMARY KEY IDENTITY(1000,1),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    department_id INT,
    role_title VARCHAR(100),
    hire_date DATE,
    FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
);
GO


CREATE TABLE Systems (
    system_id INT PRIMARY KEY IDENTITY(1,1),
    system_name VARCHAR(100) NOT NULL,
    ip_address VARCHAR(50),
    operating_system VARCHAR(100),
    criticality_level VARCHAR(20),
    owner_employee_id INT,
    FOREIGN KEY (owner_employee_id)
        REFERENCES Employees(employee_id)
);
GO


CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    access_level VARCHAR(50),
    employee_id INT,
    last_login DATETIME,
    account_status VARCHAR(20),
    FOREIGN KEY (employee_id)
        REFERENCES Employees(employee_id)
);
GO


CREATE TABLE Threats (
    threat_id INT PRIMARY KEY IDENTITY(1,1),
    threat_name VARCHAR(100),
    threat_type VARCHAR(50),
    severity VARCHAR(20),
    description VARCHAR(255)
);
GO


CREATE TABLE Vulnerabilities (
    vulnerability_id INT PRIMARY KEY IDENTITY(1,1),
    vulnerability_name VARCHAR(100),
    cve_code VARCHAR(50),
    severity VARCHAR(20),
    affected_system_id INT,
    discovered_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (affected_system_id)
        REFERENCES Systems(system_id)
);
GO


CREATE TABLE Incidents (
    incident_id INT PRIMARY KEY IDENTITY(1,1),
    incident_title VARCHAR(150),
    incident_type VARCHAR(50),
    severity VARCHAR(20),
    detected_date DATETIME,
    resolved_date DATETIME,
    status VARCHAR(50),
    affected_system_id INT,
    reported_by INT,
    FOREIGN KEY (affected_system_id)
        REFERENCES Systems(system_id),
    FOREIGN KEY (reported_by)
        REFERENCES Employees(employee_id)
);
GO


CREATE TABLE Incident_Threats (
    incident_id INT,
    threat_id INT,
    PRIMARY KEY (incident_id, threat_id),
    FOREIGN KEY (incident_id)
        REFERENCES Incidents(incident_id),
    FOREIGN KEY (threat_id)
        REFERENCES Threats(threat_id)
);
GO


CREATE TABLE Security_Logs (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    system_id INT,
    activity VARCHAR(255),
    log_time DATETIME DEFAULT GETDATE(),
    ip_address VARCHAR(50),
    FOREIGN KEY (user_id)
        REFERENCES Users(user_id),
    FOREIGN KEY (system_id)
        REFERENCES Systems(system_id)
);
GO


CREATE TABLE Security_Training (
    training_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT,
    training_name VARCHAR(100),
    completion_date DATE,
    certification_status VARCHAR(50),
    FOREIGN KEY (employee_id)
        REFERENCES Employees(employee_id)
);
GO


INSERT INTO Departments (department_name, location)
VALUES
('Security Operations', 'Pretoria'),
('IT Infrastructure', 'Johannesburg'),
('Compliance', 'Cape Town');
GO


INSERT INTO Employees 
(first_name, last_name, email, phone, department_id, role_title, hire_date)
VALUES
('Norma', 'Mokoena', 'norma@company.com', '0711111111', 1, 'SOC Analyst', '2024-01-15'),
('David', 'Smith', 'david@company.com', '0722222222', 2, 'System Administrator', '2023-07-10'),
('Aisha', 'Khan', 'aisha@company.com', '0733333333', 3, 'Compliance Officer', '2022-05-22');
GO


INSERT INTO Systems
(system_name, ip_address, operating_system, criticality_level, owner_employee_id)
VALUES
('Firewall-01', '192.168.1.1', 'Cisco IOS', 'High', 1000),
('WebServer-01', '192.168.1.20', 'Windows Server 2022', 'Critical', 1001),
('Database-01', '192.168.1.30', 'Ubuntu Linux', 'Critical', 1001);
GO


INSERT INTO Users
(username, password_hash, access_level, employee_id, last_login, account_status)
VALUES
('nmokoena', 'HASH12345', 'Admin', 1000, GETDATE(), 'Active'),
('dsmith', 'HASH67890', 'User', 1001, GETDATE(), 'Active'),
('akhan', 'HASHABCDE', 'Auditor', 1002, GETDATE(), 'Locked');
GO


INSERT INTO Threats
(threat_name, threat_type, severity, description)
VALUES
('Ransomware Attack', 'Malware', 'Critical', 'Encrypts files and demands payment'),
('SQL Injection', 'Web Attack', 'High', 'Database manipulation attack'),
('Phishing Email', 'Social Engineering', 'Medium', 'Fraudulent email attack');
GO


INSERT INTO Vulnerabilities
(vulnerability_name, cve_code, severity, affected_system_id, discovered_date, status)
VALUES
('OpenSSL Exploit', 'CVE-2024-1234', 'Critical', 3, '2026-05-01', 'Open'),
('Weak Password Policy', 'CVE-2024-5678', 'High', 2, '2026-05-03', 'In Progress');
GO


INSERT INTO Incidents
(incident_title, incident_type, severity, detected_date, resolved_date, status, affected_system_id, reported_by)
VALUES
('Database Breach Attempt', 'Intrusion', 'Critical', GETDATE(), NULL, 'Investigating', 3, 1000),
('Employee Phishing Click', 'Phishing', 'Medium', GETDATE(), GETDATE(), 'Resolved', 2, 1002);
GO


INSERT INTO Incident_Threats
(incident_id, threat_id)
VALUES
(1,1),
(1,2),
(2,3);
GO


INSERT INTO Security_Logs
(user_id, system_id, activity, ip_address)
VALUES
(1,1,'Failed login attempt','10.0.0.1'),
(2,2,'Accessed confidential file','10.0.0.2'),
(3,3,'Password changed','10.0.0.3');
GO


INSERT INTO Security_Training
(employee_id, training_name, completion_date, certification_status)
VALUES
(1000, 'Ethical Hacking Fundamentals', '2026-03-01', 'Completed'),
(1001, 'Network Defense', '2026-04-15', 'Completed'),
(1002, 'ISO 27001 Compliance', '2026-02-10', 'Pending');
GO

INSERT INTO Threats 
    (threat_name, threat_type, severity, description)
VALUES 
    ('Brute Force Attack', 'Network Attack', 'High', 'Repeated login attempts to gain unauthorised access');

UPDATE Incidents
SET status = 'Resolved'
WHERE incident_id = 1;

-- Step 1: Delete the related logs first
DELETE FROM Security_Logs
WHERE user_id = (
    SELECT user_id 
    FROM Users 
    WHERE account_status = 'Locked'
);

-- Step 2: Now delete the locked user
DELETE FROM Users
WHERE account_status = 'Locked';