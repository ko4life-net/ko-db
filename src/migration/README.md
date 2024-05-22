# Migration scripts

Add here scripts that alters the existing database's schema, procedures, data and misc changes.

Couple of rules and notes when writing migration scripts:
- Always assume the database containing data, even if you just modify an empty table
- When altering the schema, adding comments (`--` for tsql) are encouraged
- When submitting a PR, please generate a `*.diff` file and commit it (`.\import.ps1 -generate_diffs`)
- Every migration script should start with max 4 leading zeros (example `0001_insert_user.sql`)

## Creating a new release

Below are instructions for the release engineer in order to create a new db release:
- Create a new release branch following the db new release version according version semantics (`git checkout -b release/1.0.1`)
- Run the import script skipping the migration scripts (`.\import.ps1 -run_migration_scripts $false`)
- Run the export script, to be sure that no diff is produced (`.\export.ps1` and then `git status`)
  - If there are local changes, something is probably off. Repeat the steps above
  - If you're sure all in order, best is if you create a new separate PR with the changes, in case empty spaces and such were added
- Run the import script again with the migration scripts and produce diffs (`.\import.ps1 -generate_diffs`)
- Move all migration scripts and its `*.diff` files to the `archived` directory
- Lastly run the export script once more, but this time you'll have the actual changes from the migration scripts affecting the actual schema
- Git commit all the changes (`Bump version from 1.0.0 to 1.0.1.`)
  - Check the final diff that all looks in order
- Create a PR and merge after approval
- After merging, create a new release using GitHub web interface and add description to the release highlighting the important changes
  - Note that it will create a new tag automatically that we can reference later from other repositories
