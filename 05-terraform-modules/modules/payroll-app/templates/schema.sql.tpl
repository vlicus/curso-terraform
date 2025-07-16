-- =============================================
-- ESQUEMA BASE DE DATOS - SISTEMA NÓMINAS
-- =============================================
-- Empresa: ${company_name}
-- Entorno: ${environment}
-- Empleados estimados: ${employee_count}
-- Departamentos: ${department_count}

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS ${company_name}_payroll;
USE ${company_name}_payroll;

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
%{ for i in range(department_count) ~}
INSERT INTO departments (name, code, budget) VALUES 
    ('Department ${i + 1}', 'DEPT${format("%02d", i + 1)}', ${50000 + (i * 25000)});
%{ endfor ~}

-- Insertar empleados de ejemplo (limitado para no hacer el archivo muy grande)
%{ for i in range(min(employee_count, 20)) ~}
INSERT INTO employees (employee_code, first_name, last_name, email, department_id, position, hire_date, salary) VALUES 
    ('EMP${format("%04d", i + 1)}', 'Employee${i + 1}', 'LastName${i + 1}', 'employee${i + 1}@${company_name}.com', 
     ${(i % department_count) + 1}, 'Position ${i + 1}', '2024-01-01', ${30000 + (i * 5000)});
%{ endfor ~}

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
-- Base de datos configurada para ${employee_count} empleados en ${department_count} departamentos
-- Esquema optimizado para entorno: ${environment}