CREATE DATABASE eventbrite;
\c eventbrite;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE users (
    id UUID PRIMARY KEY,
    role VARCHAR(20) DEFAULT 'participant',
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    username  VARCHAR(255) NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    avatar VARCHAR(255),
    bio TEXT,
    phone_number VARCHAR(20),
    email_verified_at TIMESTAMP WITHOUT TIME ZONE,
    verification_token VARCHAR(255),
    password_reset_token VARCHAR(255),
    password_reset_sent_at TIMESTAMP WITHOUT TIME ZONE,
    last_login_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN DEFAULT TRUE,
    failed_login_attempts INTEGER DEFAULT 0,
    lockout_until TIMESTAMP WITHOUT TIME ZONE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP

);

CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_users_role ON users (role);


CREATE TABLE categories (
    id UUID PRIMARY KEY,  
    name VARCHAR(255) NOT NULL UNIQUE
);
CREATE TABLE tags (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organizer_id UUID NOT NULL REFERENCES users(id),
    category_id UUID REFERENCES categories(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    location VARCHAR(255),
    price DECIMAL(10, 2) NOT NULL,
    capacity INT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    search_vector TSVECTOR GENERATED ALWAYS AS (to_tsvector('english', title || ' ' || description)) STORED
);
CREATE TABLE event_tags (
    event_id UUID REFERENCES events(id),
    tag_id UUID REFERENCES tags(id), -- Changer le type en UUID
    PRIMARY KEY (event_id, tag_id)
);


