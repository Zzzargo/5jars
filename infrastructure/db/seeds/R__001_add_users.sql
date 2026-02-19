INSERT INTO users (id, username, password_hash)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'alice', 'dev_hash_alice'),
    ('22222222-2222-2222-2222-222222222222', 'bob', 'dev_hash_bob')
ON CONFLICT (username) DO NOTHING;