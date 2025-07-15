# Staybnb Travel Booking Project

## Project Structure

This is a Java Web Application using Servlets and MySQL for a travel booking platform similar to Airbnb.

### Frontend Files:
- `index.html` - Homepage with search functionality
- `listing.html` - Property listings page with filters
- `house.html` - Individual property details page
- `travel.html` - Travel destinations page
- `style.css` - Main stylesheet with responsive design

### Backend Structure:
- `WEB-INF/web.xml` - Servlet configuration
- `src/com/staybnb/` - Java source code
  - `servlets/` - Servlet classes
    - `ListingServlet.java` - Handles property listings API
    - `BookingServlet.java` - Handles booking functionality
  - `models/` - Data model classes
    - `Property.java` - Property data model
    - `Booking.java` - Booking data model
  - `utils/` - Utility classes
    - `DBConnection.java` - Database connection utility
  - `filters/` - Servlet filters
    - `CorsFilter.java` - CORS handling filter

### Required Dependencies:
1. **Servlet API** (javax.servlet-api)
2. **MySQL Connector** (mysql-connector-java)
3. **Gson** (com.google.code.gson)

### Database Setup:
The application uses MySQL database named `staybnb_db` with the following tables:
- `properties` - Property listings
- `bookings` - Booking records
- `reviews` - Property reviews
- `amenities` - Property amenities
- `property_amenities` - Property-amenity relationships

### Setup Instructions:

1. **Install Dependencies:**
   - Download `servlet-api.jar`
   - Download `mysql-connector-java.jar`
   - Download `gson.jar`
   - Place all JAR files in `WEB-INF/lib/` directory

2. **Database Setup:**
   - Create MySQL database named `staybnb_db`
   - Run the database schema creation script
   - Update database credentials in `DBConnection.java`

3. **Compilation:**
   ```bash
   # Compile Java classes
   javac -cp "WEB-INF/lib/*" -d WEB-INF/classes src/com/staybnb/*/*.java
   ```

4. **Deployment:**
   - Deploy to Tomcat server
   - Access application at `http://localhost:8080/StaybnbProject/`

### API Endpoints:
- `GET /listings` - Fetch property listings with optional filters
- `POST /book` - Create new booking
- `GET /search` - Search properties

### Features:
- Responsive design for all devices
- Dynamic property listing with filters
- Interactive booking system
- Smooth transitions and animations
- Database-driven content
- CORS support for API calls

### Live Demo:
🌐 **Repository:** [https://github.com/sanjay2005-dev/staybnb-project](https://github.com/sanjay2005-dev/staybnb-project)

### Technologies Used:
- **Frontend:** HTML5, CSS3, JavaScript
- **Backend:** Java Servlets
- **Database:** MySQL
- **Server:** Apache Tomcat
- **Build Tools:** Batch scripts for automation

### Project Status:
✅ **Complete** - Full-stack travel booking platform ready for deployment