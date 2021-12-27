# Testing

## Testing with Tox
---


dpaste is continuously tested online with [Travis](https://travis-ci.org/bartTC/dpaste). You can also run the test suite locally with [tox](https://tox.wiki/en/latest/). Tox automatically tests the project against multiple Python and Django versions.

```bash
$ pip install tox
```

Then simply call it from the project directory.

```bash
$ cd dpaste/
$ tox
```

Example tox output:
```bash
$ tox

py35-django-111 create: /tmp/tox/dpaste/py35-django-111
SKIPPED:InterpreterNotFound: python3.5
py36-django-111 create: /tmp/tox/dpaste/py36-django-111
py36-django-111 installdeps: django>=1.11,<1.12
py36-django-111 inst: /tmp/tox/dpaste/dist/dpaste-3.0a1.zip

...................
----------------------------------------------------------------------
Ran 48 tests in 1.724s
OK


SKIPPED:  py35-django-111: InterpreterNotFound: python3.5
SKIPPED:  py35-django-20: InterpreterNotFound: python3.5
py36-django-111: commands succeeded
py36-django-20: commands succeeded
congratulations :)
```