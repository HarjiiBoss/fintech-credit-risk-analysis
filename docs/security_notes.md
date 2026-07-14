# Security Notes

**Project:** Fintech Credit Risk Analysis (Project 08)

---

## Issue: Database Credentials Hardcoded in Notebook

**Identified:** Phase 0 — Initial data ingestion

### Description

During the initial MySQL data-loading process, the SQLAlchemy connection string in `notebooks/01_cleaning_eda.ipynb` contained the MySQL root password in plaintext.

Because this repository is intended for public release on GitHub, committing the notebook in its original state would have exposed database credentials.

### Risk Assessment

- Plaintext database credentials stored in source code
- Potential credential exposure through Git version history
- Violation of secure credential management best practices

### Remediation

The issue was resolved during Phase 1 by implementing environment-based configuration.

1. Installed `python-dotenv`
2. Created a project-level `.env` file containing the database password
3. Added `.env` to `.gitignore` to prevent accidental commits
4. Replaced the hardcoded SQLAlchemy connection string with environment variables loaded via `os.getenv()`

### Additional Security Action

As a precaution, the MySQL root password was rotated after the credential was removed to eliminate any potential exposure risk.

### Current Status

✅ No database credentials are stored in any tracked project files.

✅ Database credentials are loaded securely through environment variables.

✅ The repository is safe for public publication on GitHub.

---

## Security Best Practices Implemented

- Environment variables used for sensitive configuration
- `.env` excluded from version control via `.gitignore`
- No secrets committed to Git history
- Credentials separated from application code
- Password rotated after remediation as a defense-in-depth measure
