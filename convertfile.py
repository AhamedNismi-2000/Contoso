
import csv
import re
import os

sql_file = "contoso_100k.sql"
output_dir = "csv_files"   # 👈 your desired folder

# Create folder if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

with open(sql_file, "r", encoding="utf-8") as f:
    lines = f.readlines()

table_name = None
columns = []
rows = []

for line in lines:
    line = line.strip()

    # Detect COPY statement
    copy_match = re.match(r"COPY (\S+) \((.+)\) FROM stdin;", line)
    if copy_match:
        table_name = copy_match.group(1).split('.')[-1]
        columns = [col.strip() for col in copy_match.group(2).split(',')]
        rows = []
        continue

    # End of COPY data
    if line == r"\.":
        if table_name and rows:
            output_path = os.path.join(output_dir, f"{table_name}.csv")

            with open(output_path, "w", newline='', encoding="utf-8") as csvfile:
                writer = csv.writer(csvfile)
                writer.writerow(columns)
                writer.writerows(rows)

            print(f"Exported {output_path} with {len(rows)} rows")

        table_name = None
        columns = []
        rows = []
        continue

    # Collect row data
    if table_name:
        row = line.split('\t')  # PostgreSQL COPY uses tab separator
        rows.append(row)
