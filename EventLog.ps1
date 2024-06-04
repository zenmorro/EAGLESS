$ErrorActionPreference = "SilentlyContinue"
Clear-Host

Write-Host "";
Write-Host "";
Write-Host -ForegroundColor Red "███████  █████   ██████  ██      ███████     ███████ ███████";
Write-Host -ForegroundColor Red "██      ██   ██ ██       ██      ██          ██      ██      ";
Write-Host -ForegroundColor Red "█████   ███████ ██   ███ ██      █████       ███████ ███████ ";
Write-Host -ForegroundColor Red "██      ██   ██ ██    ██ ██      ██               ██      ██";
Write-Host -ForegroundColor Red "███████ ██   ██  ██████  ███████ ███████     ███████ ███████";
Write-Host "";
Write-Host -ForegroundColor Blue "Made By ZenMorro For Eagle SS - " -NoNewLine
Write-Host -ForegroundColor Red "https://discord.gg/NGTSNsvRGV";
Write-Host "";

function Test-Admin {;$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent());$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);}
if (!(Test-Admin)) {
    Write-Warning "Please Run This Script as Admin."
    Start-Sleep 10
    Exit
}
# Ottenere eventi dal registro applicazioni
$applicationEvents = Get-WinEvent -LogName Application -FilterXPath "*[System[(EventID=1000 or EventID=105 or EventID=3079 or EventID=400 or EventID=410 or EventID=420)]]" -ErrorAction SilentlyContinue

# Ottenere eventi dal registro sistema per Kernel-PnP
$systemEvents = Get-WinEvent -LogName System -FilterXPath "*[System[(EventID=404 or EventID=400 or EventID=410 or EventID=411)]]" -ErrorAction SilentlyContinue

# Ottenere eventi dal registro sicurezza
$securityEvents = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=1102 or EventID=1100 or EventID=4616 or EventID=4688 or EventID=4689 or EventID=4697 or EventID=6416 or EventID=6420 or EventID=4799)]]" -ErrorAction SilentlyContinue

# Creare una lista di oggetti personalizzati per gli eventi di applicazione
$applicationEventsList = $applicationEvents | ForEach-Object {
    [PSCustomObject]@{
        LogName = "Application"
        Id = $_.Id
        TimeCreated = $_.TimeCreated
        ProviderName = $_.ProviderName
        Message = $_.Message
    }
}

# Creare una lista di oggetti personalizzati per gli eventi di sistema
$systemEventsList = $systemEvents | ForEach-Object {
    [PSCustomObject]@{
        LogName = "System"
        Id = $_.Id
        TimeCreated = $_.TimeCreated
        ProviderName = $_.ProviderName
        Message = $_.Message
    }
}

# Creare una lista di oggetti personalizzati per gli eventi di sicurezza
$securityEventsList = $securityEvents | ForEach-Object {
    [PSCustomObject]@{
        LogName = "Security"
        Id = $_.Id
        TimeCreated = $_.TimeCreated
        ProviderName = $_.ProviderName
        Message = $_.Message
    }
}

# Unire le liste degli eventi
$allEventsList = $applicationEventsList + $systemEventsList + $securityEventsList

# Visualizzare gli eventi in una finestra stile griglia di Excel
$allEventsList | Out-GridView -Title "Eventi Applicazione, Sistema e Sicurezza"
