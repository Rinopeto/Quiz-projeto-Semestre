require("dotenv").config();
const { createApp } = require("./app");
const { pool } = require("./db");

const port = Number(process.env.PORT) || 3000;
const server = createApp().listen(port, () => {
  console.log(`API do DevClash rodando em http://localhost:${port}`);
});

function shutdown() {
  server.close(() => pool.end().then(() => process.exit(0)));
}
process.on("SIGINT", shutdown);
process.on("SIGTERM", shutdown);
