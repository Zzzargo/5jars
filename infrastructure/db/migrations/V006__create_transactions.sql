ALTER TABLE jars
ALTER COLUMN balance TYPE NUMERIC(19, 4);
CREATE TYPE transaction_type AS ENUM (
    'INCOME_DISTRIBUTION',
    'DEPOSIT',
    'WITHDRAWAL',
    'TRANSFER'
);
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    user_id UUID NOT NULL,
    jar_id UUID NOT NULL,
    amount NUMERIC(19, 4) NOT NULL,
    type transaction_type NOT NULL,
    description TEXT,
    -- For distribution transactions
    correlation_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transaction_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_transaction_jar FOREIGN KEY(jar_id) REFERENCES jars(id) ON DELETE CASCADE
);
CREATE INDEX idx_tx_user_history ON transactions(user_id, created_at DESC);
CREATE INDEX idx_tx_jar_history ON transactions(jar_id, created_at DESC);
CREATE INDEX idx_tx_correlation ON transactions(correlation_id);