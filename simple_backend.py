#!/usr/bin/env python3
"""
Staybnb Simple Backend Server
Simple Python HTTP server for the Staybnb project
Serves the frontend and provides basic API endpoints
"""

import http.server
import socketserver
import json
import urllib.parse
import os
from datetime import datetime

# Sample property data
PROPERTIES = [
    {
        "id": 1,
        "title": "Luxury Villa in Bali",
        "location": "Bali, Indonesia",
        "price": 150,
        "rating": 4.8,
        "image": "images/bali.png",
        "type": "Villa",
        "guests": 6,
        "bedrooms": 3,
        "bathrooms": 2,
        "amenities": ["WiFi", "Pool", "Kitchen", "Air Conditioning"],
        "description": "Beautiful luxury villa with private pool and stunning views"
    },
    {
        "id": 2,
        "title": "Modern Apartment in Paris",
        "location": "Paris, France",
        "price": 120,
        "rating": 4.6,
        "image": "images/paris.png",
        "type": "Apartment",
        "guests": 4,
        "bedrooms": 2,
        "bathrooms": 1,
        "amenities": ["WiFi", "Kitchen", "Heating", "City View"],
        "description": "Stylish apartment in the heart of Paris"
    },
    {
        "id": 3,
        "title": "Cozy Cabin in Swiss Alps",
        "location": "Swiss Alps, Switzerland",
        "price": 200,
        "rating": 4.9,
        "image": "images/swiss.png",
        "type": "Cabin",
        "guests": 8,
        "bedrooms": 4,
        "bathrooms": 3,
        "amenities": ["WiFi", "Fireplace", "Mountain View", "Ski Access"],
        "description": "Perfect mountain retreat with breathtaking alpine views"
    }
]

class StaybnbHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        parsed_path = urllib.parse.urlparse(self.path)
        path = parsed_path.path
        query_params = urllib.parse.parse_qs(parsed_path.query)
        
        # Handle API endpoints
        if path.startswith('/api/'):
            self.handle_api_request(path, query_params)
        else:
            # Serve static files
            super().do_GET()
    
    def handle_api_request(self, path, params):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        
        if path == '/api/properties':
            # Filter properties based on query parameters
            filtered_properties = self.filter_properties(params)
            response = {
                'status': 'success',
                'data': filtered_properties,
                'total': len(filtered_properties)
            }
        else:
            response = {'status': 'error', 'message': 'Endpoint not found'}
        
        self.wfile.write(json.dumps(response).encode())
    
    def filter_properties(self, params):
        properties = PROPERTIES.copy()
        
        # Filter by location
        if 'location' in params and params['location'][0]:
            location = params['location'][0].lower()
            properties = [p for p in properties if location in p['location'].lower()]
        
        # Filter by type
        if 'type' in params and params['type'][0]:
            property_type = params['type'][0].lower()
            properties = [p for p in properties if property_type in p['type'].lower()]
        
        # Filter by price range
        if 'min_price' in params and params['min_price'][0]:
            min_price = float(params['min_price'][0])
            properties = [p for p in properties if p['price'] >= min_price]
        
        if 'max_price' in params and params['max_price'][0]:
            max_price = float(params['max_price'][0])
            properties = [p for p in properties if p['price'] <= max_price]
        
        # Sort properties
        if 'sort' in params and params['sort'][0]:
            sort_by = params['sort'][0]
            if sort_by == 'price_low':
                properties.sort(key=lambda x: x['price'])
            elif sort_by == 'price_high':
                properties.sort(key=lambda x: x['price'], reverse=True)
            elif sort_by == 'rating':
                properties.sort(key=lambda x: x['rating'], reverse=True)
        
        return properties

def main():
    PORT = 8000
    
    try:
        with socketserver.TCPServer(("", PORT), StaybnbHandler) as httpd:
            print(f"🌐 Staybnb Backend Server running on http://localhost:{PORT}")
            print(f"📁 Serving files from: {os.getcwd()}")
            print(f"🔗 API available at: http://localhost:{PORT}/api/properties")
            print("\n🚀 Server started successfully!")
            print("Press Ctrl+C to stop the server\n")
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Server stopped by user")
    except Exception as e:
        print(f"❌ Error starting server: {e}")

if __name__ == "__main__":
    main()