# datafun-05-sql
This is Module 5 SQL practice. 

## Step 1 Environment Setup and Project Start
1. Create a GitHub project repository with a default README.md.
 - [Quickstart for Repositories - GitHub Docs](https://docs.github.com/en/repositories/creating-and-managing-repositories/quickstart-for-repositories)

2. Clone your repo down to your machine.
 -  Open a terminal in your Documents folder and clone the repo to your machine: 
 ```python
 'git clone https://github.com/tfmontague/datafun-05-sql'
 ```

3. Open your project folder in VS Code (if you haven't already): 
```python
'code .'
```

4. Add a .gitignore with .vsode/ and .venv/ and whatever else doesn't need to go in the repo:
 - Create a new file in the root folder of your project named .gitignore (using touch, ni, or your editor). Open .gitignore and add the following to ignore the .venv/ folder and .vscode (your editor settings).
```python
'.venv/
.vscode/'
```

5. Create and activate a local virtual environment in .venv.
'python -m venv .venv'
```python
'.venv\Scripts\activate'
```

6. Install your dependencies into your .venv and freeze your requirements.txt.
```python
'python -m pip install logging'
```
 - verify if sqlite3 is installed in your Python in terminal using: 'python -c "import sqlite3"; print(sqlite3.sqlite_version)'
 - if not, use  'pip install sqlite3' or 'pip install pysqlite3' to install

7. Record the commands used in your README.md.
 - [How to Write a Good README File for Your GitHub Project](https://www.freecodecamp.org/news/how-to-write-a-good-readme-file)

8. Git add and commit with a useful message (e.g. "initial commit") and push to GitHub.
```python
'git add .'
```
```python
'git commit -m "initial commit".'
```

9. Create your first project files (usually in VS Code).
- tmontague_sql.py

## CC5.2 Use SQL with Python Assignment
1. Ensure CC5.1 steps are complete

2. Activate a local virtual environment in .venv.
```python
'.venv\Scripts\activate'
```

3. Install pandas in .venv
```python
'pip install pandas'
```

4. Run pip freeze and redirect the results (>) into requirements.txt
```python
'pip freeze > requirements.txt'
```

5. Checked .gitignore to ensure that .venv will not be pushed to GitHub


## CC5.3 Plan the Project / Make Data Files
1. Create new data folder in project repository folder

2. Create 2 data csv files with provided data


## CC5.4 Initialize the Database
1. Create new sql folder in project repository folder

2. Create a Python file (module and script) named 'book_manager.py'. in VS code in the root project repository folder with the following code:

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

3. Create a SQL file named 'create_tables.sql' in the sql folder created in step 1 with the following code:

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

