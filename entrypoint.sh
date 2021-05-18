#!/bin/bash

set -euo pipefail

# Configuration Step
[[ ! -f /etc/mopidy/mopidy.conf ]] && envsubst < /etc/mopidy/.mopidy.conf > /etc/mopidy/mopidy.conf

exec "$@"
