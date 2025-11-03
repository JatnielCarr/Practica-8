import express from 'express';
import cors from 'cors';
import { pokemonCards } from './data/cards.js';

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// In-memory favorites storage (en producción usar base de datos)
const favorites = new Map();

// GET /cards - Obtener cartas con paginación
app.get('/api/v1/cards', (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const pageSize = parseInt(req.query.pageSize) || 20;
  const search = req.query.search?.toLowerCase() || '';
  const type = req.query.type?.toLowerCase();
  const rarity = req.query.rarity?.toLowerCase();

  let filtered = pokemonCards;

  // Filtrar por búsqueda de nombre
  if (search) {
    filtered = filtered.filter(card => 
      card.name.toLowerCase().includes(search)
    );
  }

  // Filtrar por tipo
  if (type) {
    filtered = filtered.filter(card => 
      card.types?.some(t => t.toLowerCase() === type)
    );
  }

  // Filtrar por rareza
  if (rarity) {
    filtered = filtered.filter(card => 
      card.rarity?.toLowerCase() === rarity
    );
  }

  const totalCount = filtered.length;
  const totalPages = Math.ceil(totalCount / pageSize);
  const start = (page - 1) * pageSize;
  const end = start + pageSize;
  const data = filtered.slice(start, end);

  res.json({
    data,
    page,
    pageSize,
    totalCount,
    totalPages,
  });
});

// GET /cards/:id - Obtener carta por ID
app.get('/api/v1/cards/:id', (req, res) => {
  const card = pokemonCards.find(c => c.id === req.params.id);
  
  if (!card) {
    return res.status(404).json({ error: 'Card not found' });
  }
  
  res.json({ data: card });
});

// GET /favorites - Obtener favoritos de un usuario
app.get('/api/v1/favorites', (req, res) => {
  const userId = req.query.userId || 'default-user';
  const userFavorites = favorites.get(userId) || [];
  
  const favoriteCards = userFavorites
    .map(cardId => pokemonCards.find(c => c.id === cardId))
    .filter(Boolean);
  
  res.json({
    data: favoriteCards,
    count: favoriteCards.length,
  });
});

// POST /favorites - Agregar a favoritos
app.post('/api/v1/favorites', (req, res) => {
  const { userId = 'default-user', cardId } = req.body;
  
  if (!cardId) {
    return res.status(400).json({ error: 'cardId is required' });
  }
  
  const card = pokemonCards.find(c => c.id === cardId);
  if (!card) {
    return res.status(404).json({ error: 'Card not found' });
  }
  
  const userFavorites = favorites.get(userId) || [];
  
  if (!userFavorites.includes(cardId)) {
    userFavorites.push(cardId);
    favorites.set(userId, userFavorites);
  }
  
  res.json({
    message: 'Added to favorites',
    data: card,
  });
});

// DELETE /favorites/:cardId - Eliminar de favoritos
app.delete('/api/v1/favorites/:cardId', (req, res) => {
  const userId = req.query.userId || 'default-user';
  const { cardId } = req.params;
  
  const userFavorites = favorites.get(userId) || [];
  const filtered = userFavorites.filter(id => id !== cardId);
  favorites.set(userId, filtered);
  
  res.json({
    message: 'Removed from favorites',
    cardId,
  });
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`🚀 Pokemon Card API running on http://localhost:${PORT}`);
  console.log(`📊 Loaded ${pokemonCards.length} cards`);
});
