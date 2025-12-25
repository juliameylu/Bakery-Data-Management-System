# Bakery-Data-Management-System

A relational SQL database that models a retail bakery’s operations, including
customers, products, orders, and loyalty logic. The project demonstrates
schema design, data integrity, and business logic implemented through
stored procedures.

---

## Overview
This project simulates a production-style bakery database. It supports
order processing, customer loyalty evaluation, and inventory management,
with data loaded from structured CSV files. Emphasis is placed on clean
schema design, referential integrity, and reusable SQL procedures.

---

## Key Features
- Normalized relational schema with foreign key constraints
- Order processing and receipt generation
- Customer loyalty evaluation via stored procedures
- CSV-driven data population
- Reusable, testable SQL scripts

---

## Tech Stack
- SQL (DDL, DML, stored procedures)
- SQLite / PostgreSQL / MySQL (portable design)
- Python (CSV → SQL insert generation)

---

## Project Structure
- `BAKERY-setup.sql` – Database schema definition  
- `BAKERY-build-*.sql` – Data insertion scripts  
- `prcProcessOrder.sql` – Order processing logic  
- `prcCheckLoyaltyStatus.sql` – Loyalty qualification logic  
- `prcAddNewGood.sql` – Product management  
- `BAKERY_queries.sql` – Analytical queries  
- `BAKERY-test.sql` – Validation and testing  
- `*.csv` – Source data files  

---

## Usage
1. Create schema:
```sql
.read BAKERY-setup.sql
```
2. Load data and procedures:
```sql
.read BAKERY-build-customers.sql
.read BAKERY-build-goods.sql
.read BAKERY-build-receipts.sql
.read BAKERY-build-items.sql
.read prcAddNewGood.sql
.read prcCheckLoyaltyStatus.sql
.read prcProcessOrder.sql
```
3. Run queries or tests:
```sql
.read BAKERY_queries.sql
```

## Author
Julia Lu

LinkedIn: [https://linkedin.com/in/julia-mey-lu](https://www.linkedin.com/in/julia-mey-lu/)
