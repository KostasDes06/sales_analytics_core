import tkinter as tk
from tkinter import ttk, messagebox
import sqlite3
import os
import logging
from datetime import date

# --- CONFIGURATION & CONSTANTS ---
DB_NAME = "sales.db"
SQL_FILE = "salesdb(1).sql"
APP_TITLE = "Team 12 | Enterprise Sales Analytics"
WINDOW_SIZE = "1240x850"
MIN_SIZE = (1100, 750)

# --- THEME COLORS (Enterprise Palette) ---
CLR_BG = "#FFFFFF"           
CLR_SIDEBAR = "#0f172a"     # Deeper Slate 900
CLR_ACCENT = "#2563eb"       # Vibrant Blue 600
CLR_HEADER = "#f1f5f9"       
CLR_TEXT = "#1e293b"         
CLR_TEXT_LIGHT = "#64748b"   
CLR_CARD_BG = "#ffffff"      
CLR_BORDER = "#e2e8f0"       

# --- LOGGING SETUP ---
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# --- DATABASE LAYER ---
class DatabaseManager:
    def __init__(self, db_name):
        self.db_name = db_name

    def get_connection(self):
        try:
            conn = sqlite3.connect(self.db_name)
            conn.execute("PRAGMA foreign_keys = ON;")
            return conn
        except sqlite3.Error as e:
            logger.error(f"Connection error: {e}")
            return None

    def initialize_from_sql(self, sql_file):
        if os.path.exists(self.db_name): return True
        if not os.path.exists(sql_file): return False
        try:
            conn = self.get_connection()
            if not conn: return False
            with open(sql_file, 'r', encoding='utf-8') as f:
                conn.executescript(f.read())
            conn.commit()
            conn.close()
            return True
        except Exception as e:
            logger.error(f"Init failed: {e}")
            return False

    def execute_query(self, query, params=()):
        conn = self.get_connection()
        if not conn: return [], []
        try:
            cursor = conn.cursor()
            cursor.execute(query, params)
            rows = cursor.fetchall()
            columns = [description[0] for description in cursor.description]
            return rows, columns
        except sqlite3.Error as e:
            raise e
        finally:
            conn.close()

    def execute_non_query(self, sql, params=()):
        conn = self.get_connection()
        if not conn: return False
        try:
            cursor = conn.cursor()
            cursor.execute(sql, params)
            conn.commit()
            return True
        except sqlite3.Error as e:
            raise e
        finally:
            conn.close()

# --- CUSTOM UI WIDGETS ---

class MetricCard(tk.Frame):
    def __init__(self, parent, title, value, icon_text="📊"):
        super().__init__(parent, bg=CLR_CARD_BG, highlightthickness=1, highlightbackground=CLR_BORDER)
        self.pack_propagate(False)
        
        container = tk.Frame(self, bg=CLR_CARD_BG, padx=20, pady=20)
        container.pack(expand=True, fill="both")
        
        tk.Label(container, text=icon_text, font=("Segoe UI", 24), bg=CLR_CARD_BG).pack(side="left", padx=(0,15))
        
        info_frame = tk.Frame(container, bg=CLR_CARD_BG)
        info_frame.pack(side="left", fill="y")
        
        tk.Label(info_frame, text=title, font=("Segoe UI", 10), fg=CLR_TEXT_LIGHT, bg=CLR_CARD_BG).pack(anchor="w")
        self.label_value = tk.Label(info_frame, text=value, font=("Segoe UI Bold", 20), fg=CLR_TEXT, bg=CLR_CARD_BG)
        self.label_value.pack(anchor="w")

    def set_value(self, val):
        self.label_value.config(text=str(val))

class SidebarButton(tk.Button):
    def __init__(self, parent, text, command, **kwargs):
        super().__init__(parent, text=text, command=command, 
                         bg=CLR_SIDEBAR, fg="#94a3b8", 
                         font=("Segoe UI Semibold", 11), bd=0, 
                         activebackground="#1e293b", activeforeground="white",
                         padx=25, pady=15, anchor="w", cursor="hand2", **kwargs)
        self.bind("<Enter>", lambda e: self.config(bg="#1e293b", fg="white"))
        self.bind("<Leave>", lambda e: self.config(bg=CLR_SIDEBAR, fg="#94a3b8"))

# --- VIEW COMPONENTS ---

class HomeView(tk.Frame):
    def __init__(self, parent, db_manager):
        super().__init__(parent, bg=CLR_BG)
        self.db_manager = db_manager
        self.setup_ui()

    def setup_ui(self):
        # Header / Welcome
        header_frame = tk.Frame(self, bg=CLR_BG)
        header_frame.pack(fill="x", padx=40, pady=(40,20))
        tk.Label(header_frame, text="Executive Command Center", font=("Segoe UI Bold", 26), bg=CLR_BG, fg=CLR_TEXT).pack(anchor="w")
        tk.Label(header_frame, text="Welcome back. Here is your enterprise performance summary for today.", font=("Segoe UI", 11), bg=CLR_BG, fg=CLR_TEXT_LIGHT).pack(anchor="w", pady=(5,0))

        # Main Scrollable Area
        scroll_container = tk.Canvas(self, bg=CLR_BG, highlightthickness=0)
        scrollbar = ttk.Scrollbar(self, orient="vertical", command=scroll_container.yview)
        self.scrollable_frame = tk.Frame(scroll_container, bg=CLR_BG)

        self.scrollable_frame.bind("<Configure>", lambda e: scroll_container.configure(scrollregion=scroll_container.bbox("all")))

        scroll_container.create_window((0, 0), window=self.scrollable_frame, anchor="nw")
        scroll_container.configure(yscrollcommand=scrollbar.set)

        scroll_container.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")

        # 1. Metrics Grid
        metrics_container = tk.Frame(self.scrollable_frame, bg=CLR_BG, padx=40, pady=10)
        metrics_container.pack(fill="x")
        
        self.card_rev = MetricCard(metrics_container, "Total Revenue", "$0.00", "💰")
        self.card_rev.grid(row=0, column=0, padx=(0,15), pady=10, sticky="nsew")
        
        self.card_orders = MetricCard(metrics_container, "Total Orders", "0", "🛍️")
        self.card_orders.grid(row=0, column=1, padx=15, pady=10, sticky="nsew")
        
        self.card_cust = MetricCard(metrics_container, "Active Customers", "0", "👥")
        self.card_cust.grid(row=0, column=2, padx=15, pady=10, sticky="nsew")
        
        self.card_stock = MetricCard(metrics_container, "Inventory SKUs", "0", "📦")
        self.card_stock.grid(row=0, column=3, padx=(15,0), pady=10, sticky="nsew")

        metrics_container.columnconfigure((0,1,2,3), weight=1)

        # 2. Middle Section: Insights & Highlights
        insight_section = tk.Frame(self.scrollable_frame, bg=CLR_BG, padx=40, pady=20)
        insight_section.pack(fill="x")

        # Left: Business Intelligence
        bi_frame = tk.LabelFrame(insight_section, text="Business Insights", bg=CLR_BG, padx=20, pady=20, font=("Segoe UI Bold", 12), fg=CLR_TEXT)
        bi_frame.pack(side="left", fill="both", expand=True, padx=(0,10))

        self.lbl_top_cust = self.create_insight_row(bi_frame, "Top Performing Customer:", "N/A")
        self.lbl_top_seller = self.create_insight_row(bi_frame, "Lead Sales Representative:", "N/A")
        self.lbl_avg_order = self.create_insight_row(bi_frame, "Average Order Value:", "$0.00")
        self.lbl_team_count = self.create_insight_row(bi_frame, "Registered Affiliate Teams:", "0")
        
        # Right: Company Profile
        profile_frame = tk.LabelFrame(insight_section, text="Enterprise Profile", bg=CLR_BG, padx=20, pady=20, font=("Segoe UI Bold", 12), fg=CLR_TEXT)
        profile_frame.pack(side="right", fill="both", expand=True, padx=(10,0))

        profile_text = (
            "Team 12 Enterprise Core is a leading-edge sales and logistics platform. "
            "Our data architecture ensures seamless integration between inventory, sales representatives, "
            "and client demographics. Currently connected to the Production Environment (sales.db)."
        )
        tk.Label(profile_frame, text=profile_text, wraplength=400, justify="left", font=("Segoe UI", 10), bg=CLR_BG, fg=CLR_TEXT).pack(anchor="w")

        # 3. Bottom Section: Recent Activity Table
        activity_section = tk.Frame(self.scrollable_frame, bg=CLR_BG, padx=40, pady=20)
        activity_section.pack(fill="x")
        
        tk.Label(activity_section, text="Recent Transactions", font=("Segoe UI Bold", 14), bg=CLR_BG, fg=CLR_TEXT).pack(anchor="w", pady=(0,15))
        
        tbl_container = tk.Frame(activity_section, bg="white", bd=1, relief="flat", highlightthickness=1, highlightbackground=CLR_BORDER)
        tbl_container.pack(fill="x")

        self.recent_tree = ttk.Treeview(tbl_container, show="headings", height=8)
        self.recent_tree["columns"] = ("Date", "Customer", "Amount")
        for col in self.recent_tree["columns"]:
            self.recent_tree.heading(col, text=col.upper())
            self.recent_tree.column(col, anchor="center")
        self.recent_tree.pack(fill="x")

        self.refresh()

    def create_insight_row(self, parent, label, val):
        f = tk.Frame(parent, bg=CLR_BG, pady=8)
        f.pack(fill="x")
        tk.Label(f, text=label, font=("Segoe UI", 10), fg=CLR_TEXT_LIGHT, bg=CLR_BG).pack(side="left")
        v = tk.Label(f, text=val, font=("Segoe UI Semibold", 10), fg=CLR_TEXT, bg=CLR_BG)
        v.pack(side="right")
        return v

    def refresh(self):
        try:
            # 1. Main Metrics
            rev, _ = self.db_manager.execute_query("SELECT SUM(Price) FROM order_table")
            ord_cnt, _ = self.db_manager.execute_query("SELECT COUNT(*) FROM order_table")
            cust_cnt, _ = self.db_manager.execute_query("SELECT COUNT(*) FROM customer")
            prod_cnt, _ = self.db_manager.execute_query("SELECT COUNT(*) FROM product")

            self.card_rev.set_value(f"${rev[0][0]:,.2f}" if rev[0][0] else "$0.00")
            self.card_orders.set_value(ord_cnt[0][0])
            self.card_cust.set_value(cust_cnt[0][0])
            self.card_stock.set_value(prod_cnt[0][0])

            # 2. Insights
            # Top Customer
            top_c, _ = self.db_manager.execute_query("""
                SELECT c.Fullname FROM order_table o 
                JOIN customer c ON o.Customer_ID = c.Customer_ID 
                GROUP BY o.Customer_ID ORDER BY SUM(o.Price) DESC LIMIT 1
            """)
            if top_c: self.lbl_top_cust.config(text=top_c[0][0])

            # Top Seller
            top_s, _ = self.db_manager.execute_query("""
                SELECT s.Fullname FROM order_table o 
                JOIN seller s ON o.Seller_ID = s.Seller_ID 
                GROUP BY o.Seller_ID ORDER BY COUNT(*) DESC LIMIT 1
            """)
            if top_s: self.lbl_top_seller.config(text=top_s[0][0])

            # Avg Order
            avg_o, _ = self.db_manager.execute_query("SELECT AVG(Price) FROM order_table")
            if avg_o: self.lbl_avg_order.config(text=f"${avg_o[0][0]:,.2f}")

            # Team Count
            team_c, _ = self.db_manager.execute_query("SELECT COUNT(*) FROM team")
            self.lbl_team_count.config(text=str(team_c[0][0]))

            # 3. Recent Transactions
            for i in self.recent_tree.get_children(): self.recent_tree.delete(i)
            recent, _ = self.db_manager.execute_query("""
                SELECT o.Order_Date, c.Fullname, o.Price 
                FROM order_table o 
                JOIN customer c ON o.Customer_ID = c.Customer_ID 
                ORDER BY o.Order_Date DESC LIMIT 8
            """)
            for r in recent:
                self.recent_tree.insert("", "end", values=(r[0], r[1], f"${r[2]:.2f}"))

        except Exception as e:
            logger.error(f"Home refresh failed: {e}")

class DataEntryView(tk.Frame):
    def __init__(self, parent, db_manager):
        super().__init__(parent, bg=CLR_BG)
        self.db_manager = db_manager
        self.setup_ui()

    def setup_ui(self):
        container = tk.Frame(self, bg=CLR_BG, padx=40, pady=30)
        container.pack(fill="both", expand=True)

        tk.Label(container, text="Data Administration", font=("Segoe UI Bold", 20), bg=CLR_BG, fg=CLR_TEXT).pack(anchor="w", pady=(0,25))

        # Forms in a grid
        forms_grid = tk.Frame(container, bg=CLR_BG)
        forms_grid.pack(fill="both", expand=True)

        self.create_form(forms_grid, "Client Onboarding", [
            ("Full Name", "c_name"), ("Email Address", "c_email"), ("Team ID (Ref)", "c_team")
        ], self.add_customer, 0, 0)

        self.create_form(forms_grid, "Inventory Provisioning", [
            ("Asset Name", "p_name"), ("Unit Market Price", "p_price"), ("Current Stock", "p_stock")
        ], self.add_product, 0, 1)

        self.create_form(forms_grid, "Transaction Processing", [
            ("Customer ID", "o_cust"), ("Seller ID", "o_seller"), ("Transaction Total", "o_price")
        ], self.add_order, 1, 0)

        forms_grid.columnconfigure((0,1), weight=1)

    def create_form(self, parent, title, fields, cmd, r, c):
        frame = tk.Frame(parent, bg=CLR_CARD_BG, bd=1, relief="flat", highlightthickness=1, highlightbackground=CLR_BORDER)
        frame.grid(row=r, column=c, padx=12, pady=12, sticky="nsew")
        
        tk.Label(frame, text=title, font=("Segoe UI Semibold", 13), bg=CLR_CARD_BG, fg=CLR_TEXT).pack(anchor="w", padx=25, pady=(25,20))
        
        entries = {}
        for label, key in fields:
            f = tk.Frame(frame, bg=CLR_CARD_BG, padx=25, pady=6)
            f.pack(fill="x")
            tk.Label(f, text=label, font=("Segoe UI", 9), fg=CLR_TEXT_LIGHT, bg=CLR_CARD_BG).pack(anchor="w")
            e = ttk.Entry(f)
            e.pack(fill="x", pady=2)
            entries[key] = e
            
        btn_frame = tk.Frame(frame, bg=CLR_CARD_BG, padx=25, pady=25)
        btn_frame.pack(fill="x")
        ttk.Button(btn_frame, text=f"Submit {title.split()[0]}", command=lambda: cmd(entries)).pack(side="right")

    def add_customer(self, ent):
        try:
            self.db_manager.execute_non_query("INSERT INTO customer (Fullname, Email, Team_ID) VALUES (?,?,?)", 
                                              (ent['c_name'].get(), ent['c_email'].get(), ent['c_team'].get()))
            messagebox.showinfo("Operation Successful", "Customer profile integrated.")
        except Exception as e: messagebox.showerror("Validation Error", str(e))

    def add_product(self, ent):
        try:
            self.db_manager.execute_non_query("INSERT INTO product (Product_name, Price, Stock_Quantity) VALUES (?,?,?)", 
                                              (ent['p_name'].get(), float(ent['p_price'].get()), int(ent['p_stock'].get())))
            messagebox.showinfo("Operation Successful", "Inventory adjusted.")
        except Exception as e: messagebox.showerror("Validation Error", "Please ensure numerical values for price/stock.")

    def add_order(self, ent):
        try:
            self.db_manager.execute_non_query("INSERT INTO order_table (Order_Date, Price, Customer_ID, Seller_ID) VALUES (?,?,?,?)", 
                                              (date.today().strftime("%Y-%m-%d"), float(ent['o_price'].get()), ent['o_cust'].get(), ent['o_seller'].get()))
            messagebox.showinfo("Operation Successful", "Transaction logged.")
        except Exception as e: messagebox.showerror("Validation Error", "Verify IDs and amount.")

class ReportsView(tk.Frame):
    def __init__(self, parent, db_manager):
        super().__init__(parent, bg=CLR_BG)
        self.db_manager = db_manager
        self.setup_ui()

    def setup_ui(self):
        # Header area for search
        search_bar = tk.Frame(self, bg=CLR_HEADER, padx=30, pady=25, bd=1, relief="flat", highlightthickness=1, highlightbackground=CLR_BORDER)
        search_bar.pack(fill="x")
        
        tk.Label(search_bar, text="Advanced Analytics", font=("Segoe UI Bold", 18), bg=CLR_HEADER, fg=CLR_TEXT).pack(side="left")
        
        self.search_val = ttk.Entry(search_bar, width=35)
        self.search_val.pack(side="right", padx=10)
        tk.Label(search_bar, text="Search Scope:", font=("Segoe UI Semibold", 10), bg=CLR_HEADER, fg=CLR_TEXT).pack(side="right")

        # Main Layout: Buttons on left, Table on right
        body = tk.Frame(self, bg=CLR_BG, padx=40, pady=30)
        body.pack(fill="both", expand=True)
        
        btn_panel = tk.Frame(body, bg=CLR_BG, width=220)
        btn_panel.pack(side="left", fill="y", padx=(0,30))
        
        queries = [
            ("Client Directory", self.q1), ("Affiliate Teams", self.q2), ("Product Inventory", self.q3),
            ("Market Segment [3-15]", self.q4), ("Geospatial Analysis", self.q5), ("Sales Performance", self.q6),
            ("High-Value Events", self.q7)
        ]
        
        for txt, cmd in queries:
            b = tk.Button(btn_panel, text=txt, command=cmd, bg=CLR_BG, fg=CLR_TEXT, font=("Segoe UI", 10), 
                          bd=0, pady=10, anchor="w", padx=20, cursor="hand2")
            b.pack(fill="x", pady=2)
            b.bind("<Enter>", lambda e, w=b: w.config(bg=CLR_HEADER))
            b.bind("<Leave>", lambda e, w=b: w.config(bg=CLR_BG))

        # Table
        tbl_frame = tk.Frame(body, bg="white", bd=1, relief="flat", highlightthickness=1, highlightbackground=CLR_BORDER)
        tbl_frame.pack(side="right", fill="both", expand=True)
        
        self.tree = ttk.Treeview(tbl_frame, show="headings", selectmode="browse")
        vsb = ttk.Scrollbar(tbl_frame, orient="vertical", command=self.tree.yview)
        hsb = ttk.Scrollbar(tbl_frame, orient="horizontal", command=self.tree.xview)
        self.tree.configure(yscrollcommand=vsb.set, xscrollcommand=hsb.set)
        
        self.tree.grid(row=0, column=0, sticky="nsew")
        vsb.grid(row=0, column=1, sticky="ns")
        hsb.grid(row=1, column=0, sticky="ew")
        tbl_frame.columnconfigure(0, weight=1)
        tbl_frame.rowconfigure(0, weight=1)

    def run(self, sql, p=()):
        for i in self.tree.get_children(): self.tree.delete(i)
        try:
            rows, cols = self.db_manager.execute_query(sql, p)
            self.tree["columns"] = cols
            for c in cols:
                self.tree.heading(c, text=c.replace("_", " ").upper())
                self.tree.column(c, width=150, anchor="center")
            for r in rows: self.tree.insert("", "end", values=r)
        except Exception as e: messagebox.showerror("DB Error", str(e))

    def q1(self):
        v = self.search_val.get().strip()
        if not v: self.run("SELECT Customer_ID, Fullname, Email, Address FROM customer")
        else: self.run("SELECT Customer_ID, Fullname, Email FROM customer WHERE Fullname LIKE ?", ('%'+v+'%',))
    def q2(self): self.run("SELECT * FROM team")
    def q3(self): self.run("SELECT * FROM product")
    def q4(self): self.run("SELECT * FROM product WHERE Price BETWEEN 3 AND 15")
    def q5(self): self.run("SELECT * FROM customer WHERE Address LIKE '%Starford%' OR Address LIKE '%Liverpool%'")
    def q6(self): self.run("SELECT s.Fullname, AVG(o.Price) as AVG_Sales FROM seller s JOIN order_table o ON s.Seller_ID = o.Seller_ID GROUP BY s.Seller_ID")
    def q7(self): self.run("SELECT s.Fullname as Seller, c.Fullname as Customer, o.Price FROM order_table o JOIN seller s ON o.Seller_ID = s.Seller_ID JOIN customer c ON o.Customer_ID = c.Customer_ID ORDER BY o.Price DESC LIMIT 1")

# --- MAIN SHELL ---

class EnterpriseApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title(APP_TITLE)
        self.geometry(WINDOW_SIZE)
        self.minsize(*MIN_SIZE)
        self.configure(bg=CLR_BG)
        
        self.db_manager = DatabaseManager(DB_NAME)
        if not self.db_manager.initialize_from_sql(SQL_FILE):
            messagebox.showerror("Critical Failure", "Database integration failed.")
            self.destroy(); return

        self.setup_styles()
        self.setup_layout()
        
    def setup_styles(self):
        s = ttk.Style()
        s.theme_use('clam')
        s.configure("Treeview", background="white", foreground=CLR_TEXT, fieldbackground="white", borderwidth=0, font=("Segoe UI", 10), rowheight=30)
        s.configure("Treeview.Heading", background=CLR_HEADER, foreground=CLR_TEXT, font=("Segoe UI Semibold", 10), borderwidth=0)
        s.map("Treeview", background=[('selected', CLR_ACCENT)])
        s.configure("TButton", font=("Segoe UI Semibold", 10), padding=12)
        s.configure("TEntry", padding=8)

    def setup_layout(self):
        # Sidebar
        sidebar = tk.Frame(self, bg=CLR_SIDEBAR, width=280)
        sidebar.pack(side="left", fill="y")
        sidebar.pack_propagate(False)
        
        # Identity Area
        logo_frame = tk.Frame(sidebar, bg=CLR_SIDEBAR, pady=50)
        logo_frame.pack(fill="x")
        tk.Label(logo_frame, text="TEAM 12", font=("Segoe UI Bold", 26), fg="white", bg=CLR_SIDEBAR).pack()
        tk.Label(logo_frame, text="CORE ARCHITECTURE", font=("Segoe UI Bold", 9), fg="#475569", bg=CLR_SIDEBAR).pack()

        # Content Area
        self.view_container = tk.Frame(self, bg=CLR_BG)
        self.view_container.pack(side="right", fill="both", expand=True)
        
        self.views = {
            "home": HomeView(self.view_container, self.db_manager),
            "entry": DataEntryView(self.view_container, self.db_manager),
            "reports": ReportsView(self.view_container, self.db_manager)
        }
        
        SidebarButton(sidebar, "  🏠   Executive Home", lambda: self.show_view("home")).pack(fill="x")
        SidebarButton(sidebar, "  ➕   Asset Administration", lambda: self.show_view("entry")).pack(fill="x")
        SidebarButton(sidebar, "  📊   Intelligence Reports", lambda: self.show_view("reports")).pack(fill="x")
        
        # Bottom sidebar info
        tk.Label(sidebar, text="System: production_live", font=("Segoe UI", 8), fg="#475569", bg=CLR_SIDEBAR, pady=20).pack(side="bottom")

        self.show_view("home")

    def show_view(self, name):
        for v in self.views.values(): v.pack_forget()
        self.views[name].pack(fill="both", expand=True)
        if name == "home": self.views["home"].refresh()

if __name__ == "__main__":
    app = EnterpriseApp()
    app.mainloop()
