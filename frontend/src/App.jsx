import { useEffect, useState } from "react";
import "./App.css";

const API_URL =
  import.meta.env.VITE_API_BASE_URL || "http://localhost:3000";

function App() {
  const [tasks, setTasks] = useState([]);
  const [title, setTitle] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  async function loadTasks() {
    try {
      setError("");

      const response = await fetch(`${API_URL}/api/tasks`);

      if (!response.ok) {
        throw new Error("Could not load tasks");
      }

      const data = await response.json();
      setTasks(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    loadTasks();
  }, []);

  async function createTask(event) {
    event.preventDefault();

    if (!title.trim()) return;

    try {
      setError("");

      const response = await fetch(`${API_URL}/api/tasks`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || "Could not create task");
      }

      setTasks((current) => [...current, data]);
      setTitle("");
    } catch (err) {
      setError(err.message);
    }
  }

  async function toggleTask(task) {
    const newStatus =
      task.status === "completed" ? "pending" : "completed";

    try {
      setError("");

      const response = await fetch(`${API_URL}/api/tasks/${task.id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status: newStatus }),
      });

      const updatedTask = await response.json();

      if (!response.ok) {
        throw new Error(updatedTask.error || "Could not update task");
      }

      setTasks((current) =>
        current.map((item) =>
          item.id === updatedTask.id ? updatedTask : item
        )
      );
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <main className="container">
      <h1>CloudDesk</h1>
      <p>Your multi-cloud SaaS project workspace</p>

      <form onSubmit={createTask}>
        <input
          value={title}
          onChange={(event) => setTitle(event.target.value)}
          placeholder="Enter a task..."
          aria-label="Task title"
        />
        <button type="submit">Add task</button>
      </form>

      {error && <p role="alert">{error}</p>}
      {loading && <p>Loading tasks...</p>}

      {!loading && !error && tasks.length === 0 && (
        <p>No tasks yet. Add your first task.</p>
      )}

      <ul>
        {tasks.map((task) => (
          <li key={task.id}>
            <span>
              {task.title} — {task.status}
            </span>

            <button onClick={() => toggleTask(task)}>
              {task.status === "completed"
                ? "Reopen"
                : "Complete"}
            </button>
          </li>
        ))}
      </ul>
    </main>
  );
}

export default App;