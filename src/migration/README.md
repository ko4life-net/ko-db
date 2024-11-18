# Migration Scripts

This directory contains sql scripts for updating the database schema, procedures, data, and other changes.

## Guidelines for Writing Migration Scripts

- Add comments (`--` for T-SQL) to explain schema changes.
- When submitting a PR, generate and commit a `*.diff` file using `.\import.ps1 -generate_diffs`.
- Name migration scripts with up to four leading zeros (e.g., `0001_insert_user.sql`).

## Creating a New Release

- **Create a release branch**
  - Use semantic versioning for the branch name (e.g., `release/1.0.1`).

- **Run the import script (skip migration scripts)**
  - Execute: `.\import.ps1 -skip_migration_scripts`.

- **Run the export script to validate**
  - Execute: `.\export.ps1`.
  - Use `git status` to check for changes.
    - If changes exist, investigate or address them in a separate PR if valid (e.g., whitespace).

- **Run the import script with migration scripts**
  - Execute: `.\import.ps1 -generate_diffs`.

- **Archive processed migration scripts**
  - Move processed migration scripts and their `*.diff` files to the `archive` submodule.
  - Commit and push changes. Update `ko-db` to reference the new commit.

- **Final export and validation**
  - Execute the export script again to capture changes from migration scripts.

- **Commit changes**
  - Use a descriptive message (e.g., `Bump version from 1.0.0 to 1.0.1`).
  - Review the final diff for correctness.

- **Create and merge a pull request**
  - Open a PR, get approval, and merge it into the main branch.

- **Create a release on GitHub**
  - Use the GitHub interface to create a release, describing key changes.
  - A new tag will be generated automatically.
