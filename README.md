# Vero

A comprehensive driver management and tracking system built with Flutter mobile application and PHP backend API.

## Overview

Vero is a full-stack application designed for managing drivers and tracking their activities. The system consists of:

- **Flutter Mobile App**: Cross-platform mobile application with location tracking and mapping capabilities
- **PHP REST API**: Backend server providing authentication, driver management, and data persistence

## Project Structure

```
vero/
├── flutter/           # Flutter mobile application
│   ├── lib/
│   │   ├── communication/ # API communication modules
│   │   ├── enums/        # Application enumerations
│   │   ├── handlers/     # Event and data handlers
│   │   ├── helpers/      # Utility functions
│   │   ├── widgets/      # UI components
│   │   └── main.dart     # Application entry point
│   └── pubspec.yaml      # Flutter dependencies
├── api/               # PHP REST API backend
│   ├── auth_functions.php
│   ├── config.php
│   ├── create_db.php
│   ├── functions.php
│   └── index.php      # Main API endpoint
└── LICENSE           # MIT License
```

## Features

### Mobile App (Flutter)
- User authentication (login/register)
- Real-time location tracking
- Interactive maps with location markers
- Custom navigation interface
- Cross-platform support (iOS, Android, Web, Desktop)

### Backend API (PHP)
- JWT token-based authentication
- User registration and login
- Driver management (CRUD operations)
- Role-based access control (admin/user levels)
- RESTful API endpoints

## Dependencies

### Flutter App
- **flutter**: Flutter SDK
- **http**: HTTP requests for API communication
- **location**: Location services
- **flutter_map**: Interactive map widget
- **flutter_map_location_marker**: Location markers for maps
- **latlong2**: Latitude/longitude calculations
- **geocoding**: Address geocoding services
- **custom_navigation_bar**: Custom navigation components

### Backend API
- **PHP**: Server-side scripting
- **PDO**: Database abstraction layer
- **MySQL/PostgreSQL**: Database (configurable)

## Getting Started

### Prerequisites
- Flutter SDK (3.4.1 or higher)
- PHP 7.4+
- MySQL or PostgreSQL database
- Web server (Apache/Nginx)

### Backend Setup
1. Configure database connection in `api/config.php`
2. Run `api/create_db.php` to initialize database tables
3. Deploy API files to your web server

### Flutter App Setup
1. Navigate to the `flutter/` directory
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure API endpoints in the communication modules
4. Run the application:
   ```bash
   flutter run
   ```

## API Endpoints

- `POST /api/?action=register` - User registration
- `POST /api/?action=login` - User authentication
- `GET /api/?action=get_all_drivers` - Retrieve all drivers (admin only)
- `POST /api/?action=add_driver` - Add new driver (admin only)

## Authentication

The API uses Bearer token authentication. Include the token in the Authorization header:
```
Authorization: Bearer <your-token>
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Copyright (c) 2024 Orestis Lefkadtis

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request