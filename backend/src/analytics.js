const { PubSub } = require("@google-cloud/pubsub");
const { randomUUID } = require("node:crypto");

let pubsub;

function getPubSubClient() {
  if (!process.env.GCP_PROJECT_ID || !process.env.GCP_PUBSUB_TOPIC) {
    return null;
  }

  if (!pubsub) {
    pubsub = new PubSub({
      projectId: process.env.GCP_PROJECT_ID,
    });
  }

  return pubsub;
}

async function publishApplicationEvent({
  eventType,
  taskId,
  environment = "dev",
}) {
  const client = getPubSubClient();

  if (!client) {
    console.warn("Analytics publishing is not configured.");
    return;
  }

  const event = {
    event_id: randomUUID(),
    event_type: eventType,
    occurred_at: new Date().toISOString(),
    task_id: String(taskId),
    environment,
  };

  try {
    const messageId = await client
      .topic(process.env.GCP_PUBSUB_TOPIC)
      .publishMessage({
        data: Buffer.from(JSON.stringify(event)),
      });

    console.log("Analytics event published:", {
      messageId,
      eventType,
    });
  } catch (error) {
    // Analytics failures should not turn a successful task write
    // into a failed API response in this development implementation.
    console.error("Analytics event publishing failed:", error.message);
  }
}

module.exports = { publishApplicationEvent };