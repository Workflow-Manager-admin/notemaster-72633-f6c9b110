#!/bin/bash
cd /home/kavia/workspace/code-generation/notemaster-72633-f6c9b110/notes_app_frontend_workspace/notes_app_frontend
npx run lint
ESLINT_EXIT_CODE=$?
npm run build
BUILD_EXIT_CODE=$?
if [ $ESLINT_EXIT_CODE -ne 0 ] || [ $BUILD_EXIT_CODE -ne 0 ]; then
  exit 1
fi

