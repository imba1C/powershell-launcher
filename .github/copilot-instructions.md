<!-- AI_CONTEXT_START -->
## 🤖 AI Prompt Guide / Coding Conventions

> **IMPORTANT FOR AI ASSISTANTS:** When writing, modifying, or refactoring PowerShell (`.ps1`) or Batch (`.bat`) scripts in this repository, you **MUST** strictly adhere to the following environment-specific rules:

### 1. File Encoding Requirements
* **PowerShell (`.ps1`):** Must be saved in **UTF-8 with BOM**. Always include `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8` at the very beginning of the script to prevent Cyrillic rendering issues.
* **Batch (`.bat`):** Must be saved in **UTF-8 WITHOUT BOM** (or ANSI) to prevent `cmd.exe` from failing on the first line.

### 2. Execution & Custom Exit Codes (Recommended Range: 100–125)
* **Launcher Invocation (`-File`):** `run.bat` **MUST** invoke `.ps1` scripts using `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<script_path>"`. Never use `-Command`, as it coerces non-zero exit codes to `1` and masks custom codes.
* **Custom Exit Codes (Recommended):** To avoid collisions with Windows Win32 System Errors (`1–99`) and POSIX/Git fatal exit codes (`126+`), it is **recommended** to use the isolated **100–125** range via `exit <code>` for custom validation and business logic errors:
  * `exit 0` — Success.
  * `exit 101` — Input/Source validation failed (e.g., missing file or directory).
  * `exit 102` — Environment/Dependency validation failed (e.g., missing required tool or module).
  * `exit 103` — Configuration/Path validation failed (e.g., invalid config or inaccessible target path).
  * `exit 104` — External command or execution failure.

*Prefer explicit `exit 101–125` over generic `exit 1` in `if/else` checks and `try/catch` blocks when reporting predictable script errors.*

### 3. Console UI & Color Logging (PowerShell)
To maintain consistent visual output within the CLI launcher, never use plain `Write-Output` or `echo` for system messages. You **must use** `Write-Host` with appropriate `-ForegroundColor` flags:
* **Errors & Failures:** `Write-Host "[ERROR XXX]: message" -ForegroundColor Red` (print the custom exit code in the brackets before exit).
* **Warnings & Paths:** `Write-Host "Context info/Path..." -ForegroundColor Yellow`
* **Success Messages:** `Write-Host "[SUCCESS]: message" -ForegroundColor Green`
* **Headers & Diagnostics:** `Write-Host "--- Heading ---" -ForegroundColor Cyan`
* **Minor/Debug details:** `Write-Host "Skipping/Processing..." -ForegroundColor Gray`
<!-- AI_CONTEXT_END -->
