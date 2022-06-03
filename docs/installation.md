# Installation
There are various ways to install and deploy dpaste. See the guides below:

## dpaste with Docker
---
dpaste Docker images are available to pull from the [Docker Hub.](https://hub.docker.com/r/darrenofficial/dpaste)

Quickstart to run a dpaste container image:
```bash
$ docker run --rm -p 8000:8000 darrenofficial/dpaste:latest
```

The dpaste image serves the project using uWSGi and is ready for production-like environments. However it’s encouraged to use an external database to store the data. See the example below for all available options, specifically `DATABASE_URL`:
```bash
$ docker run --rm -p 12345:12345 \
      --link db1 \
      -e DATABASE_URL=postgres://dpaste:supersecureposgrespassword@127.0.0.1:5432/postgres \
      -e DEBUG=True \
      -e SECRET_KEY=super-secure-key \
      -e PORT=12345 \
      darrenofficial/dpaste:latest
```

## Integration into an existing Django project
---

Install the latest dpaste release in your environment. This will install all necessary dependencies of dpaste as well:
```bash
$ pip install dpaste
```

Add `dpaste.apps.dpasteAppConfig` to your `INSTALLED_APPS` list:

```python
INSTALLED_APPS = (
    'django.contrib.sessions',
    # ...
    'dpaste.apps.dpasteAppConfig',
)
```

Add `dpaste` and the (optional) `dpaste_api` url patterns:

```python
urlpatterns = patterns('',
    # ...

    url(r'my-pastebin/', include('dpaste.urls.dpaste')),
    url(r'my-pastebin/api/', include('dpaste.urls.dpaste_api')),
)
```

Finally, migrate the database schema:

```bash
$ manage.py migrate dpaste
```

## dpaste with docker-compose for local development
---

The project’s preferred way for local development is docker-compose:

```bash
$ docker-compose up
```

This will open the Django runserver on [http://127.0.0.1:8000](http://127.0.0.1:8000). Changes to the code are automatically reflected in the Docker container and the runserver will reload automatically.

Upon first run you will need to migrate the database. Do that in a separate terminal window:

```bash
$ docker-compose run --rm app ./manage.py migrate
```

## dpaste with virtualenv for local development
---

If you prefer the classic local installation using Virtualenv then you can do so. There’s no magic involved.

Example:
```bash
$ python3 -m venv .venv
$ source .venv/bin/activate
$ pip install -e .[dev]
$ ./manage.py migrate
$ ./manage.py runserver
```

## CSS and Javascript development
---

Static files are stored in the `client/` directory and must get compiled and compressed before being used on the website.

```bash
$ npm install
```

There are some helper scripts you can invoke with `make`

**make js**
    Compile only JS files.

**make css**
    Compile only CSS files.

**make css-watch**
    Same as `build-css` but it automatically watches for changes in the CSS files and re-compiles it.

After compilation the CSS and JS files are stored in `dpaste/static/` where they are picked up by Django (and Django’s collectstatic command).

!!! note "Note"

        These files are not commited to the project repository, however they are part of the pypi wheel package, since users couldn’t compile those once they are within Python’s site-packages.
