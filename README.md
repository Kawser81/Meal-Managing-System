# 🍽️ Monthly Meal Manager

🌐 **Live Demo:** [https://meal-manager-app.onrender.com](https://meal-manager-app.onrender.com)

A full-stack Spring Boot web application for managing monthly meal expenses in a shared living or mess environment. It tracks deposits, meal entries, meal costs, combined costs, and protein stocks — and generates a complete financial summary per user per month.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Data Model](#data-model)
- [Roles & Permissions](#roles--permissions)
- [Modules](#modules)
- [API Endpoints](#api-endpoints)
- [Setup & Installation](#setup--installation)
- [Configuration](#configuration)
- [How It Works](#how-it-works)

---

## Overview

Monthly Meal Manager is designed for groups (e.g., office messes, hostels, shared homes) where:

- Members deposit money each month
- A manager tracks daily meal counts per member
- Food and other shared costs are recorded
- At month-end, a summary shows each member's balance, meal cost, and net due/refund

---

## Features

- 🔐 **Authentication** — Register & login with BCrypt-hashed passwords; session-based auth with auto-redirect
- 📅 **Month Management** — One active month at a time; admin can create new months and deactivate old ones
- 👥 **Role-Based Access** — Global roles (ADMIN / USER) and per-month roles (MANAGER / VIEWER)
- 💰 **Deposit Tracking** — Manager records deposits per user; full history with notes
- 🍛 **Meal Entry** — Daily meal count per user tracked on a calendar-style grid
- 🧾 **Meal Cost** — Itemized food cost entries for the month
- 🏠 **Combined Cost** — Shared non-food costs (utilities, rent share, etc.) split equally among members
- 🥩 **Protein Stock** — Inventory tracking for protein items purchased for the mess
- 📊 **Summary** — Auto-calculated per-user breakdown: deposit, combined cost share, meal fund, meal cost, and net due
- 💬 **Group Chat** — Real-time polling-based chat for all members of the mess

---

## Tech Stack

| Layer        | Technology                              |
|--------------|-----------------------------------------|
| Language     | Java 17                                 |
| Framework    | Spring Boot 3.4.1                       |
| View Layer   | JSP (Jakarta JSTL) via embedded Tomcat  |
| Persistence  | Spring Data JPA + Hibernate             |
| Database     | PostgreSQL                              |
| Security     | Session-based auth + Servlet Filter     |
| Password     | jBCrypt (bcrypt hashing)                |
| Build Tool   | Maven (WAR packaging)                   |

---

## Project Structure

```
com.mealmanager
├── MonthlyMealManagerApplication.java   # Entry point
│
├── controller
│   ├── AuthController.java              # Login, Register, Logout
│   ├── DashboardController.java         # Dashboard & role management
│   ├── DepositController.java           # Deposit CRUD
│   ├── MealController.java              # Meal entry CRUD
│   ├── MealCostController.java          # Meal cost CRUD
│   ├── CombinedCostController.java      # Combined cost CRUD
│   ├── ProteinStockController.java      # Protein stock CRUD
│   ├── SummaryController.java           # Monthly summary view
│   └── ChatController.java             # Group chat (send + poll)
│
├── service
│   ├── UserService.java
│   ├── DashboardService.java
│   ├── DepositService.java
│   ├── MealService.java
│   ├── MealCostService.java
│   ├── CombinedCostService.java
│   ├── ProteinStockService.java
│   ├── SummaryService.java
│   ├── ChatService.java
│   ├── MonthService.java
│   └── MonthUserRoleService.java
│
├── model
│   ├── User.java
│   ├── Month.java
│   ├── MonthUserRole.java
│   ├── Deposit.java
│   ├── MealEntry.java
│   ├── MealCost.java
│   ├── CombinedCost.java
│   ├── ProteinStock.java
│   └── ChatMessage.java
│
├── dto
│   ├── UserSummaryRow.java              # Per-user summary data
│   └── MealCostSummary.java            # Total meals, cost, per-meal rate
│
├── repository
│   ├── UserRepository.java
│   ├── MonthRepository.java
│   ├── MonthUserRoleRepository.java
│   ├── DepositRepository.java
│   ├── MealRepository.java
│   ├── MealCostRepository.java
│   ├── CombinedCostRepository.java
│   ├── ProteinStockRepository.java
│   └── ChatMessageRepository.java
│
├── enumeration
│   ├── GlobalRole.java                  # ADMIN, USER
│   └── MonthlyRole.java                 # MANAGER, VIEWER
│
└── filter
    └── LoginFilter.java                 # Session guard for all protected routes
```

---

## Data Model

### Entities & Relationships

```
User  ──< MonthUserRole >── Month
User  ──< Deposit        >── Month
User  ──< MealEntry      >── Month
User  ──< ChatMessage

Month ──< MealCost
Month ──< CombinedCost
Month ──< ProteinStock
```

### Key Entities

| Entity          | Table              | Description                                      |
|-----------------|--------------------|--------------------------------------------------|
| `User`          | `users`            | App user with global role (ADMIN/USER)           |
| `Month`         | `months`           | A billing period with start/end date; one active |
| `MonthUserRole` | `month_user_roles` | Per-month role assignment (MANAGER/VIEWER)       |
| `Deposit`       | `deposits`         | Money deposited by a user for a month            |
| `MealEntry`     | `meal_entries`     | Daily meal count per user per date               |
| `MealCost`      | `meal_costs`       | Itemized food expenses for a month               |
| `CombinedCost`  | `combined_costs`   | Shared non-food costs for a month                |
| `ProteinStock`  | `protein_stocks`   | Protein/grocery inventory per month              |
| `ChatMessage`   | `chat_messages`    | Group chat messages with timestamp               |

---

## Roles & Permissions

### Global Roles (`GlobalRole`)

| Role    | Capability                                      |
|---------|-------------------------------------------------|
| `ADMIN` | Can assign/change monthly roles for all users   |
| `USER`  | Standard member                                 |

### Monthly Roles (`MonthlyRole`)

| Role      | Capability                                                                 |
|-----------|----------------------------------------------------------------------------|
| `MANAGER` | Can add/edit/delete deposits, meals, costs, protein stock for that month   |
| `VIEWER`  | Read-only access to all data for that month                                |

> A user must be assigned a `MonthUserRole` for the active month to participate. Role assignment is done by the ADMIN from the Dashboard.

---

## Modules

### 🔐 Authentication (`/login`, `/register`, `/logout`)
- Register with name, email, password (BCrypt hashed)
- Login stores `loggedInUser` (email) and `loggedInName` in session
- `LoginFilter` protects all routes except `/login`, `/register`, and static assets
- Session timeout: **30 minutes**

### 📊 Dashboard (`/dashboard`)
- Shows active month info
- ADMIN can see all users and their monthly roles
- ADMIN can change a user's monthly role (MANAGER ↔ VIEWER)

### 💰 Deposits (`/deposit`)
- MANAGER can add deposits for any user with an optional note
- Shows a per-user deposit history table
- Displays total deposit per user for the active month

### 🍛 Meals (`/meal`)
- Calendar grid view: rows = users, columns = dates of the month
- MANAGER can enter/update meal count per user per date
- Upsert logic: saves a new entry or updates the existing one for that user+date

### 🧾 Meal Cost (`/meal-cost`)
- MANAGER adds itemized food cost entries (e.g., "Rice - 500")
- Shows total meal cost for the month
- Used to calculate per-meal cost in the summary

### 🏠 Combined Cost (`/combined-cost`)
- MANAGER adds shared costs (e.g., "Gas Bill - 1200")
- Total is divided equally among all members assigned to the month
- Each member's share is deducted from their meal fund

### 🥩 Protein Stock (`/protein`)
- MANAGER tracks protein inventory (item name, quantity, unit, note)
- Ordered by item name; supports update and delete

### 📊 Summary (`/summary`)

The summary page auto-calculates the following for each member:

| Column           | Formula                                             |
|------------------|-----------------------------------------------------|
| Deposit          | Sum of all deposits for the user this month         |
| Combined Cost    | Total combined cost ÷ number of members             |
| Meal Fund        | Deposit − Combined Cost share                       |
| Total Meals      | Sum of all meal entries for the user                |
| Per-User Meal Cost | User's meals × (total meal cost ÷ total meals)   |
| Due              | Per-User Meal Cost − Meal Fund                      |
| Money In Hand    | Total Deposit − (Total Meal Cost + Total Combined Cost) |

### 💬 Chat (`/chat`)
- Any logged-in user can send messages
- Polling-based refresh via `GET /chat/poll?lastId={id}` — fetches only new messages
- Messages display sender name, timestamp, and are visually distinguished (own vs others)

---

## API Endpoints

### Auth
| Method | Path        | Description          |
|--------|-------------|----------------------|
| GET    | `/login`    | Login page           |
| POST   | `/login`    | Submit login         |
| GET    | `/register` | Register page        |
| POST   | `/register` | Submit registration  |
| GET    | `/logout`   | Invalidate session   |

### Dashboard
| Method | Path                   | Description                    |
|--------|------------------------|--------------------------------|
| GET    | `/dashboard`           | Dashboard home                 |
| POST   | `/dashboard/role/update` | Update a user's monthly role |

### Deposits
| Method | Path              | Description          |
|--------|-------------------|----------------------|
| GET    | `/deposit`        | View deposit page    |
| POST   | `/deposit/add`    | Add deposit          |
| POST   | `/deposit/delete` | Delete deposit       |

### Meals
| Method | Path           | Description        |
|--------|----------------|--------------------|
| GET    | `/meal`        | Meal grid page     |
| POST   | `/meal/save`   | Save/update meal   |
| POST   | `/meal/delete` | Delete meal entry  |

### Meal Cost
| Method | Path                | Description      |
|--------|---------------------|------------------|
| GET    | `/meal-cost`        | View meal costs  |
| POST   | `/meal-cost/add`    | Add cost item    |
| POST   | `/meal-cost/update` | Update cost item |
| POST   | `/meal-cost/delete` | Delete cost item |

### Combined Cost
| Method | Path                    | Description           |
|--------|-------------------------|-----------------------|
| GET    | `/combined-cost`        | View combined costs   |
| POST   | `/combined-cost/add`    | Add cost item         |
| POST   | `/combined-cost/update` | Update cost item      |
| POST   | `/combined-cost/delete` | Delete cost item      |

### Protein Stock
| Method | Path               | Description       |
|--------|--------------------|-------------------|
| GET    | `/protein`         | View stock list   |
| POST   | `/protein/add`     | Add stock item    |
| POST   | `/protein/update`  | Update stock item |
| POST   | `/protein/delete`  | Delete stock item |

### Summary
| Method | Path       | Description            |
|--------|------------|------------------------|
| GET    | `/summary` | Monthly summary report |

### Chat
| Method | Path          | Description                   |
|--------|---------------|-------------------------------|
| GET    | `/chat`       | Chat page                     |
| POST   | `/chat/send`  | Send a message (JSON response)|
| GET    | `/chat/poll`  | Poll for new messages         |

---

## Setup & Installation

### Prerequisites

- Java 17+
- Maven 3.8+
- PostgreSQL 13+

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/monthly-meal-manager.git
cd monthly-meal-manager
```

### 2. Create the PostgreSQL Database

```sql
CREATE DATABASE meal_manager;
```

### 3. Configure `application.properties`

Edit `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/meal_manager
spring.datasource.username=your_db_username
spring.datasource.password=your_db_password
```

### 4. Build & Run

```bash
mvn clean install
mvn spring-boot:run
```

The app will start at: **http://localhost:8080**

> Tables are auto-created by Hibernate (`ddl-auto=update`) on first run.

### 5. First-Time Setup

1. Register a user at `/register`
2. Manually set their `role` to `ADMIN` in the database:
   ```sql
   UPDATE users SET role = 'ADMIN' WHERE email = 'your@email.com';
   ```
3. Login as ADMIN, go to Dashboard, create a Month, and assign roles to members

---

## Configuration

All configuration is in `src/main/resources/application.properties`:

```properties
# View resolver (JSP)
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp

# Database
spring.datasource.url=jdbc:postgresql://localhost:5432/meal_manager
spring.datasource.username=postgres
spring.datasource.password=your_password
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA / Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.open-in-view=false

# Session
server.servlet.session.timeout=30m
```

---

## How It Works

### Monthly Lifecycle

1. **Admin creates a new Month** (name, start date, end date) → automatically deactivates the previous active month
2. **Admin assigns roles** to all participating users for that month (MANAGER or VIEWER)
3. **Manager records deposits** as members pay in
4. **Manager enters daily meal counts** throughout the month
5. **Manager logs meal costs and combined costs** as expenses occur
6. **Manager tracks protein stock** as grocery inventory
7. **At month-end**, anyone views the **Summary** page to see each member's balance

### Summary Calculation Example

Assume 4 members, total combined cost = ৳2000, total meals = 200, total meal cost = ৳10,000:

- Per-member combined cost = ৳2000 ÷ 4 = **৳500**
- Per-meal cost = ৳10,000 ÷ 200 = **৳50/meal**

For a member with deposit = ৳5000 and 40 meals:
- Meal fund = ৳5000 − ৳500 = **৳4500**
- Meal cost = 40 × ৳50 = **৳2000**
- Due = ৳2000 − ৳4500 = **−৳2500** *(refund of ৳2500)*
