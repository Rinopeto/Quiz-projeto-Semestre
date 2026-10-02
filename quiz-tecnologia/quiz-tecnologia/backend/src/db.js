const { Pool } = require("pg");

// Carregue o .env (dotenv) ANTES de importar este módulo.
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  // Bancos gerenciados (Neon, Supabase, Render...) costumam exigir SSL: DATABASE_SSL=true
  ssl: process.env.DATABASE_SSL === "true" ? { rejectUnauthorized: false } : undefined
});

module.exports = { pool };
