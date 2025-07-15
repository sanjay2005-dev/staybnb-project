package com.staybnb.servlets;

import com.google.gson.Gson;
import com.staybnb.models.Property;
import com.staybnb.utils.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ListingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String location = request.getParameter("location");
        String priceRange = request.getParameter("priceRange");
        String propertyType = request.getParameter("propertyType");
        String sortBy = request.getParameter("sortBy");
        
        List<Property> properties = new ArrayList<>();
        
        try {
            properties = getProperties(location, priceRange, propertyType, sortBy);
            String jsonResponse = gson.toJson(properties);
            response.getWriter().write(jsonResponse);
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error: " + e.getMessage() + "\"}");
        }
    }
    
    private List<Property> getProperties(String location, String priceRange, 
                                       String propertyType, String sortBy) throws SQLException {
        List<Property> properties = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            StringBuilder sql = new StringBuilder(
                "SELECT p.property_id, p.title, p.description, p.location, p.city, " +
                "p.state, p.country, p.price_per_night, p.max_guests, p.bedrooms, " +
                "p.bathrooms, p.property_type, p.main_image, p.available, " +
                "COALESCE(AVG(r.rating), 0) as avg_rating, " +
                "COUNT(r.review_id) as review_count " +
                "FROM properties p " +
                "LEFT JOIN reviews r ON p.property_id = r.property_id " +
                "WHERE p.available = 1"
            );
            
            List<Object> params = new ArrayList<>();
            
            // Add filters
            if (location != null && !location.trim().isEmpty()) {
                sql.append(" AND (p.city LIKE ? OR p.state LIKE ? OR p.country LIKE ? OR p.location LIKE ?)");
                String locationParam = "%" + location + "%";
                params.add(locationParam);
                params.add(locationParam);
                params.add(locationParam);
                params.add(locationParam);
            }
            
            if (propertyType != null && !propertyType.trim().isEmpty() && !propertyType.equals("all")) {
                sql.append(" AND p.property_type = ?");
                params.add(propertyType);
            }
            
            if (priceRange != null && !priceRange.trim().isEmpty()) {
                switch (priceRange) {
                    case "0-100":
                        sql.append(" AND p.price_per_night <= 100");
                        break;
                    case "100-250":
                        sql.append(" AND p.price_per_night BETWEEN 100 AND 250");
                        break;
                    case "250-500":
                        sql.append(" AND p.price_per_night BETWEEN 250 AND 500");
                        break;
                    case "500+":
                        sql.append(" AND p.price_per_night >= 500");
                        break;
                }
            }
            
            sql.append(" GROUP BY p.property_id");
            
            // Add sorting
            if (sortBy != null && !sortBy.trim().isEmpty()) {
                switch (sortBy) {
                    case "price_low":
                        sql.append(" ORDER BY p.price_per_night ASC");
                        break;
                    case "price_high":
                        sql.append(" ORDER BY p.price_per_night DESC");
                        break;
                    case "rating":
                        sql.append(" ORDER BY avg_rating DESC");
                        break;
                    case "newest":
                        sql.append(" ORDER BY p.created_at DESC");
                        break;
                    default:
                        sql.append(" ORDER BY p.created_at DESC");
                }
            } else {
                sql.append(" ORDER BY p.created_at DESC");
            }
            
            pstmt = conn.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Property property = new Property();
                property.setPropertyId(rs.getInt("property_id"));
                property.setTitle(rs.getString("title"));
                property.setDescription(rs.getString("description"));
                property.setLocation(rs.getString("location"));
                property.setCity(rs.getString("city"));
                property.setState(rs.getString("state"));
                property.setCountry(rs.getString("country"));
                property.setPricePerNight(rs.getBigDecimal("price_per_night"));
                property.setMaxGuests(rs.getInt("max_guests"));
                property.setBedrooms(rs.getInt("bedrooms"));
                property.setBathrooms(rs.getInt("bathrooms"));
                property.setPropertyType(rs.getString("property_type"));
                property.setMainImage(rs.getString("main_image"));
                property.setAvailable(rs.getBoolean("available"));
                property.setAverageRating(rs.getDouble("avg_rating"));
                property.setReviewCount(rs.getInt("review_count"));
                
                properties.add(property);
            }
            
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        return properties;
    }
}