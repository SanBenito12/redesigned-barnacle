# API Swagger-like Reference

Base URL: `http://192.168.1.10:3000` (replace with the value of `API` from `src/config/config.ts` on each environment).

Authentication:
- Protected routes expect the header `Authorization: Bearer <JWT>`.
- Role restrictions follow the `HasRoles` decorator: `ADMIN`, `CLIENT`.

## Endpoint Summary

| Method | Path | Roles | Description |
| --- | --- | --- | --- |
| GET | `/` | Public | Health check handled by `AppController`. |
| POST | `/auth/register` | Public | Creates a new authenticated user and returns a JWT. |
| POST | `/auth/login` | Public | Authenticates an existing user and returns a JWT. |
| GET | `/users` | CLIENT | Lists every user with its roles. |
| POST | `/users` | Public | Creates a user without logging in. |
| PUT | `/users/:id` | CLIENT | Updates profile fields. |
| PUT | `/users/upload/:id` | CLIENT | Updates profile fields plus avatar image. |
| POST | `/roles` | CLIENT | Creates a new role entry. |
| GET | `/categories` | ADMIN, CLIENT | Lists product categories. |
| POST | `/categories` | ADMIN | Creates a category with an image. |
| PUT | `/categories/:id` | ADMIN | Updates text fields. |
| PUT | `/categories/upload/:id` | ADMIN | Updates category and image. |
| DELETE | `/categories/:id` | ADMIN | Removes a category. |
| POST | `/address` | ADMIN, CLIENT | Creates an address for a user. |
| GET | `/address` | ADMIN, CLIENT | Lists all addresses. |
| GET | `/address/user/:id_user` | ADMIN, CLIENT | Lists addresses that belong to a user. |
| PUT | `/address/:id` | ADMIN, CLIENT | Updates an address. |
| DELETE | `/address/:id` | ADMIN, CLIENT | Deletes an address. |
| GET | `/products` | ADMIN, CLIENT | Lists products. |
| GET | `/products/pagination` | ADMIN, CLIENT | Lists paginated products. |
| GET | `/products/category/:id_category` | ADMIN, CLIENT | Lists products filtered by category id. |
| GET | `/products/search/:name` | ADMIN, CLIENT | Searches products by partial name. |
| POST | `/products` | ADMIN | Creates a product uploading up to two images. |
| PUT | `/products/upload/:id` | ADMIN | Updates product metadata plus specific images. |
| PUT | `/products/:id` | ADMIN | Updates product metadata only. |
| DELETE | `/products/:id` | ADMIN | Removes a product. |
| GET | `/orders` | ADMIN | Lists every order with relations. |
| GET | `/orders/:id_client` | ADMIN, CLIENT | Lists orders for a client id. |
| PUT | `/orders/:id` | ADMIN | Marks an order as `DESPACHADO`. |
| GET | `/mercadopago/identification_types` | ADMIN, CLIENT | Reads MP identification types. |
| GET | `/mercadopago/installments/:first_six_digits/:amount` | ADMIN, CLIENT | Calculates installments for a BIN + amount. |
| POST | `/mercadopago/card_token` | ADMIN, CLIENT | Creates a card token on MP. |
| POST | `/mercadopago/payments` | ADMIN, CLIENT | Creates a Mercado Pago payment and order. |

---

## Root
### `GET /`
- Roles: Public.
- Description: Returns the message from `AppService.getHello()`.

**Response 200**
```json
"Ecommerce backend is up!"
```

## Authentication
### `POST /auth/register`
- Roles: Public.
- Body: `RegisterAuthDto`.
- Description: Creates a user, attaches provided roles or defaults to `CLIENT`, and returns a JWT.

**Request**
```json
{
  "name": "Lucia",
  "lastname": "Sosa",
  "email": "lucia@example.com",
  "phone": "+5491122223333",
  "password": "secret123",
  "rolesIds": ["CLIENT"]
}
```

**Response 201**
```json
{
  "user": {
    "id": 12,
    "name": "Lucia",
    "lastname": "Sosa",
    "email": "lucia@example.com",
    "phone": "+5491122223333",
    "image": null,
    "notification_token": null,
    "roles": [
      { "id": "CLIENT", "name": "Cliente", "image": "https://.../role-icon.png", "route": "/client" }
    ],
    "created_at": "2024-03-01T12:00:00.000Z",
    "updated_at": "2024-03-01T12:00:00.000Z"
  },
  "token": "Bearer eyJhbGciOi..."
}
```

### `POST /auth/login`
- Roles: Public.
- Body: `LoginAuthDto`.

**Request**
```json
{
  "email": "lucia@example.com",
  "password": "secret123"
}
```

**Response 200**
```json
{
  "user": {
    "id": 12,
    "name": "Lucia",
    "lastname": "Sosa",
    "email": "lucia@example.com",
    "phone": "+5491122223333",
    "image": "https://.../users/12.png",
    "notification_token": "fcm-token",
    "roles": [
      { "id": "CLIENT", "name": "Cliente", "image": "https://.../role-icon.png", "route": "/client" }
    ],
    "created_at": "2024-03-01T12:00:00.000Z",
    "updated_at": "2024-03-10T09:12:00.000Z"
  },
  "token": "Bearer eyJhbGciOi..."
}
```

## Users
All protected routes require `Authorization` header with a CLIENT token.

### `GET /users`
Returns every user with related roles.

**Response 200**
```json
[
  {
    "id": 12,
    "name": "Lucia",
    "lastname": "Sosa",
    "email": "lucia@example.com",
    "phone": "+5491122223333",
    "image": "https://.../users/12.png",
    "notification_token": "fcm-token",
    "roles": [
      { "id": "CLIENT", "name": "Cliente", "image": "https://.../role-icon.png", "route": "/client" }
    ],
    "created_at": "2024-03-01T12:00:00.000Z",
    "updated_at": "2024-03-10T09:12:00.000Z"
  }
]
```

### `POST /users`
Creates a user entry without authentication (used for seeding or admin panels).

**Body**
```json
{
  "name": "Ana",
  "lastname": "Paz",
  "email": "ana@example.com",
  "phone": "+51999444555",
  "password": "password",
  "image": null,
  "notification_token": null
}
```

### `PUT /users/:id`
Updates mutable fields.

**Body**
```json
{
  "name": "Lucia",
  "lastname": "Lopez",
  "phone": "+5491188884444",
  "notification_token": "new-fcm-token"
}
```

### `PUT /users/upload/:id`
`multipart/form-data` form with:
- `file`: image (`png|jpeg|jpg`, max 10MB).
- Optional JSON fields from `UpdateUserDto`.

**Sample curl**
```bash
curl -X PUT http://API:3000/users/upload/12 \
  -H "Authorization: Bearer <token>" \
  -F "file=@/path/avatar.png" \
  -F "name=Lucia" \
  -F "lastname=Lopez"
```

## Roles
### `POST /roles`
- Roles: CLIENT token required.
- Body: `CreateRolDto`.

```json
{
  "id": "MANAGER",
  "name": "Manager",
  "image": "https://.../roles/manager.png",
  "route": "/manager"
}
```

## Categories
Routes with uploads require `multipart/form-data` plus ADMIN token.

### `GET /categories`
Returns every category.

**Response 200**
```json
[
  {
    "id": 2,
    "name": "Tecnología",
    "description": "Accesorios y gadgets",
    "image": "https://.../categories/tech.png",
    "created_at": "2024-02-10T09:00:00.000Z",
    "updated_at": "2024-02-10T09:00:00.000Z"
  }
]
```

### `POST /categories`
Form-data fields:
- `file`: category image.
- `name`, `description`.

### `PUT /categories/:id`
Body: `UpdateCategoryDto`.

```json
{
  "name": "Tecnología y Hogar",
  "description": "Tech products for every room"
}
```

### `PUT /categories/upload/:id`
Form-data: `file` + optional `name`, `description`.

### `DELETE /categories/:id`
Deletes the category if it exists.

## Address
### `POST /address`
`CreateAddressDto`.
```json
{
  "address": "Av. Siempre Viva 742",
  "neighborhood": "Springfield",
  "id_user": 12
}
```

### `GET /address`
Returns every entry.

### `GET /address/user/:id_user`
`id_user` path param.

### `PUT /address/:id`
`UpdateAddressDto`.

### `DELETE /address/:id`
Removes an address.

## Products
### `GET /products`
Returns the full list.

### `GET /products/pagination`
Query params:
- `page` (default `1`),
- `limit` (default `5`).

**Sample Response**
```json
{
  "items": [
    {
      "id": 10,
      "name": "Mouse inalámbrico",
      "description": "Silencioso, bluetooth",
      "price": 39.99,
      "image1": "https://.../products/10-front.png",
      "image2": "https://.../products/10-side.png",
      "id_category": 2,
      "created_at": "2024-02-10T09:00:00.000Z",
      "updated_at": "2024-02-10T09:00:00.000Z"
    }
  ],
  "meta": {
    "totalItems": 12,
    "itemCount": 1,
    "itemsPerPage": 5,
    "totalPages": 3,
    "currentPage": 1
  },
  "links": {
    "first": "http://192.168.1.10:3000/products/pagination?page=1&limit=5",
    "previous": null,
    "next": "http://192.168.1.10:3000/products/pagination?page=2&limit=5",
    "last": "http://192.168.1.10:3000/products/pagination?page=3&limit=5"
  }
}
```

### `GET /products/category/:id_category`
Numeric `id_category`.

### `GET /products/search/:name`
Substring search.

### `POST /products`
Form-data:
- `files[]`: up to 2 images.
- `name`, `description`, `price`, `id_category`.

### `PUT /products/upload/:id`
Form-data:
- `files[]`: array of replacements.
- `images_to_update`: JSON array with indexes (`[0,1]`).
- Optional `name`, `description`, `price`, `id_category`.

### `PUT /products/:id`
JSON body `UpdateProductDto`.

### `DELETE /products/:id`
Deletes the product.

## Orders
### `GET /orders`
ADMIN only; returns orders with `user`, `address`, and `orderHasProducts.product`.

### `GET /orders/:id_client`
Accepts client id path param; accessible by ADMIN or CLIENT.

### `PUT /orders/:id`
ADMIN only; toggles status to `DESPACHADO`. No body is required.

**Response 200**
```json
{
  "id": 100,
  "id_client": 12,
  "id_address": 7,
  "status": "DESPACHADO",
  "created_at": "2024-03-22T18:20:00.000Z",
  "updated_at": "2024-03-23T10:32:00.000Z"
}
```

## Mercado Pago
All routes require ADMIN or CLIENT token because they depend on the logged user’s context.

### `GET /mercadopago/identification_types`
Returns the list of document types exposed by MP.

### `GET /mercadopago/installments/:first_six_digits/:amount`
- `first_six_digits`: BIN of the card.
- `amount`: purchase amount.

### `POST /mercadopago/card_token`
`CardTokenBody`.
```json
{
  "card_number": "4509953566233704",
  "expiration_year": "2025",
  "expiration_month": 11,
  "security_code": "123",
  "cardholder": {
    "name": "Lucia Sosa",
    "identification": {
      "type": "DNI",
      "number": "12345678"
    }
  }
}
```

### `POST /mercadopago/payments`
`PaymentBody` that also embeds the order payload consumed by `OrdersService`.

```json
{
  "transaction_amount": 120.5,
  "token": "card-token-id",
  "installments": 3,
  "issuer_id": "24",
  "payment_method_id": "visa",
  "payer": {
    "email": "lucia@example.com",
    "identification": {
      "type": "DNI",
      "number": "12345678"
    }
  },
  "order": {
    "id_client": 12,
    "id_address": 7,
    "products": [
      { "id": 10, "quantity": 2 },
      { "id": 8, "quantity": 1 }
    ]
  }
}
```

---

## Example Swagger JSON
Paste the snippet below into https://editor.swagger.io/ to visualize it. Replace the server URL if needed and extend response schemas when you have the real payloads.

```json
{
  "openapi": "3.0.3",
  "info": {
    "title": "Ecommerce Backend API",
    "version": "1.0.0",
    "description": "Swagger-style representation of every controller exposed by the NestJS backend."
  },
  "servers": [
    { "url": "http://192.168.1.10:3000", "description": "Default API host (configure via src/config/config.ts)" }
  ],
  "components": {
    "securitySchemes": {
      "BearerAuth": {
        "type": "http",
        "scheme": "bearer",
        "bearerFormat": "JWT"
      }
    },
    "schemas": {
      "Role": {
        "type": "object",
        "properties": {
          "id": { "type": "string" },
          "name": { "type": "string" },
          "image": { "type": "string", "format": "uri" },
          "route": { "type": "string" }
        }
      },
      "User": {
        "type": "object",
        "properties": {
          "id": { "type": "integer" },
          "name": { "type": "string" },
          "lastname": { "type": "string" },
          "email": { "type": "string", "format": "email" },
          "phone": { "type": "string" },
          "image": { "type": "string", "nullable": true },
          "notification_token": { "type": "string", "nullable": true },
          "roles": {
            "type": "array",
            "items": { "$ref": "#/components/schemas/Role" }
          }
        }
      },
      "LoginRequest": {
        "type": "object",
        "required": ["email", "password"],
        "properties": {
          "email": { "type": "string", "format": "email" },
          "password": { "type": "string", "format": "password" }
        }
      },
      "RegisterRequest": {
        "type": "object",
        "required": ["name", "lastname", "email", "phone", "password"],
        "properties": {
          "name": { "type": "string" },
          "lastname": { "type": "string" },
          "email": { "type": "string", "format": "email" },
          "phone": { "type": "string" },
          "password": { "type": "string", "format": "password", "minLength": 6 },
          "rolesIds": {
            "type": "array",
            "items": { "type": "string" }
          }
        }
      },
      "AuthResponse": {
        "type": "object",
        "properties": {
          "user": { "$ref": "#/components/schemas/User" },
          "token": { "type": "string" }
        }
      },
      "CreateUserRequest": {
        "type": "object",
        "required": ["name", "lastname", "email", "phone", "password"],
        "properties": {
          "name": { "type": "string" },
          "lastname": { "type": "string" },
          "email": { "type": "string" },
          "phone": { "type": "string" },
          "password": { "type": "string" },
          "image": { "type": "string", "nullable": true },
          "notification_token": { "type": "string", "nullable": true }
        }
      },
      "UpdateUserRequest": {
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "lastname": { "type": "string" },
          "phone": { "type": "string" },
          "image": { "type": "string" },
          "notification_token": { "type": "string" }
        }
      },
      "Category": {
        "type": "object",
        "properties": {
          "id": { "type": "integer" },
          "name": { "type": "string" },
          "description": { "type": "string" },
          "image": { "type": "string" }
        }
      },
      "CreateCategoryRequest": {
        "type": "object",
        "required": ["name", "description"],
        "properties": {
          "name": { "type": "string" },
          "description": { "type": "string" }
        }
      },
      "UpdateCategoryRequest": {
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "description": { "type": "string" },
          "image": { "type": "string" }
        }
      },
      "Address": {
        "type": "object",
        "properties": {
          "id": { "type": "integer" },
          "address": { "type": "string" },
          "neighborhood": { "type": "string" },
          "id_user": { "type": "integer" }
        }
      },
      "CreateAddressRequest": {
        "type": "object",
        "required": ["address", "neighborhood", "id_user"],
        "properties": {
          "address": { "type": "string" },
          "neighborhood": { "type": "string" },
          "id_user": { "type": "integer" }
        }
      },
      "UpdateAddressRequest": {
        "type": "object",
        "properties": {
          "address": { "type": "string" },
          "neighborhood": { "type": "string" },
          "id_user": { "type": "integer" }
        }
      },
      "Product": {
        "type": "object",
        "properties": {
          "id": { "type": "integer" },
          "name": { "type": "string" },
          "description": { "type": "string" },
          "price": { "type": "number" },
          "image1": { "type": "string", "nullable": true },
          "image2": { "type": "string", "nullable": true },
          "id_category": { "type": "integer" }
        }
      },
      "CreateProductRequest": {
        "type": "object",
        "required": ["name", "description", "price", "id_category"],
        "properties": {
          "name": { "type": "string" },
          "description": { "type": "string" },
          "price": { "type": "number" },
          "id_category": { "type": "integer" }
        }
      },
      "UpdateProductRequest": {
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "description": { "type": "string" },
          "price": { "type": "number" },
          "id_category": { "type": "integer" },
          "image1": { "type": "string" },
          "image2": { "type": "string" }
        }
      },
      "OrderItem": {
        "type": "object",
        "properties": {
          "id": { "type": "integer" },
          "quantity": { "type": "integer" },
          "product": { "$ref": "#/components/schemas/Product" }
        }
      },
      "Order": {
        "type": "object",
        "properties": {
          "id": { "type": "integer" },
          "id_client": { "type": "integer" },
          "id_address": { "type": "integer" },
          "status": { "type": "string" },
          "user": { "$ref": "#/components/schemas/User" },
          "address": { "$ref": "#/components/schemas/Address" },
          "orderHasProducts": {
            "type": "array",
            "items": { "$ref": "#/components/schemas/OrderItem" }
          }
        }
      },
      "OrderInput": {
        "type": "object",
        "required": ["id_client", "id_address", "products"],
        "properties": {
          "id_client": { "type": "integer" },
          "id_address": { "type": "integer" },
          "products": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "id": { "type": "integer" },
                "quantity": { "type": "integer" }
              },
              "required": ["id", "quantity"]
            }
          }
        }
      },
      "CardTokenRequest": {
        "type": "object",
        "required": ["card_number", "expiration_year", "expiration_month", "security_code", "cardholder"],
        "properties": {
          "card_number": { "type": "string" },
          "expiration_year": { "type": "string" },
          "expiration_month": { "type": "integer" },
          "security_code": { "type": "string" },
          "cardholder": {
            "type": "object",
            "properties": {
              "name": { "type": "string" },
              "identification": {
                "type": "object",
                "properties": {
                  "type": { "type": "string" },
                  "number": { "type": "string" }
                },
                "required": ["type", "number"]
              }
            },
            "required": ["name", "identification"]
          }
        }
      },
      "PaymentRequest": {
        "type": "object",
        "required": ["transaction_amount", "token", "installments", "issuer_id", "payment_method_id", "payer", "order"],
        "properties": {
          "transaction_amount": { "type": "number" },
          "token": { "type": "string" },
          "installments": { "type": "integer" },
          "issuer_id": { "type": "string" },
          "payment_method_id": { "type": "string" },
          "payer": {
            "type": "object",
            "properties": {
              "email": { "type": "string" },
              "identification": {
                "type": "object",
                "properties": {
                  "type": { "type": "string" },
                  "number": { "type": "string" }
                },
                "required": ["type", "number"]
              }
            },
            "required": ["email", "identification"]
          },
          "order": { "$ref": "#/components/schemas/OrderInput" }
        }
      }
    }
  },
  "paths": {
    "/": {
      "get": {
        "summary": "Health check",
        "responses": {
          "200": { "description": "Returns hello message" }
        }
      }
    },
    "/auth/register": {
      "post": {
        "summary": "Register user",
        "requestBody": {
          "required": true,
          "content": {
            "application/json": { "schema": { "$ref": "#/components/schemas/RegisterRequest" } }
          }
        },
        "responses": {
          "201": {
            "description": "User created",
            "content": {
              "application/json": { "schema": { "$ref": "#/components/schemas/AuthResponse" } }
            }
          },
          "409": { "description": "Email or phone already exists" }
        }
      }
    },
    "/auth/login": {
      "post": {
        "summary": "Login user",
        "requestBody": {
          "required": true,
          "content": {
            "application/json": { "schema": { "$ref": "#/components/schemas/LoginRequest" } }
          }
        },
        "responses": {
          "200": {
            "description": "Login success",
            "content": {
              "application/json": { "schema": { "$ref": "#/components/schemas/AuthResponse" } }
            }
          },
          "403": { "description": "Invalid password" },
          "404": { "description": "User not found" }
        }
      }
    },
    "/users": {
      "get": {
        "summary": "List users",
        "security": [{ "BearerAuth": [] }],
        "responses": {
          "200": {
            "description": "Array of users",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": { "$ref": "#/components/schemas/User" }
                }
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create user",
        "requestBody": {
          "required": true,
          "content": {
            "application/json": { "schema": { "$ref": "#/components/schemas/CreateUserRequest" } }
          }
        },
        "responses": {
          "201": {
            "description": "User created",
            "content": {
              "application/json": { "schema": { "$ref": "#/components/schemas/User" } }
            }
          }
        }
      }
    },
    "/users/{id}": {
      "put": {
        "summary": "Update user",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": { "schema": { "$ref": "#/components/schemas/UpdateUserRequest" } }
          }
        },
        "responses": {
          "200": { "description": "Updated user" },
          "404": { "description": "User not found" }
        }
      }
    },
    "/users/upload/{id}": {
      "put": {
        "summary": "Update user with avatar",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "multipart/form-data": {
              "schema": {
                "type": "object",
                "properties": {
                  "file": { "type": "string", "format": "binary" },
                  "payload": { "$ref": "#/components/schemas/UpdateUserRequest" }
                }
              }
            }
          }
        },
        "responses": {
          "200": { "description": "Updated user" }
        }
      }
    },
    "/roles": {
      "post": {
        "summary": "Create role",
        "security": [{ "BearerAuth": [] }],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": { "schema": { "$ref": "#/components/schemas/Role" } }
          }
        },
        "responses": {
          "201": { "description": "Role created" }
        }
      }
    },
    "/categories": {
      "get": {
        "summary": "List categories",
        "security": [{ "BearerAuth": [] }],
        "responses": {
          "200": {
            "description": "Array of categories",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": { "$ref": "#/components/schemas/Category" }
                }
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create category",
        "security": [{ "BearerAuth": [] }],
        "requestBody": {
          "required": true,
          "content": {
            "multipart/form-data": {
              "schema": {
                "type": "object",
                "properties": {
                  "file": { "type": "string", "format": "binary" },
                  "name": { "type": "string" },
                  "description": { "type": "string" }
                },
                "required": ["file", "name", "description"]
              }
            }
          }
        },
        "responses": { "201": { "description": "Category created" } }
      }
    },
    "/categories/{id}": {
      "put": {
        "summary": "Update category",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": { "schema": { "$ref": "#/components/schemas/UpdateCategoryRequest" } }
          }
        },
        "responses": {
          "200": { "description": "Updated category" },
          "404": { "description": "Category not found" }
        }
      },
      "delete": {
        "summary": "Delete category",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "responses": {
          "200": { "description": "Category deleted" },
          "404": { "description": "Category not found" }
        }
      }
    },
    "/categories/upload/{id}": {
      "put": {
        "summary": "Update category with image",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "multipart/form-data": {
              "schema": {
                "type": "object",
                "properties": {
                  "file": { "type": "string", "format": "binary" },
                  "name": { "type": "string" },
                  "description": { "type": "string" }
                },
                "required": ["file"]
              }
            }
          }
        },
        "responses": { "200": { "description": "Category updated" } }
      }
    },
    "/address": {
      "get": {
        "summary": "List addresses",
        "security": [{ "BearerAuth": [] }],
        "responses": {
          "200": {
            "description": "Array of addresses",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": { "$ref": "#/components/schemas/Address" }
                }
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create address",
        "security": [{ "BearerAuth": [] }],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": { "schema": { "$ref": "#/components/schemas/CreateAddressRequest" } }
          }
        },
        "responses": { "201": { "description": "Address created" } }
      }
    },
    "/address/user/{id_user}": {
      "get": {
        "summary": "Addresses by user",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id_user", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "responses": { "200": { "description": "Addresses returned" } }
      }
    },
    "/address/{id}": {
      "put": {
        "summary": "Update address",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": { "schema": { "$ref": "#/components/schemas/UpdateAddressRequest" } }
          }
        },
        "responses": { "200": { "description": "Address updated" } }
      },
      "delete": {
        "summary": "Delete address",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "responses": { "200": { "description": "Address deleted" } }
      }
    },
    "/products": {
      "get": {
        "summary": "List products",
        "security": [{ "BearerAuth": [] }],
        "responses": {
          "200": {
            "description": "Array of products",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": { "$ref": "#/components/schemas/Product" }
                }
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create product",
        "security": [{ "BearerAuth": [] }],
        "requestBody": {
          "required": true,
          "content": {
            "multipart/form-data": {
              "schema": {
                "type": "object",
                "properties": {
                  "files[]": { "type": "array", "items": { "type": "string", "format": "binary" } },
                  "name": { "type": "string" },
                  "description": { "type": "string" },
                  "price": { "type": "number" },
                  "id_category": { "type": "integer" }
                },
                "required": ["files[]", "name", "description", "price", "id_category"]
              }
            }
          }
        },
        "responses": { "201": { "description": "Product created" } }
      }
    },
    "/products/pagination": {
      "get": {
        "summary": "Paginated products",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "page", "in": "query", "schema": { "type": "integer", "default": 1 } },
          { "name": "limit", "in": "query", "schema": { "type": "integer", "default": 5 } }
        ],
        "responses": { "200": { "description": "Paginated result" } }
      }
    },
    "/products/category/{id_category}": {
      "get": {
        "summary": "Products by category",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id_category", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "responses": { "200": { "description": "Products returned" } }
      }
    },
    "/products/search/{name}": {
      "get": {
        "summary": "Search products",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "name", "in": "path", "required": true, "schema": { "type": "string" } }
        ],
        "responses": { "200": { "description": "Matching products" } }
      }
    },
    "/products/{id}": {
      "put": {
        "summary": "Update product",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": { "schema": { "$ref": "#/components/schemas/UpdateProductRequest" } }
          }
        },
        "responses": {
          "200": { "description": "Updated product" },
          "404": { "description": "Product not found" }
        }
      },
      "delete": {
        "summary": "Delete product",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "responses": {
          "200": { "description": "Product deleted" },
          "404": { "description": "Product not found" }
        }
      }
    },
    "/products/upload/{id}": {
      "put": {
        "summary": "Update product with new images",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "multipart/form-data": {
              "schema": {
                "type": "object",
                "properties": {
                  "files[]": { "type": "array", "items": { "type": "string", "format": "binary" } },
                  "images_to_update": { "type": "array", "items": { "type": "integer" } },
                  "name": { "type": "string" },
                  "description": { "type": "string" },
                  "price": { "type": "number" },
                  "id_category": { "type": "integer" }
                },
                "required": ["files[]", "images_to_update"]
              }
            }
          }
        },
        "responses": { "200": { "description": "Product updated" } }
      }
    },
    "/orders": {
      "get": {
        "summary": "List orders",
        "security": [{ "BearerAuth": [] }],
        "responses": {
          "200": {
            "description": "Array of orders",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": { "$ref": "#/components/schemas/Order" }
                }
              }
            }
          }
        }
      }
    },
    "/orders/{id}": {
      "get": {
        "summary": "Orders by client id",
        "description": "Returns every order that belongs to the provided client id.",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" }, "description": "Client id" }
        ],
        "responses": { "200": { "description": "Orders returned" } }
      },
      "put": {
        "summary": "Update order status",
        "description": "Sets the order status to DESPACHADO.",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" }, "description": "Order id" }
        ],
        "responses": {
          "200": { "description": "Order updated" },
          "404": { "description": "Order not found" }
        }
      }
    },
    "/mercadopago/identification_types": {
      "get": {
        "summary": "Mercado Pago identification types",
        "security": [{ "BearerAuth": [] }],
        "responses": { "200": { "description": "MP response" } }
      }
    },
    "/mercadopago/installments/{bin}/{amount}": {
      "get": {
        "summary": "Mercado Pago installments",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "bin", "in": "path", "required": true, "schema": { "type": "string" } },
          { "name": "amount", "in": "path", "required": true, "schema": { "type": "number" } }
        ],
        "responses": { "200": { "description": "MP response" } }
      }
    },
    "/mercadopago/card_token": {
      "post": {
        "summary": "Create card token",
        "security": [{ "BearerAuth": [] }],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": { "schema": { "$ref": "#/components/schemas/CardTokenRequest" } }
          }
        },
        "responses": { "201": { "description": "Card token created" } }
      }
    },
    "/mercadopago/payments": {
      "post": {
        "summary": "Create Mercado Pago payment",
        "security": [{ "BearerAuth": [] }],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": { "schema": { "$ref": "#/components/schemas/PaymentRequest" } }
          }
        },
        "responses": { "201": { "description": "Payment created" } }
      }
    }
  }
}
```
