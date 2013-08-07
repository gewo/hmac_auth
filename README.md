# HMACAuth

[![Build Status](https://travis-ci.org/gewo/hmac_auth.png)](https://travis-ci.org/gewo/hmac_auth/)
[![Code Coverage](https://coveralls.io/repos/gewo/hmac_auth/badge.png)](https://coveralls.io/r/gewo/hmac_auth)

```
    __  ____  ______   _________         __  __
   / / / /  |/  /   | / ____/   | __  __/ /_/ /_
  / /_/ / /|_/ / /| |/ /   / /| |/ / / / __/ __ \
 / __  / /  / / ___ / /___/ ___ / /_/ / /_/ / / /
/_/ /_/_/  /_/_/  |_\____/_/  |_\__,_/\__/_/ /_/

```

Ruby gem providing HMAC based message signing and verification. Without
fancy Rails integration.

## Installation

```ruby
gem 'hmac_auth'       # Gemfile
gem install hmac_auth # manual
```

## Usage

```ruby
# Configuration
HMACAuth.secret      = 't0p_s3cr3!!eins1'
HMACAuth.reject_keys = %w(action controller format)
HMACAuth.valid_for   = 15.minutes

to_be_signed = {
  b: 2,
  a: { d: 4, c: 3 }
}

signed = HMACAuth::Signature.sign to_be_signed
# => Hash including 'timestamp' and 'signature'

HMACAuth::Signature.verify(signed)                        # => true
HMACAuth::Signature.verify(signed.merge(evil: 'yes'))     # => false
HMACAuth::Signature.verify(signed, secret: 'good guess?') # => false

sleep 20.minutes
HMACAuth::Signature.verify(signed)                        # => false

# That's it. Nothing more, nothing less.
```

## Contributing

This is very much appreciated :-)
