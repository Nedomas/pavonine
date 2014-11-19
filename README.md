# Pavonine
Backend as a service

## Developing
- ``gulp`` - builds the ``.coffee`` files and runs ``gulp watch``
- ``gulp watch`` - runs ``gulp`` continuously.
- ``gulp build`` - runs ``gulp`` and builds minimized version alongside.

## Initial setup

1. Clone [pavonine-backend](https://github.com/ryzaskaciukas/pavonine-backend) with ``git clone git@github.com:ryzaskaciukas/pavonine-backend.git``
2. Run ``rails server`` in ``~/pavonine-backend``
3. Clone this repo with ``git clone git@github.com:Nedomas/pavonine.git``
4. Symlink ``dist/js/pavonine.js`` to ``~/pavonine-backend/public/pavonine.js``
5. Open ``localhost:3000`` and follow the instructions.

Sample developed app is here: [bro-web-app](https://github.com/Nedomas/bro-web-app) with ``git@github.com:Nedomas/bro-web-app.git``
