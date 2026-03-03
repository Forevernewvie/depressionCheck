#!/usr/bin/env bash
set -euo pipefail

# Purpose: Build and deploy Flutter web assets to Firebase Hosting using env vars only.
: "${FIREBASE_PROJECT_ID:?FIREBASE_PROJECT_ID is required}"
: "${FIREBASE_TOKEN:?FIREBASE_TOKEN is required}"

flutter pub get
flutter analyze
flutter test
flutter build web --release --no-wasm-dry-run --dart-define=FIREBASE_PROJECT_ID="${FIREBASE_PROJECT_ID}"

firebase deploy --only hosting --project "${FIREBASE_PROJECT_ID}" --token "${FIREBASE_TOKEN}"
