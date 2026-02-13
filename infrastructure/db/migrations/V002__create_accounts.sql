CREATE TABLE accounts (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    name VARCHAR(100) NOT NULL,
    description TEXT,
    coefficient NUMERIC(5, 2) NOT NULL CHECK (coefficient >= 0.00 AND coefficient <= 100.00),
    balance NUMERIC(15, 4) NOT NULL DEFAULT 0.0000,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
