# **UnitNest: Your Automated Building Renting Management System with Payment Integration via Telegram**  
_A fully automated building rental management system that streamlines the rental process with integrated payment tracking via Telegram._

## **Table of Contents** 
## **Introduction**  
The aim of this project is to develop an automated building renting management system that streamlines the rental process for both tenants and landlords. Tenants can conveniently pay their rent through a Telegram bot, while landlords can monitor and manage payments through a dedicated Flutter application.

## **Problem Statement**  
In Cambodia, tenants and landlords face challenges in the rental process, such as inefficient payment tracking, lack of communication, and inconvenient payment methods. These problems lead to misunderstandings, delayed payments, and dissatisfaction for both parties.

## **Project Objectives**  
- **Convenient Payment Method:** Enable tenants to pay rent easily via Telegram, a platform they are already familiar with.  
- **Real-Time Monitoring:** Provide landlords with a Flutter application to track payments, manage tenant information, and send reminders.  
- **Enhanced Communication:** Improve communication between tenants and landlords through the Telegram bot.

## **System Components**  

### **Telegram Bot for Tenants**  
**Core Features:**  
- Handles rent payment requests from tenants.  
- Generates and sends a receipt with KHQR (Khmer QR Code) for payment.  
- Sends monthly automated payment reminders to tenants.  
- Provides basic support and answers tenant queries (e.g., rules, due dates).  
- Handles tenant registration.

### **Flutter Application for Landlords**  
**Core Features:**  
- Real-time monitoring of incoming payment requests.  
- Manual payment tracking for tenants paying outside of Telegram.  
- Building and room management for landlords to define rooms and services.  
- Tenant profile management.  
- Reports and analytics generation for rental income tracking.

## **Technologies Used**  

### **Backend:**  
- **Firebase:** For authentication and real-time database.  
- **Node.js:** For handling payment integration (KHQR) and webhook for the Telegram bot.  
- **Flask:** Custom OCR API using Flask and YOLO to detect water and electricity meter readings sent by tenants during the payment process.

### **Frontend:**  
- **Flutter:** Cross-platform app for landlords' management.

### **Payment Integration:**  
- **KHQR Standard:** QR code-based payment and deep link payment tracking for compliance with Cambodia's payment standards.

### **Hosting (Locally):**  
- **Ngrok:** Hosting the backend for communication between the system and the Telegram bot.  
- **Vercel:** Hosting the API for seamless communication and deployment.

### **Tools:**  
- **Postman:** API endpoint testing.  
- **GitHub/GitLab:** Version control and team collaboration.  
- **Visual Studio Code:** Development environment.  
- **YOLO:** Real-time object detection for text extraction from water and electricity meters.

## **Expected Outcomes**  
- Increased convenience for tenants and landlords in managing rental payments.  
- Improved communication and transparency in the renting process.  
- A scalable solution that can be adapted for future enhancements.

## **Challenges and Risks**  
- **User Adoption:** Convincing tenants and landlords to transition to the system.  
- **OCR:** Lack of a dataset for water meter and electricity meter readings could affect the OCR process.

## **Future Enhancements**  
- Support for international payments.  
- Integrating AI for predictive analytics and expense tracking.  
- Expanding the system to support commercial spaces and offices.

## **Installation & Usage**  

### **Install Dependencies**  
Run the following command to install the required dependencies:  

```bash
flutter pub get
```

### **Run the Application**  
Use the command below to start the application:  

```bash
flutter run
```

### **Request Access to the Telegram Bot**  
To use the system, you need to register your email for access.  

1. Send us an email with your **registration Gmail**.  
2. We will grant access to the Telegram bot and notify you once it's ready.


## **License**  
MIT License  
