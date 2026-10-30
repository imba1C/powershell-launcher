# Устанавливаем кодировку вывода в UTF-8, чтобы русский текст в консоли не превращался в "крякозябры"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "Hello, World!" -ForegroundColor Cyan
Write-Host "Привет, мир! Скрипт успешно запущен." -ForegroundColor Green
Write-Host ""
