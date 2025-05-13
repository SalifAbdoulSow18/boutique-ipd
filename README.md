# Symfony Product API

A RESTful API for product management built with Symfony 6, including authentication and user registration.

## Features

- Complete CRUD operations for products
- User authentication with JWT tokens
- User registration
- API documentation with Swagger/OpenAPI
- Role-based access control
- Data validation and error handling

## Requirements

- PHP 8.1 or higher
- Composer
- SQLite (default) or another database of your choice

## Installation

1. Clone the repository

2. Install dependencies:
   ```
   composer install
   ```

3. Install Symfony CLI:
   ```
   # Download and install Symfony CLI
   curl -s -L https://get.symfony.com/cli/installer -o symfony
   chmod a+x symfony
   sudo mv symfony /usr/local/bin/

   # Verify installation
   symfony --version
   ```

   Note: If the `symfony` command is not found, add it to your PATH:
   ```
   echo 'export PATH="$PATH:/usr/local/bin"' >> ~/.bashrc
   source ~/.bashrc
   # Or if using zsh:
   # echo 'export PATH="$PATH:/usr/local/bin"' >> ~/.zshrc
   # source ~/.zshrc
   ```

4. Generate JWT keys:
   ```
   mkdir -p config/jwt
   openssl genrsa -out config/jwt/private.pem 4096
   openssl rsa -pubout -in config/jwt/private.pem -out config/jwt/public.pem
   ```
   When prompted for a passphrase, use the one from your .env.local file (JWT_PASSPHRASE)

5. Create the database:
   ```
   php bin/console doctrine:database:create
   php bin/console doctrine:schema:create
   ```

6. Start the server:
   ```
   symfony server:start
   ```

## API Endpoints

### Authentication

- `POST /api/register` - Register a new user
- `POST /api/login_check` - Obtain JWT token

### Products

- `GET /api/products` - List all products (paginated)
- `GET /api/products/{id}` - Get a single product
- `POST /api/products` - Create a new product
- `PUT /api/products/{id}` - Update a product
- `DELETE /api/products/{id}` - Delete a product

## Sample Requests

### Register a User

```
POST /api/register
{
  "email": "user@example.com",
  "password": "securepassword",
  "name": "John Doe"
}
```

### Login

```
POST /api/login_check
{
  "username": "user@example.com",
  "password": "securepassword"
}
```

### Create a Product

```
POST /api/products
Authorization: Bearer <jwt_token>
{
  "name": "New Product",
  "description": "Product description",
  "price": 99.99,
  "stock": 50,
  "imageUrl": "https://example.com/image.jpg"
}
```

## Test Users

If you loaded the fixtures, you can use these test accounts:

- Regular User:
  - Email: test@example.com
  - Password: password123

- Admin User:
  - Email: admin@example.com
  - Password: admin123