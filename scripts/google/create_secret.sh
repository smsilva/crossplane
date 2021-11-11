#!/bin/bash
BASE64ENCODED_GOOGLE_PROJECT=$(            echo -n "${GOOGLE_PROJECT?}"             | base64 | tr -d "\n") && \
BASE64ENCODED_GOOGLE_BUCKET=$(             echo -n "${GOOGLE_BUCKET?}"              | base64 | tr -d "\n") && \
BASE64ENCODED_GOOGLE_PREFIX=$(             echo -n "${GOOGLE_PREFIX?}"              | base64 | tr -d "\n") && \
BASE64ENCODED_GOOGLE_CREDENTIALS=$(        echo -n "${GOOGLE_CREDENTIALS?}"         | base64 | tr -d "\n") && \
BASE64ENCODED_GOOGLE_BACKEND_CREDENTIALS=$(echo -n "${GOOGLE_BACKEND_CREDENTIALS?}" | base64 | tr -d "\n") && \
kubectl apply -f - <<EOF
---
apiVersion: v1
kind: Secret
metadata:
  name: google-credentials
type: Opaque
data:
  GOOGLE_PROJECT:             ${BASE64ENCODED_GOOGLE_PROJECT}
  GOOGLE_BUCKET:              ${BASE64ENCODED_GOOGLE_BUCKET}
  GOOGLE_PREFIX:              ${BASE64ENCODED_GOOGLE_PREFIX}
  GOOGLE_CREDENTIALS:         ${BASE64ENCODED_GOOGLE_CREDENTIALS}
  GOOGLE_BACKEND_CREDENTIALS: ${BASE64ENCODED_GOOGLE_BACKEND_CREDENTIALS}
EOF
