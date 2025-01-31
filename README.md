# Bash Database Management System

This is a simple **Database Management System (DBMS)** implemented in Bash. It allows users to create, manage, and manipulate databases and tables using command-line interface.

## Features

- Create and delete databases.
- List available databases.
- Connect to a database.
- Create, list, and delete tables within a database.
- Insert, update, delete, and view table data.
- Supports primary key constraints and data type validation.

## Getting Started

### Prerequisites
- A **Unix-based system** (Linux or macOS).
- Bash shell installed (`bash --version` to check).

### Installation
1. Clone or download the script files:
   git clone https://github.com/jackiee211/DBMS-Bash
   
   cd DBMS-Bash
   
Ensure the scripts have execution permission:

chmod +x db.sh table.sh

Usage:

Running the Database Management System

Start the database system with:

./db.sh

Follow the on-screen menu to navigate database operations.

Database Operations

Create a Database – Enter a name, ensuring it contains only alphanumeric characters.

List Databases – Displays available databases.

Connect to a Database – Select a database to perform table operations.

Delete a Database – Removes a selected database and all its tables.

Table Operations

Once connected to a database, you can:

Create a Table – Define column names and types (String or Integer).

List Tables – Shows available tables.

Show Table Data – View all or specific columns/rows of a table.

Delete a Table – Removes a table and its metadata.

Insert Row – Add a new record, ensuring data types match.

Delete Row – Remove records by row number or value.

Update Cell – Modify existing cell data while maintaining integrity.

Exit – Return to the database selection menu.

Example Usage

$ ./db.sh

================================== DB Management System ========================================

1- Create Database

2- List Databases

3- Connect Database

4- Delete Database

5- Exit

Choose an option: 1

Please Enter The Name Of The Database You Want To Create: my_database

Database "my_database" created successfully!


Notes:

The system ensures Primary Key uniqueness and data type validation.


Databases are stored in the .db/ directory.


Metadata for tables is saved in .db/<database>/.<table>.meta.




Author

Developed by Abdelrahman Teleb, Mostafa Muhammed, Essam.
