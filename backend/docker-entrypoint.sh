
#!/bin/sh
set -eu

CREDENTIAL_FILE="${GOOGLE_APPLICATION_CREDENTIALS:-/run/credentials/gcp-wif.json}"

# Write the ECS-injected WIF configuration to a file.
if [ -n "${GCP_WIF_CONFIG:-}" ]; then
    mkdir -p "$(dirname "$CREDENTIAL_FILE")"
    printf '%s' "$GCP_WIF_CONFIG" > "$CREDENTIAL_FILE"
    chmod 600 "$CREDENTIAL_FILE"
    unset GCP_WIF_CONFIG
fi

# Stop startup if the credential file is missing.
if [ ! -f "$CREDENTIAL_FILE" ]; then
    echo "ERROR: Google WIF credential configuration is missing: $CREDENTIAL_FILE" >&2
    exit 1
fi

exec node src/server.js
