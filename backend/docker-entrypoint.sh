
#!/bin/sh
set -eu

CREDENTIAL_FILE="${GOOGLE_APPLICATION_CREDENTIALS:-/run/credentials/gcp-wif.json}"

# Create the credential file from the ECS-injected secret.
if [ -n "${GCP_WIF_CONFIG:-}" ]; then
    mkdir -p "$(dirname "$CREDENTIAL_FILE")"
    printf '%s' "$GCP_WIF_CONFIG" > "$CREDENTIAL_FILE"
    chmod 600 "$CREDENTIAL_FILE"
    unset GCP_WIF_CONFIG
fi

# Fail clearly instead of silently starting without configured credentials.
if [ ! -f "$CREDENTIAL_FILE" ]; then
    echo "ERROR: Google WIF credential configuration is missing: $CREDENTIAL_FILE" >&2
    exit 1
fi

exec node src/server.js
