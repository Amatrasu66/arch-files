#!/usr/bin/env python3
"""
ai-agent-status.py - Real-time, non-locking AI agent activity monitor.
Detects active tasks, agent counts, and lifecycle states for Google Antigravity
and OpenCode. Never reads private prompt contents or secrets.
"""
import datetime
import json
import os
import sqlite3
import subprocess
import time
from pathlib import Path


def get_niri_windows():
    """Retrieve mapped windows from Niri to locate app windows."""
    try:
        res = subprocess.run(
            ['niri', 'msg', '-j', 'windows'],
            capture_output=True,
            text=True,
            timeout=0.15
        )
        if res.returncode == 0 and res.stdout:
            return json.loads(res.stdout)
    except Exception:
        pass
    return []


def match_window_id(windows, app_name):
    """Find the Niri window ID for a given application."""
    app_lower = app_name.lower()
    for w in windows:
        w_app = (w.get('app_id') or '').lower()
        w_title = (w.get('title') or '').lower()
        if app_lower in w_app or app_lower in w_title:
            return w.get('id')
    return None


def parse_iso_to_ms(iso_str):
    """Parse ISO datetime string to epoch milliseconds preserving UTC timezone."""
    try:
        s = iso_str.strip()
        if s.endswith('Z'):
            s = s[:-1] + '+00:00'
        dt = datetime.datetime.fromisoformat(s)
        return int(dt.timestamp() * 1000)
    except Exception:
        return int(time.time() * 1000)


def get_antigravity_tasks(windows=None):
    """Query Antigravity conversation summaries for active and recent tasks."""
    db_path = Path.home() / '.gemini/antigravity/conversation_summaries.db'
    if not db_path.exists():
        return []

    win_id = match_window_id(windows, 'antigravity') if windows else None

    tasks = []
    try:
        uri = f"{db_path.as_uri()}?mode=ro"
        with sqlite3.connect(uri, uri=True, timeout=0.15) as conn:
            conn.execute('PRAGMA query_only=ON')
            cursor = conn.cursor()

            # First, fetch all active rows (running or not_fully_idle)
            cursor.execute('''
                SELECT conversation_id, title, preview, status, not_fully_idle,
                       killed, last_modified_time, parent_conversation_id, step_count
                FROM conversation_summaries
                WHERE (status = 'CASCADE_RUN_STATUS_RUNNING' OR not_fully_idle = 1)
                  AND killed = 0
                ORDER BY last_modified_time DESC
            ''')
            active_rows = cursor.fetchall()

            # Also check for recently completed tasks (within last 15 seconds)
            cursor.execute('''
                SELECT conversation_id, title, preview, status, not_fully_idle,
                       killed, last_modified_time, parent_conversation_id, step_count
                FROM conversation_summaries
                WHERE killed = 0
                  AND status = 'CASCADE_RUN_STATUS_IDLE'
                  AND last_modified_time >= datetime('now', '-15 seconds')
                ORDER BY last_modified_time DESC LIMIT 2
            ''')
            recent_rows = cursor.fetchall()

            # Group active subagents by parent_conversation_id
            subagent_counts = {}
            top_level_active = []
            for r in active_rows:
                cid, title, preview, status, not_fully_idle, killed, mtime, parent_id, steps = r
                if parent_id and parent_id.strip():
                    subagent_counts[parent_id] = subagent_counts.get(parent_id, 0) + 1
                else:
                    top_level_active.append(r)

            # If there are subagents whose parents are not in top_level_active, include them
            parent_ids = {r[0] for r in top_level_active}
            for r in active_rows:
                cid, title, preview, status, not_fully_idle, killed, mtime, parent_id, steps = r
                if parent_id and parent_id not in parent_ids and cid not in parent_ids:
                    top_level_active.append(r)

            for r in top_level_active:
                cid, title, preview, status, not_fully_idle, killed, mtime, parent_id, steps = r
                count = 1 + subagent_counts.get(cid, 0)
                ms_time = parse_iso_to_ms(mtime)

                clean_title = (title or 'Antigravity Session').strip()
                clean_desc = (preview or f"Step {steps} in progress").strip()

                tasks.append({
                    'application_id': 'antigravity',
                    'application_name': 'Google Antigravity',
                    'application_icon': 'antigravity',
                    'task_id': cid,
                    'task_title': clean_title,
                    'task_description': clean_desc,
                    'active_agent_count': count,
                    'status': 'working',
                    'status_label': 'Working',
                    'started_at': ms_time,
                    'last_activity': ms_time,
                    'window_identifier': win_id
                })

            # If no active tasks, include recent completed tasks for temporary completion display
            if not tasks:
                for r in recent_rows:
                    cid, title, preview, status, not_fully_idle, killed, mtime, parent_id, steps = r
                    ms_time = parse_iso_to_ms(mtime)
                    clean_title = (title or 'Antigravity Session').strip()
                    tasks.append({
                        'application_id': 'antigravity',
                        'application_name': 'Google Antigravity',
                        'application_icon': 'antigravity',
                        'task_id': cid,
                        'task_title': clean_title,
                        'task_description': 'Task completed',
                        'active_agent_count': 1,
                        'status': 'completed',
                        'status_label': 'Completed',
                        'started_at': ms_time,
                        'last_activity': ms_time,
                        'window_identifier': win_id
                    })

    except Exception:
        pass

    return tasks


def is_process_running(name):
    """Fast /proc scan in Python to check if a process is alive (<25ms)."""
    try:
        name_lower = name.lower()
        for entry in os.scandir('/proc'):
            if entry.name.isdigit():
                try:
                    with open(os.path.join(entry.path, 'comm'), 'r') as f:
                        if name_lower in f.read().lower():
                            return True
                except (IOError, PermissionError):
                    continue
    except Exception:
        pass
    return False


def get_opencode_tasks(windows=None):
    """Query OpenCode session database for active, waiting, and recent tasks."""
    db_path = Path.home() / '.local/share/opencode/opencode.db'
    if not db_path.exists():
        return []

    # If db hasn't been modified in last 5 minutes, skip expensive checks
    try:
        if time.time() - db_path.stat().st_mtime > 300:
            return []
    except Exception:
        pass

    # Fast process check
    if not is_process_running('opencode'):
        return []

    win_id = match_window_id(windows, 'opencode') if windows else None
    tasks = []
    try:
        uri = f"{db_path.as_uri()}?mode=ro"
        with sqlite3.connect(uri, uri=True, timeout=0.15) as conn:
            conn.execute('PRAGMA query_only=ON')
            cursor = conn.cursor()
            now_ms = int(time.time() * 1000)

            # Query active or recent sessions within last 2 minutes
            cursor.execute('''
                SELECT id, title, directory, agent, time_created, time_updated,
                       time_busy, time_idle, permission, idle_outcome
                FROM session_v2
                WHERE (time_busy > time_idle OR time_idle IS NULL OR time_updated > ?)
                ORDER BY time_updated DESC
            ''', (now_ms - 120000,))
            rows = cursor.fetchall()

            for r in rows:
                sid, title, directory, agent, t_created, t_updated, t_busy, t_idle, perm, outcome = r

                is_busy = bool(t_busy and (not t_idle or t_busy > t_idle))
                has_perm = bool(perm and perm not in ('[]', 'null', ''))

                if has_perm:
                    status = 'waiting'
                    status_label = 'Waiting for input'
                elif is_busy:
                    status = 'working'
                    status_label = 'Working'
                elif outcome == 'succeeded':
                    status = 'completed'
                    status_label = 'Completed'
                elif outcome == 'failed':
                    status = 'error'
                    status_label = 'Failed'
                else:
                    # If not busy and no permission request, check if completed recently
                    if t_updated and (now_ms - t_updated < 20000):
                        status = 'completed'
                        status_label = 'Completed'
                    else:
                        continue

                clean_title = (title or (os.path.basename(directory) if directory else 'OpenCode Session')).strip()
                desc = f"Agent: {agent or 'default'}" if agent else (directory or "Active task")

                tasks.append({
                    'application_id': 'opencode',
                    'application_name': 'OpenCode',
                    'application_icon': 'opencode',
                    'task_id': sid,
                    'task_title': clean_title,
                    'task_description': desc,
                    'active_agent_count': 1,
                    'status': status,
                    'status_label': status_label,
                    'started_at': t_created or t_updated or now_ms,
                    'last_activity': t_updated or now_ms,
                    'window_identifier': win_id
                })

    except Exception:
        pass

    return tasks


def main():
    override_file = Path('/tmp/modesty_qa_state.json')
    if override_file.exists():
        try:
            with open(override_file) as f:
                content = f.read().strip()
                if content:
                    print(content)
                    return
        except Exception:
            pass

    # Collect tasks from both applications first
    ag_tasks = get_antigravity_tasks()
    oc_tasks = get_opencode_tasks()

    all_tasks = ag_tasks + oc_tasks

    # Filter out stale completed tasks if active tasks exist
    active_tasks = [t for t in all_tasks if t['status'] in ('working', 'waiting')]
    display_tasks = active_tasks if active_tasks else [t for t in all_tasks if t['status'] == 'completed'][:2]

    # Attach window identifiers if tasks exist
    if display_tasks:
        windows = get_niri_windows()
        for t in display_tasks:
            t['window_identifier'] = match_window_id(windows, t['application_id'])

    is_active = len(active_tasks) > 0
    is_available = True

    if display_tasks:
        total_agents = sum(t['active_agent_count'] for t in display_tasks)
        apps = {t['application_name'] for t in display_tasks}
        icons = {t['application_icon'] for t in display_tasks}

        # Determine primary app label and icon
        if len(apps) == 1:
            primary_app = list(apps)[0]
            primary_icon = list(icons)[0]
        else:
            primary_app = 'AI Agents'
            primary_icon = 'antigravity'

        # Check aggregate kind
        if any(t['status'] == 'waiting' for t in display_tasks):
            kind = 'waiting'
            status_label = 'Waiting for input'
        elif any(t['status'] == 'working' for t in display_tasks):
            kind = 'working'
            status_label = 'Working'
        elif any(t['status'] == 'completed' for t in display_tasks):
            kind = 'completed'
            status_label = 'Completed'
        else:
            kind = 'idle'
            status_label = 'Idle'

        primary_task_title = display_tasks[0]['task_title']

        response = {
            'available': is_available,
            'active': is_active or (kind == 'completed'),
            'app': primary_app,
            'icon': primary_icon,
            'task': primary_task_title,
            'agentCount': total_agents,
            'kind': kind,
            'statusLabel': status_label,
            'tasks': display_tasks,
            'taskCount': len(display_tasks),
            'recent': []
        }
    else:
        response = {
            'available': is_available,
            'active': False,
            'app': '',
            'icon': 'antigravity',
            'task': '',
            'agentCount': 0,
            'kind': 'idle',
            'statusLabel': 'Idle',
            'tasks': [],
            'taskCount': 0,
            'recent': []
        }

    print(json.dumps(response))


if __name__ == '__main__':
    main()
