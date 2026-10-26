require("dotenv").config();

const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");

const app = express();
const PORT = process.env.PORT || 3000;

const helmet = require("helmet");
const rateLimit = require("express-rate-limit");
const cors = require("cors");

app.use(cors());
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  ssl: process.env.DB_SSL === "true" ? { rejectUnauthorized: false } : false,
  connectionTimeoutMillis: 5000,
});

async function initializeDatabase() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS tasks (
      id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      title VARCHAR(200) NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'completed')),
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    )
  `);
}

// Configure Middleware before your API Routes
const frontendOrigin = process.env.FRONTEND_ORIGIN;

if (!frontendOrigin) {
  throw new Error("FRONTEND_ORIGIN must be configured");
}

app.disable("x-powered-by");

app.use(helmet());

app.use(cors({
  origin: frontendOrigin,
  methods: ["GET", "POST", "PATCH", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
}));

app.use(express.json({ limit: "100kb" }));

const apiLimiter = rateLimit({
  windowMs: 60 * 1000,
  limit: 100,
  standardHeaders: "draft-8",
  legacyHeaders: false,
});

app.use("/api", apiLimiter);


app.get("/health", (req, res) => {
  res.status(200).json({
    status: "ok",
    service: "saas-clouddesk-api",
  });
});

app.get("/ready", async (req, res) => {
  try {
    await pool.query("SELECT 1");
    res.json({ status: "ready", database: "connected" });
  } catch {
    res.status(503).json({ status: "not_ready" });
  }
});

app.get("/api/tasks", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT id, title, status FROM tasks ORDER BY id"
    );
    res.json(result.rows);
  } catch {
    res.status(500).json({ error: "Could not retrieve taskssss" });
  }
});

app.post("/api/tasks", async (req, res) => {
  const title = req.body.title?.trim();

  if (!title || title.length > 200) {
    return res.status(400).json({
      error: "Title must contain between 1 and 200 characters",
    });
  }

  try {
    const result = await pool.query(
      "INSERT INTO tasks (title) VALUES ($1) RETURNING id, title, status",
      [title]
    );

    res.status(201).json(result.rows[0]);
  } catch {
    res.status(500).json({ error: "Could not create task" });
  }
});

app.patch("/api/tasks/:id", async (req, res) => {
  const id = Number(req.params.id);
  const { status } = req.body;

  if (!Number.isSafeInteger(id) || id <= 0) {
    return res.status(400).json({ error: "Invalid task ID" });
  }

  if (!["pending", "completed"].includes(status)) {
    return res.status(400).json({ error: "Invalid task status" });
  }

  try {
    const result = await pool.query(
      "UPDATE tasks SET status = $1 WHERE id = $2 RETURNING id, title, status",
      [status, id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Task not found" });
    }

    res.json(result.rows[0]);
  } catch {
    res.status(500).json({ error: "Could not update task" });
  }
});

async function start() {
  try {
    await initializeDatabase();

    app.listen(PORT, () => {
      console.log(`SaaS API listening on port ${PORT}`);
    });
  } catch (error) {
    console.error("Database initialization failed:", error.message);
    process.exit(1);
  }
}

start();