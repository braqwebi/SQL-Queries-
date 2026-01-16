## 1️⃣ ALY_6030_Assignment_1_IsaacNyinaku.sql

### 🎯 Purpose
This script establishes the foundational data modeling and SQL analytics framework** for the project. It demonstrates core dimensional modeling concepts and prepares hospital data for downstream analytical use.

### 🧱 What This Script Does
- Creates and structures base tables required for hospital analytics  
- Applies data normalization and cleaning logic  
- Establishes keys and relationships necessary for analytics  
- Ensures data consistency and integrity for reporting  

### 🧠 Concepts Demonstrated
- Relational and dimensional modeling  
- Schema design for analytics  
- SQL DDL and DML best practices  
- Preparing transactional data for BI workloads  

### 📌 Why It Matters
This script serves as the data foundation for all subsequent analysis. Without clean, well-modeled tables, reliable hospital capacity reporting would not be possible.

---

## 2️⃣ ALY6030_3_Isaac_Nyinaku (1).sql

### 🎯 Purpose
This script implements analytical modeling using a star-schema–style approach to analyze ICU and SICU bed capacity across hospitals.

### 🧱 What This Script Does
- Builds analytical tables focused on ICU and SICU bed types 
- Aggregates hospital bed metrics across multiple dimensions  
- Separates measures such as:
  - Licensed beds  
  - Staffed beds  
  - Census (occupied) beds  
- Structures data for fast analytical querying  

### 🧠 Concepts Demonstrated
- Star schema design  
- Fact and dimension separation  
- Healthcare operations metrics  
- SQL aggregations for analytics  
- BI-ready data modeling  

### 📌 Why It Matters
This script translates raw hospital data into analytics-ready structures, enabling:
- Performance comparison across hospitals  
- Capacity utilization analysis  
- Downstream BI dashboard integration  

---

## 3️⃣ Complex Query for hospital business case.sql

### 🎯 Purpose
This script answers a real-world healthcare business question using advanced SQL:

> Which hospitals have the highest combined ICU and SICU capacity based on licensed, staffed, and census beds?

### 🧱 What This Script Does
- Joins multiple hospital and bed datasets  
- Calculates derived metrics combining ICU and SICU capacity  
- Ranks hospitals by total critical-care bed availability
- Produces Top-N hospital reports for decision-makers  

### 🧠 Concepts Demonstrated
- Advanced multi-table joins  
- Complex aggregations and calculated fields  
- Ranking and ordering logic  
- Business-rule driven analytics  
- Decision-support SQL design  

### 📌 Why It Matters
This script represents production-level SQL analytics that could be directly used by:
- Hospital operations teams  
- Capacity planners  
- Healthcare BI analysts  
- Executive leadership dashboards  

It showcases SQL complexity beyond basic CRUD queries and demonstrates true analytical problem-solving.

---

## 🧠 Business Context & Use Case
Hospitals must continuously monitor critical care capacity to:
- Prevent overcrowding  
- Optimize staffing decisions  
- Respond to emergencies and patient surges  
- Support regulatory and operational reporting  

This project enables stakeholders to:
- Compare ICU vs SICU capacity across hospitals  
- Understand differences between licensed, staffed, and census beds  
- Make data-driven operational and strategic decisions  

---

## 🛠️ Technology Stack
- **SQL** (MySQL / Snowflake-compatible syntax)  
- Dimensional Modeling (Star Schema)  
 
  

---

## 📊 Skills Demonstrated
- Advanced SQL querying and optimization  
- Dimensional modeling and analytical design  
- Healthcare data analysis  
- Business-driven problem solving  
- Clean, maintainable, production-ready SQL  

---

## 🚀 How to Execute
1. Load the `.sql` scripts into a SQL environment (MySQL, Snowflake, or compatible)  
2. Run schema and table creation scripts first  
3. Execute analytical and business queries  
4. Use outputs directly or connect to BI tools (Power BI, Tableau)  

---

## 📈 Potential Enhancements
- Power BI or Tableau dashboards  
- Automated ETL pipelines  
- Time-series trend analysis  
- Integration with public health datasets  

---

## 👤 Author
**Isaac Nyinaku**  
 


