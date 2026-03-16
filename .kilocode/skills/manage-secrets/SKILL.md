---
name: manage-secrets
description: Establish secrets management architecture and best practices
---

# SKILL: Manage Secrets

## Trigger
When asked to:
- Set up secrets management for a project
- Migrate from hardcoded secrets to secure storage
- Configure Varlock, HashiCorp Vault, or cloud secret managers
- Design secrets architecture for multi-cloud or CI/CD
- Audit secrets sprawl or establish rotation policies
- Prevent secrets from leaking to AI tools

## Related Skills
- **audit-security** — Detects secrets vulnerabilities (reactive scanning)
- **manage-secrets** — Establishes secrets infrastructure (proactive setup)

Use **manage-secrets** before **audit-security** in new projects.

## Process — follow in order

1. **Assess current state** (do NOT skip):
   - Scan for hardcoded secrets in codebase (`gitleaks detect --source .`)
   - Identify all secret types needed (DB creds, API keys, certificates, tokens, etc.)
   - Map environments (local dev, CI/CD, staging, production)
   - Determine deployment targets (AWS, Azure, GCP, on-prem, multi-cloud)
   - Assess AI tooling usage (Claude, Cursor, Windsurf, etc.)
2. **Design architecture** based on requirements:
   - Choose tools per layer (see Architecture Patterns below)
   - Document decision rationale
   - Identify integration points
3. **Propose implementation plan** with phases:
   - Phase 1: Development workflow (Varlock or equivalent)
   - Phase 2: Production secrets (cloud vaults)
   - Phase 3: CI/CD integration
   - Phase 4: Rotation and lifecycle
4. **WAIT for approval** before implementing
5. **Implement approved architecture**:
   - Configure chosen tools
   - Migrate existing secrets
   - Setup scanning and prevention
   - Document for team
6. **Verify security**:
   - Scan for remaining hardcoded secrets
   - Test secret rotation
   - Verify access controls
   - Confirm audit logging

---

## Architecture Patterns

### Pattern 1: Development-First (Small to Medium Teams)

**Use when:**
- Team size: 1-20 developers
- Primary concern: Developer experience + AI safety
- Heavy use of AI coding tools (Claude, Cursor, Windsurf, etc.)

**Stack:**
```
Development Layer:
  └─ Varlock (AI-safe .env management)
     └─ Loads from Production Layer via plugins

Production Layer:
  ├─ AWS Secrets Manager (AWS workloads)
  ├─ Azure Key Vault (Azure workloads)
  └─ GCP Secret Manager (GCP workloads)

Detection Layer:
  ├─ Varlock scan (pre-commit)
  └─ gitleaks or GitGuardian (repo scanning)
```

### Pattern 2: Enterprise Multi-Cloud

**Use when:**
- Team size: 20+ developers
- Compliance requirements (SOC2, HIPAA, PCI-DSS)
- Dynamic credentials needed
- Multi-cloud or hybrid infrastructure

**Stack:**
```
Development Layer:
  └─ Varlock or Doppler (unified interface)

Orchestration Layer:
  └─ HashiCorp Vault (cross-cloud, dynamic secrets)

Cloud Layer:
  ├─ AWS Secrets Manager (AWS-specific)
  ├─ Azure Key Vault (Azure-specific)
  └─ GCP Secret Manager (GCP-specific)

Detection Layer:
  ├─ Varlock scan (pre-commit)
  ├─ Cycode or Snyk (SDLC scanning)
  └─ Cloud-native audit logs
```

### Pattern 3: Single-Cloud Native

**Use when:**
- Committed to single cloud provider
- Simplest operational overhead desired
- No cross-cloud orchestration needed

**Stack (AWS example — replace with Azure/GCP as needed):**
```
Development Layer:
  └─ Varlock with cloud provider plugin

Production Layer:
  └─ AWS Secrets Manager
     ├─ Automatic rotation (RDS, Redshift)
     └─ IAM integration

CI/CD Layer:
  └─ GitHub Actions with OIDC
     └─ Fetches from Secrets Manager

Detection Layer:
  ├─ Varlock scan (pre-commit)
  └─ Cloud-native audit logs
```

---

## Tool Decision Matrix

| Requirement | Varlock | Doppler | HashiCorp Vault | Cloud Native |
|-------------|---------|---------|-----------------|--------------|
| AI safety | Best | Partial | No | No |
| Local dev DX | Best | Good | Complex | Complex |
| Production runtime | No | Limited | Best | Best |
| Dynamic secrets | No | No | Best | Limited |
| Multi-cloud | Via plugins | Good | Best | Lock-in |
| Compliance audit | Basic | Good | Best | Native |
| Cost (medium team) | Free | $$$ | $$$$ | $$ |
| Ops complexity | Low | Low | High | Low |

**Recommendation by scenario:**
- **AI-heavy dev team**: Varlock + Cloud Native (Pattern 1)
- **Enterprise multi-cloud**: Vault + Cloud Native (Pattern 2)
- **Single-cloud shop**: Cloud Native only (Pattern 3)
- **Startup/small team**: Varlock + single cloud vault

---

## Implementation Checklists

### Varlock Setup (Development Layer)

**Installation:**
```bash
npm install -D varlock
npx varlock init
```

**Configuration:**
- [ ] Create `.env.schema` with all variables documented
- [ ] Mark sensitive values with `@sensitive` decorator
- [ ] Configure cloud provider plugins (AWS/Azure/GCP)
- [ ] Setup pre-commit hooks: `npx varlock scan --setup`
- [ ] Test with `varlock run` for AI tools
- [ ] Document team onboarding process

**`.env.schema` example:**
```bash
# @defaultSensitive=true
# ---

# Database
# @type=string
# @description="PostgreSQL connection string"
DATABASE_URL=

# AWS credentials
# @type=string
AWS_ACCESS_KEY_ID=

# @type=string
AWS_SECRET_ACCESS_KEY=

# Public config (not sensitive)
# @sensitive=false
# @type=string
# @default="development"
NODE_ENV=
```

**Validation:**
- [ ] `varlock scan` passes on clean codebase
- [ ] AI tools (Claude, Cursor, Windsurf) don't see secret values
- [ ] Developers can load secrets from production vaults
- [ ] Pre-commit hooks block accidental commits

### Cloud Vault Setup (Production Layer)

**AWS Secrets Manager:**
- [ ] Create secrets in Secrets Manager
- [ ] Configure IAM policies (least privilege)
- [ ] Enable automatic rotation for RDS/databases
- [ ] Setup CloudTrail audit logging
- [ ] Configure cross-region replication (if needed)
- [ ] Test secret retrieval from application

**Azure Key Vault:**
- [ ] Create Key Vault with RBAC enabled
- [ ] Store secrets with versioning
- [ ] Configure managed identity access
- [ ] Enable diagnostic logging
- [ ] Setup certificate auto-renewal
- [ ] Test secret retrieval from application

**GCP Secret Manager:**
- [ ] Create secrets in Secret Manager
- [ ] Configure IAM bindings
- [ ] Enable automatic replication
- [ ] Setup audit logs
- [ ] Configure secret versions
- [ ] Test secret retrieval from application

### CI/CD Integration

**GitHub Actions:**
```yaml
- name: Load secrets with Varlock
  run: |
    npm install -D varlock
    npx varlock run -- npm run build

- name: Scan for leaked secrets
  run: npx varlock scan
```

**GitLab CI:**
```yaml
secrets_check:
  script:
    - npm install -D varlock
    - npx varlock scan
  only:
    - merge_requests
```

**Checklist:**
- [ ] CI can fetch secrets from production vault
- [ ] Secrets never appear in CI logs
- [ ] Builds fail if `varlock scan` detects leaks
- [ ] Rotation doesn't break CI pipelines

### Migration Checklist

**From hardcoded secrets to managed secrets:**

1. **Audit current state:**
   - [ ] Scan all repos: `gitleaks detect --source .`
   - [ ] List all `.env` files: `find . -name ".env*"`
   - [ ] Identify secret types and environments

2. **Prepare new system:**
   - [ ] Setup Varlock or chosen dev tool
   - [ ] Create secrets in production vault
   - [ ] Configure access policies

3. **Migrate secrets:**
   - [ ] Move secrets to vault (one environment at a time)
   - [ ] Update application to fetch from vault
   - [ ] Test each environment after migration
   - [ ] Update documentation

4. **Clean up:**
   - [ ] Remove hardcoded secrets from codebase
   - [ ] Rotate ALL exposed credentials
   - [ ] Scrub git history if needed:
     `git filter-repo --replace-text <(echo "OLD_SECRET==>REMOVED")`
   - [ ] Add `.env*` to `.gitignore` if not already present

5. **Verify:**
   - [ ] Run `varlock scan` or `gitleaks` — should find nothing
   - [ ] Application works in all environments
   - [ ] Team can access secrets they need

---

## Secret Scanning Tools

### Pre-commit Scanning (Prevent Leaks)

**Varlock:**
```bash
npx varlock scan --setup    # Install pre-commit hook
npx varlock scan            # Manual scan
```

**gitleaks:**
```bash
gitleaks detect --source . --verbose
gitleaks protect --staged   # Pre-commit mode
```

**TruffleHog:**
```bash
trufflehog git file://. --only-verified
```

**detect-secrets:**
```bash
detect-secrets scan --all-files
detect-secrets audit .secrets.baseline
```

### Repository Scanning (Detect Existing Leaks)

**GitGuardian:** GitHub app integration, monitors commits/PRs/issues

**Cycode:** Full SDLC scanning (Slack, Jira, Confluence), active credential validation

**Snyk:**
```bash
snyk code test --severity-threshold=high
```

### Git History Scanning

**TruffleHog:**
```bash
trufflehog git file://. --since-commit HEAD~100
```

**gitleaks:**
```bash
gitleaks detect --source . --log-opts="--all"
```

---

## Rotation Best Practices

### Automatic Rotation (Preferred)

**AWS Secrets Manager:**
- RDS, Redshift, DocumentDB: Built-in rotation (30-90 days)
- Custom: Lambda rotation functions

**Azure Key Vault:**
- Certificates: Auto-renewal with supported CAs
- Secrets: Azure Functions for custom rotation

**GCP Secret Manager:**
- Custom rotation via Cloud Functions
- Integrate with Cloud Scheduler

### Manual Rotation Workflow

**Rotation schedule by secret type:**
- API keys (external services): 90 days
- Database credentials: 30 days (or use dynamic secrets)
- Certificates: Before expiration (auto-renew 30 days prior)
- Service account keys: 90 days
- OAuth tokens: Refresh automatically

**Process:**
1. Generate new credential in service
2. Store new credential in vault (new version)
3. Test application with new credential (staging)
4. Deploy application to fetch new credential
5. Verify production using new credential
6. Deactivate old credential (after grace period)
7. Delete old credential from vault

**Emergency rotation (compromise):**
1. Immediately create new credential
2. Update vault
3. Force application restart to fetch new credential
4. Revoke old credential immediately
5. Audit access logs for abuse
6. Document incident

---

## Access Control Patterns

### Principle: Least Privilege

**Development:**
- Developers: Read access to dev/staging secrets only
- Developers: NO access to production secrets
- Use separate vaults or namespaces per environment

**Production:**
- Applications: Read-only via service identity (IAM roles, managed identities)
- Ops team: Emergency access only (break-glass)
- Admins: Write access with audit trail

**CI/CD:**
- Pipelines: Read access scoped to deployment environment
- Use OIDC/workload identity (no static credentials)

### Example IAM Policy (AWS)

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ],
    "Resource": "arn:aws:secretsmanager:region:account:secret:dev/*",
    "Condition": {
      "StringEquals": {
        "secretsmanager:VersionStage": "AWSCURRENT"
      }
    }
  }]
}
```

---

## Common Pitfalls & Solutions

### Pitfall 1: Secrets in Git History
**Detection:** `gitleaks detect --source . --log-opts="--all"`
**Solution:**
```bash
pip install git-filter-repo
git filter-repo --replace-text <(echo "SECRET_KEY==>REMOVED")
git push --force --all
```
Then rotate ALL exposed credentials.

### Pitfall 2: Developer Friction
**Symptom:** Developers bypass secrets management for "convenience"
**Solution:**
- Make onboarding 1-command: `./setup-dev.sh`
- Use Varlock for zero-friction local dev
- Document clearly in README
- Enforce via pre-commit hooks (can't bypass)

### Pitfall 3: Break-Glass Access
**Problem:** Production down, need secrets, person with access unavailable
**Solution:**
- Document emergency access procedures
- Use cloud vault emergency access (AWS resource policies, Azure access policies)
- Have 2-3 people with emergency access
- Log all emergency access for audit

### Pitfall 4: Secrets in Logs/Traces
**Problem:** Secrets appear in application logs, error traces, or monitoring
**Solution:**
- Varlock automatically redacts `@sensitive` values
- Use log redaction libraries
- Never log raw request/response bodies in production

### Pitfall 5: Over-permissive Access
**Problem:** Too many people/services can read production secrets
**Solution:**
- Audit access quarterly
- Use IAM Access Analyzer (AWS), Azure RBAC reports
- Principle of least privilege
- Service accounts, not user accounts for applications

---

## Audit & Compliance

### Required Audit Capabilities (SOC2/ISO27001/HIPAA)

- [ ] Who accessed which secret when (audit logs)
- [ ] All secret modifications logged
- [ ] Failed access attempts tracked
- [ ] Secrets rotated on schedule
- [ ] Access reviews performed quarterly
- [ ] Secrets encrypted at rest and in transit

**Cloud-Native Audit Solutions:**
- AWS: CloudTrail + CloudWatch Logs
- Azure: Diagnostic Logs + Azure Monitor
- GCP: Cloud Audit Logs
- HashiCorp Vault: Built-in audit devices

### Compliance Checklist

**Pre-Production:**
- [ ] Secrets never in source code
- [ ] `.env` files gitignored
- [ ] Pre-commit hooks prevent leaks
- [ ] Developers use Varlock or equivalent

**Production:**
- [ ] Secrets in encrypted vault
- [ ] Access via service identity (no hardcoded keys)
- [ ] Audit logging enabled
- [ ] Rotation schedule documented and followed

**CI/CD:**
- [ ] Secrets fetched at runtime (not stored in CI config)
- [ ] CI logs don't expose secrets
- [ ] Secrets scanning blocks merges

**Emergency:**
- [ ] Break-glass access documented
- [ ] Emergency access audited
- [ ] Rotation after emergency access

---

## Output Format

```markdown
## Secrets Management Implementation: [Project Name]

### Architecture
- **Development**: [Varlock | Doppler | Other]
- **Production**: [AWS SM | Azure KV | GCP SM | Vault]
- **Detection**: [Tools configured]

### Secrets Inventory
| Secret Type | Count | Storage Location | Rotation Schedule |
|-------------|-------|------------------|-------------------|
| Database credentials | N | [Location] | [Schedule] |
| API keys (external) | N | [Location] | [Schedule] |
| Certificates | N | [Location] | [Schedule] |

### Migration Status
- [x] Development workflow configured
- [x] Production secrets migrated
- [x] CI/CD integration
- [ ] Rotation automation

### Access Policies
- Developers: [Access level]
- Production apps: [Access method]
- Ops team: [Access level]

### Audit Trail
- Enabled: [Services]
- Retention: [Duration]
- Alerts: [Configuration]

### Team Documentation
- Onboarding guide: [Link]
- Emergency procedures: [Link]
- Rotation runbook: [Link]
```

---

## Hard Rules
- NEVER store secrets in source code, even in "private" repos
- NEVER commit `.env` files to version control
- NEVER bypass pre-commit secret scanning
- NEVER share production secrets via Slack, email, or unencrypted channels
- NEVER use the same secrets across dev/staging/production
- NEVER grant production secret access without explicit justification
- ALWAYS rotate credentials after employee offboarding, suspected
  compromise, public exposure, or emergency access usage
- ALWAYS use service identities (IAM roles, managed identities)
  over static credentials in production
- ALWAYS enable audit logging on production secret vaults
- ALWAYS test secret rotation in staging before production

## Pre-Submit Checklist

Before completing this skill:

**Assessment:**
- [ ] All secret types identified
- [ ] All environments mapped (dev/staging/prod)
- [ ] Current secret sprawl assessed (git history scanned)

**Architecture:**
- [ ] Architecture pattern chosen and justified
- [ ] Tools selected based on decision matrix
- [ ] Implementation plan created with phases

**Implementation:**
- [ ] Development workflow configured (Varlock or equivalent)
- [ ] Production vaults configured with proper access controls
- [ ] CI/CD integration tested
- [ ] Secret scanning enabled (pre-commit + repo)

**Verification:**
- [ ] No secrets in codebase (`varlock scan` or `gitleaks` passes)
- [ ] All exposed credentials rotated
- [ ] Applications work in all environments
- [ ] Audit logging enabled and tested

**Documentation:**
- [ ] Team onboarding guide written
- [ ] Emergency access procedures documented
- [ ] Rotation schedules documented
