-- =============================================
-- ESQUEMA BASE DE DATOS - SISTEMA NÓMINAS
-- =============================================
-- Empresa: TechStartup
-- Entorno: dev
-- Empleados estimados: 25
-- Departamentos: 4

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS TechStartup_payroll;
USE TechStartup_payroll;

-- =============================================
-- TABLA: DEPARTAMENTOS
-- =============================================
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) UNIQUE NOT NULL,
    manager_id INT,
    budget DECIMAL(15,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- TABLA: EMPLEADOS
-- =============================================
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_code VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    position VARCHAR(100),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    status ENUM('active', 'inactive', 'terminated') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- =============================================
-- TABLA: NÓMINAS
-- =============================================
CREATE TABLE payrolls (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    pay_period_start DATE NOT NULL,
    pay_period_end DATE NOT NULL,
    gross_pay DECIMAL(10,2) NOT NULL,
    deductions DECIMAL(10,2) DEFAULT 0,
    taxes DECIMAL(10,2) DEFAULT 0,
    net_pay DECIMAL(10,2) NOT NULL,
    status ENUM('draft', 'processed', 'paid') DEFAULT 'draft',
    processed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

-- =============================================
-- TABLA: DEDUCCIONES
-- =============================================
CREATE TABLE deductions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    payroll_id INT NOT NULL,
    type ENUM('tax', 'insurance', 'retirement', 'other') NOT NULL,
    description VARCHAR(100),
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (payroll_id) REFERENCES payrolls(id)
);

-- =============================================
-- INSERTAR DATOS DE EJEMPLO
-- =============================================

-- Insertar departamentos
INSERT INTO departments (name, code, budget) VALUES 
    ('Department 1', 'DEPT01', 50000);
INSERT INTO departments (name, code, budget) VALUES 
    ('Department 2', 'DEPT02', 75000);
INSERT INTO departments (name, code, budget) VALUES 
    ('Department 3', 'DEPT03', 100000);
INSERT INTO departments (name, code, budget) VALUES 
    ('Department 4', 'DEPT04', 125000);

-- Insertar empleados de ejemplo (limitado para no hacer el archivo muy grande)
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0001', 'Employee1', 'LastName1', 'employee1@TechStartup.com', 
     1, 'Position 1', '2024-01-01', 30000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0002', 'Employee2', 'LastName2', 'employee2@TechStartup.com', 
     2, 'Position 2', '2024-01-01', 35000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0003', 'Employee3', 'LastName3', 'employee3@TechStartup.com', 
     3, 'Position 3', '2024-01-01', 40000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0004', 'Employee4', 'LastName4', 'employee4@TechStartup.com', 
     4, 'Position 4', '2024-01-01', 45000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0005', 'Employee5', 'LastName5', 'employee5@TechStartup.com', 
     1, 'Position 5', '2024-01-01', 50000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0006', 'Employee6', 'LastName6', 'employee6@TechStartup.com', 
     2, 'Position 6', '2024-01-01', 55000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0007', 'Employee7', 'LastName7', 'employee7@TechStartup.com', 
     3, 'Position 7', '2024-01-01', 60000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0008', 'Employee8', 'LastName8', 'employee8@TechStartup.com', 
     4, 'Position 8', '2024-01-01', 65000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0009', 'Employee9', 'LastName9', 'employee9@TechStartup.com', 
     1, 'Position 9', '2024-01-01', 70000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0010', 'Employee10', 'LastName10', 'employee10@TechStartup.com', 
     2, 'Position 10', '2024-01-01', 75000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0011', 'Employee11', 'LastName11', 'employee11@TechStartup.com', 
     3, 'Position 11', '2024-01-01', 80000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0012', 'Employee12', 'LastName12', 'employee12@TechStartup.com', 
     4, 'Position 12', '2024-01-01', 85000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0013', 'Employee13', 'LastName13', 'employee13@TechStartup.com', 
     1, 'Position 13', '2024-01-01', 90000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0014', 'Employee14', 'LastName14', 'employee14@TechStartup.com', 
     2, 'Position 14', '2024-01-01', 95000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0015', 'Employee15', 'LastName15', 'employee15@TechStartup.com', 
     3, 'Position 15', '2024-01-01', 100000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0016', 'Employee16', 'LastName16', 'employee16@TechStartup.com', 
     4, 'Position 16', '2024-01-01', 105000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0017', 'Employee17', 'LastName17', 'employee17@TechStartup.com', 
     1, 'Position 17', '2024-01-01', 110000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0018', 'Employee18', 'LastName18', 'employee18@TechStartup.com', 
     2, 'Position 18', '2024-01-01', 115000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0019', 'Employee19', 'LastName19', 'employee19@TechStartup.com', 
     3, 'Position 19', '2024-01-01', 120000);
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP0020', 'Employee20', 'LastName20', 'employee20@TechStartup.com', 
     4, 'Position 20', '2024-01-01', 125000);

-- =============================================
-- ÍNDICES PARA RENDIMIENTO
-- =============================================
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_status ON employees(status);
CREATE INDEX idx_payrolls_employee ON payrolls(employee_id);
CREATE INDEX idx_payrolls_period ON payrolls(pay_period_start, pay_period_end);
CREATE INDEX idx_payrolls_status ON payrolls(status);

-- =============================================
-- VISTAS ÚTILES
-- =============================================

-- Vista: Empleados activos por departamento
CREATE VIEW active_employees_by_dept AS
SELECT 
    d.name as department_name,
    d.code as department_code,
    COUNT(e.id) as active_employees,
    AVG(e.salary) as average_salary
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id AND e.status = 'active'
GROUP BY d.id, d.name, d.code;

-- Vista: Resumen de última nómina
CREATE VIEW latest_payroll_summary AS
SELECT 
    e.employee_code,
    CONCAT(e.first_name, ' ', e.last_name) as full_name,
    d.name as department,
    p.gross_pay,
    p.net_pay,
    p.pay_period_start,
    p.pay_period_end,
    p.status
FROM employees e
JOIN departments d ON e.department_id = d.id
LEFT JOIN payrolls p ON e.id = p.employee_id
WHERE p.pay_period_end = (
    SELECT MAX(pay_period_end) 
    FROM payrolls p2 
    WHERE p2.employee_id = e.id
) OR p.id IS NULL;

-- Comentarios finales
-- Base de datos configurada para 25 empleados en 4 departamentos
-- Esquema optimizado para entorno: dev