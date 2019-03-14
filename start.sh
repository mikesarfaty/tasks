#!/bin/bash

export MIX_ENV=prod
export PORT=4795

echo "Stopping old copy of app, if any..."

_build/prod/rel/tasks/bin/tasks stop || true

echo "Starting app..."

_build/prod/rel/tasks/bin/tasks foreground
