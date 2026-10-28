
const { PubSub } = require("@google-cloud/pubsub");
const { AwsClient } = require("google-auth-library");
const { fromNodeProviderChain } = require("@aws-sdk/credential-providers");
const { randomUUID } = require("node:crypto");
const fs = require("node:fs");

let pubsub;

class EcsAwsCredentialsSupplier {
  constructor() {
    this.credentialsProvider = fromNodeProviderChain();
  }

  async getAwsRegion() {
    const region =
      process.env.AWS_REGION ||
      process.env.AWS_DEFAULT_REGION;

    if (!region) {
      throw new Error("AWS_REGION is not configured");
    }

    return region;
  }

  async getAwsSecurityCredentials() {
    const credentials = await this.credentialsProvider();

    if (
      !credentials.accessKeyId ||
      !credentials.secretAccessKey ||
      !credentials.sessionToken
    ) {
      throw new Error(
        "Unable to obtain temporary ECS task-role credentials"
      );
    }

    return {
      accessKeyId: credentials.accessKeyId,
      secretAccessKey: credentials.secretAccessKey,
      token: credentials.sessionToken,
    };
  }
}

function getPubSubClient() {
  if (!process.env.GCP_PROJECT_ID || !process.env.GCP_PUBSUB_TOPIC) {
    return null;
  }

  if (!pubsub) {
    const credentialPath =
      process.env.GOOGLE_APPLICATION_CREDENTIALS ||
      "/run/credentials/gcp-wif.json";

    const wifConfig = JSON.parse(
      fs.readFileSync(credentialPath, "utf8")
    );

    if (wifConfig.type !== "external_account" || !wifConfig.audience) {
      throw new Error("Invalid Google WIF external-account configuration");
    }

    const {
      credential_source,
      ...wifOptions
    } = wifConfig;

    const authClient = new AwsClient({
      ...wifOptions,
      aws_security_credentials_supplier:
        new EcsAwsCredentialsSupplier(),
    });

    pubsub = new PubSub({
      projectId: process.env.GCP_PROJECT_ID,
      authClient,
    });
  }

  return pubsub;
}

async function publishApplicationEvent({
  eventType,
  taskId,
  environment = "dev",
}) {
  let client;

  try {
    client = getPubSubClient();

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
    console.error("Analytics event publishing failed:", error.message);
  }
}

module.exports = { publishApplicationEvent };
