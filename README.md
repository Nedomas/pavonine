# Cornflake
Backend as a service

## Developing
- ``gulp`` - builds the ``.coffee`` and ``.slim`` files.
- ``gulp watch`` - runs ``gulp`` continuously.
- ``gulp build`` - runs ``gulp`` and builds minimized version alongside.

## Initial setup

1. Clone [cornflake-backend](https://github.com/Nedomas/cornflake-backend) with ``git clone git@github.com:Nedomas/cornflake-backend.git``
2. Run ``rails server`` in ``~/cornflake-backend``
3. Set up ``Databound.API_URL = 'localhost:3000'`` in ``cornflake.coffee``
4. Run ``gulp`` in ``~/cornflake``
5. Run ``rackup`` in ``~/cornflake`` to run static file server with rack.
6. Open up ``localhost:9292``.
