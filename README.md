---
# Enterprise Sales & Analytics Core

A robust, full-stack desktop application for managing sales, inventory, and affiliate teams. Built as a 2nd-year University project and later refined into a professional-grade tool, this project demonstrates a strong understanding of relational database design, Python application architecture, and modern UI/UX principles.

---

## -> Key Features

- **Executive Dashboard**: Real-time business intelligence featuring total revenue, order counts, and active customer metrics.
- **Relational Data Management**: Complete CRUD operations for Customers, Products, and Transactions with strict referential integrity.
- **Advanced Analytics**: Built-in reporting engine for sales performance, geospatial customer analysis, and inventory tracking.
- **Robust Architecture**: Clean separation of concerns between the database layer (`sqlite3`), business logic, and the UI.
- **Modern UI**: A polished "Enterprise" theme with a responsive sidebar navigation and custom metric widgets.

## -> Technical Stack

- **Language**: Python 3.11+
- **Database**: SQLite (SQL/DLD/DML)
- **GUI Framework**: Tkinter (Custom Themed)
- **Design Patterns**: OOP, Singleton-style Database Manager, Component-based UI.

## -> Database Schema

The project utilizes a normalized 3NF schema consisting of 6 tables:
- `team`: Affiliate team management and discount rates.
- `seller`: Representative profiles and commission tracking.
- `product`: Inventory management (stock, wholesale vs. retail).
- `customer`: Client demographics and balance tracking.
- `order_table`: Transaction headers.
- `order_details`: Line-item transaction data.

## -> Installation & Usage

1. **Clone the repository**:
   ```bash
   git clone https://github.com/KostasDes06/sales_analytics_core.git
   cd sales_analytics_core
   ```
2. **Install the dependencies**:
  ```bash
   pip install tkinter sqlite3
  ```
3. **Run the application**:
   ```bash
   python3 sales_app.py
   ```
   *Note: On the first run, the system will automatically initialize the `sales.db` database using the provided `salesdb(1).sql` script.*

## -> LLM usage for the project
  - `Google's Gemini` contributed by suggesting the color palette and the tab section's names on the left and generating the Python code for them.
  - `OpenAI's ChatGPT` contributed by generating the SQL code for inserting values in the salesdb(1).sql file.
   
---

