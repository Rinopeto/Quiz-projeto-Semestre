// Cria as tabelas e carrega as perguntas iniciais: npm run db:init
require("dotenv").config();
const fs = require("fs");
const path = require("path");
const { pool } = require("../src/db");

async function main() {
  for (const file of ["schema.sql", "seed.sql"]) {
    const sql = fs.readFileSync(path.join(__dirname, "..", file), "utf8");
    await pool.query(sql);
    console.log(`OK: ${file}`);
  }
}

main()
  .catch((err) => {
    console.error("Falha ao inicializar o banco:", err.message);
    process.exitCode = 1;
  })
  .finally(() => pool.end());
