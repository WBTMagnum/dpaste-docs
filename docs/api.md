# API

## API endpoint
---

dpaste provides a simple API endpoint to create new snippets. All you need to do is a simple `POST` request to the API endpoint, usually `/api/`:

### POST/api/
Create a new Snippet on this dpaste installation. It returns the full URL that snippet was created.

**Example request:**

```bash
$ curl -X POST -F "format=url" -F "content=ABC" https:/dpaste.de/api/

Host: dpaste.de
User-Agent: curl/7.54.0
Accept: */*
```

**Example response:**

```bash
{
  "lexer": "python",
  "url": "https://dpaste.de/EBKU",
  "content": "ABC"
}
```

**Form Parameters**


- **content** – (required) The UTF-8 encoded string you want to paste.
- **lexer** – (optional) The lexer string key used for highlighting. See the `CODE_FORMATTER` property in [Settings](https://docs.dpaste.org/settings/) for a full list of choices. Default: `_code`.
- **format** -
(optional) The format of the API response. Choices are:
    - `default` — Returns a full qualified URL wrapped in quotes. Example: `"https://dpaste.de/xsWd"`
    - `url` — Returns the full qualified URL to the snippet, without surrounding quotes, but with a line break. Example: `https://dpaste.de/xsWd\n`
    - `json` — Returns a JSON object containing the URL, lexer and content of the the snippet. Example:

            {
            "url": "https://dpaste.de/xsWd",
            "lexer": "python",
            "content": "The text body of the snippet."
            }



<!-- !TODO: add more example -->