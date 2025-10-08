USE fivejars;

-- Test users
INSERT INTO users (username, nickname, password_hash)
VALUES
('test', 'Test User', 'pass'),
('maria_dev', 'Maria', 'hashed_pw_2'),
('john_doe', 'Johnny', 'hashed_pw_3'),
('luna99', 'Luna', 'hashed_pw_4'),
('chris_p', 'Chris', 'hashed_pw_5');

-- Test accounts
INSERT INTO accounts (user_id, name, balance, coefficient)
VALUES
-- Test user's accounts
(1, 'Necessities Account', 1250.55, 0.550),
(1, 'Long-Term Account', 730.52, 0.200),
(1, 'Play Account', 230.09, 0.100),
(1, 'Financial Freedom Account', 530.99, 0.100),
(1, 'Charity Account', 50.01, 0.050),

-- Maria's accounts
(2, 'Emergency Jar', 820.10, 0.020),
(2, 'Investments', 3000.00, 0.150),

-- Johnny's accounts
(3, 'Daily Expenses', 95.20, 0.005),
(3, 'Gaming Budget', 270.00, 0.020),

-- Luna's accounts
(4, 'Wellness', 510.50, 0.060),
(4, 'Education', 950.00, 0.100),

-- Chris's accounts
(5, 'Bills', 1220.00, 0.030),
(5, 'Savings', 150.00, 0.010);
