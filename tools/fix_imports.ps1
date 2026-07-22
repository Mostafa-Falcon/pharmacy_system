param(
  [string]$ProjectRoot = "D:\projects\work\project-pharmacy\pharmacy_system"
)

$libRoot = Join-Path $ProjectRoot "lib"
$testRoot = Join-Path $ProjectRoot "test"
$toolsDir = Join-Path $ProjectRoot "tools"

$modelMoves = @{
  'archive_record_model' = 'archive/archive_record_model'
  'error_log_model' = 'base/error_log_model'
  'error_log_model.g' = 'base/error_log_model.g'
  'app_notification_model' = 'base/app_notification_model'
  'app_notification_model.g' = 'base/app_notification_model.g'
  'sync_queue_item' = 'base/sync_queue_item'
  'sync_queue_item.g' = 'base/sync_queue_item.g'
  'sync_queue_item_adapter' = 'base/sync_queue_item_adapter'
  'task_models' = 'base/task_models'
  'correction_model' = 'base/correction_model'
  'lookup_model' = 'base/lookup_model'
  'lookup_model.g' = 'base/lookup_model.g'
  'lookup_model_adapter' = 'base/lookup_model_adapter'
  'crm_model' = 'crm/crm_model'
  'crm_model.g' = 'crm/crm_model.g'
  'customer_model' = 'customer/customer_model'
  'customer_model_adapter' = 'customer/customer_model_adapter'
  'customer_group_model' = 'customer/customer_group_model'
  'customer_group_model_adapter' = 'customer/customer_group_model_adapter'
  'customer_ledger_model' = 'customer/customer_ledger_model'
  'customer_ledger_model.g' = 'customer/customer_ledger_model.g'
  'customer_supplier_model' = 'customer/customer_supplier_model'
  'customer_supplier_model_adapter' = 'customer/customer_supplier_model_adapter'
  'medicine_model' = 'inventory/medicine_model'
  'medicine_model.g' = 'inventory/medicine_model.g'
  'medicine_model_adapter' = 'inventory/medicine_model_adapter'
  'medicine_unit_model' = 'inventory/medicine_unit_model'
  'medicine_unit_model.g' = 'inventory/medicine_unit_model.g'
  'medicine_unit_model_adapter' = 'inventory/medicine_unit_model_adapter'
  'medicine_search_extension' = 'inventory/medicine_search_extension'
  'inventory_model' = 'inventory/inventory_model'
  'inventory_model.g' = 'inventory/inventory_model.g'
  'inventory_model_adapter' = 'inventory/inventory_model_adapter'
  'item_batch_model' = 'inventory/item_batch_model'
  'stocktaking_model' = 'inventory/stocktaking_model'
  'stocktaking_model.g' = 'inventory/stocktaking_model.g'
  'stocktaking_period_model' = 'inventory/stocktaking_period_model'
  'sale_model' = 'sales/sale_model'
  'sale_model.g' = 'sales/sale_model.g'
  'sale_model_adapter' = 'sales/sale_model_adapter'
  'purchase_model' = 'sales/purchase_model'
  'purchase_model.g' = 'sales/purchase_model.g'
  'purchase_model_adapter' = 'sales/purchase_model_adapter'
  'return_model' = 'sales/return_model'
  'return_model.g' = 'sales/return_model.g'
  'return_model_adapter' = 'sales/return_model_adapter'
  'cashier_shift_model' = 'sales/cashier_shift_model'
  'quote_model' = 'sales/quote_model'
  'branch_model' = 'security/branch_model'
  'branch_model.g' = 'security/branch_model.g'
  'branch_model_adapter' = 'security/branch_model_adapter'
  'permission_model' = 'security/permission_model'
  'permission_model.g' = 'security/permission_model.g'
  'permission_model_adapter' = 'security/permission_model_adapter'
  'user_model' = 'security/user_model'
  'user_model.g' = 'security/user_model.g'
  'user_model_adapter' = 'security/user_model_adapter'
  'supplier_model' = 'supplier/supplier_model'
  'supplier_model.g' = 'supplier/supplier_model.g'
  'supplier_model_adapter' = 'supplier/supplier_model_adapter'
  'supplier_ledger_model' = 'supplier/supplier_ledger_model'
  'supplier_ledger_model.g' = 'supplier/supplier_ledger_model.g'
}

Write-Output "Fixing imports across all source files..."

# Fix lib/ files
$allDart = Get-ChildItem -Path $libRoot -Recurse -Filter "*.dart"
$count = 0
foreach ($file in $allDart) {
  $content = Get-Content -Path $file.FullName -Raw
  $changed = $false
  foreach ($oldBase in $modelMoves.Keys) {
    $newBase = $modelMoves[$oldBase]
    # Match both "models/oldBase" and "models/oldBase.dart" 
    $oldPattern = "models/$oldBase"
    $newPattern = "models/$newBase"
    if ($content.IndexOf($oldPattern, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
      $content = $content -replace [regex]::Escape($oldPattern), $newPattern
      $changed = $true
    }
  }
  if ($changed) {
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
    $count++
  }
}
Write-Output "  Updated $count files in lib/"

# Fix test/ files
if (Test-Path $testRoot) {
  $testDart = Get-ChildItem -Path $testRoot -Recurse -Filter "*.dart"
  $tcount = 0
  foreach ($file in $testDart) {
    $content = Get-Content -Path $file.FullName -Raw
    $changed = $false
    foreach ($oldBase in $modelMoves.Keys) {
      $newBase = $modelMoves[$oldBase]
      $oldPattern = "models/$oldBase"
      $newPattern = "models/$newBase"
      if ($content.IndexOf($oldPattern, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
        $content = $content -replace [regex]::Escape($oldPattern), $newPattern
        $changed = $true
      }
    }
    if ($changed) {
      Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
      $tcount++
    }
  }
  Write-Output "  Updated $tcount files in test/"
}

# Fix tools/ files
if (Test-Path $toolsDir) {
  $toolsDart = Get-ChildItem -Path $toolsDir -Recurse -Filter "*.dart"
  $tcount = 0
  foreach ($file in $toolsDart) {
    $content = Get-Content -Path $file.FullName -Raw
    $changed = $false
    foreach ($oldBase in $modelMoves.Keys) {
      $newBase = $modelMoves[$oldBase]
      $oldPattern = "models/$oldBase"
      $newPattern = "models/$newBase"
      if ($content.IndexOf($oldPattern, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
        $content = $content -replace [regex]::Escape($oldPattern), $newPattern
        $changed = $true
      }
    }
    if ($changed) {
      Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
      $tcount++
    }
  }
  Write-Output "  Updated $tcount files in tools/"
}

Write-Output "Done!"
