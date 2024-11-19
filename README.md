# Knight Online Database

This repository contains scripts to build the database from scratch and configure everything needed to run the game.

### Directory Structure under `src`:

- **data**: Insert queries based on the current database state.
- **migration**: [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) scripts to update the existing database state.
  - **archive**: [ko-db-archive](https://github.com/ko4life-net/ko-db-archive) archived migration scripts that has been released.
- **misc**: Utility and helper scripts.
- **procedure**: Stored procedures based on the current database state.
- **schema**: Table structures and constraints based on the current database state.


### Prerequisites

- **PowerShell**: Enable script execution by running: `Set-ExecutionPolicy Bypass -Scope CurrentUser`
- **Git**: Install [Git](https://git-scm.com/download/win) (e.g., version 2.45.1).
- **Microsoft SQL Server**:
  - Install SQL Server Express/Developer Edition (minimum: MSSQL 2019 for UTF-8 collation).
    - [Download SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
  - Install [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms).
- **Python**:
  - Install [Python](https://www.python.org/downloads/) (e.g., version 3.12.3).
    - During setup, check **"Add Python to environment variables"** in `Advanced Options`.
  - Install required packages: `pip install -r requirements.txt`


### Getting Started

After completing the prerequisites, you can import the database into your SQL Server by running the import script: `.\import.ps1`

The script will automatically execute `odbcad.ps1` to configure ODBC settings, ensuring the server files can connect to your database. Once done, your database will be ready for use, and no additional configuration is needed.

Note: The main KO project clones this repository as a shallow submodule (without history). To browse the full history or inspect the migration scripts (a submodule of this project), unshallow the repository by running the following command in the root directory: `git fetch --unshallow`

### Development

The development process is inspired by [various database development environments](https://docs.djangoproject.com/en/4.0/topics/migrations/), where tables are treated as models.

During development, create migration scripts to alter the current state of the database. The "base" refers to the generated scripts in the `data`, `procedure`, and `schema` directories.

Migration scripts should be prefixed with a maximum of four leading zeros. For example:
- `0001_insert_steve_user.sql`: Contains an `INSERT` statement for the `TB_USER` table.

Benefits of this approach:
- The database is version-controlled.
- You can easily use almost any SQL version you prefer.


### Release Process

The release process for the [main KO project](https://github.com/ko4life-net/ko) should align with changes in the KO-DB project. Follow these steps:

1. **Identify the Need for a KO-DB Release**:
   - If the main KO project introduces changes that depend on KO-DB updates, ensure those updates are implemented in KO-DB first.
   - Follow the steps in the [migration directory README.md](/src/migration/README.md) to prepare the changes.

2. **Create a KO-DB Release**:
   - Once the database changes are ready, create a new KO-DB release with a version tag.

3. **Update the Submodule**:
   - In the main KO project, update the KO-DB submodule to reference the new release tag.

**Best Practice**:
- If the KO-DB project has changes (e.g., cleaning inconsistencies or extending tables) that do not immediately impact the main KO project, you don’t need to draft a KO-DB release right away.
- However, if the main KO project is preparing a release and KO-DB has untagged updates, draft a new KO-DB release first. This ensures the main KO project can reference the latest KO-DB release tag.
