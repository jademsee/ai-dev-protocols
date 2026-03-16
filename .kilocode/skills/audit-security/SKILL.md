---
name: audit-security
description: Security audit or hardening
---

# SKILL: Security Audit

## Trigger
When asked to audit, check, or harden code for security issues,
vulnerabilities, or attack surface reduction.

## Related Skills
- **manage-secrets** — For proactive secrets infrastructure setup (architecture, tooling, migration)
- **audit-security** — For reactive secrets vulnerability detection (scanning, reporting)

Use **manage-secrets** to establish secrets infrastructure, then **audit-security** to verify.

## Process — follow in order
1. Read the entire target scope — do not sample
2. **Run automated security tools** first (see tools below)
3. Map the attack surface: all entry points, all trust boundaries
4. Audit in priority order (P0 first)
5. Report ALL findings — do not self-censor "minor" issues
6. Propose fixes for each finding
7. WAIT for approval before implementing fixes
8. Implement fixes and write tests that would catch regressions

## Automated Security Analysis Tools

### Multi-Language Tools
**Static Analysis:**
- **Semgrep** — pattern-based static analysis, supports 30+ languages
  - `semgrep --config=auto` — auto-detect security issues
  - Community rules: `semgrep --config=p/security-audit`
- **CodeQL** — semantic code analysis by GitHub
  - Supports: C/C++, C#, Go, Java, JavaScript/TypeScript, Python, Ruby
  - `codeql database analyze --format=sarif-latest`
- **Trivy** — comprehensive security scanner
  - Scans: code, containers, IaC, dependencies
  - `trivy fs --security-checks vuln,config,secret .`
- **Snyk** — developer-first security platform
  - `snyk test` — dependency vulnerabilities
  - `snyk code test` — static application security testing

**Secret Detection:**
- **gitleaks** — detect hardcoded secrets
  - `gitleaks detect --source .`
- **TruffleHog** — find secrets in git history
  - `trufflehog git file://.`
- **detect-secrets** — enterprise secret scanner
  - `detect-secrets scan`

### JavaScript/TypeScript
**Static Analysis:**
- **npm audit** / **yarn audit** / **pnpm audit** — dependency vulnerabilities
- **eslint-plugin-security** — security-focused ESLint rules
- **eslint-plugin-no-unsanitized** — XSS prevention
- **@microsoft/eslint-plugin-sdl** — Microsoft Security Development Lifecycle

**Dependency Scanning:**
- **Snyk** — `snyk test`
- **OWASP Dependency-Check** — `dependency-check --scan .`
- **npm-audit-resolver** — interactive audit resolution

**Runtime Security:**
- **helmet** — secure HTTP headers for Express
- **express-rate-limit** — rate limiting middleware

### Python
**Static Analysis:**
- **bandit** — security linter for Python
  - `bandit -r . -f json -o bandit-report.json`
- **safety** — dependency vulnerability scanner
  - `safety check --json`
- **Semgrep** with Python rules
  - `semgrep --config=p/python`

**Dependency Scanning:**
- **pip-audit** — official PyPA tool
  - `pip-audit`
- **safety** — checks against vulnerability database

**Type Safety:**
- **mypy** — static type checker (prevents type confusion bugs)
- **pyre-check** — Facebook's type checker with security taint analysis

### Go
**Static Analysis:**
- **gosec** — Go security checker
  - `gosec ./...`
- **govulncheck** — official Go vulnerability scanner
  - `govulncheck ./...`
- **staticcheck** — advanced Go linter with security checks

**Dependency Scanning:**
- **govulncheck** — checks dependencies against Go vulnerability database
- **nancy** — Sonatype dependency scanner for Go

### Rust
**Dependency Scanning:**
- **cargo-audit** — audit Cargo.lock for vulnerabilities
  - `cargo audit`
- **cargo-deny** — lint dependencies for security/licensing
  - `cargo deny check`

**Static Analysis:**
- **cargo-geiger** — detect unsafe code usage
  - `cargo geiger`
- **Clippy** with security lints
  - `cargo clippy -- -W clippy::all`

### Java
**Static Analysis:**
- **SpotBugs** with **Find Security Bugs** plugin
  - Detects: SQL injection, XSS, XXE, crypto issues
- **SonarQube** — comprehensive code quality and security
- **Checkmarx** — commercial SAST tool

**Dependency Scanning:**
- **OWASP Dependency-Check**
  - `dependency-check --project myapp --scan .`
- **Snyk** — `snyk test`
- **JFrog Xray** — artifact analysis

**Runtime:**
- **Java Security Manager** — runtime security policies
- **OWASP Java Encoder** — output encoding library

### C#/.NET
**Static Analysis:**
- **Security Code Scan** — .NET security analyzer
  - Roslyn-based, integrates with Visual Studio
- **Puma Scan** — .NET security analyzer
- **SonarQube for .NET**

**Dependency Scanning:**
- **dotnet list package --vulnerable**
  - Built-in vulnerability check
- **OWASP Dependency-Check**
- **Snyk**

### C/C++
**Static Analysis:**
- **Clang Static Analyzer** — `scan-build make`
- **Cppcheck** — `cppcheck --enable=all .`
- **Flawfinder** — scans for common security flaws
  - `flawfinder .`
- **Coverity** — commercial static analyzer

**Runtime:**
- **AddressSanitizer (ASan)** — memory safety
- **UndefinedBehaviorSanitizer (UBSan)** — undefined behavior
- **MemorySanitizer (MSan)** — uninitialized memory

### Swift
**Static Analysis:**
- **SwiftLint** with security rules
- **Xcode Static Analyzer**

**Dependency Scanning:**
- **OWASP Dependency-Check** for CocoaPods/Carthage

### Kotlin
**Static Analysis:**
- **detekt** with security rules
  - `detekt --config detekt.yml`
- Same Java tools (SpotBugs, SonarQube)

**Dependency Scanning:**
- Same as Java (OWASP Dependency-Check, Snyk)

### Dart/Flutter
**Static Analysis:**
- **dart analyze** — built-in static analyzer with security lints
  - `dart analyze`
- **flutter analyze** — Flutter-specific analysis
  - `flutter analyze`
- **Semgrep** with Dart rules
  - `semgrep --config=auto`

**Dependency Scanning:**
- **osv-scanner** — Open Source Vulnerabilities scanner
  - `osv-scanner --lockfile=pubspec.lock`
- **Snyk** — supports Flutter/Dart
  - `snyk test`
- Manual review of pub.dev package scores (security, maintenance)

**Flutter-Specific:**
- Review platform-specific code (Android/iOS) with respective tools
- Check for insecure deep link handling
- Validate WebView configurations if used
- Review permissions in AndroidManifest.xml and Info.plist

### Infrastructure as Code (IaC)
**Terraform/CloudFormation/Kubernetes:**
- **Checkov** — policy-as-code scanner
  - `checkov -d .`
- **tfsec** — Terraform security scanner
  - `tfsec .`
- **Terrascan** — multi-IaC scanner
- **kube-score** — Kubernetes manifest analysis

### Container Security
- **Trivy** — container image scanner
  - `trivy image myimage:tag`
- **Grype** — vulnerability scanner for containers
  - `grype myimage:tag`
- **Clair** — static analysis for container vulnerabilities
- **Docker Bench Security** — Docker host configuration

### CI/CD Integration
Most tools support CI/CD integration:
- **GitHub Actions**: CodeQL, Semgrep, Snyk, Trivy
- **GitLab CI**: SAST, dependency scanning, container scanning
- **Jenkins**: OWASP Dependency-Check, SonarQube plugins
- **CircleCI**: Snyk, Semgrep orbs

## Vulnerability Categories — check all that apply

### P0 — Critical (immediate action required)
- **Injection** — SQL, command, LDAP, XPath, template injection
- **Authentication bypass** — missing auth checks, broken session
  management, insecure token validation
- **Authorization bypass** — missing ownership checks, IDOR,
  privilege escalation, missing role checks
- **Sensitive data exposure** — secrets in code/logs/responses,
  unencrypted PII, over-fetching in API responses
- **Remote code execution** — deserializing untrusted data,
  unsafe eval, dynamic code execution
- **Cryptographic failure** — broken algorithms (MD5, SHA1 for
  secrets), hardcoded keys, weak randomness

### P1 — High
- **CSRF** — missing tokens on state-changing requests
- **SSRF** — unvalidated URLs fetched server-side
- **Path traversal** — user input in file paths
- **XXE** — XML parsing with external entities enabled
- **Race conditions** — TOCTOU on security-critical operations
- **Mass assignment** — binding untrusted input to model fields

### P2 — Medium
- **Missing rate limiting** on auth, API, or sensitive endpoints
- **Information disclosure** — stack traces, internal paths,
  version numbers in error responses
- **Insecure defaults** — debug mode, verbose errors in production
- **Insecure direct object references** without ownership check
- **Missing security headers** — CSP, HSTS, X-Frame-Options

### P3 — Low / Hardening
- **Dependency vulnerabilities** — known CVEs in dependencies
- **Overly permissive CORS**
- **Cookies missing Secure/HttpOnly/SameSite flags**
- **Logging gaps** — missing audit trail for sensitive operations

## Audit Checklist

### Input Handling
- [ ] All user inputs validated (type, length, format, range)
- [ ] All inputs sanitized before use in queries/commands/templates
- [ ] File uploads validated (type, size, content)
- [ ] No user input used in file paths without sanitization

### Authentication & Sessions
- [ ] All sensitive endpoints require authentication
- [ ] Tokens validated on every request (not just login)
- [ ] Sessions invalidated on logout
- [ ] Passwords hashed with bcrypt/argon2/scrypt (not MD5/SHA1)
- [ ] MFA available for sensitive operations

### Authorization
- [ ] Every data access checks ownership, not just authentication
- [ ] Role checks present and not bypassable
- [ ] Horizontal privilege escalation not possible

### Data
- [ ] No secrets in source code, logs, or API responses
- [ ] PII encrypted at rest
- [ ] Sensitive data not logged
- [ ] API responses return only what is needed (no over-fetching)

### Dependencies
- [ ] No known vulnerable dependencies
- [ ] Dependencies are pinned to exact versions
- [ ] No abandoned/unmaintained packages in security-critical paths

## Output Format
```
## Security Audit: [scope]

### Attack Surface
[Entry points and trust boundaries identified]

### Findings

#### [FINDING-001] [P0] [Category]: [Title]
Location: [file:line]
Description: [what the vulnerability is]
Impact: [what an attacker could do]
Reproduction: [how to trigger it]
Fix: [specific remediation]

...

### Summary
P0: [count] | P1: [count] | P2: [count] | P3: [count]
```

## Hard Rules
- NEVER suppress or downgrade a finding to avoid discomfort
- NEVER propose "security through obscurity" as a fix
- NEVER approve P0 findings as "acceptable risk" without
  explicit written sign-off from the user
- NEVER implement a security fix that breaks authentication
  or authorization — test thoroughly
