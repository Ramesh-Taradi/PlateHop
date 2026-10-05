# 🍽️ PlateHop - Modern Food Delivery Web Application

[![Live Demo](https://img.shields.io/badge/Demo-Live%20on%20Render-brightgreen?style=for-the-badge&logo=render)](https://platehop.onrender.com)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4%20%2F%204.x-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-21%2B-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

> **PlateHop** is a full-featured, high-performance food ordering and delivery web platform built with Java, Spring Boot, Spring Data JPA, and JSP. It features modern dark-mode glassmorphism aesthetics, responsive mobile drawer navigation, live cart management, dynamic category/price filtering, and automated cloud database seeding.

---

## 🚀 Live Demo

Experience the live application deployed on the cloud:
👉 **[https://platehop.onrender.com](https://platehop.onrender.com)**

*(Note: Hosted on Render's free tier. If the server has been idle for 15+ minutes, please allow ~45–60 seconds for the initial wake-up spin).*

---

## ✨ Features

- **🍔 20 Curated Restaurants**: Features diverse culinary options ranging from Italian, Japanese, and Mexican to Indian, Thai, French, BBQ, and Seafood.
- **📜 200+ Menu Items**: Every restaurant has 10 dishes with categorized menus (*Mains, Starters, Sides, Desserts, Beverages*), high-definition imagery, pricing, and descriptions.
- **🔍 Instant Filtering & Sorting**: Real-time category filtering, price sliders, and sorting (by popularity, price low-to-high, and price high-to-low).
- **🛒 Dynamic Shopping Cart**: Add, increase/decrease quantities, or remove items with automatic tax and delivery fee calculation.
- **📱 Responsive Mobile Experience**: Custom mobile slide-out drawer, touch-friendly horizontal scroll lists, and stacked single-column layouts for smartphones and tablets.
- **🔐 User Accounts & Order History**: User registration, login session tracking, profile management, and past order history view.
- **⚡ High-Speed Performance**:
  - GZIP HTTP response compression enabled (reduces network payload size by 70–80%).
  - 24-hour browser Cache-Control headers for static assets.
  - DNS preconnects for web fonts and image CDNs.
  - Non-blocking hero video metadata preloading.
- **☁️ Zero-Config Multi-Database Support**:
  - Automatically connects to **MySQL** in local development environments.
  - Automatically activates an embedded **H2 fallback database** with automated schema seeding when deployed to cloud providers (Render, Railway, Fly.io, etc.).

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Backend** | Java 21+, Spring Boot, Spring MVC, Spring Data JPA |
| **ORM / Persistence** | Hibernate, HikariCP Connection Pool |
| **Databases** | MySQL (Local Dev) / H2 In-Memory (Cloud Deployment) |
| **View / Frontend** | JSP (Jakarta Pages), JSTL, Modern CSS3 (Glassmorphism, Flexbox, CSS Grid), Vanilla JavaScript |
| **Build Tool** | Apache Maven (`mvnw`) |
| **Deployment / Container** | Docker, Render Cloud Platform |

---

## 💻 Local Getting Started

### Prerequisites
- **JDK 21** or higher installed
- **Git**
- Optional: **MySQL 8.x** running locally (or let it run in H2 mode)

### 1. Clone the repository
```bash
git clone https://github.com/Ramesh-Taradi/PlateHop.git
cd PlateHop
```

### 2. Configure Database (Optional)
By default, `src/main/resources/application.properties` connects to:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/platehop_db?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=1234
```
If MySQL is not detected, it will gracefully fall back to the embedded in-memory database with all 20 restaurants pre-seeded.

### 3. Run the application
Using the Maven wrapper:

**Windows (PowerShell / CMD):**
```powershell
.\mvnw.cmd spring-boot:run
```

**macOS / Linux:**
```bash
./mvnw spring-boot:run
```

### 4. Open in Browser
Visit **[http://localhost:8081](http://localhost:8081)** (or port specified in `application.properties`).

---

## 🐳 Docker Build

To run PlateHop via Docker:
```bash
docker build -t platehop .
docker run -p 8080:8080 platehop
```
Then visit `http://localhost:8080`.

---

## 📂 Project Structure

```
PlateHop/
├── src/
│   ├── main/
│   │   ├── java/com/project/platehop/
│   │   │   ├── config/              # Security & DataInitializer seeding
│   │   │   ├── controller/          # Spring MVC & REST Controllers
│   │   │   ├── model/               # JPA Entities (Restaurant, Menu, User, Order)
│   │   │   ├── repository/          # Spring Data JPA Repositories
│   │   │   ├── service/             # Business Logic Layer
│   │   │   └── util/                # Spring Context & Utility classes
│   │   ├── resources/
│   │   │   ├── application.properties
│   │   │   └── static/              # CSS, JS, Images, Videos
│   │   └── webapp/
│   │       ├── index.jsp            # Homepage with video hero & highlights
│   │       ├── restaurants.jsp      # Restaurant discovery page
│   │       ├── menu.jsp             # Restaurant menu & dish ordering
│   │       ├── cart.jsp             # Shopping cart & checkout
│   │       ├── orders.jsp           # Order tracking & history
│   │       ├── login.jsp            # User login
│   │       └── register.jsp         # User registration
├── Dockerfile                       # Multi-stage Docker build for cloud deploy
├── pom.xml                          # Maven project configuration
└── README.md
```

---

## 👨‍💻 Author

Developed with ❤️ by **[Ramesh Taradi](https://github.com/Ramesh-Taradi)**
