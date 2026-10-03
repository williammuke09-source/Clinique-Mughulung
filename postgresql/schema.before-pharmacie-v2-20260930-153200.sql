-- CLINIQUE MUGHULUNGU
-- Préparation PostgreSQL production
-- Basé exclusivement sur la structure fonctionnelle du cahier des charges.
-- À exécuter dans une base PostgreSQL dédiée.

CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE permissions (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    module VARCHAR(80) NOT NULL
);

CREATE TABLE role_permissions (
    role_id BIGINT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id BIGINT NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(120) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role_id BIGINT NOT NULL REFERENCES roles(id),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    failed_attempts INTEGER NOT NULL DEFAULT 0,
    locked_until TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    action TEXT NOT NULL,
    module VARCHAR(80) NOT NULL,
    date_time TIMESTAMP NOT NULL,
    object_type VARCHAR(120),
    object_id BIGINT,
    result VARCHAR(80) NOT NULL
);

CREATE TABLE patients (
    id BIGSERIAL PRIMARY KEY,
    patient_number VARCHAR(40) NOT NULL UNIQUE,
    last_name VARCHAR(120) NOT NULL,
    post_name VARCHAR(120),
    first_name VARCHAR(120) NOT NULL,
    sex VARCHAR(30) NOT NULL,
    birth_date DATE,
    birth_place TEXT,
    address TEXT,
    phone VARCHAR(50),
    profession VARCHAR(120),
    admin_info TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE patient_contacts (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    name VARCHAR(160) NOT NULL,
    relationship VARCHAR(100),
    phone VARCHAR(50)
);

CREATE TABLE appointments (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES patients(id),
    doctor_id BIGINT REFERENCES users(id),
    service VARCHAR(120),
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    reason TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'Prévu',
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE triage_records (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES patients(id),
    temperature NUMERIC(6,2),
    weight NUMERIC(8,2),
    blood_pressure VARCHAR(50),
    heart_rate NUMERIC(8,2),
    respiratory_rate NUMERIC(8,2),
    oxygen_saturation NUMERIC(6,2),
    height NUMERIC(8,2),
    bmi NUMERIC(8,2),
    pain_scale INTEGER,
    observation TEXT,
    recorded_by BIGINT REFERENCES users(id),
    recorded_at TIMESTAMP NOT NULL
);

CREATE TABLE medical_records (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL UNIQUE REFERENCES patients(id),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE consultations (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES patients(id),
    medical_record_id BIGINT NOT NULL REFERENCES medical_records(id),
    doctor_id BIGINT NOT NULL REFERENCES users(id),
    consultation_date TIMESTAMP NOT NULL,
    complaint TEXT,
    history TEXT,
    temperature NUMERIC(6,2),
    weight NUMERIC(8,2),
    blood_pressure VARCHAR(50),
    heart_rate NUMERIC(8,2),
    respiratory_rate NUMERIC(8,2),
    oxygen_saturation NUMERIC(6,2),
    clinical_exam TEXT,
    primary_diagnosis TEXT,
    secondary_diagnosis TEXT,
    hypotheses TEXT,
    treatment TEXT,
    advice TEXT,
    next_appointment TEXT,
    referral TEXT,
    hospitalization_needed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE medicine_categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(160) NOT NULL UNIQUE
);

CREATE TABLE suppliers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE,
    phone VARCHAR(50),
    address TEXT,
    contact_person VARCHAR(160)
);

CREATE TABLE medicines (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(80) NOT NULL UNIQUE,
    name VARCHAR(200) NOT NULL,
    form VARCHAR(120),
    dosage VARCHAR(120),
    category VARCHAR(160),
    supplier VARCHAR(200),
    purchase_price NUMERIC(14,2) NOT NULL DEFAULT 0,
    sale_price NUMERIC(14,2) NOT NULL DEFAULT 0,
    available_quantity NUMERIC(14,2) NOT NULL DEFAULT 0,
    minimum_threshold NUMERIC(14,2) NOT NULL DEFAULT 0,
    expiration_date DATE,
    lot_number VARCHAR(120),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE prescriptions (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES patients(id),
    consultation_id BIGINT REFERENCES consultations(id),
    prescribed_by BIGINT NOT NULL REFERENCES users(id),
    prescription_date TIMESTAMP NOT NULL,
    instructions TEXT
);

CREATE TABLE prescription_items (
    id BIGSERIAL PRIMARY KEY,
    prescription_id BIGINT NOT NULL REFERENCES prescriptions(id) ON DELETE CASCADE,
    medicine_id BIGINT REFERENCES medicines(id),
    medicine_name VARCHAR(200) NOT NULL,
    dosage VARCHAR(120),
    frequency VARCHAR(120),
    duration VARCHAR(120),
    instructions TEXT
);

CREATE TABLE laboratory_requests (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES patients(id),
    prescriber_id BIGINT NOT NULL REFERENCES users(id),
    exam_requested TEXT NOT NULL,
    sample TEXT,
    request_date TIMESTAMP NOT NULL
);

CREATE TABLE laboratory_results (
    id BIGSERIAL PRIMARY KEY,
    laboratory_request_id BIGINT NOT NULL REFERENCES laboratory_requests(id) ON DELETE CASCADE,
    result TEXT,
    conclusion TEXT,
    result_date TIMESTAMP NOT NULL,
    recorded_by BIGINT REFERENCES users(id)
);

CREATE TABLE hospitalizations (
    id BIGSERIAL PRIMARY KEY,
    hospitalization_number VARCHAR(80) NOT NULL UNIQUE,
    patient_id BIGINT NOT NULL REFERENCES patients(id),
    doctor_id BIGINT NOT NULL REFERENCES users(id),
    service VARCHAR(120),
    entry_datetime TIMESTAMP NOT NULL,
    reason TEXT,
    diagnosis TEXT,
    room_bed VARCHAR(120),
    treatment TEXT,
    observations TEXT,
    discharge_datetime TIMESTAMP,
    final_diagnosis TEXT,
    recommendations TEXT
);

CREATE TABLE hospitalization_observations (
    id BIGSERIAL PRIMARY KEY,
    hospitalization_id BIGINT NOT NULL REFERENCES hospitalizations(id),
    observation_datetime TIMESTAMP NOT NULL,
    temperature NUMERIC(6,2),
    blood_pressure VARCHAR(50),
    pulse NUMERIC(8,2),
    weight NUMERIC(8,2),
    patient_state TEXT,
    treatment TEXT,
    nurse_observation TEXT,
    recorded_by BIGINT REFERENCES users(id)
);

CREATE TABLE stock_movements (
    id BIGSERIAL PRIMARY KEY,
    medicine_id BIGINT NOT NULL REFERENCES medicines(id),
    movement_type VARCHAR(50) NOT NULL,
    quantity NUMERIC(14,2) NOT NULL,
    unit_price NUMERIC(14,2),
    reference TEXT,
    user_id BIGINT NOT NULL REFERENCES users(id),
    movement_date TIMESTAMP NOT NULL
);

CREATE TABLE inventory (
    id BIGSERIAL PRIMARY KEY,
    inventory_date DATE NOT NULL,
    medicine_id BIGINT NOT NULL REFERENCES medicines(id),
    theoretical_quantity NUMERIC(14,2) NOT NULL,
    counted_quantity NUMERIC(14,2) NOT NULL,
    difference NUMERIC(14,2) NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users(id)
);

CREATE TABLE invoices (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT REFERENCES patients(id),
    invoice_number VARCHAR(80) NOT NULL UNIQUE,
    reason TEXT NOT NULL,
    amount NUMERIC(14,2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'À payer',
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,
    invoice_id BIGINT REFERENCES invoices(id),
    patient_id BIGINT REFERENCES patients(id),
    amount NUMERIC(14,2) NOT NULL,
    payment_mode VARCHAR(80) NOT NULL,
    reason TEXT,
    user_id BIGINT NOT NULL REFERENCES users(id),
    payment_date TIMESTAMP NOT NULL
);

CREATE TABLE expenses (
    id BIGSERIAL PRIMARY KEY,
    reason TEXT NOT NULL,
    amount NUMERIC(14,2) NOT NULL,
    supplier VARCHAR(200),
    user_id BIGINT NOT NULL REFERENCES users(id),
    expense_date TIMESTAMP NOT NULL
);

CREATE TABLE cash_transactions (
    id BIGSERIAL PRIMARY KEY,
    transaction_type VARCHAR(50) NOT NULL,
    amount NUMERIC(14,2) NOT NULL,
    reason TEXT NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users(id),
    transaction_date TIMESTAMP NOT NULL
);

CREATE TABLE discharges (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES patients(id),
    hospitalization_id BIGINT REFERENCES hospitalizations(id),
    diagnosis TEXT,
    evolution TEXT,
    treatment TEXT,
    recommendations TEXT,
    discharge_date TIMESTAMP NOT NULL,
    user_id BIGINT REFERENCES users(id)
);

CREATE TABLE referrals (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES patients(id),
    destination TEXT NOT NULL,
    reason TEXT,
    clinical_summary TEXT,
    recommendations TEXT,
    referral_date TIMESTAMP NOT NULL,
    user_id BIGINT REFERENCES users(id)
);

CREATE TABLE follow_ups (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES patients(id),
    care_type VARCHAR(120),
    observation TEXT,
    evolution TEXT,
    follow_up_date TIMESTAMP NOT NULL,
    user_id BIGINT REFERENCES users(id)
);

CREATE INDEX idx_patients_number ON patients(patient_number);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_triage_patient ON triage_records(patient_id);
CREATE INDEX idx_consultations_patient ON consultations(patient_id);
CREATE INDEX idx_hospitalizations_patient ON hospitalizations(patient_id);
CREATE INDEX idx_stock_movement_medicine ON stock_movements(medicine_id);
CREATE INDEX idx_inventory_medicine ON inventory(medicine_id);
CREATE INDEX idx_payments_invoice ON payments(invoice_id);
CREATE INDEX idx_audit_logs_date ON audit_logs(date_time);

INSERT INTO roles(name) VALUES
('Administrateur'),('Réceptionniste'),('Médecin'),('Infirmier'),
('Pharmacien'),('Comptable'),('Direction')
ON CONFLICT (name) DO NOTHING;

INSERT INTO permissions(name,module) VALUES
('patients.view','Réception'),
('patients.manage','Réception'),
('appointments.manage','Réception'),
('triage.manage','Réception'),
('consultations.manage','Consultation'),
('hospitalizations.manage','Consultation'),
('laboratory.manage','Consultation'),
('pharmacy.manage','Pharmacie'),
('accounting.manage','Comptabilité'),
('reports.view','Administration'),
('users.manage','Administration'),
('audit.view','Administration')
ON CONFLICT (name) DO NOTHING;
