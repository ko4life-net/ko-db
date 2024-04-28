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

If you running for the first time the `import.ps1` script, open Powershell as admin and run this command: `Install-Module sqlserver`

Before running the `import.ps1` script, check that the `$server_name` variable matches your current server name. If you use the default instance, then defaults should work, otherwise you can provide the script an argument with your custom server name (`.\import.ps1 -server_name "MyServer`).

Once you run the script, the database is ready to be used by the server files.
