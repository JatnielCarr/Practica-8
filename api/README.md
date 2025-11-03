# Pokemon Card API

API REST para gestionar cartas Pokémon con paginación, búsqueda, filtros y favoritos.

## 🚀 Inicio Rápido

### Requisitos
- Node.js 18+ 

### Instalación

```bash
cd api
npm install
```

### Ejecutar en desarrollo

```bash
npm run dev
```

La API estará disponible en `http://localhost:3000`

### Ejecutar en producción

```bash
npm start
```

## 📚 Endpoints

### Health Check
```
GET /health
```

### Cartas

#### Obtener todas las cartas (paginado)
```
GET /api/v1/cards?page=1&pageSize=20
```

**Query Parameters:**
- `page` (opcional): Número de página (default: 1)
- `pageSize` (opcional): Cartas por página (default: 20)
- `search` (opcional): Buscar por nombre
- `type` (opcional): Filtrar por tipo (Fire, Water, Grass, etc.)
- `rarity` (opcional): Filtrar por rareza (Common, Rare Holo, etc.)

**Respuesta:**
```json
{
  "data": [...],
  "page": 1,
  "pageSize": 20,
  "totalCount": 20,
  "totalPages": 1
}
```

#### Obtener carta por ID
```
GET /api/v1/cards/:id
```

**Respuesta:**
```json
{
  "data": {
    "id": "base1-4",
    "name": "Charizard",
    "hp": "120",
    "types": ["Fire"],
    ...
  }
}
```

### Favoritos

#### Obtener favoritos
```
GET /api/v1/favorites?userId=default-user
```

#### Agregar a favoritos
```
POST /api/v1/favorites
Content-Type: application/json

{
  "userId": "default-user",
  "cardId": "base1-4"
}
```

#### Eliminar de favoritos
```
DELETE /api/v1/favorites/:cardId?userId=default-user
```

## 🗂️ Estructura del Proyecto

```
api/
├── server.js         # Servidor Express principal
├── data/
│   └── cards.js      # Datos seed de cartas
├── package.json
└── README.md
```

## 🌐 Deploy

### Railway
```bash
railway up
```

### Render
1. Conecta tu repo a Render
2. Configura Build Command: `cd api && npm install`
3. Start Command: `cd api && npm start`

### Heroku
```bash
heroku create
git subtree push --prefix api heroku main
```

## 📝 Notas

- Los favoritos se almacenan en memoria (se pierden al reiniciar). En producción usar base de datos (MongoDB, PostgreSQL, etc.)
- Las imágenes apuntan a pokemontcg.io CDN
- La API incluye 20 cartas seed para testing

## 🔧 Variables de Entorno

Crea un archivo `.env`:

```
PORT=3000
NODE_ENV=production
```

## 🧪 Testing

Para probar los endpoints:

```bash
# Health check
curl http://localhost:3000/health

# Obtener cartas
curl http://localhost:3000/api/v1/cards?page=1&pageSize=5

# Buscar Charizard
curl http://localhost:3000/api/v1/cards?search=charizard

# Filtrar por tipo Fire
curl http://localhost:3000/api/v1/cards?type=fire
```
