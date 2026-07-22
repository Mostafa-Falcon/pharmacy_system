param(
  [string]$ProjectRoot = "D:\projects\work\project-pharmacy\pharmacy_system"
)

$servicesRoot = Join-Path $ProjectRoot "lib\app\core\services"

Write-Output "Fixing imports in moved service files..."

# Get all dart files in subdirectories
$movedFiles = Get-ChildItem -Path $servicesRoot -Recurse -Filter "*.dart" | Where-Object { $_.DirectoryName -ne $servicesRoot }

foreach ($file in $movedFiles) {
  $content = Get-Content -Path $file.FullName -Raw
  $changed = $false
  $orig = $content

  # Fix 1: `import '../models/` -> `import '../../models/`
  $content = $content -replace "import '\.\./models/", "import '../../models/"
  
  # Fix 2: `import '../utils/` -> `import '../../utils/`
  $content = $content -replace "import '\.\./utils/", "import '../../utils/"
  
  # Fix 3: `import '../config/` -> `import '../../config/`
  $content = $content -replace "import '\.\./config/", "import '../../config/"
  
  # Fix 4: `import '../widgets/` -> `import '../../widgets/`
  $content = $content -replace "import '\.\./widgets/", "import '../../widgets/"

  # Fix 5: `import 'XXXX_service.dart'` (sibling file now in subdir) -> `import '../XXXX_service.dart'`
  # Only catch imports that are just filenames (not relative paths)
  $content = $content -replace "(?m)^import '([a-zA-Z][a-zA-Z0-9_]*\.dart)';$", "import '../`$1';"
  
  # Fix 6: `import '../services/XXX.dart'` -> `import '../XXX.dart'` or `import '../SUB/XXX.dart'`
  # These are imports from within core/services/ that reference other services
  # From a subdirectory like customer/, `../sync_service.dart` goes up to services/
  $content = $content -replace "import '\.\./services/", "import '../"

  if ($content -ne $orig) {
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
    $changed = $true
    Write-Output "  Fixed: $($file.FullName)"
  }
}

Write-Output "Done!"
