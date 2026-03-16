# Secrets Management Rules

When working with any project that handles secrets, credentials, or sensitive configuration:

---

## Core Rules

1. **Never store secrets in source code** — no hardcoded API keys, passwords, tokens, or connection strings
2. **Use `.env.schema` or equivalent** — give AI agents config context without exposing secret values
3. **Separate secrets per environment** — dev, staging, and production must use different credentials
4. **Use service identities in production** — IAM roles, managed identities, or workload identity over static credentials
5. **Enable audit logging** — all production secret vaults must have access logging enabled
6. **Rotate after exposure** — rotate credentials immediately after offboarding, suspected compromise, public exposure, or emergency access
7. **Enforce pre-commit scanning** — block commits containing secrets (`varlock scan`, `gitleaks protect`)
8. **Never log secrets** — redact sensitive values from application logs, error traces, and monitoring

---

## Hard Stops

- NEVER commit `.env` files to version control
- NEVER share production secrets via Slack, email, or unencrypted channels
- NEVER grant production secret access without explicit justification

---

## Recommended Tools

- **Secret Scanning:** gitleaks, trufflehog, varlock
- **Secrets Management:** HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, GCP Secret Manager
- **Environment Files:** dotenv (.env.schema for documentation), direnv
