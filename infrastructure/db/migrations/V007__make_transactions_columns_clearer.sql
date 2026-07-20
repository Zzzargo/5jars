ALTER TABLE transactions
    RENAME COLUMN user_id TO initiator_id;
ALTER TABLE transactions
    RENAME COLUMN jar_id TO affected_jar_id;