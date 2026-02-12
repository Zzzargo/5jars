CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuidv7(),

    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(60) NOT NULL,  -- Using Spring's default bcrypt hash length

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    last_access TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
