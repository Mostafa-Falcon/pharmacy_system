$servicesDir = "D:\projects\work\project-pharmacy\pharmacy_system\lib\app\core\services"
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

$movedServices = @{
    'auth_service'             = 'auth'
    'auth_session'             = 'auth'
    'auth_device_lock'         = 'auth'
    'auth_user_sync'           = 'auth'
    'password_hasher'          = 'auth'
    'secure_storage_helper'    = 'auth'
    'branch_data_service'      = 'admin'
    'permission_service'       = 'admin'
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

$rootServices = @(
    'sync_service'
    'print_service'
    'excel_import_service'
    'lookup_service'
    'hive_ledger_service'
    'party_ledger_service'
    'storage_service'
    'sound_service'
    'base_crud_service'
    'supabase_client'
    'theme_service'
)

$global:fixCount = 0

Get-ChildItem -Path $servicesDir -Filter "*.dart" -Recurse | Where-Object { $_.Directory.Name -ine "services" } | ForEach-Object {
    $file = $_.FullName
    $content = [System.IO.File]::ReadAllText($file, $utf8NoBom)
    $original = $content

    $dirName = $_.Directory.Name  # e.g., 'auth', 'admin', etc.

    # Fix 1: '../ → '../../ (add one more level up for parent-dir relative imports)
    # Fix the pattern 'import '../...' → 'import '../../...'
    $content = $content -replace "'\.\.\/", "'../../"

    # Fix 2: same-directory imports for ROOT services
    foreach ($svc in $rootServices) {
        $content = $content -replace "import '$svc\.dart'", "import '../$svc.dart'"
    }

    # Fix 3: same-directory imports for MOVED services
    foreach ($kv in $movedServices.GetEnumerator()) {
        $name = $kv.Key
        $targetDir = $kv.Value
        if ($targetDir -eq $dirName) {
            # Same directory - import stays as is (just 'name.dart')
            continue
        }
        # Different directory: import 'name.dart' → import '../DIR/name.dart'
        $content = $content -replace "import '$name\.dart'", "import '../$targetDir/$name.dart'"
    }

    # Fix 4: absolute package imports in moved services
    foreach ($kv in $movedServices.GetEnumerator()) {
        $name = $kv.Key
        $targetDir = $kv.Value
        $content = $content -replace [regex]::Escape("services/$name.dart"), "services/$targetDir/$name.dart"
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($file, $content, $utf8NoBom)
        $global:fixCount++
        Write-Host "  Fixed: $($_.Name) (in $dirName/)"
    }
}

Write-Host "Fixed $global:fixCount moved service files"
