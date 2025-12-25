import csv

def generate_inserts_cars(input_filename, output_filename):
    with open(input_filename, 'r', newline='', encoding='utf-8') as csv_in, open(output_filename, 'w', newline='', encoding='utf-8') as sql_out:

        reader = csv.reader(csv_in)
        header = next(reader)

        table_name = input_filename[:-4].upper().replace("-", "_")

        line_prefix = "INSERT INTO " + table_name + "("
        for col in header:
            line_prefix += col.strip() + ','
        line_prefix = line_prefix[:-1] + ") VALUES("

        for row in reader:
            if not row:
                continue
            line_suffix = ""
            for idx, col in enumerate(row):
                if table_name == 'RECEIPTS' and idx == 1:
                    date_split = col.strip()[1:-1].split("-")
                    date_split[0], date_split[2] = date_split[2], date_split[0]
                    if len(date_split[2]) == 1:
                        date_split[2] = '0' + date_split[2]
                    line_suffix += "'" + "-".join(date_split) + "',"
                else:
                    line_suffix += col.strip() + ","
            line_suffix = line_suffix[:-1]
            line = line_prefix + line_suffix + ");\n"
            sql_out.write(line)

def main():
    generate_inserts_cars("customers.csv", "BAKERY-build-customers.sql")
    generate_inserts_cars("goods.csv", "BAKERY-build-goods.sql")
    generate_inserts_cars("items.csv", "BAKERY-build-items.sql")
    generate_inserts_cars("receipts.csv", "BAKERY-build-receipts.sql")

    

if __name__ == "__main__":
    main()