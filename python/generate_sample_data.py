import csv
import random
from pathlib import Path

random.seed(11)

root = Path(file).resolve().parents[1]
raw_dir = root / "data" / "raw"
raw_dir.mkdir(parents=True, exist_ok=True)

hospitals = ["University", "Community", "North", "South"]
departments = ["Emergency Dept", "Med Surg", "ICU", "Cardiology Clinic", "Orthopedics Clinic"]
roles = ["RN", "Tech", "Clerical"]
months = ["2026-01", "2026-02", "2026-03"]

rows = []

for month in months:
for hospital in hospitals:
for dept in departments:
for role in roles:
rows.append([
month,
hospital,
dept,
role,
random.randint(250, 2200),
random.randint(700, 1800),
random.randint(40, 180),
random.randint(10, 180),
random.randint(0, 120),
round(random.uniform(6, 18), 1),
round(random.uniform(6, 19), 1),
round(random.uniform(0.9, 1.5), 2),
])

with open(raw_dir / "raw_department_productivity.csv", "w", newline="") as f:
w = csv.writer(f)
w.writerow([
"month","hospital","department","role_group","encounters","productive_hours","nonproductive_hours","overtime_hours","agency_hours","budgeted_fte","worked_fte","productivity_target"
])
w.writerows(rows)

print("data regenerated")