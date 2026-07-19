INSERT INTO users (id, username, password_hash, email)
VALUES (
        '67b6a5b7-a527-479d-81fd-8e5c11b025d8',
        'test1',
        '$2a$10$2hNCGQXx3fCKzh4uSoIGkewQxhFNuhTjNZU0dKn7tYr/KgnEW2dy.',
        'test@example.com'
    ) ON CONFLICT (username) DO NOTHING;