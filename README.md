# Knight Online Database

This repository contains scripts to build the database from scratch and set all the configurations needed for you to be able running the game.

Brief explanation of the directory structure under `src`:
- data - Insert queries based on the current db state
- migration - [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) scripts to update the existing db state
- misc - Utility and useful scripts
- procedure - Stored procedures based on the current db state
- schema - Tables structure and constraints based on the current db state


### Prerequisite

- Being able to run powershell scripts. Note that if you're unable to run the scripts, it is because you need to allow powershell scripts to run on your system by setting the execution policy to bypass with the following powershell command: `Set-ExecutionPolicy Bypass -Scope CurrentUser`
- Microsoft SQL Server Express or Developer (confirmed to be working with versions 2022 and 2008)
  - [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
  - [SQL Management Studio](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
- [Git](https://git-scm.com/download/win) (version 2.45.1 at the time of writing)
- [Python](https://www.python.org/downloads/) (version 3.12.3 at the time of writing)
  - During installation in the `Advanced Options` make sure to tick `Add Python to environment variables`
  - Once finished, install the required packages with the following command: `pip install -r requirements.txt`


### Getting Started

Before running the `import.ps1` script, check that the `$server_name` variable matches with your current server name. If you installed SQL Server using the default instance, then the default arguments should be working fine, otherwise you can provide the script an argument with your custom server name. You can run the following command in powershell to know the names of your current SQL Servers:
```powershell
(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances
```

Assuming you set a custom name to your SQL Server instance, you may invoke the import command as follows:
```powershell
.\import.ps1 -server_name ".\MyCustomInstanceName"
```

Once the import script finished importing the db, it will also invoke the `odbcad.ps1` script automatically for you to set odbc configurations so that the server files can connect with your db.


### Development

Note that the development process is inspired from [different db development environments](https://docs.djangoproject.com/en/4.0/topics/migrations/), where a table is treated as a model.

During development we only create migration scripts to alter the current state of the base. The base here refers to the generated scripts in data, procedure and schema.

Every migration script will be prefixed with max 4 leading zeros. For example, `0001_insert_steve_user.sql` will contain an insert statement into `TB_USER` table.

Apart from the benifit of having the database under version control, this also makes it easy to use any SQL version you want. I use both 2008 and 2022 and it works perfectly fine with both.

Release process should follow for every release we create in the [main ko project](https://github.com/ko4life-net/ko). The steps should look like this:
- Main ko project needs a new release
  - Are there any pending migration scrips in the ko-db project?
    - If yes, create a new ko-db release, which the steps are documented in the [migration dir README.md](/src/migration/README.md)
    - If no, no need to update the ko-db project
- Main ko project sets the tag in the config script to the latest released ko-db version
- Main ko project creates a new release and after merging, changing the config script back to the ko-db master branch
  - This is because the migration scripts in the ko-db project has been archived at this point, meaning newly added migration scripts will automatically affect the main ko project

In other words, we use the `master` branch as the development and release branch, but when tagging, they are all fixed to a specific tag.
Maybe in the future this will change if it makes things difficult and we maintain a separate development branch.
