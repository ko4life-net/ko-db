# Knight Online Database

This repository contains scripts to build the database from scratch.

Brief explanation of the directory structure under `src`:
- data - Insert queries based on the current db state
- migration - [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) scripts to update the existing db state
- misc - Utility and useful scripts
- procedure - Stored procedures based on the current db state
- schema - Tables structure and constraints based on the current db state

### Development

Note that the development process is inspired from [different db development environments](https://docs.djangoproject.com/en/4.0/topics/migrations/), where a table is treated as a model.

During development we only create migration scripts to alter the current state of the base. The base here refers to the generated scripts in data, procedure and schema.

Every migration script will be prefixed by index. For example, `1_insert_steve_user.sql` will contain an insert statement to `TB_USER` table.

Release process should follow every 30-50 migration scripts or major changes that will be archived. Part of the release process will require running the `export.ps1` script that will update the existing base in this repository.

The steps for the release process are:
1. Run the `import.ps1` script to create the db from scratch following all the migration scripts
2. Run the `export.ps1` script that will update the existing base scripts in data, procedure and schema
3. Move all migration scripts under `src/archive/[1,2,3,4...]` to start fresh
4. Create a pull request with the changes
5. Once merged, update version based on version semantics and draft a new release


### How to use

If you running for the first time the `import.ps1` script, open Powershell as admin and run this command: `Install-Module sqlserver`

Before running the `import.ps1` script, check that the `$server_name` variable matches your current server name. If you use the default instance, then `(localhost)` should work.

Once you run the script, the database is ready to be used by the server files.
