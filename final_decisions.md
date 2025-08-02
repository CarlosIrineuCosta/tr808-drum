# DevOps Project Decisions - FINAL

## 1. Secrets Management: 1Password
**Decision**: Use 1Password Individual Plan ($2.99/month when billed annually)
- The CLI is included with ALL 1Password plans, including Individual
- No need for the expensive Developer plan
- CLI setup: `op` command-line tool works with personal vaults
- Integration: GitHub Actions + Terraform + Ansible all support 1Password CLI

## 2. Domain Strategy
**Decision**: Use Tailscale's internal domains + Egyptian god naming
- Internal domains: `*.tail7f5166.ts.net` (your Tailnet domain)
- Service naming examples:
  - `anubis.tail7f5166.ts.net` - CI/CD service
  - `thoth.tail7f5166.ts.net` - Documentation/Wiki
  - `horus.tail7f5166.ts.net` - Monitoring dashboard
  - `ra.tail7f5166.ts.net` - Main application
- No public domain costs, all internal to Tailscale mesh

## 3. GPU CI Test Strategy
**Decision**: Intelligent test scheduling
- **Quick tests** (<10 min): On every push
  - Linting, unit tests, build verification
  - Docker image builds (no GPU)
- **GPU-intensive tests**: Nightly at 3 AM local time
  - ML model training validation
  - GPU memory leak tests
  - Performance benchmarks
- Implementation: GitHub Actions with self-hosted runner on DEV-GPU

## 4. Observability & Backups - Budget Conscious
**Decision**: Start minimal, scale later
- **Monitoring**: Grafana Cloud Free Tier
  - 10k metrics, 50GB logs, 50GB traces/month
  - 3 users, 14-day retention
  - Sufficient for 3-host setup
- **Backups**: 
  - Week 1-2: Use existing Backblaze for critical data
  - Week 3: Add NAS to infrastructure as 4th node
  - Backup strategy: Restic to NAS, then NAS to Backblaze
- **Cost**: $0 additional for now

## 5. Network Architecture
**Confirmed Setup**:
```
Internet
    |
    └── Hostinger VPS (147.79.110.46)
            |
        Tailscale Mesh (100.x.x.x)
       /            \
   OSIRIS        DEV-GPU
   (Control)     (CI/GPU)
      |              |
   Samba ←──────────┘
   Share
```

## 6. Hostinger VPS Capabilities
**Verified**:
- KVM 2 plan is sufficient for production workloads
- 8GB RAM handles Docker + monitoring agents
- 100GB storage (85GB available) 
- São Paulo location good for your timezone
- Valid until June 2026 (auto-renewal enabled)

## Summary Budget Impact
- **1Password**: $3/month
- **Grafana Cloud**: $0 (free tier)
- **Domains**: $0 (Tailscale internal)
- **Total Additional Cost**: $3/month

Ready to proceed with these decisions?