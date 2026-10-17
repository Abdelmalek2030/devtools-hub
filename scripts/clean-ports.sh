#!/usr/bin/env bash
# Kill process running on a specific port
PORT=$1
if [ -z "$PORT" ]; then
    echo "Usage: ./clean-ports.sh <port>"
    exit 1
fi
lsof -ti :$PORT | xargs kill -9 2>/dev/null && echo "Port $PORT freed." || echo "Port $PORT is already clear."
