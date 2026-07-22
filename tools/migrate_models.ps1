$modelsDir = "D:\projects\work\project-pharmacy\pharmacy_system\lib\app\core\models"
$libDir = "D:\projects\work\project-pharmacy\pharmacy_system\lib"

$modelDirs = @{
    'medicine_model'               = 'inventory'
    'medicine_model.g'             = 'inventory'
    'medicine_model_adapter'       = 'inventory'
    'medicine_unit_model'          = 'inventory'
    'medicine_unit_model.g'        = 'inventory'
    'medicine_unit_model_adapter'  = 'inventory'
    'medicine_search_extension'    = 'inventory'
    'inventory_model'              = 'inventory'
    'inventory_model.g'            = 'inventory'
    'inventory_model_adapter'      = 'inventory'
    'item_batch_model'             = 'inventory'
    'stocktaking_model'            = 'inventory'
    'stocktaking_model.g'          = 'inventory'
    'stocktaking_period_model'     = 'inventory'
    'customer_model'               = 'customer'
    'customer_model_adapter'       = 'customer'
    'customer_group_model'         = 'customer'
    'customer_group_model_adapter' = 'customer'
    'customer_ledger_model'        = 'customer'
    'customer_ledger_model.g'      = 'customer'
    'customer_supplier_model'      = 'customer'
    'customer_supplier_model_adapter' = 'customer'
    'sale_model'                   = 'sales'
    'sale_model.g'                 = 'sales'
    'sale_model_adapter'           = 'sales'
    'purchase_model'               = 'sales'
    'purchase_model.g'             = 'sales'
    'purchase_model_adapter'       = 'sales'
    'return_model'                 = 'sales'
    'return_model.g'               = 'sales'
    'return_model_adapter'         = 'sales'
    'quote_model'                  = 'sales'
    'cashier_shift_model'          = 'sales'
    'user_model'                   = 'security'
    'user_model.g'                 = 'security'
    'user_model_adapter'           = 'security'
    'permission_model'             = 'security'
    'permission_model.g'           = 'security'
    'permission_model_adapter'     = 'security'
    'branch_model'                 = 'security'
    'branch_model.g'               = 'security'
    'branch_model_adapter'         = 'security'
    'crm_model'                    = 'crm'
    'crm_model.g'                  = 'crm'
    'supplier_model'               = 'supplier'
    'supplier_model.g'             = 'supplier'
    'supplier_model_adapter'       = 'supplier'
    'supplier_ledger_model'        = 'supplier'
    'supplier_ledger_model.g'      = 'supplier'
    'archive_record_model'         = 'archive'
    'task_models'                  = 'tasks'
    'sync_queue_item'              = 'base'
    'sync_queue_item.g'            = 'base'
    'sync_queue_item_adapter'      = 'base'
    'error_log_model'              = 'base'
    'error_log_model.g'            = 'base'
    'app_notification_model'       = 'base'
    'correction_model'             = 'base'
    'lookup_model'                 = 'base'
    'lookup_model.g'               = 'base'
    'lookup_model_adapter'         = 'base'
}

# Step 1: Move files to subdirectories
$global:movedCount = 0
foreach ($kv in $modelDirs.GetEnumerator()) {
    $baseName = $kv.Key
    $subDir = $kv.Value
    $sourceFile = Join-Path $modelsDir "$baseName.dart"
    $destDir = Join-Path $modelsDir $subDir
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }
    if (Test-Path $sourceFile) {
        Move-Item -LiteralPath $sourceFile -Destination (Join-Path $destDir "$baseName.dart") -Force
        $global:movedCount++
    }
}
Write-Host "Moved $global:movedCount model files"

# Step 2: Build regex replacements using raw path segments
# We need: models/XXX.dart -> models/SUBDIR/XXX.dart
$replacements = @{}
foreach ($kv in $modelDirs.GetEnumerator()) {
    $baseName = $kv.Key
    $subDir = $kv.Value
    $oldPath = "models/$baseName.dart"
    $newPath = "models/$subDir/$baseName.dart"
    $replacements[$oldPath] = $newPath
}

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$global:updateCount = 0
Get-ChildItem -Path $libDir -Filter "*.dart" -Recurse | Where-Object { $_.FullName -notlike "*\core\models\*" } | ForEach-Object {
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
        $global:updateCount++
    }
}
Write-Host "Updated $global:updateCount files with new model import paths"
