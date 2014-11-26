[![Build Status](https://travis-ci.org/Nedomas/pavonine.svg)](https://travis-ci.org/Nedomas/pavonine)

# Pavonine
Backend as a service

## Developing
- ``gulp`` - builds the ``.coffee`` files and runs ``gulp watch``
- ``gulp watch`` - runs ``gulp`` continuously.

## Initial setup

1. Clone [pavonine-backend](https://github.com/ryzaskaciukas/pavonine-backend) with ``git clone git@github.com:ryzaskaciukas/pavonine-backend.git``
2. Install MongoDB. [Instructions](http://docs.mongodb.org/manual/installation)
3. Run ``bundle install`` in ``~/pavonine-backend``
4. Run ``rails server`` in ``~/pavonine-backend``
5. Clone this repo with ``git clone git@github.com:Nedomas/pavonine.git``
6. Create a loader symlink ``ln ~/pavonine/dist/js/pavonine.js ~/pavonine-backend/app/views/scripts/_pavonine.js``
7. Create a core script symlink ``ln ~/pavonine/dist/js/core.js ~/pavonine-backend/public/core.js``
8. Open ``localhost:3000`` and follow the instructions on the launching page.

## Sample app
Sample developed app is here:
[bro-web-app](https://github.com/Nedomas/bro-web-app).

1. Clone it with ``git clone git@github.com:Nedomas/bro-web-app.git``
2. Insert the script tag from launchin website at pavonine-backend
3. Change local ip to your ip (probably ``localhost``)

```jade
script(src='http://10.30.0.1:3000/app/heaney-muller-and-mohr.js', type='text/javascript')
```

4. Run ``gulp`` to build html.
5. Run ``rackup`` to start a server on ``localhost:9292`` or just open the
``index.html`` with your browser.
