-- Insert a single book
INSERT INTO books (title) VALUES ('Robinson Crusoe');

-- Insert multiple books in a single statement
INSERT INTO books (title) VALUES ('Adventures of Huckleberry Finn'), ('The Art of War'), ('Alice''s'' Adventures in Wonderland');

-- Insert an book and retrieve the auto-generated ID (SQLite specific)
INSERT INTO books (title) VALUES ('Moby-Dick');
SELECT last_insert_rowid();