<!-- AI_CONTEXT_START -->
## 🤖 AI Prompt Guide / Coding Conventions

> **IMPORTANT FOR AI ASSISTANTS:** When writing, modifying, or refactoring PowerShell (`.ps1`) or Batch (`.bat`) scripts in this repository, you **MUST** strictly adhere to the following environment-specific rules:

### 1. File Encoding Requirements
* **PowerShell (`.ps1`):** Must be saved in **UTF-8 with BOM**. Always include `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8` at the very beginning of the script to prevent Cyrillic rendering issues.
* **Batch (`.bat`):** Must be saved in **UTF-8 WITHOUT BOM** (or ANSI) to prevent `cmd.exe` from failing on the first line.

### 2. Custom Exit Codes Convention (Range 100–125)
To avoid collisions with standard Windows Win32 System Errors (`1-5`, etc.) and native Git fatal/signal exit codes (`1`, `128+`), all custom automation logic failures and validation errors must use the isolated **100–125** range:
* `exit 0` — Success.
* `exit 101` — Source directory validation failed (does not exist).
* `exit 102` — Git environment validation failed (target is not a git repo / missing `.git`).
* `exit 103` — Configuration/Path validation failed (parent backup directory or drive unavailable).
* `exit 104` — Execution failure (external `git` command crashed or returned non-zero).

*Enforce this behavior in all `if/else` checks and `try/catch` blocks. Do not use generic `exit 1`.*

### 3. Console UI & Color Logging (PowerShell)
To maintain consistent visual output within the CLI launcher, never use plain `Write-Output` or `echo` for system messages. You **must use** `Write-Host` with appropriate `-ForegroundColor` flags:
* **Errors & Failures:** `Write-Host "[ERROR XXX]: message" -ForegroundColor Red` (always print the custom exit code in the brackets before exit).
* **Warnings & Paths:** `Write-Host "Context info/Path..." -ForegroundColor Yellow`
* **Success Messages:** `Write-Host "[SUCCESS]: message" -ForegroundColor Green`
* **Headers & Diagnostics:** `Write-Host "--- Heading ---" -ForegroundColor Cyan`
* **Minor/Debug details:** `Write-Host "Skipping/Processing..." -ForegroundColor Gray`
<!-- AI_CONTEXT_END -->
