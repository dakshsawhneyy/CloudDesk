require("dotenv").config();

const express = require("express");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Temporary storage. PostgreSQL comes in a later phase.
let tasks = [
  { id: 1, title: "Set up the SaaS repository", status: "completed" },
  { id: 2, title: "Build the backend API", status: "pending" },
];

let nextId = 3;

// Health check
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "ok",
    service: "saas-api",
  });
});

// Retrieve all tasks
app.get("/api/tasks", (req, res) => {
  res.json(tasks);
});

// Create a task
app.post("/api/tasks", (req, res) => {
  const title = req.body.title?.trim();

  if (!title) {
    return res.status(400).json({
      error: "Task title is required",
    });
  }

  const task = {
    id: nextId++,
    title,
    status: "pending",
  };

  tasks.push(task);

  res.status(201).json(task);
});

// Update task status
app.patch("/api/tasks/:id", (req, res) => {
  const id = Number(req.params.id);
  const { status } = req.body;

  if (!Number.isInteger(id) || id <= 0) {
    return res.status(400).json({ error: "Invalid task ID" });
  }

  if (!["pending", "completed"].includes(status)) {
    return res.status(400).json({
      error: "Status must be pending or completed",
    });
  }

  const task = tasks.find((item) => item.id === id);

  if (!task) {
    return res.status(404).json({ error: "Task not found" });
  }

  task.status = status;

  res.json(task);
});

app.listen(PORT, () => {
  console.log(`SaaS API running on http://localhost:${PORT}`);
});