# Risk Assessment Framework

This template provides comprehensive risk assessment patterns for FRD generation.

---

## Risk Assessment Structure

All FRDs should include a Risk Assessment section with:
- Technical risks
- Project risks
- Risk matrix
- Mitigation strategies
- Contingency plans
- Early warning signs

---

## Risk Template Format

Use this format for each identified risk:

```markdown
### RISK-XXX: [Risk Name]

**Category**: [Technical | Project | External]
**Likelihood**: [Low | Medium | High]
**Impact**: [Low | Medium | High]
**Risk Score**: [1-9, calculated as Likelihood × Impact]

**Description**: [Detailed explanation of the risk]

**Potential Consequences**:
- [Consequence 1: What happens if risk materializes]
- [Consequence 2: Secondary effects]
- [Consequence 3: Cascading impacts]

**Mitigation Strategies**:
1. [Proactive step to prevent risk or reduce likelihood]
2. [Proactive step to reduce impact if it occurs]
3. [Monitoring or early detection approach]

**Contingency Plan**:
- **If risk materializes**: [Immediate response plan]
- **Fallback approach**: [Alternative solution or workaround]
- **Recovery steps**: [How to get back on track]

**Early Warning Signs**:
- [Indicator 1 that risk is emerging]
- [Indicator 2 that requires attention]
- [Metric or signal to monitor]

**Owner**: [Team member responsible for monitoring]

**Related Requirements**: [TR-XXX, FR-XXX, or other relevant requirements]
```

---

## Risk Scoring System

### Likelihood Scale

- **Low (1)**: <20% chance of occurring
- **Medium (2)**: 20-50% chance of occurring
- **High (3)**: >50% chance of occurring

### Impact Scale

- **Low (1)**: Minor inconvenience, <1 week delay, <10% budget impact
- **Medium (2)**: Significant issue, 1-3 week delay, 10-25% budget impact
- **High (3)**: Major problem, >3 week delay, >25% budget impact, scope reduction

### Risk Score Matrix

| Likelihood / Impact | Low (1) | Medium (2) | High (3) |
|---------------------|---------|------------|----------|
| **High (3)** | 3 | 6 | 9 |
| **Medium (2)** | 2 | 4 | 6 |
| **Low (1)** | 1 | 2 | 3 |

**Priority Levels**:
- **Critical (7-9)**: Immediate attention, weekly monitoring
- **High (4-6)**: Active monitoring, bi-weekly review
- **Medium (2-3)**: Watch list, monthly review
- **Low (1)**: Awareness only, quarterly review

---

## Common Technical Risks

### Recipe/Configuration Management Risks (Drupal)

#### RISK-001: Recipe Installation Order Conflicts

**Category**: Technical
**Likelihood**: Medium (2)
**Impact**: High (3)
**Risk Score**: 6 (High priority)

**Description**: Recipes with shared field storage dependencies may fail if installed in the wrong order. If a recipe attempts to use a shared field before the recipe that creates the field storage has run, the installation will fail.

**Potential Consequences**:
- Installation failures during deployment
- Data loss if partial installation corrupts configuration
- Delays in environment setup and testing
- Client demo failures if installation is broken

**Mitigation Strategies**:
1. **Document installation order explicitly** in master recipe README and dependency comments
2. **Create automated installation script** with proper dependency ordering and error handling
3. **Test installation sequence** in clean environment before each release
4. **Use recipe dependency declarations** where supported by the recipe system
5. **Create shared field storage first** in a base/foundation recipe that all others depend on

**Contingency Plan**:
- **If risk materializes**:
  1. Identify which recipe failed and which field storage is missing
  2. Manually install the dependency recipe first
  3. Reset to clean database state if corruption occurred
  4. Re-run installation in correct order
- **Fallback approach**: Provide detailed manual installation steps as backup to automated script
- **Recovery steps**:
  1. Document the failure scenario
  2. Update installation order documentation
  3. Add error checking to installation script
  4. Create automated test for this specific order

**Early Warning Signs**:
- Shared field errors during recipe installation in dev/staging
- Configuration import failures mentioning field storage
- Missing or duplicate field storage entities
- Inconsistent installation results across environments

**Owner**: Technical Lead

**Related Requirements**: FR-002 (recipe structure), DR-003 (shared field storage)

---

#### RISK-002: Configuration Synchronization Conflicts

**Category**: Technical
**Likelihood**: Medium (2)
**Impact**: Medium (2)
**Risk Score**: 4 (High priority)

**Description**: Multiple developers working on recipes simultaneously may create conflicting configuration changes that fail to merge or cause unexpected behavior when synchronized.

**Potential Consequences**:
- Configuration import failures in shared environments
- Lost work if configurations overwrite each other
- Merge conflicts in version control
- Time spent debugging configuration issues

**Mitigation Strategies**:
1. **Use separate recipes for separate features** to minimize overlap
2. **Coordinate recipe development** - assign recipes to specific developers
3. **Export and commit config frequently** to catch conflicts early
4. **Test config imports** in clean environment regularly
5. **Use configuration update hooks** for programmatic changes where appropriate

**Contingency Plan**:
- **If risk materializes**:
  1. Identify conflicting configuration entities
  2. Compare configuration in both versions
  3. Manually merge or choose correct version
  4. Test merged configuration in dev environment
- **Fallback approach**: Roll back to last known good configuration state
- **Recovery steps**: Document conflict resolution, establish config workflow rules

**Early Warning Signs**:
- Configuration import warnings or errors
- UUIDs mismatches between environments
- Unexpected configuration changes appearing in exports
- Developer reports of "lost" configuration changes

**Owner**: Technical Lead

**Related Requirements**: TR-002 (recipe architecture), TR-007 (development environment)

---

### Integration Risks

#### RISK-003: Third-Party API Reliability

**Category**: Technical
**Likelihood**: Low (1)
**Impact**: High (3)
**Risk Score**: 3 (Medium priority)

**Description**: Third-party API services may experience downtime, rate limiting, or breaking changes that impact site functionality.

**Potential Consequences**:
- Feature failures during API outages
- Degraded user experience
- Data synchronization issues
- Potential data loss if API changes unexpectedly

**Mitigation Strategies**:
1. **Implement graceful degradation** - site functions with reduced features if API unavailable
2. **Add caching layer** - reduce API calls and provide fallback data
3. **Set up monitoring and alerts** - detect API failures quickly
4. **Establish SLA with vendor** - document expected uptime and support response times
5. **Create fallback data sources** where possible

**Contingency Plan**:
- **If risk materializes**:
  1. Activate cached/fallback data immediately
  2. Display user-friendly error messages
  3. Queue failed requests for retry
  4. Contact API vendor support
- **Fallback approach**: Manual data entry process for critical functions
- **Recovery steps**:
  1. Verify API restoration
  2. Process queued requests
  3. Validate data synchronization

**Early Warning Signs**:
- Increased API response times
- Intermittent API timeouts
- Rate limit warnings
- API version deprecation notices from vendor

**Owner**: Backend Developer

**Related Requirements**: TR-004 (third-party integrations), TS-004 (integration testing)

---

### Performance Risks

#### RISK-004: Performance Degradation Under Load

**Category**: Technical
**Likelihood**: Medium (2)
**Impact**: Medium (2)
**Risk Score**: 4 (High priority)

**Description**: Site may not meet performance benchmarks under expected production traffic levels, especially during peak usage.

**Potential Consequences**:
- Poor user experience with slow page loads
- Failed Lighthouse and Core Web Vitals scores
- SEO ranking impacts
- Potential infrastructure scaling costs

**Mitigation Strategies**:
1. **Establish performance budget early** - define acceptable metrics
2. **Implement caching strategies** - page cache, object cache, CDN
3. **Optimize database queries** - add indexes, use query analysis tools
4. **Conduct load testing** - simulate expected traffic in staging
5. **Monitor performance continuously** - Lighthouse CI, Real User Monitoring

**Contingency Plan**:
- **If risk materializes**:
  1. Enable aggressive caching immediately
  2. Optimize slowest queries identified in logs
  3. Scale infrastructure horizontally if needed
  4. Implement request throttling for non-critical features
- **Fallback approach**: Reduce feature complexity in initial launch, add back incrementally
- **Recovery steps**:
  1. Conduct thorough performance audit
  2. Implement identified optimizations
  3. Re-test under load
  4. Establish ongoing monitoring

**Early Warning Signs**:
- Lighthouse scores declining in CI/CD
- Slow query warnings in database logs
- Increased server response times
- Cache hit rate decreasing
- Memory usage increasing

**Owner**: Backend Developer + Performance Specialist

**Related Requirements**: NFR-001 (performance benchmarks), TS-002 (performance testing)

---

### Security Risks

#### RISK-005: Security Vulnerability in Dependencies

**Category**: Technical
**Likelihood**: Medium (2)
**Impact**: High (3)
**Risk Score**: 6 (High priority)

**Description**: Third-party packages and modules may contain security vulnerabilities that could be exploited.

**Potential Consequences**:
- Data breaches exposing sensitive information
- Site defacement or malicious code injection
- Compliance violations (GDPR, HIPAA, etc.)
- Reputational damage and loss of user trust

**Mitigation Strategies**:
1. **Keep dependencies up to date** - regular security updates
2. **Use automated security scanning** - Dependabot, Snyk, or similar
3. **Review dependency security advisories** - monitor Drupal/WordPress security feeds
4. **Minimize dependencies** - only include necessary packages
5. **Implement Web Application Firewall (WAF)** - block common attack vectors

**Contingency Plan**:
- **If risk materializes**:
  1. Immediately apply security patch or update vulnerable package
  2. Assess scope of potential breach
  3. Notify stakeholders per security response plan
  4. Conduct security audit to verify no exploitation occurred
- **Fallback approach**: Temporarily disable affected feature if patch unavailable
- **Recovery steps**:
  1. Complete full security audit
  2. Implement additional hardening
  3. Update security response procedures

**Early Warning Signs**:
- Security advisory notifications
- Dependabot or Snyk alerts
- Unusual traffic patterns
- Failed authentication attempts increasing
- Suspicious database queries in logs

**Owner**: Technical Lead + Security Specialist

**Related Requirements**: TR-006 (security requirements), TS-004 (security testing)

---

## Common Project Risks

### Scope & Requirements Risks

#### RISK-006: Scope Creep During Development

**Category**: Project
**Likelihood**: High (3)
**Impact**: Medium (2)
**Risk Score**: 6 (High priority)

**Description**: Additional features or changes requested during development that were not in original scope, potentially delaying timeline and exceeding budget.

**Potential Consequences**:
- Timeline delays and missed launch date
- Budget overruns
- Team burnout from constant changes
- Incomplete core features due to resource diversion

**Mitigation Strategies**:
1. **Establish clear change request process** - document how changes are evaluated and approved
2. **Educate stakeholders on impact** - show timeline/budget effects of changes
3. **Defer non-critical changes** - maintain "Phase 2" backlog for post-launch enhancements
4. **Use story point re-estimation** - quantify impact of each change request
5. **Require formal sign-off** - changes must be approved by decision-maker

**Contingency Plan**:
- **If risk materializes**:
  1. Pause to assess cumulative impact of changes
  2. Re-negotiate timeline or reduce "Nice to Have" features
  3. Present options: extend timeline, reduce scope, or increase resources
- **Fallback approach**: Implement MVP only, push enhancements to Phase 2
- **Recovery steps**:
  1. Update project plan with revised scope
  2. Communicate new timeline to all stakeholders
  3. Strengthen change control process

**Early Warning Signs**:
- Increasing frequency of change requests
- "Just one more small thing" conversations
- Story points per sprint exceeding velocity
- Developers reporting context-switching overhead
- Sprint goals frequently changed mid-sprint

**Owner**: Project Manager

**Related Requirements**: All FR-XXX (functional requirements affected by scope)

---

#### RISK-007: Unclear or Changing Requirements

**Category**: Project
**Likelihood**: Medium (2)
**Impact**: Medium (2)
**Risk Score**: 4 (High priority)

**Description**: Stakeholders may not have clear vision of requirements, or requirements may change as they see implementation progress, leading to rework.

**Potential Consequences**:
- Rework of completed features
- Developer frustration and reduced morale
- Timeline delays
- Increased technical debt from rushed changes

**Mitigation Strategies**:
1. **Conduct thorough discovery phase** - document requirements in detail before development
2. **Create clickable prototypes** - validate understanding before building
3. **Use iterative demos** - show progress regularly to catch misunderstandings early
4. **Document assumptions** - make implicit requirements explicit
5. **Obtain written sign-off** - ensure stakeholder agreement on requirements

**Contingency Plan**:
- **If risk materializes**:
  1. Pause development to clarify requirements
  2. Conduct focused requirements workshop
  3. Update FRD with clarified requirements
  4. Re-estimate affected stories
- **Fallback approach**: Implement most conservative interpretation, iterate based on feedback
- **Recovery steps**:
  1. Update requirements documentation
  2. Adjust sprint plans
  3. Improve requirements gathering process for future phases

**Early Warning Signs**:
- Stakeholders saying "that's not what I meant" during demos
- Frequent questions from developers about intended behavior
- Multiple iterations on same feature
- Acceptance criteria being added or changed after story started

**Owner**: Project Manager + Product Owner

**Related Requirements**: All FR-XXX, US-XXX

---

### Resource & Timeline Risks

#### RISK-008: Key Team Member Unavailability

**Category**: Project
**Likelihood**: Low (1)
**Impact**: High (3)
**Risk Score**: 3 (Medium priority)

**Description**: Critical team members may become unavailable due to illness, departure, or competing priorities, impacting project continuity.

**Potential Consequences**:
- Knowledge loss and context switching delays
- Timeline delays while replacement is found and onboarded
- Quality issues if specialized expertise is lost
- Team morale impact

**Mitigation Strategies**:
1. **Document decisions and architecture** - reduce reliance on tribal knowledge
2. **Pair programming and code reviews** - spread knowledge across team
3. **Cross-train team members** - ensure multiple people understand critical areas
4. **Maintain technical documentation** - enable faster onboarding
5. **Plan for backup resources** - identify available developers who could step in

**Contingency Plan**:
- **If risk materializes**:
  1. Immediately assess impact on critical path
  2. Redistribute work among remaining team
  3. Engage backup resources if available
  4. Extend timeline if necessary
- **Fallback approach**: Reduce scope to focus on must-have features only
- **Recovery steps**:
  1. Onboard replacement as quickly as possible
  2. Conduct knowledge transfer sessions
  3. Update documentation to prevent future gaps

**Early Warning Signs**:
- Team member expressing dissatisfaction or burnout
- Key knowledge concentrated in single person
- Lack of documentation for critical systems
- Absences increasing

**Owner**: Project Manager

**Related Requirements**: All (project-wide impact)

---

#### RISK-009: Optimistic Velocity Estimates

**Category**: Project
**Likelihood**: Medium (2)
**Impact**: Medium (2)
**Risk Score**: 4 (High priority)

**Description**: Team may not achieve expected velocity due to underestimating complexity, unforeseen issues, or over-optimistic planning.

**Potential Consequences**:
- Missed deadlines and launch delays
- Pressure to cut corners, increasing technical debt
- Team burnout from unrealistic expectations
- Stakeholder disappointment

**Mitigation Strategies**:
1. **Use historical velocity data** - base estimates on actual team performance
2. **Add 20% buffer to timeline** - account for unknowns and issues
3. **Track velocity early** - measure actual vs. estimated in first few sprints
4. **Re-estimate regularly** - adjust plans based on observed velocity
5. **Account for non-story work** - meetings, bug fixes, support reduce capacity

**Contingency Plan**:
- **If risk materializes**:
  1. Identify gap between estimated and actual velocity
  2. Re-forecast timeline based on actual velocity
  3. Prioritize must-have features, defer nice-to-haves
  4. Communicate revised timeline to stakeholders early
- **Fallback approach**: Release MVP with reduced scope, iterate post-launch
- **Recovery steps**:
  1. Update project plan with realistic velocity
  2. Adjust sprint planning process
  3. Set expectations with stakeholders

**Early Warning Signs**:
- Stories frequently not completed in sprint
- Sprint goals missed multiple times
- Team reporting stories were harder than estimated
- Burndown chart consistently not reaching zero
- Velocity declining sprint over sprint

**Owner**: Scrum Master / Project Manager

**Related Requirements**: Implementation Plan (affects all phases)

---

### External Dependency Risks

#### RISK-010: Third-Party Vendor Delays

**Category**: External
**Likelihood**: Low (1)
**Impact**: High (3)
**Risk Score**: 3 (Medium priority)

**Description**: External vendors (design agency, API provider, hosting provider) may deliver late or have service disruptions, blocking project progress.

**Potential Consequences**:
- Timeline delays waiting for vendor deliverables
- Inability to implement features dependent on vendor services
- Scope reduction if vendor cannot deliver
- Cost overruns from project extension

**Mitigation Strategies**:
1. **Establish SLAs with vendors** - document expected timelines and response times
2. **Build vendor dependencies into critical path** - account for potential delays
3. **Request regular status updates** - monitor vendor progress proactively
4. **Identify alternative vendors** - have backup options researched
5. **Plan work to minimize dependencies** - parallelize where possible

**Contingency Plan**:
- **If risk materializes**:
  1. Escalate with vendor management
  2. Activate alternative vendor if available
  3. Adjust project timeline
  4. Temporarily mock vendor services for testing
- **Fallback approach**: Build simplified version of dependent feature in-house
- **Recovery steps**:
  1. Complete vendor deliverable or transition to alternative
  2. Update project plan
  3. Review vendor relationships for future projects

**Early Warning Signs**:
- Vendor missing intermediate milestones
- Communication from vendor becoming less frequent
- Vendor reporting internal issues or resource constraints
- Deliverable quality declining in early samples

**Owner**: Project Manager

**Related Requirements**: TR-004 (third-party integrations)

---

## Risk Matrix Template

Include this summary table in every FRD:

```markdown
## Risk Matrix

| Risk ID | Risk Name | Category | Likelihood | Impact | Score | Priority | Owner |
|---------|-----------|----------|------------|--------|-------|----------|-------|
| RISK-001 | Recipe Installation Order | Technical | Medium | High | 6 | High | Tech Lead |
| RISK-002 | Config Sync Conflicts | Technical | Medium | Medium | 4 | High | Tech Lead |
| RISK-003 | Third-Party API Reliability | Technical | Low | High | 3 | Medium | Backend Dev |
| RISK-004 | Performance Under Load | Technical | Medium | Medium | 4 | High | Backend Dev |
| RISK-005 | Dependency Vulnerabilities | Technical | Medium | High | 6 | High | Tech Lead |
| RISK-006 | Scope Creep | Project | High | Medium | 6 | High | PM |
| RISK-007 | Unclear Requirements | Project | Medium | Medium | 4 | High | PM |
| RISK-008 | Team Member Unavailability | Project | Low | High | 3 | Medium | PM |
| RISK-009 | Optimistic Velocity | Project | Medium | Medium | 4 | High | PM |
| RISK-010 | Vendor Delays | External | Low | High | 3 | Medium | PM |

**Critical Priority Risks** (Score 6-9): RISK-001, RISK-005, RISK-006
**High Priority Risks** (Score 4-6): RISK-002, RISK-004, RISK-007, RISK-009
**Medium Priority Risks** (Score 2-3): RISK-003, RISK-008, RISK-010
**Low Priority Risks** (Score 1): None identified

**Monitoring Frequency**:
- Critical risks: Weekly review in stand-up
- High priority risks: Bi-weekly review in sprint retrospective
- Medium/Low priority risks: Monthly review in project status meeting
```

---

## Platform-Specific Risk Patterns

### Drupal Recipe-Based Project Risks

Common risks specific to Drupal recipe architecture:

1. **Recipe Installation Order Conflicts** (see RISK-001)
2. **Configuration Synchronization Issues** (see RISK-002)
3. **Shared Field Storage Conflicts** - multiple recipes creating same field storage
4. **Recipe Dependency Chain Complexity** - long dependency chains hard to manage
5. **Demo Content Installation Failures** - Default Content module dependencies
6. **Recipe Update Conflicts** - updating installed recipes with configuration changes

### WordPress Block Theme Project Risks (Future)

To be documented in v0.3.0:

1. **Block Deprecation** - Gutenberg blocks deprecated in updates
2. **Theme.json Schema Changes** - breaking changes in theme.json format
3. **Plugin Compatibility** - plugin conflicts with FSE features
4. **Performance with Block Rendering** - block editor overhead

---

## Risk Monitoring Best Practices

### Regular Risk Reviews

**Weekly** (Stand-up):
- Quick check: Any new risks emerged?
- Critical risks: Status update from owners

**Bi-Weekly** (Sprint Retrospective):
- High priority risks: Detailed review
- Early warning signs: Any indicators present?
- Mitigation effectiveness: Are strategies working?

**Monthly** (Project Status):
- Full risk register review
- Update likelihood/impact based on progress
- Retire risks that are no longer applicable
- Add newly identified risks

### Risk Documentation

**Maintain**:
- Risk register (table format for quick reference)
- Detailed risk descriptions (RISK-XXX format)
- Risk log (history of when risks emerged, materialized, resolved)

**Update**:
- When risk likelihood or impact changes
- When mitigation strategies prove effective or ineffective
- When risks materialize (document actual consequences)
- When new risks are identified

### Escalation Triggers

**Escalate to stakeholders when**:
- Critical risk (score 7-9) identified
- High priority risk materializes
- Multiple risks materializing simultaneously
- Risk requires scope/timeline/budget changes
- External help needed (vendor, consultant)

---

## Example: Complete Risk Assessment Section

```markdown
## Risk Assessment

This section identifies potential risks that could impact project success, along with mitigation strategies and contingency plans.

### Technical Risks

#### RISK-001: Recipe Installation Order Conflicts
[Full risk description as shown in templates above]

#### RISK-002: Configuration Synchronization Conflicts
[Full risk description as shown in templates above]

#### RISK-003: Third-Party API Reliability
[Full risk description as shown in templates above]

#### RISK-004: Performance Degradation Under Load
[Full risk description as shown in templates above]

#### RISK-005: Security Vulnerability in Dependencies
[Full risk description as shown in templates above]

### Project Risks

#### RISK-006: Scope Creep During Development
[Full risk description as shown in templates above]

#### RISK-007: Unclear or Changing Requirements
[Full risk description as shown in templates above]

#### RISK-008: Key Team Member Unavailability
[Full risk description as shown in templates above]

#### RISK-009: Optimistic Velocity Estimates
[Full risk description as shown in templates above]

### External Risks

#### RISK-010: Third-Party Vendor Delays
[Full risk description as shown in templates above]

### Risk Matrix

[Risk matrix table as shown above]

### Risk Monitoring Plan

**Review Frequency**:
- **Weekly**: Stand-up review of critical risks (RISK-001, RISK-005, RISK-006)
- **Bi-weekly**: Sprint retrospective review of high priority risks
- **Monthly**: Full risk register review in project status meeting

**Risk Owners**:
- Technical Lead: Technical risks (RISK-001 through RISK-005)
- Project Manager: Project and external risks (RISK-006 through RISK-010)

**Escalation Process**:
- Critical risks (score 7-9): Immediate stakeholder notification
- Risk materialization: Document in risk log, implement contingency plan, report in next status meeting
```

---

## Customization Guidelines

When creating risk assessment for specific projects:

1. **Use these templates as starting point** - customize for project specifics
2. **Add project-specific risks** - beyond common patterns
3. **Be realistic about likelihood and impact** - don't downplay risks
4. **Provide actionable mitigation strategies** - not just "monitor closely"
5. **Assign clear owners** - someone must watch each risk
6. **Update as project progresses** - risks evolve over time
7. **Document when risks materialize** - learn for future projects

---
