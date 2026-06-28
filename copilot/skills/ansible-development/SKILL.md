---
name: ansible-development
description: Ansible automation workflow guidelines. Activate when working with Ansible playbooks, ansible-playbook, inventory files (.yml, .ini), or Ansible-specific patterns.
---

# Ansible Workflow

## Tool Grid

| Task | Tool | Command |
|------|------|---------|
| Lint | ansible-lint | `ansible-lint` |
| YAML lint | yamllint | `yamllint .` |
| Syntax check | ansible | `ansible-playbook --syntax-check` |
| Dry run | ansible | `ansible-playbook --check` |

## Code Standards

### FQCN Requirement

All modules MUST use Fully Qualified Collection Names (FQCN):

```yaml
- name: Copy configuration file
  ansible.builtin.copy:
    src: app.conf
    dest: /etc/app/app.conf
```

### Linting

All changes must pass: `ansible-lint && yamllint .`

## Project Structure

```
group_vars/
├── all.yml          # Common variables
├── nginx.yml        # Common nginx hosts
├── cxo.yml          # Hosts at the cxo datacenter
└── jenkins.yml      # Common Jenkins variables

host_vars/           # Host-specific variables that change frequently

roles/               # Each role is single-purpose
├── nginx/           # Web server only
├── base/            # Basic linux system setup only
├── docker/          # Docker setup only
└── grafana/         # Grafana deployment only
```

## Handler Patterns

```yaml
# tasks/main.yml
- name: Update nginx configuration
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify:
    - Validate nginx config
    - Restart nginx

# handlers/main.yml - define in logical sequence (validate -> reload -> restart)
- name: Validate nginx config
  ansible.builtin.command: nginx -t
  changed_when: false

- name: Restart nginx
  ansible.builtin.systemd:
    name: nginx
    state: restarted
```

## Variable Best Practices

```yaml
# roles/nginx/defaults/main.yml — safe defaults
nginx_worker_processes: auto
nginx_worker_connections: 1024

# group_vars/prod/nginx.yml — environment-specific overrides
nginx_worker_connections: 4096

# Extra vars for one-time overrides only
# ansible-playbook playbook.yml -e "nginx_worker_connections=8192"
```

## Checklist

1. [ ] `ansible-lint` passes with no warnings
2. [ ] `yamllint .` passes
3. [ ] `ansible-playbook --syntax-check` passes
4. [ ] All modules use FQCN
5. [ ] Sensitive tasks have `no_log: true`
