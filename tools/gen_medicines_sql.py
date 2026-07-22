import openpyxl
import json
import re
import uuid
import datetime

BRANCH = "br_ahmed_awad"
XLSX = "products-export-2026-07-16.xlsx"
OUT = "supabase_seed_medicines.sql"

# مسار نسبي من مجلد tools/ إلى جذر المشروع
import os
_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
XLSX = os.path.join(_ROOT, "products-export-2026-07-16.xlsx")
OUT = os.path.join(_ROOT, "supabase_seed_medicines.sql")

wb = openpyxl.load_workbook(XLSX, read_only=True, data_only=True)
ws = wb.active
rows = ws.iter_rows(values_only=True)
header = next(rows)

seen = set()
medicines = []
now = datetime.datetime.now(datetime.timezone.utc)

def clean_str(v):
    if v is None:
        return None
    return str(v).strip()

def clean_barcode(v):
    s = clean_str(v)
    if s is None or s == "":
        return None
    # remove float artifacts like 6223003200749.0
    if "." in s:
        parts = s.split(".")
        if parts[1].replace("0", "") == "":
            s = parts[0]
    # strip any non-digit (keep digits only for barcode)
    digits = re.sub(r"\D", "", s)
    return digits if digits else s

for row in rows:
    if row is None:
        continue
    name = clean_str(row[0]) if len(row) > 0 else None
    if not name:
        continue
    brand = clean_str(row[1]) if len(row) > 1 else None
    unit = clean_str(row[2]) if len(row) > 2 else None
    unit = unit or "علبة"
    category = clean_str(row[3]) if len(row) > 3 else None

    sku_raw = clean_str(row[5]) if len(row) > 5 else None
    barcode = clean_barcode(sku_raw)
    barcodes = [barcode] if barcode else []

    dedup_key = ("barcode:" + barcode) if barcode else ("name:" + name)
    if dedup_key in seen:
        continue
    seen.add(dedup_key)

    # alert qty (col 8)
    try:
        alert_qty = int(float(row[8])) if len(row) > 8 and row[8] not in (None, "") else 10
    except (ValueError, TypeError):
        alert_qty = 10

    # buy price: prefer excluding tax (col 18) else including (col 17)
    buy = None
    try:
        if len(row) > 18 and row[18] not in (None, ""):
            buy = float(row[18])
        elif len(row) > 17 and row[17] not in (None, ""):
            buy = float(row[17])
    except (ValueError, TypeError):
        buy = None
    buy = buy if buy is not None else 0.0

    sell = 0.0
    try:
        if len(row) > 20 and row[20] not in (None, ""):
            sell = float(row[20])
    except (ValueError, TypeError):
        sell = 0.0

    # expiry (col 9 value, col 10 unit)
    expires_val = None
    try:
        if len(row) > 9 and row[9] not in (None, ""):
            expires_val = float(row[9])
    except (ValueError, TypeError):
        expires_val = None
    raw_unit = clean_str(row[10]) if len(row) > 10 else None
    expiry_unit = raw_unit.lower() if raw_unit else None

    expiry_date = None
    if expires_val and expires_val > 0:
        days = int(expires_val * 30) if expiry_unit == "months" else int(expires_val)
        expiry_date = (now + datetime.timedelta(days=days)).date().isoformat()

    # quantity (col 21)
    qty = 0
    try:
        if len(row) > 21 and row[21] not in (None, ""):
            qty = int(float(row[21]))
    except (ValueError, TypeError):
        qty = 0

    image = clean_str(row[29]) if len(row) > 29 else None
    image = image or "https://cashcl.com/img/default.png"

    medicines.append({
        "id": "med_" + uuid.uuid4().hex,
        "name": name,
        "category": category,
        "barcode": barcode,
        "buy_price": round(buy, 4),
        "sell_price": round(sell, 4),
        "quantity": qty,
        "min_stock": alert_qty,
        "expiry_date": expiry_date,
        "manufacturer": brand,
        "image_url": image,
        "created_at": now.isoformat(),
    })

# Build SQL upsert (chunked inserts). Use ON CONFLICT DO NOTHING since ids are fresh.
lines = []
lines.append("-- Auto-generated seed for branch %s" % BRANCH)
lines.append("-- Deduplicated: %d unique medicines from Excel." % len(medicines))
lines.append("")

chunk = 500
for i in range(0, len(medicines), chunk):
    batch = medicines[i:i+chunk]
    cols = "(id, name, category, barcode, buy_price, sell_price, quantity, min_stock, expiry_date, manufacturer, branch_id, sync_version, last_modified, is_deleted, created_at)"
    lines.append("INSERT INTO public.medicines %s VALUES" % cols)
    val_lines = []
    for m in batch:
        val = "  ('%s', %s, %s, %s, %s, %s, %s, %s, %s, %s, '%s', 1, now(), false, '%s')" % (
            m["id"].replace("'", "''"),
            "'" + m["name"].replace("'", "''") + "'",
            ("'" + m["category"].replace("'", "''") + "'") if m["category"] else "NULL",
            ("'" + m["barcode"] + "'") if m["barcode"] else "NULL",
            m["buy_price"],
            m["sell_price"],
            m["quantity"],
            m["min_stock"],
            ("'" + m["expiry_date"] + "'") if m["expiry_date"] else "NULL",
            ("'" + (m["manufacturer"] or "").replace("'", "''") + "'") if m["manufacturer"] else "NULL",
            BRANCH,
            m["created_at"],
        )
        val_lines.append(val)
    lines.append(",\n".join(val_lines) + ";")
    lines.append("")

with open(OUT, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

print("Total unique medicines:", len(medicines))
print("Written to", OUT)
