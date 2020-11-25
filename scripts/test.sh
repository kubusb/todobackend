#!/bin/bash
# Activate virtual environemnt
. /appenv/bin/activate

# Download requirements to build cache
pip download -d /build -r requirements_test.txt --no-input
# Install application test requirements
pip install -f /build -r requirements_test.txt

# Run test.sh arguments
exec $@
