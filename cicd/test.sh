#!/bin/bash
set -e

echo "Running pytest unit tests in $(pwd)..."
pytest cicd/test.py

echo "Integration tests can be added here..."
# pytest tests/integration

