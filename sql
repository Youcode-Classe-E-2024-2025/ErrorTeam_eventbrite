
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


create table contributions (
    user_id uuid REFERENCES users(id),
    event_id uuid REFERENCES events(id)
);

CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_users_role ON users (role);


CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL UNIQUE
);


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
    reserved INT NOT NULL default 0,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    search_vector TSVECTOR GENERATED ALWAYS AS (
        to_tsvector('english', title || ' ' || description)
    ) STORED
);

CREATE TABLE event_tags (
    event_id UUID REFERENCES events(id),
    tag_id UUID REFERENCES tags(id), 
    PRIMARY KEY (event_id, tag_id)
);

CREATE TABLE organizer_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),  -- Référence à l'utilisateur qui fait la demande
    message TEXT NOT NULL,  -- Message ou raison de la demande
    status VARCHAR(50) DEFAULT 'pending',  -- Statut de la demande (pending, approved, rejected)
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP -- Date de création
);

-- Indexation pour améliorer les recherches par statut ou utilisateur
CREATE INDEX idx_organizer_requests_status ON organizer_requests (status);
CREATE INDEX idx_organizer_requests_user_id ON organizer_requests (user_id);




CREATE TABLE reservations (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),  -- Clé étrangère vers l'utilisateur qui a fait la réservation
    event_id UUID REFERENCES events(id), -- Clé étrangère vers l'événement réservé
    reservation_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Date et heure de la réservation
    number_of_tickets INT NOT NULL,      -- Nombre de billets réservés
    total_price DECIMAL(10, 2) NOT NULL,  -- Prix total de la réservation
    status VARCHAR(50) DEFAULT 'pending', -- Statut de la réservation (pending, confirmed, cancelled, etc.)
    qr_code VARCHAR(255),                -- Code QR pour le billet
    payment_id VARCHAR(255),               -- ID de la transaction de paiement (si applicable)
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


