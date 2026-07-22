param(
  [string]$ProjectRoot = "D:\projects\work\project-pharmacy\pharmacy_system"
)

$servicesRoot = Join-Path $ProjectRoot "lib\app\core\services"
$filesToFix = @{}
$count = 0

# ── accounting/ ──
$filesToFix["accounting\correction_service.dart"] = @(
  @('import ''auth_service.dart''', "import '../auth/auth_service.dart'")
)
$filesToFix["accounting\supplier_ledger_service.dart"] = @(
  @("import '../party_ledger_service.dart'", "import 'party_ledger_service.dart'")
)

# ── admin/ ──
$filesToFix["admin\branch_data_service.dart"] = @(
  @("import 'auth_service.dart'", "import '../auth/auth_service.dart'")
  @("import 'sync_service.dart'", "import '../sync_service.dart'")
  @("import 'customer_ledger_service.dart'", "import '../accounting/customer_ledger_service.dart'")
)
$filesToFix["admin\permission_service.dart"] = @(
  @("import 'auth_service.dart'", "import '../auth/auth_service.dart'")
)

# ── auth/ ──
$filesToFix["auth\auth_service.dart"] = @(
  @("import 'sync_service.dart'", "import '../sync_service.dart'")
)

# ── customer/ ──
$filesToFix["customer\crm_service.dart"] = @(
  @("import 'sync_service.dart'", "import '../sync_service.dart'")
)
$filesToFix["customer\customer_group_service.dart"] = @(
  @("import '../auth_service.dart'", "import '../auth/auth_service.dart'")
  @("import '../base_crud_service.dart'", "import '../base_crud_service.dart'")
)
$filesToFix["customer\customer_service.dart"] = @(
  @("import '../sync_service.dart'", "import '../sync_service.dart'")
  @("import '../auth_service.dart'", "import '../auth/auth_service.dart'")
  @("import '../base_crud_service.dart'", "import '../base_crud_service.dart'")
)

# ── inventory/ ──
$filesToFix["inventory\barcode_service.dart"] = @(
  @("import 'package:pharmacy_system/app/core/services/auth_service.dart'", "import 'package:pharmacy_system/app/core/services/auth/auth_service.dart'")
)
$filesToFix["inventory\stocktaking_service.dart"] = @(
  @("import '../auth_service.dart'", "import '../auth/auth_service.dart'")
  @("import '../stock_mutation_service.dart'", "import 'stock_mutation_service.dart'")
)
$filesToFix["inventory\stock_mutation_service.dart"] = @(
  @("import '../sync_service.dart'", "import '../sync_service.dart'")
)

# ── operations/ ──
$filesToFix["operations\void_operations_service.dart"] = @(
  @("import 'auth_service.dart'", "import '../auth/auth_service.dart'")
  @("import 'branch_data_service.dart'", "import '../admin/branch_data_service.dart'")
  @("import 'correction_service.dart'", "import '../accounting/correction_service.dart'")
)

# ── sales/ ──
$filesToFix["sales\cashier_shift_service.dart"] = @(
  @("import 'auth_service.dart'", "import '../auth/auth_service.dart'")
)
$filesToFix["sales\quote_service.dart"] = @(
  @("import 'auth_service.dart'", "import '../auth/auth_service.dart'")
)

# ── supplier/ ──
$filesToFix["supplier\supplier_service.dart"] = @(
  @("import '../sync_service.dart'", "import '../sync_service.dart'")
  @("import '../auth_service.dart'", "import '../auth/auth_service.dart'")
  @("import '../base_crud_service.dart'", "import '../base_crud_service.dart'")
)

# ── tasks/ ──
$filesToFix["tasks\task_service.dart"] = @(
  @("import '../auth_service.dart'", "import '../auth/auth_service.dart'")
)

# Apply fixes
foreach ($relPath in $filesToFix.Keys) {
  $fullPath = Join-Path $servicesRoot $relPath
  if (!(Test-Path $fullPath)) {
    Write-Output "  NOT FOUND: $relPath"
    continue
  }
  $content = Get-Content -Path $fullPath -Raw
  $changed = $false
  foreach ($fix in $filesToFix[$relPath]) {
    $oldText = $fix[0]
    $newText = $fix[1]
    if ($content.Contains($oldText)) {
      $content = $content -replace [regex]::Escape($oldText), $newText
      $changed = $true
    }
  }
  if ($changed) {
    Set-Content -Path $fullPath -Value $content -Encoding UTF8 -NoNewline
    $count++
    Write-Output "  Fixed: $relPath"
  }
}

Write-Output "`nFixed $count files. Done!"
