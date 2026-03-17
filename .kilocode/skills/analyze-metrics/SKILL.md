---
name: analyze-metrics
description: Design and implement visualizations for performance, CI/CD health, dev velocity, and user analytics
---

# SKILL: Metrics Analysis & Visualization

## Trigger
When asked to:
- Design performance monitoring dashboards
- Analyze CI/CD pipeline health
- Track development velocity metrics
- Create user behavior visualizations
- Plan observability instrumentation
- Set up DORA metrics tracking

## Purpose
This skill helps design visualizations for **runtime behavior and process metrics** — performance, CI/CD health, development velocity, and user analytics. For codebase structure visualizations, use the `visualize-project` skill.

---

## Metric Categories

### Category 1: Performance & Runtime Characteristics

#### Graph 1.1: Response Time Percentiles Over Time
**Visualizes**: X-axis: Time | Y-axis: p50, p90, p99 latency (multiple lines)
**Data Sources**: APM, access logs, custom instrumentation
**Questions Answered**:
- Is latency degrading over time?
- Are tail latencies (p99) within acceptable bounds?
- When did performance regressions occur?
**Most Valuable**: Production systems with latency SLAs
**Tools**: Datadog, New Relic, Prometheus + Grafana, Jaeger

#### Graph 1.2: Throughput vs Latency Correlation
**Visualizes**: Scatter plot: X-axis = requests/second, Y-axis = latency
**Data Sources**: APM, load balancer metrics
**Questions Answered**:
- At what load does latency degrade?
- What is the sustainable throughput ceiling?
**Most Valuable**: Systems approaching capacity limits
**Tools**: Grafana, Datadog, custom load test analysis

#### Graph 1.3: Memory Allocation Rate Over Time
**Visualizes**: X-axis: Time | Y-axis: Allocations per second (by type/region)
**Data Sources**: Profiler, APM memory tracking
**Questions Answered**:
- Is allocation rate increasing (potential leak)?
- Which code paths allocate most?
**Most Valuable**: Long-running processes, memory-constrained environments
**Tools**: pprof (Go), Valgrind massif (C/C++), Chrome DevTools (JS), memray (Python)

#### Graph 1.4: GC Pause Time Distribution
**Visualizes**: Histogram of GC pause durations, or time series of GC frequency/duration
**Data Sources**: Runtime metrics (Go, JVM, .NET)
**Questions Answered**:
- Are GC pauses impacting latency SLAs?
- Is GC pressure increasing?
**Most Valuable**: High-throughput services, latency-sensitive systems
**Tools**: Go runtime metrics, JMX/GC logs, .NET CLR metrics

#### Graph 1.5: Error Rate by Endpoint/Operation
**Visualizes**: X-axis: Time | Y-axis: Error rate per endpoint (stacked or multi-line)
**Data Sources**: Error tracking, logs, APM
**Questions Answered**:
- Which endpoints are most error-prone?
- Are error rates correlated with deployments?
**Most Valuable**: All production systems
**Tools**: Sentry, Rollbar, Datadog error tracking, Prometheus

---

### Category 2: CI/CD Pipeline Health

#### Graph 2.1: Pipeline Success Rate Over Time
**Visualizes**: X-axis: Time | Y-axis: Success rate percentage (main branch)
**Data Sources**: CI/CD logs
**Questions Answered**:
- Is main branch stability improving?
- When did instability start?
**Most Valuable**: All projects with CI/CD
**Tools**: Jenkins, GitHub Actions, GitLab CI dashboards

#### Graph 2.2: Build Time Trend
**Visualizes**: X-axis: Time | Y-axis: Build duration (p50, p90)
**Data Sources**: CI/CD logs
**Questions Answered**:
- Are builds getting slower?
- When should build optimization be prioritized?
**Most Valuable**: Projects with growing codebases
**Tools**: CI/CD dashboards, Buildkite analytics

#### Graph 2.3: Flaky Test Detection
**Visualizes**: Matrix: tests × runs, color = pass/fail, highlighting inconsistent tests
**Data Sources**: Test runner output history
**Questions Answered**:
- Which tests are flaky?
- What is the flakiness rate?
**Most Valuable**: Projects with test suites >100 tests
**Tools**: Flaky test trackers, CI/CD analytics, custom scripts

#### Graph 2.4: Queue Time vs Build Time
**Visualizes**: Stacked area: queue wait time + actual build time
**Data Sources**: CI/CD logs
**Questions Answered**:
- Is CI capacity adequate?
- How much time is wasted waiting?
**Most Valuable**: Teams experiencing CI delays
**Tools**: CI/CD dashboards

#### Graph 2.5: Deployment Rollback Rate
**Visualizes**: X-axis: Time | Y-axis: Rollback rate percentage
**Data Sources**: Deployment records, incident logs
**Questions Answered**:
- How often do deployments fail in production?
- Is deployment confidence improving?
**Most Valuable**: All production systems
**Tools**: Deployment tools, incident trackers

---

### Category 3: Development Velocity & Team Productivity

#### Graph 3.1: Lead Time Distribution
**Visualizes**: Histogram or box plot: time from first commit to deployment
**Data Sources**: Git history, CI/CD logs, issue tracker
**Questions Answered**:
- What is the typical lead time?
- Are there outliers taking too long?
- Is lead time improving?
**Most Valuable**: Teams optimizing flow, DORA metrics programs
**Tools**: DORA metrics tools, LinearB, custom analysis

#### Graph 3.2: Deployment Frequency Over Time
**Visualizes**: X-axis: Time | Y-axis: Deployments per week (or day)
**Data Sources**: CI/CD logs, deployment records
**Questions Answered**:
- How frequently are we deploying?
- Is frequency increasing (maturity indicator)?
**Most Valuable**: All teams, DORA metrics
**Tools**: CI/CD dashboards, DORA tools

#### Graph 3.3: Cycle Time by Work Type
**Visualizes**: Box plots: cycle time distribution per work type (feature, bug, refactor)
**Data Sources**: Issue tracker with timestamps
**Questions Answered**:
- Which work types take longest?
- Is there high variance in cycle times?
**Most Valuable**: Teams optimizing estimation, planning
**Tools**: Jira, Linear, GitHub Issues + custom analysis

#### Graph 3.4: PR Size Distribution
**Visualizes**: Histogram: lines changed per PR
**Data Sources**: Git history, PR data
**Questions Answered**:
- Are PRs appropriately sized for review?
- What is the typical review burden?
**Most Valuable**: Teams optimizing code review process
**Tools**: GitHub PR stats, git-quick-stats

#### Graph 3.5: Code Review Turnaround Time
**Visualizes**: X-axis: Time | Y-axis: Average time to first review, time to merge
**Data Sources**: PR/merge request data
**Questions Answered**:
- How long do authors wait for review?
- Is review process a bottleneck?
**Most Valuable**: Teams 3+, optimizing collaboration
**Tools**: GitHub Insights, GitLab analytics, Reviewable

**Privacy Note**: Team productivity metrics should be aggregated, not individualized. Use team-level or role-level aggregations. Avoid individual performance tracking.

---

### Category 4: User Behavior & Product Analytics

#### Graph 4.1: User Funnel Conversion
**Visualizes**: Funnel chart: steps × users reaching each step
**Data Sources**: Analytics events, product tracking
**Questions Answered**:
- Where do users drop off?
- Which steps have highest abandonment?
**Most Valuable**: Products with defined user journeys
**Tools**: Mixpanel, Amplitude, PostHog, Google Analytics

#### Graph 4.2: Feature Adoption Rate
**Visualizes**: X-axis: Time since release | Y-axis: % of users using feature
**Data Sources**: Feature usage events
**Questions Answered**:
- How quickly are new features adopted?
- Which features have low adoption?
**Most Valuable**: Products with feature flags, A/B testing
**Tools**: Product analytics tools, feature flag systems

#### Graph 4.3: Daily/Weekly Active Users Trend
**Visualizes**: X-axis: Time | Y-axis: DAU/WAU count
**Data Sources**: User activity logs
**Questions Answered**:
- Is user base growing, stable, or declining?
- Are there seasonal patterns?
**Most Valuable**: Products with recurring users
**Tools**: Product analytics, custom dashboards

#### Graph 4.4: Error Impact by User Segment
**Visualizes**: Grouped bar: error type × user segment (free, paid, enterprise)
**Data Sources**: Error tracking + user data
**Questions Answered**:
- Which user segments are most affected by errors?
- Are high-value users experiencing problems?
**Most Valuable**: Products with tiered user segments
**Tools**: Sentry with user context, custom analysis

#### Graph 4.5: API Endpoint Usage Heatmap
**Visualizes**: Matrix: endpoints × time periods, color = request count
**Data Sources**: API access logs
**Questions Answered**:
- Which endpoints are most used?
- When is peak usage?
- Which endpoints could be deprecated?
**Most Valuable**: API products, platforms
**Tools**: API gateways, custom log analysis

---

## Process — follow in order, no skipping

### 1. Identify Metric Category

Determine which categories are relevant:
- [ ] **Performance** — Production systems, latency-sensitive applications
- [ ] **CI/CD Health** — All projects with automated pipelines
- [ ] **Dev Velocity** — Teams 2+, especially growing teams
- [ ] **User Analytics** — Products with end users (web, mobile, API)

### 2. Prioritize by ROI

Rank metrics by:
- **Implementation effort** (instrumentation + visualization)
- **Insight value** (decisions enabled, risks detected)
- **Maintenance cost** (ongoing overhead)

**High ROI** (low effort, high insight):
- Pipeline success rate (CI dashboards exist)
- Error rate by endpoint (built into error trackers)
- Deployment frequency (CI/CD logs available)

**Medium ROI**:
- Response time percentiles (requires APM)
- Lead time distribution (multiple data sources)
- Feature adoption (requires product analytics)

**Lower ROI**:
- Flaky test detection (requires test history)
- Memory allocation trends (profiler setup)
- User funnels (product analytics setup)

### 3. Design Data Collection

For each selected metric:
- Identify data sources
- Plan instrumentation points
- Estimate performance overhead
- Address edge cases

### 4. Recommend Tools

Match tools to project stack and constraints.

### 5. Define Alert Thresholds

For each metric, define:
- Normal range
- Warning threshold
- Critical threshold
- Response action

---

## Edge Cases & Constraints

### Limited Historical Data

**Problem**: New projects or projects without historical metrics
**Solutions**:
- Start with baseline measurements
- Use industry benchmarks (DORA metrics, latency SLAs)
- Focus on forward-looking metrics
- Prioritize metrics that work with current snapshot

### Privacy Considerations

**Problem**: Team productivity metrics can be misused
**Solutions**:
- **Never** track individual performance metrics
- Aggregate to team level minimum
- Use role-based aggregation, not individuals
- Make data access transparent
- Focus on system metrics, not individual metrics

### Performance Overhead of Instrumentation

**Problem**: Data collection impacts production
**Solutions**:
- Use sampling for high-volume metrics (trace 1%)
- Prefer push-based metrics over polling
- Use async/offline analysis where possible
- Profile the profiler: measure overhead
- For hot paths: aggregate in memory, flush periodically

### Monorepo vs Polyrepo

**Monorepo**:
- Filter by project/package
- Use directory-based grouping
- Aggregate at project level for team metrics

**Polyrepo**:
- Aggregate across repos for team metrics
- Track per-repo health separately
- May need centralized metrics collection

---

## Expected Outcomes

### Decision-Making by Metric Type

| Metric Type | Decisions Enabled |
|-------------|-------------------|
| Response Time Percentiles | Capacity planning, SLA adjustments |
| Pipeline Success Rate | CI investment, quality gates |
| Lead Time Distribution | Process improvement, bottleneck ID |
| User Funnel | Product priorities, UX investment |
| Error Rate | Reliability priorities, incident response |

### Warning Signs & Anomalies

| Anomaly | Metrics That Detect It |
|---------|------------------------|
| Impending capacity exhaustion | Throughput vs latency, memory allocation |
| Flaky test suite | Flaky test detection, pipeline success rate |
| User experience degradation | Error rate, response time percentiles |
| CI bottleneck | Queue time, build time trend |
| Process inefficiency | Lead time distribution, cycle time |

---

## Visualization Tools by Category

### Performance
- **Prometheus + Grafana** — Custom metrics dashboards
- **Datadog/New Relic** — Full APM with visualization
- **Jaeger/Zipkin** — Distributed tracing

### CI/CD
- **Buildkite Analytics** — Build time analysis
- **GitHub Actions** — Workflow insights
- **Jenkins** — Build history and trends

### Dev Velocity
- **LinearB** — DORA metrics
- **GitHub Insights** — Built-in team metrics
- **GitLab Analytics** — Cycle time, deployment frequency

### User Analytics
- **PostHog** — Open-source product analytics
- **Mixpanel/Amplitude** — Funnel and retention analysis
- **Sentry** — Error tracking with user context

---

## Output Format

```
## Metrics Dashboard Plan: [Project Name]

### Relevant Categories
- Performance: [Yes/No - reason]
- CI/CD Health: [Yes/No - reason]
- Dev Velocity: [Yes/No - reason]
- User Analytics: [Yes/No - reason]

### Recommended Metrics by Priority

#### High Priority
1. **[Metric Name]**
   - Category: [category]
   - Data sources: [list]
   - Questions answered: [list]
   - Tool recommendation: [specific tool]
   - Alert thresholds: [warning/critical]
   - Implementation effort: [Low/Medium]

#### Medium Priority
[Same format]

### Data Collection Plan

| Metric | Instrumentation Points | Performance Overhead | Privacy Considerations |
|--------|------------------------|---------------------|------------------------|
| ... | ... | ... | ... |

### Tool Stack Recommendation
- Performance: [tool]
- CI/CD: [tool]
- Dev Velocity: [tool]
- User Analytics: [tool]

### Alert Configuration
| Metric | Warning | Critical | Response |
|--------|---------|----------|----------|
| ... | ... | ... | ... |

### Next Steps
1. [First implementation step]
2. [Second step]
...
```

---

## Hard Rules

- NEVER recommend individual-level productivity metrics
- NEVER recommend metrics without identifying data sources
- NEVER ignore performance overhead of instrumentation
- NEVER propose tools that conflict with existing stack without justification
- ALWAYS prioritize by ROI (effort vs insight)
- ALWAYS consider privacy implications
- ALWAYS define alert thresholds for production metrics

---

## Related Skills

- **visualize-project** — For codebase structure, dependencies, ownership
- **optimize** — Performance profiling and improvement
- **audit-security** — Verify metrics don't expose sensitive data
- **write-docs** — Document dashboard setup and interpretation
- **create-item** — Implement data collection and dashboard code

---

## Pre-Submit Checklist

- [ ] Relevant categories identified
- [ ] Metrics prioritized by ROI
- [ ] Data sources identified for each metric
- [ ] Tools match project stack
- [ ] Performance overhead addressed
- [ ] Privacy considerations documented
- [ ] Alert thresholds defined (for production metrics)
- [ ] Implementation steps are actionable
