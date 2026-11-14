# Final Pre-Commit Audit Report — arch-files

**Repository:** `https://github.com/Amatrasu66/arch-files`  
**Working Directory:** `/home/amatrasu/customization/arch-files`  
**Audit Date:** 2026-11-14  
**Audit Verdict:** **SAFE TO STAGE WITH EXCLUSIONS**  
**Remote Configuration:** Verified (`origin -> https://github.com/Amatrasu66/arch-files.git`)

---

## 1. Executive Summary & Audit Verdict

Prior to staging and executing the first Git commit on the `arch-files` repository, a final pre-commit audit was performed across Git identity privacy, third-party asset licensing, credential scanning, and publication boundaries.

### Audit Verdict: SAFE TO STAGE WITH EXCLUSIONS
The repository is safe to stage under the following conditions:
1. **Git Identity Privacy Action Required**: The current global Git identity uses a personal email address. To prevent exposing this personal email in public Git commit history, the user should set their official GitHub noreply address locally before committing.
2. **Third-Party Wallpaper Exclusions**: Three digital wallpaper images (`cat-street.jpg`, `laundry.jpg`, `sushi.jpg`) have unverified redistribution rights. In accordance with open-source licensing compliance, **these three files are excluded from the initial public commit** while being safely preserved on disk.
3. **Zero Security Vulnerabilities**: Comprehensive scans confirmed 0 private keys, 0 passwords, 0 API tokens, 0 Wi-Fi credentials, 0 browser cookies/history, and 0 hardcoded personal user paths in the publication tree.
4. **Intended Publication Footprint**: **247 files** totaling **4.09 MB**, containing 0 compiled binaries and 0 proprietary font files.

---

## 2. Git Identity Privacy Inspection

A check of local and global Git configuration was performed:

| Git Attribute | Current Value | Privacy Status & Recommendation |
| :--- | :--- | :--- |
| **Current Branch** | `main` | Initial commit ready |
| **Configured Remote (`origin`)** | `https://github.com/Amatrasu66/arch-files.git` | **MATCHES EXPECTED REPOSITORY** |
| **Local `user.name`** | *Not set locally* (Falls back to global `Amatrasu66`) | Acceptable (Matches GitHub username) |
| **Local `user.email`** | *Not set locally* (Falls back to global personal email) | **PRIVACY CONCERN: Exposes personal email** |

### How to Retrieve and Set Your GitHub Noreply Email
To keep your personal email private in public Git commits, GitHub provides a dedicated noreply email address:
1. Open your browser and navigate to: **GitHub → Settings → Emails** (`https://github.com/settings/emails`).
2. Under **"Primary email address"** or **"Keep my email addresses private"**, locate your GitHub-provided address:
   * Format: `<id>+Amatrasu66@users.noreply.github.com` (or `Amatrasu66@users.noreply.github.com`).
3. Set this address **locally for this repository only** (does NOT affect your global Git settings):
   ```bash
   cd /home/amatrasu/customization/arch-files
   git config --local user.email "<your_id>+Amatrasu66@users.noreply.github.com"
   ```
4. Verify local configuration:
   ```bash
   git config --local user.email
   ```
*(Note: As instructed, no Git configuration has been modified automatically).*

---

## 3. Inventory & Exclusions Audit

All files on disk were audited and partitioned into publication-approved vs excluded files (itemized manifest in [`docs/INITIAL_COMMIT_MANIFEST.md`](INITIAL_COMMIT_MANIFEST.md)):

```
┌────────────────────────────────────────────────────────────────────────┐
│                        PUBLICATION INVENTORY                           │
├────────────────────────┬─────────────┬─────────────┬───────────────────┤
│ Directory / Category   │ File Count  │ Total Size  │ Publication Status│
├────────────────────────┼─────────────┼─────────────┼───────────────────┤
│ Root Files             │ 6 files     │ 24.89 KB    │ Approved          │
│ .github                │ 1 file      │ 0.40 KB     │ Approved (CI)     │
│ assets/screenshots/    │ 23 files    │ 2.75 MB     │ Approved (Desktop)│
│ assets/diagrams/       │ 1 file      │ 0.43 KB     │ Approved (Specs)  │
│ assets/wallpapers/     │ 1 file      │ 0.55 KB     │ Approved (README) │
│ configs/               │ 116 files   │ 619.41 KB   │ Approved (Configs)│
│ docs/                  │ 28 files    │ 139.59 KB   │ Approved (Docs)   │
│ packages/              │ 7 files     │ 5.06 KB     │ Approved          │
│ profiles/              │ 12 files    │ 4.99 KB     │ Approved (3 profs)│
│ scripts/               │ 27 files    │ 33.67 KB    │ Approved (Modules)│
│ system/                │ 8 files     │ 4.33 KB     │ Approved (Templates)│
│ themes/                │ 1 file      │ 1.44 KB     │ Approved (Mocha)  │
│ upstream/              │ 16 files    │ 542.62 KB   │ Approved (Modesty)│
├────────────────────────┼─────────────┼─────────────┼───────────────────┤
│ TOTAL INCLUDED         │ 247 files   │ 4.09 MB     │ SAFE TO STAGE     │
├────────────────────────┼─────────────┼─────────────┼───────────────────┤
│ EXCLUDED WALLPAPERS    │ 3 files     │ 808.53 KB   │ EXCLUDED (Licensing)│
└────────────────────────┴─────────────┴─────────────┴───────────────────┘
```

---

## 4. Wallpaper & Visual Asset Licensing Audit

Each visual asset intended for public distribution was audited:

### 4.1 Original Desktop Screenshots (23 files in `assets/screenshots/`)
* **Source:** Captured directly by `Amatrasu66` from the live desktop environment.
* **Licensing:** Released under the project's **MIT License** / CC-BY-4.0.
* **Redistribution Rights:** **PERMITTED** (Original author material).

### 4.2 Catppuccin GTK Vector Icons (68 files in `configs/gtk/assets/`)
* **Source:** Catppuccin GTK Theme (`catppuccin/gtk` / `Fausto-Korpsvart/Catppuccin-GTK-Theme`).
* **Licensing:** GNU General Public License v3.0 (**GPL-3.0**).
* **Redistribution Rights:** **PERMITTED** (Under GPL-3.0 with source and license preserved).

### 4.3 Desktop Wallpapers (3 files in `assets/wallpapers/`)
* **Files:**
  * `assets/wallpapers/cat-street.jpg` (43.2 KB)
  * `assets/wallpapers/laundry.jpg` (314.4 KB)
  * `assets/wallpapers/sushi.jpg` (452.8 KB)
* **Provenance:** Third-party digital artwork collected from community forums (r/unixporn, Wallhaven). No explicit open redistribution license (CC0, CC-BY) is documented or verifiable.
* **Licensing Principle:** In copyright law, an artistic disclaimer or opt-out notice does not constitute legal permission for redistribution.
* **Audit Determination:** **EXCLUDED FROM INITIAL COMMIT**. The files remain safe on disk, but will not be staged into the public repository.
* **User Guidance:** Added [`assets/wallpapers/README.md`](../assets/wallpapers/README.md) instructing users where to place their own custom wallpapers (`~/.config/backgrounds/wallpaper.jpg`).

---

## 5. Security & Credential Inspection Findings

* **Hardcoded Personal Paths (`/home/amatrasu`):** **0** in active configs, scripts, or profile manifests.
* **Private Keys & Certificates:** **0 found**.
* **API Keys & Passwords:** **0 found**.
* **Wi-Fi Credentials & Private Network IPs:** **0 found**.
* **Machine IDs & Host Identifiers:** Templated in configuration files.

---

## 6. Recommended Explicit Git Staging Commands

To stage only the 247 approved files while strictly leaving the 3 unverified wallpaper files untracked and unstaged:

```bash
cd /home/amatrasu/customization/arch-files

# 1. (Optional but strongly recommended) Set your GitHub private noreply email locally:
# git config --local user.email "<your_id>+Amatrasu66@users.noreply.github.com"

# 2. Stage root configuration, license, and project documentation
git add .gitignore LICENSE README.md AGENTS.md SECURITY.md CONTRIBUTING.md

# 3. Stage GitHub Actions CI workflow
git add .github/

# 4. Stage core package inventories, profiles, themes, and system templates
git add packages/ profiles/ themes/ system/

# 5. Stage deployment scripts and modules
git add scripts/

# 6. Stage desktop configuration dotfiles and GTK assets
git add configs/

# 7. Stage upstream Modesty customizations package
git add upstream/

# 8. Stage desktop screenshots, architectural diagrams, and wallpaper documentation
# Note: Omits assets/wallpapers/*.jpg to respect third-party copyright
git add assets/screenshots/ assets/diagrams/ assets/wallpapers/README.md

# 9. Stage complete forensic audit, profile, module, and license documentation
git add docs/
```

### Verification After Staging:
```bash
git status
```
*Expected Status:*
* **Changes to be committed:** Exactly **247 files**.
* **Untracked files:** Exactly 3 wallpaper files (`assets/wallpapers/cat-street.jpg`, `laundry.jpg`, `sushi.jpg`).

---

## 7. Safety Confirmation

* **Files Staged:** **0** (No `git add` executed).
* **Commits Created:** **0** (No `git commit` executed).
* **Pushes Executed:** **0** (No remote network activity).
* **Global Git Settings Modified:** **NONE**.
* **Live System Changes:** **NONE** (Host dotfiles, packages, and services untouched).
