#!/usr/bin/env python3
"""
Validates systemd unit file syntax, sections, directives, and declared executable targets.
Provides detailed diagnostics separating syntax errors from dependency requirements.
"""
import glob
import os
import re
import sys

def validate_systemd_unit(file_path):
    errors = []
    warnings = []
    current_section = None
    sections_found = set()
    directives = {}
    
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    for idx, raw_line in enumerate(lines, 1):
        line = raw_line.strip()
        if not line or line.startswith('#') or line.startswith(';'):
            continue
            
        sec_match = re.match(r'^\[([A-Za-z0-9_]+)\]$', line)
        if sec_match:
            current_section = sec_match.group(1)
            sections_found.add(current_section)
            directives.setdefault(current_section, [])
            continue
            
        if current_section is None:
            errors.append(f"Line {idx}: Directive outside of section: {line}")
            continue
            
        kv_match = re.match(r'^([A-Za-z0-9_-]+)\s*=\s*(.*)$', line)
        if kv_match:
            key, val = kv_match.group(1), kv_match.group(2)
            directives[current_section].append((key, val, idx))
        else:
            errors.append(f"Line {idx}: Malformed directive: {line}")
            
    if 'Unit' not in sections_found:
        errors.append("Missing required [Unit] section")
    if 'Service' not in sections_found:
        errors.append("Missing required [Service] section")
        
    if 'Service' in directives:
        exec_starts = [val for key, val, _ in directives['Service'] if key == 'ExecStart']
        if not exec_starts:
            errors.append("Missing ExecStart directive in [Service] section")
        else:
            for es in exec_starts:
                cmd = es.split()[0].lstrip('-@:+!')
                if not (cmd.startswith('/') or cmd.startswith('%h/')):
                    warnings.append(f"ExecStart command '{cmd}' should use an absolute or %h/ path")
                    
    return errors, warnings, directives

def main():
    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    unit_dir = os.path.join(repo_root, "configs", "misc", "systemd-user")
    
    unit_files = sorted(glob.glob(os.path.join(unit_dir, "*.service")))
    if not unit_files:
        print(f"Error: No service units found in {unit_dir}")
        return 1
        
    total_errors = 0
    total_warnings = 0
    
    print("=== Systemd User Unit File Validation ===")
    for unit_path in unit_files:
        base_name = os.path.basename(unit_path)
        if os.path.islink(unit_path):
            target = os.readlink(unit_path)
            print(f"[SKIP] Masked unit symlink: {base_name} -> {target}")
            continue
            
        errors, warnings, directives = validate_systemd_unit(unit_path)
        if errors:
            print(f"[ERROR] {base_name}:")
            for e in errors:
                print(f"  - {e}")
            total_errors += len(errors)
        else:
            print(f"[VALID] {base_name} ({len(directives)} sections)")
            for sec, items in directives.items():
                exec_items = [v for k, v, _ in items if k.startswith('Exec')]
                if exec_items:
                    print(f"  [{sec}] Exec: {', '.join(exec_items)}")
                    
        if warnings:
            for w in warnings:
                print(f"  [WARN] {w}")
            total_warnings += len(warnings)
            
    print(f"\nResult: {total_errors} errors, {total_warnings} warnings across {len(unit_files)} units.")
    return 1 if total_errors > 0 else 0

if __name__ == '__main__':
    sys.exit(main())
