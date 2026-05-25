#!/usr/bin/env python3
"""
Build a safe SSM RunShellScript parameters JSON from a base64-encoded script.
Usage: python3 deploy/ssm-params.py <base64_string>
"""
import json
import sys

b64 = sys.argv[1]
cmd = 'printf "%s" "' + b64 + '" | base64 -d > /home/ubuntu/hermes-deploy.sh && chmod +x /home/ubuntu/hermes-deploy.sh && echo written'
print(json.dumps({"commands": [cmd]}))
