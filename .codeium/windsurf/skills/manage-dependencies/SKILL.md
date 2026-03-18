---
name: manage-dependencies
description: Manage project dependencies across their full lifecycle
---

# SKILL: Manage Dependencies

## Trigger
When asked to:
- Audit, add, update, or remove project dependencies
- Set up dependency management for a new project
- Migrate package managers or upgrade major dependency versions
- Fix dependency conflicts, version resolution failures, or lock file issues
- Establish dependency update policies (Renovate, Dependabot)
- Evaluate whether a new dependency should be adopted
- Scan for vulnerable, deprecated, or unmaintained dependencies
- Optimize dependency tree size or build performance

## Related Skills
- **audit-security** — Scans for known CVEs in dependencies (reactive)
- **manage-dependencies** — Manages the full dependency lifecycle (proactive)
- **design-architecture** — Coherence audit checks dependency health and module boundaries

Use **manage-dependencies** for lifecycle management, **audit-security** for vulnerability-focused scanning.

## Process — follow in order

1. **Assess current state** (do NOT skip):
   - Identify the project's language(s) and package manager(s)
   - Read the manifest file(s) and lock file(s)
   - Run the dependency tree command (see Language-Specific Tools below)
   - Check for existing automation (Renovate, Dependabot configs)
   - Identify pinning strategy in use (exact, semver range, floating)
2. **Analyze dependency health**:
   - Run vulnerability scan (see Language-Specific Tools)
   - Run license compliance check
   - Identify deprecated or unmaintained packages
   - Identify unused dependencies
   - Check transitive dependency depth and bloat
3. **Propose changes** with rationale:
   - Categorize by priority: security fixes > deprecated replacements > updates > optimizations
   - Present 2-3 options for any non-trivial change
   - Note breaking changes and migration effort
4. **WAIT for approval** before implementing
5. **Implement approved changes**:
   - Update manifest file(s)
   - Regenerate lock file(s) using the correct command
   - Run full test suite to verify no regressions
   - Update documentation if public API changed
6. **Verify**:
   - Lock file committed and consistent
   - Vulnerability scan passes
   - License compliance passes
   - Build succeeds in CI-equivalent conditions
   - Tests pass

---

## Dependency Adoption Decision Framework

Before adding ANY new dependency, evaluate against these criteria.
This extends the global rules threshold (≥500 LOC systems / ≥200 LOC dynamic).

### Mandatory Checks

| Criterion | Accept | Reject |
|-----------|--------|--------|
| **Maintenance** | Active maintainer(s), releases within 6 months | Last commit >1 year, unresolved critical issues |
| **Size** | Focused, minimal transitive tree | Pulls >20 transitive deps for a simple task |
| **Security** | No known CVEs, has security policy | Unpatched CVEs, no disclosure process |
| **License** | MIT, Apache-2.0, BSD, ISC | GPL (in proprietary), SSPL, unlicensed |
| **Alternatives** | Best-in-class for its niche | Equivalent exists in stdlib or internal code |
| **Bus factor** | ≥2 active maintainers or corporate backing | Single-maintainer hobby project in critical path |
| **LOC threshold** | Replaces ≥500 LOC (systems) or ≥200 LOC (dynamic) | Saves <50 LOC |

### Priority Order (from rules.md)
```
Standard library > existing internal code > new dependency
```

---

## Lock File Strategy

### Always Commit Lock Files

| Ecosystem | Lock File | Commit? | CI Install Command |
|-----------|-----------|---------|-------------------|
| **npm** | `package-lock.json` | Yes | `npm ci` |
| **pnpm** | `pnpm-lock.yaml` | Yes | `pnpm install --frozen-lockfile` |
| **yarn** | `yarn.lock` | Yes | `yarn install --frozen-lockfile` |
| **Python (poetry)** | `poetry.lock` | Yes | `poetry install --no-root` |
| **Python (pip)** | pinned `requirements.txt` | Yes | `pip install -r requirements.txt` |
| **Python (uv)** | `uv.lock` | Yes | `uv sync --frozen` |
| **Rust** | `Cargo.lock` | Yes (binaries), No (libraries) | `cargo build --locked` |
| **Go** | `go.sum` | Yes | `go build ./...` (always respects go.sum) |
| **Java (Gradle)** | `gradle.lockfile` | Yes (if locking enabled) | `./gradlew build --dependency-verification strict` |
| **C#/.NET** | `packages.lock.json` | Yes (if enabled) | `dotnet restore --locked-mode` |
| **Swift (SPM)** | `Package.resolved` | Yes | `swift build` (respects resolved) |
| **Swift (CocoaPods)** | `Podfile.lock` | Yes | `pod install` (not `pod update`) |
| **Kotlin (Gradle)** | `gradle.lockfile` | Yes (if locking enabled) | `./gradlew build --dependency-verification strict` |
| **Dart/Flutter** | `pubspec.lock` | Yes (apps), No (libraries) | `dart pub get` / `flutter pub get` |
| **C/C++ (Conan)** | `conan.lock` | Yes | `conan install --lockfile=conan.lock` |
| **C/C++ (vcpkg)** | `vcpkg-configuration.json` | Yes | Manifest mode with `builtin-baseline` |

### Lock File Conflict Resolution
- NEVER manually merge lock file diffs
- Merge the manifest file(s), then regenerate the lock file using the package manager's install/resolve command
- Verify the regenerated lock file produces a passing build and test suite

---

## Version Pinning Strategy

| Approach | When to Use | Tradeoff |
|----------|-------------|----------|
| **Exact (`1.2.3`)** | Production apps, security-critical deps | Maximum reproducibility, manual update burden |
| **Semver range (`^1.2.3`)** | Libraries, dev tools | Automatic patch/minor updates, potential breakage |
| **Tilde (`~1.2.3`)** | Patch-only updates desired | Middle ground, only patches |
| **Floating (`*`, `latest`)** | Never | Unreproducible builds, random breakage |

**Recommendation:** Semver ranges in manifest + committed lock file. Lock file pins exact versions for reproducibility; manifest allows controlled updates via update commands.

---

## Automated Update Strategies

### Renovate (Recommended)
- Groups related updates (e.g., all `@types/*` together)
- Supports automerge for patch updates with passing CI
- Dashboard issue for visibility
- Configurable schedules and grouping

### Dependabot
- Simpler setup (GitHub-native)
- One PR per dependency (noisier)
- Limited grouping support

### Recommended Cadence

| Update Type | Action | Frequency |
|-------------|--------|-----------|
| **Security patches** | Immediate, interrupt current work | As detected |
| **Patch updates** | Automerge if CI passes | Weekly scan |
| **Minor updates** | Review PR, merge if CI passes | Weekly |
| **Major updates** | Manual review, changelog audit, test thoroughly | Monthly review |

---

## License Compliance

### Tooling by Ecosystem

| Ecosystem | Tool | Command |
|-----------|------|---------|
| **npm** | license-checker | `npx license-checker --failOn 'GPL;AGPL'` |
| **Python** | pip-licenses | `pip-licenses --fail-on 'GPL'` |
| **Rust** | cargo-deny | `cargo deny check licenses` |
| **Go** | go-licenses | `go-licenses check ./...` |
| **Java/Kotlin** | OWASP Dependency-Check | Gradle/Maven plugin |
| **C#/.NET** | Snyk, FOSSA | `snyk test` |
| **Swift** | FOSSA, manual | Manual review or FOSSA |
| **C/C++** | Snyk, manual | Manual review or Snyk |
| **Dart/Flutter** | manual | Review pub.dev licenses |

### Policy
- Define an allowlist of acceptable licenses in CI config
- Block PRs introducing non-compliant licenses
- Review quarterly for new transitive dependencies

---

## Language-Specific Tools

### JavaScript/TypeScript

**Package Managers:** npm, pnpm, yarn

**Dependency Tree:**
- `npm ls --all`
- `pnpm ls --depth Infinity`

**Vulnerability Scanning:**
- `npm audit --audit-level=high`
- `pnpm audit --audit-level=high`
- `yarn audit`

**Unused Dependencies:**
- **depcheck** — `npx depcheck`

**Bundle Analysis:**
- **bundlephobia.com** — check size before adding
- **webpack-bundle-analyzer** — `npx webpack-bundle-analyzer stats.json`
- **source-map-explorer** — `npx source-map-explorer build/**/*.js`

**Tree-Shaking:**
- Use ESM (`import/export`) over CJS (`require`)
- Import specific paths: `import debounce from 'lodash/debounce'`
- Prefer packages that ship ESM builds

### Python

**Package Managers:** pip, poetry, uv, conda

**Dependency Tree:**
- `pipdeptree`
- `poetry show --tree`
- `uv tree`

**Vulnerability Scanning:**
- **pip-audit** — `pip-audit`
- **safety** — `safety check --json`

**Unused Dependencies:**
- Manual review or `deptry`

### Go

**Package Manager:** Go modules

**Dependency Tree:**
- `go mod graph`
- `go mod why <package>`

**Vulnerability Scanning:**
- **govulncheck** — `govulncheck ./...`

**Unused Dependencies:**
- `go mod tidy` (removes unused)

### Rust

**Package Manager:** Cargo

**Dependency Tree:**
- `cargo tree`

**Vulnerability Scanning:**
- **cargo-audit** — `cargo audit`
- **cargo-deny** — `cargo deny check`

**Unused Dependencies:**
- **cargo-udeps** — `cargo +nightly udeps`

**Feature Flags:**
- Review enabled features: `cargo tree -e features`
- Disable unnecessary default features: `default-features = false`

### Java

**Package Managers:** Maven, Gradle

**Dependency Tree:**
- Maven: `mvn dependency:tree`
- Gradle: `./gradlew dependencies`

**Vulnerability Scanning:**
- **OWASP Dependency-Check** — `./gradlew dependencyCheckAnalyze`
- **Snyk** — `snyk test --all-sub-projects`

**Version Management:**
- **Gradle Version Catalogs** — `gradle/libs.versions.toml`
- **Maven BOM** — `<dependencyManagement>` with BOM imports
- **Maven Enforcer Plugin** — `mvn enforcer:enforce`

**Dependency Verification:**
- Gradle: `gradle/verification-metadata.xml` for checksum verification
- Use `failOnVersionConflict()` to detect silent upgrades

### C#/.NET

**Package Manager:** NuGet

**Dependency Tree:**
- `dotnet list package --include-transitive`

**Vulnerability Scanning:**
- `dotnet list package --vulnerable --include-transitive`

**Central Package Management:**
- `Directory.Packages.props` at solution root
- Single place to control all package versions across projects

**Lock File:**
- Enable: `<RestorePackagesWithLockFile>true</RestorePackagesWithLockFile>` in `.csproj`
- CI: `dotnet restore --locked-mode`

### C/C++

**Package Managers:** Conan, vcpkg, CMake FetchContent, git submodules

**Dependency Tree:**
- Conan: `conan info .`
- vcpkg: `vcpkg list`
- CMake: review `CMakeLists.txt` FetchContent declarations

**Vulnerability Scanning:**
- **Snyk** — `snyk test`
- **Trivy** — `trivy fs .`
- No built-in audit; scan source directly with Cppcheck, Flawfinder

**Specific Concerns:**
- Pin FetchContent to exact git commit SHA, not tags (tags can be moved)
- ABI compatibility matters — pin compiler version alongside dependency version
- Transitive deps often invisible (header-only libs pulling in other headers)

### Swift

**Package Managers:** Swift Package Manager (SPM), CocoaPods, Carthage

**Dependency Tree:**
- SPM: `swift package show-dependencies`
- CocoaPods: `pod outdated`

**Vulnerability Scanning:**
- **OWASP Dependency-Check** — supports CocoaPods/Carthage
- **Snyk** — `snyk test`
- No built-in `swift package audit`

**Version Pinning (SPM):**
```swift
.package(url: "...", exact: "5.8.1")       // exact pin
.package(url: "...", from: "5.8.0")        // semver range
.package(url: "...", .revision("abc123"))   // commit pin
```

**Specific Concerns:**
- SPM is the future direction; migrate from CocoaPods when feasible
- CocoaPods modifies Xcode project file — causes merge conflicts in teams

### Kotlin

**Package Managers:** Gradle (Kotlin DSL), Maven

**Dependency Tree:**
- `./gradlew dependencies`

**Vulnerability Scanning:**
- Same as Java: OWASP Dependency-Check, Snyk
- **detekt** — static analysis with security ruleset

**Version Management:**
- **Gradle Version Catalogs** — `gradle/libs.versions.toml`
- **BOM imports** for aligned versions (e.g., Ktor BOM, Compose BOM)

**Specific Concerns:**
- Kotlin Multiplatform (KMP): manage platform-specific deps via source sets
- Use `dependencyResolutionManagement` in `settings.gradle.kts` to centralize repositories
- Use `failOnVersionConflict()` to detect silent transitive upgrades

### Dart/Flutter

**Package Manager:** pub

**Dependency Tree:**
- `dart pub deps`
- `dart pub outdated`

**Vulnerability Scanning:**
- **osv-scanner** — `osv-scanner --lockfile=pubspec.lock`
- Check pub.dev scores (maintenance, popularity, pub points) before adopting

**Specific Concerns:**
- `dependency_overrides` is a code smell; track removal with a TODO and deadline
- Flutter plugin deps can conflict across platforms (Android Gradle + iOS CocoaPods)
- Use **melos** for Dart/Flutter monorepo management

---

## Performance & Build Optimization

### Minimizing Dependency Bloat
- Audit tree depth and transitive count before adding
- Prefer packages with zero transitive deps when alternatives exist
- Remove unused deps regularly (see language-specific tools above)

### CI Caching

| CI Provider | Strategy |
|-------------|----------|
| **GitHub Actions** | `actions/cache` with hash of lock file as key |
| **GitLab CI** | `cache:` with `key: files: [lockfile]` |
| **Any CI** | Cache the package manager's global cache dir, not `node_modules` |

**Cache paths by ecosystem:**
- npm: `~/.npm`
- pnpm: `~/.local/share/pnpm/store`
- pip: `~/.cache/pip`
- Go: `~/go/pkg/mod`
- Cargo: `~/.cargo/registry` + `~/.cargo/git` + `target/`
- Gradle: `~/.gradle/caches`
- NuGet: `~/.nuget/packages`

### Monorepo Patterns

| Tool | Ecosystem | Key Feature |
|------|-----------|-------------|
| **pnpm workspaces** | JS/TS | Content-addressable store, strict isolation |
| **npm workspaces** | JS/TS | Built-in, simple |
| **Cargo workspaces** | Rust | Single `Cargo.lock` at root, shared deps |
| **Go workspaces** | Go | `go.work` file, multi-module development |
| **uv workspaces** | Python | Centralized dependency management |
| **Gradle multi-project** | Java/Kotlin | Shared version catalogs, BOM |
| **melos** | Dart/Flutter | Monorepo tooling, shared deps |

**Rule:** Centralize shared dependency versions in monorepos. Use workspace-level constraints to prevent version drift between packages.

---

## Operational Concerns

### Reproducible Builds
1. Commit lock files (see Lock File Strategy)
2. Use frozen/locked install commands in CI (see table above)
3. Pin tool versions: `.nvmrc`, `.python-version`, `rust-toolchain.toml`
4. Container builds: copy lock file first for layer caching

### Handling Breaking Changes
1. Read the changelog — no exceptions
2. Create a branch for the upgrade
3. Run the full test suite before and after
4. Use codemods when available (e.g., `next-codemod`, `jscodeshift`, `2to3`)
5. Upgrade one major dep at a time — never batch unrelated majors
6. For framework upgrades: follow the official migration guide step by step

### Registry Outage Fallbacks
- **npm:** Verdaccio or Artifactory as caching proxy
- **pip:** devpi mirror; `--find-links` for local fallback
- **Go:** `GOPROXY=https://proxy.golang.org,direct` (default, already resilient)
- **Cargo:** `cargo vendor` to vendor deps for critical builds
- **General:** Vendor critical deps in CI if registry downtime is unacceptable

---

## Anti-Patterns

| Anti-Pattern | Why It's Dangerous |
|--------------|-------------------|
| Not committing lock files | Non-reproducible builds |
| `npm install` in CI (instead of `npm ci`) | Mutates lock file, non-deterministic |
| Ignoring audit output | Known vulns accumulate silently |
| Pinning to `*` or `latest` | Builds break without code changes |
| Vendoring everything | Huge repo, hidden CVEs, update burden |
| Forking instead of contributing upstream | Maintenance burden, drift from fixes |
| One giant `requirements.txt` with no groups | Can't distinguish dev/test/prod deps |
| Suppressing all CVE warnings | Real vulnerabilities missed |
| Running `--force` / `--legacy-peer-deps` habitually | Masks real incompatibilities |
| Copying dep code without attribution | License violation, no update path |
| `dependency_overrides` without expiration | Technical debt accumulates |
| Batch upgrading unrelated majors | Impossible to isolate which broke what |

---

## Output Format

```markdown
## Dependency Management Report: [Project Name]

### Current State
- **Language(s):** [Languages]
- **Package Manager(s):** [Managers]
- **Lock File:** [Present/Missing] — [Committed/Not committed]
- **Pinning Strategy:** [Exact/Semver/Mixed]
- **Automation:** [Renovate/Dependabot/None]

### Dependency Health
| Category | Count | Details |
|----------|-------|---------|
| Total dependencies | N | Direct: N, Transitive: N |
| Vulnerable | N | Critical: N, High: N, Medium: N |
| Deprecated | N | [List] |
| Unmaintained (>1yr) | N | [List] |
| Unused | N | [List] |
| License non-compliant | N | [List] |

### Recommended Actions (Priority Order)
1. [P0] [Action] — [Rationale]
2. [P1] [Action] — [Rationale]
3. ...

### Proposed Changes
| Package | Current | Proposed | Type | Risk |
|---------|---------|----------|------|------|
| [name] | [ver] | [ver] | [patch/minor/major/remove] | [low/med/high] |

### Automation Recommendations
- [Update policy recommendations]
- [CI integration recommendations]
```

---

## Hard Rules
- NEVER add a dependency without evaluating it against the Adoption Decision Framework
- NEVER use floating versions (`*`, `latest`) in any manifest file
- NEVER manually merge lock file diffs — regenerate from the merged manifest
- NEVER suppress vulnerability warnings without documented justification and expiration date
- NEVER batch unrelated major version upgrades — one at a time
- NEVER skip the test suite after updating dependencies
- NEVER run `--force` or `--legacy-peer-deps` without investigating the root conflict
- ALWAYS commit lock files for applications (see Lock File Strategy for library exceptions)
- ALWAYS use frozen/locked install commands in CI
- ALWAYS check license compliance before adopting a new dependency
- ALWAYS read the changelog before upgrading a major version

## Related Skills
- **audit-security** — Scan dependencies for vulnerabilities
- **manage-secrets** — Handle secrets in dependency config
- **maintain-consistency** — Ensure lock files synchronized

## Pre-Submit Checklist

Before completing this skill:

**Assessment:**
- [ ] All manifest and lock files identified
- [ ] Dependency tree analyzed
- [ ] Vulnerability scan run
- [ ] License compliance checked
- [ ] Deprecated/unmaintained deps identified

**Changes:**
- [ ] Each change justified against Adoption Decision Framework
- [ ] Lock file regenerated (not manually edited)
- [ ] No floating versions introduced
- [ ] No suppressed warnings without documented justification

**Verification:**
- [ ] Build succeeds
- [ ] Full test suite passes
- [ ] Lock file committed
- [ ] Vulnerability scan passes
- [ ] License compliance passes
- [ ] CI uses frozen/locked install command

**Documentation:**
- [ ] Breaking changes documented
- [ ] Update policy established or confirmed
- [ ] Migration steps documented (if major upgrade)
