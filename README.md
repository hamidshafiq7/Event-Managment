```markdown
# Event Planning & Operations Management System

A robust, relational Database Management System (DBMS) built with a **Flask (Python)** backend and a **MariaDB / MySQL (XAMPP)** storage engine. This system manages corporate and private event bookings, handles venue allocation, tracks resource provisioning, and automatically compiles dynamic financial valuations using relational database schemas.

---

## 🚀 Key System Features
- **Relational Integrity:** Implements normalized tables (`1NF`, `2NF`, `3NF`) with cross-entity referential integrity via strict foreign keys and cascading deletes (`ON DELETE CASCADE`).
- **Dynamic Aggregate Computations:** Computes real-time invoice valuations on the fly by combining static venue overhead costs with variable item quantities from associative junction tables.
- **Interactive Form Ingestion:** Provides front-end form components allowing seamless operational data insertion directly from a browser viewport into the database cluster.
- **Port-Isolated Management:** Configured to interface flawlessly with customized internal database server ports (`3307`).

---

## 📂 Repository Architecture

```text
database-project-final/
├── app.py                 # Core Flask backend server and API routing architecture
├── schema.sql             # Complete database schema and initial data seeding scripts
├── requirements.txt       # Software dependencies and target system packages
├── README.md              # System deployment manual and technical documentation
└── templates/             # Front-end user interface layout components
    └── index.html         # Interactive operational management dashboard view

```

---

## 🛠️ Tech Stack & Prerequisites

* **Backend:** Python 3.13 / 3.14, Flask Framework
* **Database Engine:** MariaDB / MySQL (Deployed via XAMPP Server stack)
* **Database Driver:** `mysql-connector-python`
* **Front-end UI:** Standard HTML5 / Embedded CSS styling rules

---

## ⚙️ Installation & Deployment Manual

### 1. Database Provisioning (XAMPP)

1. Initialize the **Apache** and **MySQL** server modules inside your XAMPP Control Panel.
2. Confirm your system port assignment. *(If using custom port `3307`, ensure it aligns with your environment variable).*
3. Open your database administrator connection inside your preferred editor (VS Code Database Client or phpMyAdmin).
4. Run the complete generation script located inside `schema.sql`. This builds the system database instance (`EventManagementSystem`), provisions all 5 core tables, and seeds operational sample datasets.

### 2. Workspace Setup

Clone the repository and verify you are targeted inside the root path:

```bash
cd "E:\database project final"

```

Install the explicit compilation dependencies using the unified system python launcher wrapper:

```bash
py -m pip install -r requirements.txt

```

### 3. Execution

Launch the backend hotspot dev server infrastructure:

```bash
py app.py

```

The terminal will confirm server execution via local port routing:

```text
 * Serving Flask app 'app'
 * Debug mode: on
 * Running on [http://127.0.0.1:5000](http://127.0.0.1:5000)

```

Open your web browser and navigate directly to **`http://localhost:5000`** to access the system dashboard interface.

---

## 📊 Entity Relationship Diagram (ERD) Blueprint

* `venues` (1:M) -> `events` (Tracks static location dimensions, capacity limits, and overhead costs)
* `users` (1:M) -> `events` (Manages administrative authorization ranks: Admin, Organizer, Client)
* `events` (M:N) -> `services` (Linked via `event_services` associative bridge table to track customized item inventories, exact dynamic cost margins, and assigned quantities without record duplication)

---

## 📜 Architectural SQL Join Mechanics

The financial matrix uses a complex `LEFT JOIN` and aggregate clustering query to evaluate total financial operations on the fly:

```sql
SELECT 
    e.event_id,
    e.title AS event_title,
    (v.cost_per_day + COALESCE(SUM(es.agreed_price * es.quantity), 0)) AS total_cost
FROM events e
INNER JOIN venues v ON e.venue_id = v.venue_id
LEFT JOIN event_services es ON e.event_id = es.event_id
GROUP BY e.event_id;

```

```

```
