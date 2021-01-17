import argparse
import json
import time

import google.auth.crypt
import google.auth.jwt

"""Max lifetime of the token (one hour, in seconds)."""
MAX_TOKEN_LIFETIME_SECS = 3600


def generate_jwt(service_account_file, issuer, audiences):
    """Generates a signed JSON Web Token using a Google API Service Account."""
    service_account_info = {}

    with open(service_account_file, 'r') as fh:
        service_account_info = json.load(fh)

    print(service_account_info)
    signer = google.auth.crypt.RSASigner.from_string(
            service_account_info['private_key'],
            service_account_info['private_key_id']
    )

    now = int(time.time())

    payload = {
        'iat': now,
        'exp': now + MAX_TOKEN_LIFETIME_SECS,
        # aud must match 'audience' in the security configuration in your
        # swagger spec. It can be any string.
        'aud': audiences,
        # iss must match 'issuer' in the security configuration in your
        # swagger spec. It can be any string.
        'iss': issuer,
        # sub and email are mapped to the user id and email respectively.
        'sub': issuer,
        'email': 'user@example.com'
    }

    signed_jwt = google.auth.jwt.encode(signer, payload)
    #return signed_jwt
    return signed_jwt.decode('utf-8')
