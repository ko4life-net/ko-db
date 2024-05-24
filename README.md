# Knight Online Database

This repository contains scripts to build the database from scratch.

Brief explanation of the directory structure under `src`:
- data - Insert queries based on the current db state
- migration - [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) scripts to update the existing db state
- misc - Utility and useful scripts
- procedure - Stored procedures based on the current db state
- schema - Tables structure and constraints based on the current db state

### Prerequisite

- Any MSSQL Express Server (confirmed to be working with 2008 and 2022)
  - Download the Express version from here: https://www.microsoft.com/en-us/sql-server/sql-server-downloads
  - Download the latest MSSQL Management Studio: https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms
    - Note that it can connect to any version of SQL Server, so even if you use 2008, just get the latest Management Studio for better development experience
- Powershell `sqlserver` module
  - Open Powershell as Admin and run the following command: `Install-Module sqlserver -AllowClobber -Force`
    - Note that if you're getting errors during the installation, it is likely because because your SQL installation installed its own powershell module which conflicts with the one we intend to use. They're incompatible and behave differently when creating db exports, hence you may want to delete it from your System Environment Variable `PSModulePath` and restart powershell to reload without these modules. Basically if you see in your `PSModulePath` environment variable something with `Microsoft SQL Server`, just remove it, since we want to use the module that we intend to use.
- Python and installing via pip the following packages (if you get errors, run powershell as admin):
  - T-SQL code formatter: `pip install sqlfluff`
  - MSSQL scripter: `pip install mssql-scripter`
  - Note that if you're using [virtualenv](https://docs.python.org/3/library/venv.html) (recommended), you can simply install the requirements.txt.


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

### How to use

Before running the `import.ps1` script, check that the `$server_name` variable matches with your current server name. If you installed SQL Server using the default instance, then the defaults arguments should work, otherwise you can provide to the script an argument with your custom server name. You can run the following command in powershell to know the names of your current SQL Servers:
```powershell
(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances
```

Assuming you set a custom name to your SQL Server instance, you may invoke the import command as follows:
```powershell
.\import.ps1 -server_name ".\MyCustomInstanceName"
```

If you encounter the error `script cannot be loaded because running scripts is disabled on this system` follow these steps:
	- Open PowerShell as Administrator and type: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
	- Run the `Import.ps1` script again.
	- After the import script completes, you can restrict script execution again by typing: `Set-ExecutionPolicy Restricted -Scope CurrentUser`

Once the import script finished importing the db, it will also invoke the `odbcad.ps1` script for you to automatically set odbc configurations so that the server files can connect with your db.
