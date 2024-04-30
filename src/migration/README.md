# Migration scripts

Add here scripts that alters the existing database's schema, procedures, data and misc changes.

Couple of rules and notes when writing migration scripts:
- Try to avoid any unnecessary formatting (eventually we'll add a formatter and automation), as it bloats the final diff when exporting the db
- Always assume the database containing data, even if you just modify an empty table
- When altering Stored Procedures, always create a separate script for it
- When altering the schema, adding comments (`--` for tsql) are encouraged
- When merging Pull Requests, if the server or client also needs changes, first merge the db PRs before the client / server
- When submitting a PR, providing a `*.diff` file is encouraged (`.\import.ps1 -generate_diffs $true`)

## Creating a new release

Below are instructions for the release engineer in order to create a new db release:
- Create a new release branch following the db new release version according version semantics (`git checkout -b release/1.0.1`)
- Run the import script skipping the migration scripts (`.\import.ps1 -run_migration_scripts $false`)
- Run the export script, to be sure that no diff is produced (`.\export.ps1` and then `git status`)
  - If there are local changes, something is probably off. Repeat the steps above
  - If you're sure all in order, best is if you create a new separate PR with the changes, in case empty spaces and such were added
- Run the import script again with the migration scripts and produce diffs (`.\import.ps1 -generate_diffs $true`)
- Move all migration scripts and its `*.diff` files to the `archived` directory
- Lastly run the export script once more, but this time you'll have the actual changes from the migration scripts affecting the actual schema
- Git commit all the changes (`Bump version from 1.0.0 to 1.0.1`)
  - Check the final diff that all looks in order
- Create a PR and merge after approval
- After merging, create a new release using GitHub web interface and add description to the release highlighting the important changes
  - Note that it will create a new tag automatically that we can reference later from other repositories
