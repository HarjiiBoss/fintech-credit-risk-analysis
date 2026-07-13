# Security Notes

**Project:** Fintech Credit Risk Analysis (Project 08)

## Issue: DB credentials hardcoded in notebook

**Found:** Phase 0, during initial data load into MySQL
**Risk:** `notebooks/01_cleaning_eda.ipynb` initially contained the MySQL
root password in plaintext inside the SQLAlchemy connection string. Since
this repo is intended to go public on GitHub, committing the notebook
as-is would have exposed the credential.

**Fix applied (Phase 1):**
1. Installed `python-dotenv`
2. Created a `.env` file at the project root containing `DB_PASSWORD`
3. Added `.env` to `.gitignore` so it is never committed
4. Updated the notebook to load the password via `os.getenv('DB_PASSWORD')`
   instead of a hardcoded string

**Additional action taken:** MySQL root password rotated as a precaution,
since the original password had briefly existed in plaintext in an
editable file.

**Status:** Resolved — no credentials present in any file tracked by git.