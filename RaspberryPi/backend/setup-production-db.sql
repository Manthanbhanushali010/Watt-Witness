-- WattWitness Production Database Setup
-- This script sets up the production database for WattWitness

-- Create database (if using PostgreSQL)
-- CREATE DATABASE wattwitness_production;

-- Connect to the database
-- \c wattwitness_production;

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create installations table
CREATE TABLE IF NOT EXISTS installations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    shelly_mac VARCHAR(17) UNIQUE NOT NULL,
    public_key TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    last_boot_timestamp BIGINT,
    location VARCHAR(255),
    description TEXT,
    
    -- Indexes
    INDEX idx_installations_shelly_mac (shelly_mac),
    INDEX idx_installations_is_active (is_active),
    INDEX idx_installations_created_at (created_at)
);

-- Create power_readings table
CREATE TABLE IF NOT EXISTS power_readings (
    id SERIAL PRIMARY KEY,
    installation_id INTEGER NOT NULL REFERENCES installations(id) ON DELETE CASCADE,
    power_w DECIMAL(10, 2) NOT NULL,
    total_wh DECIMAL(15, 2) NOT NULL,
    timestamp BIGINT NOT NULL,
    signature TEXT NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_timestamp TIMESTAMP,
    is_on_chain BOOLEAN DEFAULT FALSE,
    blockchain_tx_hash VARCHAR(66),
    blockchain_block_number BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Composite unique constraint
    UNIQUE(installation_id, timestamp),
    
    -- Indexes for performance
    INDEX idx_power_readings_installation_id (installation_id),
    INDEX idx_power_readings_timestamp (timestamp),
    INDEX idx_power_readings_is_verified (is_verified),
    INDEX idx_power_readings_is_on_chain (is_on_chain),
    INDEX idx_power_readings_created_at (created_at),
    INDEX idx_power_readings_composite (installation_id, timestamp, is_verified),
    INDEX idx_power_readings_blockchain (blockchain_tx_hash, blockchain_block_number)
);

-- Create aggregated_readings table for performance
CREATE TABLE IF NOT EXISTS aggregated_readings (
    id SERIAL PRIMARY KEY,
    installation_id INTEGER NOT NULL REFERENCES installations(id) ON DELETE CASCADE,
    time_bucket TIMESTAMP NOT NULL,
    bucket_type VARCHAR(20) NOT NULL, -- 'hour', 'day', 'week', 'month'
    avg_power_w DECIMAL(10, 2) NOT NULL,
    min_power_w DECIMAL(10, 2) NOT NULL,
    max_power_w DECIMAL(10, 2) NOT NULL,
    total_energy_wh DECIMAL(15, 2) NOT NULL,
    reading_count INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Composite unique constraint
    UNIQUE(installation_id, time_bucket, bucket_type),
    
    -- Indexes
    INDEX idx_aggregated_readings_installation_id (installation_id),
    INDEX idx_aggregated_readings_time_bucket (time_bucket),
    INDEX idx_aggregated_readings_bucket_type (bucket_type),
    INDEX idx_aggregated_readings_composite (installation_id, time_bucket, bucket_type)
);

-- Create system_logs table for monitoring
CREATE TABLE IF NOT EXISTS system_logs (
    id SERIAL PRIMARY KEY,
    installation_id INTEGER REFERENCES installations(id) ON DELETE CASCADE,
    log_level VARCHAR(10) NOT NULL, -- 'INFO', 'WARNING', 'ERROR', 'DEBUG'
    message TEXT NOT NULL,
    component VARCHAR(50) NOT NULL, -- 'ESP32', 'BACKEND', 'FRONTEND', 'BLOCKCHAIN'
    additional_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_system_logs_installation_id (installation_id),
    INDEX idx_system_logs_log_level (log_level),
    INDEX idx_system_logs_component (component),
    INDEX idx_system_logs_created_at (created_at)
);

-- Create blockchain_transactions table
CREATE TABLE IF NOT EXISTS blockchain_transactions (
    id SERIAL PRIMARY KEY,
    installation_id INTEGER NOT NULL REFERENCES installations(id) ON DELETE CASCADE,
    tx_hash VARCHAR(66) UNIQUE NOT NULL,
    block_number BIGINT NOT NULL,
    block_timestamp TIMESTAMP NOT NULL,
    gas_used BIGINT,
    gas_price DECIMAL(20, 0),
    transaction_type VARCHAR(50) NOT NULL, -- 'READING_BATCH', 'INSTALLATION_SETUP'
    reading_ids INTEGER[], -- Array of reading IDs included in this transaction
    status VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING', 'CONFIRMED', 'FAILED'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_blockchain_transactions_installation_id (installation_id),
    INDEX idx_blockchain_transactions_tx_hash (tx_hash),
    INDEX idx_blockchain_transactions_block_number (block_number),
    INDEX idx_blockchain_transactions_status (status),
    INDEX idx_blockchain_transactions_created_at (created_at)
);

-- Create triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers to tables
CREATE TRIGGER update_installations_updated_at BEFORE UPDATE ON installations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_power_readings_updated_at BEFORE UPDATE ON power_readings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_aggregated_readings_updated_at BEFORE UPDATE ON aggregated_readings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_blockchain_transactions_updated_at BEFORE UPDATE ON blockchain_transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create views for common queries
CREATE OR REPLACE VIEW latest_readings AS
SELECT DISTINCT ON (installation_id) 
    installation_id,
    power_w,
    total_wh,
    timestamp,
    is_verified,
    is_on_chain,
    created_at
FROM power_readings
WHERE is_verified = TRUE
ORDER BY installation_id, timestamp DESC;

CREATE OR REPLACE VIEW daily_energy_summary AS
SELECT 
    installation_id,
    DATE(to_timestamp(timestamp)) as date,
    COUNT(*) as reading_count,
    AVG(power_w) as avg_power_w,
    MIN(power_w) as min_power_w,
    MAX(power_w) as max_power_w,
    MAX(total_wh) - MIN(total_wh) as daily_energy_wh
FROM power_readings
WHERE is_verified = TRUE
GROUP BY installation_id, DATE(to_timestamp(timestamp))
ORDER BY installation_id, date DESC;

-- Insert default installation for demo purposes
INSERT INTO installations (name, shelly_mac, public_key, description, location) 
VALUES (
    'Demo Solar Installation',
    '00:00:00:00:00:00',
    'demo_public_key_for_testing_purposes_only',
    'Demo installation for public access and testing',
    'Demo Location'
) ON CONFLICT (shelly_mac) DO NOTHING;

-- Create database user for application (optional)
-- CREATE USER wattwitness_app WITH PASSWORD 'secure_password_here';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO wattwitness_app;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO wattwitness_app;

-- Performance optimizations
-- Enable query planner to use indexes more effectively
ANALYZE;

-- Create additional indexes for common query patterns
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_power_readings_time_range 
ON power_readings (installation_id, timestamp) 
WHERE is_verified = TRUE;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_power_readings_unprocessed 
ON power_readings (installation_id, timestamp) 
WHERE is_verified = TRUE AND is_on_chain = FALSE;

-- Performance monitoring queries (for reference)
/*
-- Check table sizes
SELECT 
    schemaname,
    tablename,
    attname,
    n_distinct,
    correlation
FROM pg_stats
WHERE tablename IN ('installations', 'power_readings', 'aggregated_readings');

-- Check index usage
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
WHERE tablename IN ('installations', 'power_readings', 'aggregated_readings');

-- Monitor query performance
SELECT 
    query,
    calls,
    total_time,
    mean_time,
    rows
FROM pg_stat_statements
WHERE query LIKE '%power_readings%'
ORDER BY mean_time DESC
LIMIT 10;
*/ 