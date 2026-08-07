[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$errors = [System.Collections.Generic.List[string]]::new()

$required = @(
    'README.md', 'ARCHITECTURE.md', 'DECISIONS.md', 'ROADMAP.md',
    'CONTRIBUTING.md', 'docs/adr/README.md', 'docs/adr/template.md',
    'inventory/hosts.yml', 'inventory/services.yml', 'runbooks/README.md',
    'backups/README.md', 'LICENSE', 'SECURITY.md', '.github/workflows/validate.yml'
)

foreach ($relative in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $relative))) {
        $errors.Add("Missing required file: $relative")
    }
}

$markdownFiles = Get-ChildItem -LiteralPath $root -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' }

$linkPattern = [regex]'\[[^\]]+\]\((?!https?://|mailto:|#)([^)]+)\)'
foreach ($file in $markdownFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName
    foreach ($match in $linkPattern.Matches($content)) {
        $targetText = [Uri]::UnescapeDataString(($match.Groups[1].Value -split '#')[0])
        if ([string]::IsNullOrWhiteSpace($targetText)) { continue }
        $target = Join-Path $file.DirectoryName $targetText
        if (-not (Test-Path -LiteralPath $target)) {
            $relativeFile = [IO.Path]::GetRelativePath($root, $file.FullName)
            $errors.Add("Broken local link in ${relativeFile}: $($match.Groups[1].Value)")
        }
    }
}

$allowedStatuses = @('observed', 'target', 'optional', 'retired')
foreach ($inventory in @('inventory/hosts.yml', 'inventory/services.yml')) {
    $path = Join-Path $root $inventory
    if (-not (Test-Path -LiteralPath $path)) { continue }
    foreach ($line in Get-Content -LiteralPath $path) {
        if ($line -match '^\s+status:\s+(.+?)\s*$' -and $Matches[1] -notin $allowedStatuses) {
            $errors.Add("Invalid status '$($Matches[1])' in $inventory")
        }
    }
}

foreach ($inventory in @('inventory/hosts.yml', 'inventory/services.yml')) {
    $path = Join-Path $root $inventory
    $text = Get-Content -Raw -LiteralPath $path
    if ($text -notmatch '(?m)^schema_version:\s+1\s*$' -or $text -notmatch '(?m)^as_of:\s+\d{4}-\d{2}-\d{2}\s*$') {
        $errors.Add("Missing schema_version or ISO as_of in $inventory")
    }
    $entryKey = if ($inventory -like '*hosts*') { 'id' } else { 'name' }
    $blocks = [regex]::Matches($text, "(?ms)^  - ${entryKey}:\s+.+?(?=^  - ${entryKey}:|\z)")
    foreach ($block in $blocks) {
        foreach ($field in @('status', 'evidence')) {
            if ($block.Value -notmatch "(?m)^    ${field}:\s+\S.+$") {
                $errors.Add("Inventory entry missing $field in ${inventory}: $($block.Value.Split([Environment]::NewLine)[0].Trim())")
            }
        }
    }
}

$servicesText = Get-Content -Raw -LiteralPath (Join-Path $root 'inventory/services.yml')
$serviceBlocks = [regex]::Matches($servicesText, '(?ms)^  - name:\s+(.+?)\r?\n.+?(?=^  - name:|\z)')
foreach ($block in $serviceBlocks) {
    $name = $block.Groups[1].Value.Trim()
    if ($block.Value -match '(?m)^    target_platform:\s+citadel\s*$' -and $name -notin @('litellm')) {
        $errors.Add("Citadel placement requires explicit architecture review: $name")
    }
}

foreach ($diagram in Get-ChildItem -LiteralPath (Join-Path $root 'diagrams') -File -Filter '*.mmd') {
    $content = Get-Content -Raw -LiteralPath $diagram.FullName
    if ($content -notmatch '^\s*(flowchart|sequenceDiagram|graph)\b') {
        $errors.Add("Unsupported or missing Mermaid diagram declaration: $($diagram.Name)")
    }
    if (($content.ToCharArray() | Where-Object { $_ -eq '[' }).Count -ne ($content.ToCharArray() | Where-Object { $_ -eq ']' }).Count) {
        $errors.Add("Unbalanced square brackets in Mermaid diagram: $($diagram.Name)")
    }
}

$secretPattern = '(?i)(-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----|(?:api[_-]?key|token|password|secret)\s*[:=]\s*["'']?[A-Za-z0-9+/=_-]{16,})'
$trackedCandidates = Get-ChildItem -LiteralPath $root -Recurse -File |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' -and $_.Name -ne 'validate-docs.ps1' }
foreach ($file in $trackedCandidates) {
    $hit = Select-String -LiteralPath $file.FullName -Pattern $secretPattern -Quiet
    if ($hit) {
        $relativeFile = [IO.Path]::GetRelativePath($root, $file.FullName)
        $errors.Add("Possible committed secret in $relativeFile")
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Documentation validation passed: $($markdownFiles.Count) Markdown files checked."
