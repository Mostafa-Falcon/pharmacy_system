$servicesDir = "D:\projects\work\project-pharmacy\pharmacy_system\lib\app\core\services"
$libDir = "D:\projects\work\project-pharmacy\pharmacy_system\lib"

$serviceDirs = @{
    'auth_service'             = 'auth'
    'auth_session'             = 'auth'
    'auth_device_lock'         = 'auth'
    'auth_user_sync'           = 'auth'
    'password_hasher'          = 'auth'
    'secure_storage_helper'    = 'auth'
    'branch_data_service'      = 'admin'
    'permission_service'       = 'admin'
    'branch_service'           = 'admin'
    'customer_service'         = 'customer'
    'customer_group_service'   = 'customer'
    'customer_ledger_service'  = 'customer'
    'crm_service'              = 'crm'
    'supplier_service'         = 'supplier'
    'supplier_ledger_service'  = 'supplier'
    'cashier_shift_service'    = 'sales'
    'stocktaking_service'      = 'inventory'
    'stock_mutation_service'   = 'inventory'
    'barcode_service'          = 'inventory'
    'batch_service'            = 'inventory'
    'task_service'             = 'tasks'
    'correction_service'       = 'accounting'
    'void_operations_service'  = 'operations'
    'quote_service'            = 'sales'
    'receipt_number_service'   = 'operations'
    'export_service'           = 'operations'
}

# Step 1: Move service files to subdirectories
$global:svcMoved = 0
foreach ($kv in $serviceDirs.GetEnumerator()) {
    $baseName = $kv.Key
    $subDir = $kv.Value
    $sourceFile = Join-Path $servicesDir "$baseName.dart"
    $destDir = Join-Path $servicesDir $subDir
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }
    if (Test-Path $sourceFile) {
        Move-Item -LiteralPath $sourceFile -Destination (Join-Path $destDir "$baseName.dart") -Force
        $global:svcMoved++
    }
}
Write-Host "Moved $global:svcMoved service files"

$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# Step 2: Update imports in files OUTSIDE core/services/
$replacements = @{}
foreach ($kv in $serviceDirs.GetEnumerator()) {
    $baseName = $kv.Key
    $subDir = $kv.Value
    $oldPath = "services/$baseName.dart"
    $newPath = "services/$subDir/$baseName.dart"
    $replacements[$oldPath] = $newPath
}

$global:svcUpdated = 0
Get-ChildItem -Path $libDir -Filter "*.dart" -Recurse | Where-Object { $_.FullName -notlike "*\core\services\*" } | ForEach-Object {
    $file = $_.FullName
    try {
        $content = [System.IO.File]::ReadAllText($file, $utf8NoBom)
    } catch {
        Write-Host "  SKIP (read error): $($_.Name)"
        return
    }
    $original = $content
    foreach ($kv in $replacements.GetEnumerator()) {
        $content = $content -replace [regex]::Escape($kv.Key), $kv.Value
    }
    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($file, $content, $utf8NoBom)
        $global:svcUpdated++
    }
}
Write-Host "Updated $global:svcUpdated files with new service import paths"
