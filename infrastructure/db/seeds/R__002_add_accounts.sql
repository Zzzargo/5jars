-- 2 accounts for the test user
INSERT INTO jars (owner_id, name, coefficient, balance)
VALUES (
        '67b6a5b7-a527-479d-81fd-8e5c11b025d8',
        'Savings',
        50.00,
        1500.00
    ),
    (
        '67b6a5b7-a527-479d-81fd-8e5c11b025d8',
        'Food',
        50.00,
        300.00
    ) on conflict do nothing;