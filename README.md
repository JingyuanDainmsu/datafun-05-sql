# datafun-05-sql
This is Module 5 SQL practice. 

## Step 1 Environment Setup and Project Start
Create a GitHub project repository with a default README.md.
Open a terminal and clone the repo down to the local machine.
 ```python
 'git clone https://github.com/JingyuanDainmsu/datafun-05-sql'
 ```
Create and activate a virtual environment in the local machine.
'python -m venv .venv'
```python
'.venv\Scripts\activate'
```
Install the dependencies into the virtual environment .venv.
Freeze the requirements.txt
Git add and commit with a useful message (e.g. "initial commit") and push to GitHub.
```python
'git add .'
```
```python
'git commit -m "initial commit".'
```

## Step 2 Use SQL with Python 
Activate a local virtual environment in .venv.
```python
'.venv\Scripts\activate'
```
Install necesary dependencies in .venv
Freeze the requirements.txt
Check .gitignore.

## Step 3 Create the Data Files
Create new data folder in project repository folder.
Create csv files into the data folder.

## Step 4 Initialize the Database
Create new sql folder in project repository folder
Create a Python file 'book_manager.py'. in the root project repository folder with the following code:

```python
import sqlite3
import pandas as pd
import pathlib

# Define the database file in the current root project directory
db_file = pathlib.Path("project.db")

def create_database():
    """Function to create a database. Connecting for the first time
    will create a new database file if it doesn't exist yet.
    Close the connection after creating the database
    to avoid locking the file."""
    try:
        conn = sqlite3.connect(db_file)
        conn.close()
        print("Database created successfully.")
    except sqlite3.Error as e:
        print("Error creating the database:", e)

def create_tables():
    """Function to read and execute SQL statements to create tables"""
    try:
        with sqlite3.connect(db_file) as conn:
            sql_file = pathlib.Path("sql", "create_tables.sql")
            with open(sql_file, "r") as file:
                sql_script = file.read()
            conn.executescript(sql_script)
            print("Tables created successfully.")
    except sqlite3.Error as e:
        print("Error creating tables:", e)

def insert_data_from_csv():
    """Function to use pandas to read data from CSV files (in 'data' folder)
    and insert the records into their respective tables."""
    try:
        author_data_path = pathlib.Path("data", "authors.csv")
        book_data_path = pathlib.Path("data", "books.csv")
        authors_df = pd.read_csv(author_data_path)
        books_df = pd.read_csv(book_data_path)
        with sqlite3.connect(db_file) as conn:
            # use the pandas DataFrame to_sql() method to insert data
            # pass in the table name and the connection
            authors_df.to_sql("authors", conn, if_exists="replace", index=False)
            books_df.to_sql("books", conn, if_exists="replace", index=False)
            print("Data inserted successfully.")
    except (sqlite3.Error, pd.errors.EmptyDataError, FileNotFoundError) as e:
        print("Error inserting data:", e)

def main():
    create_database()
    create_tables()
    insert_data_from_csv()

if __name__ == "__main__":
    main()
```

Create a SQL file named 'create_tables.sql' in the sql folder with the following code:

```markdown
-- Start by deleting any tables if the exist already
-- We want to be able to re-run this script as needed.
-- DROP tables in reverse order of creation 
-- DROP dependent tables (with foreign keys) first

DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;

-- Create the books table
-- Note that the books table has a foreign key to the authors table
-- This means that the books table is dependent on the authors table
-- Be sure to create the standalone authors table BEFORE creating the books table.

CREATE TABLE books (
    book_id TEXT PRIMARY KEY,
    title TEXT,
    year_published INTEGER,
    author_id TEXT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- Create the authors table 
-- Note that the author table has no foreign keys, so it is a standalone table

CREATE TABLE authors (
    author_id TEXT PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    year_born INTEGER
);
```

