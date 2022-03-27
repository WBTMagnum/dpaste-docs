# API

## API endpoint
---

dpaste provides a simple API endpoint to create new snippets. All you need to do is a simple `POST` request to the API endpoint, usually `/api/`:

### POST/api/
Create a new Snippet on this dpaste installation. It returns the full URL that snippet was created.

**Example request:**

```bash
$ curl -X POST -F "format=url" -F "content=ABC" https:/dpaste.org/api/

Host: dpaste.de
User-Agent: curl/7.82.0
Accept: */*
```

**Example response:**

```bash
{
  "lexer": "python",
  "url": "https://dpaste.org/EBKU",
  "content": "ABC"
}
```

### Form Parameters

- **content** – (required) The UTF-8 encoded string you want to paste.
- **lexer** – (optional) The lexer string key used for highlighting. See the `CODE_FORMATTER` property in [Settings](https://docs.dpaste.org/settings/) for a full list of choices. Default: `_code`.
- **format** -
(optional) The format of the API response. Choices are:
    - `default` — Returns a full qualified URL wrapped in quotes. Example: `"https://dpaste.org/xsWd"`
    - `url` — Returns the full qualified URL to the snippet, without surrounding quotes, but with a line break. Example: `https://dpaste.org/xsWd\n`
    - `json` — Returns a JSON object containing the URL, lexer and content of the the snippet. Example:

            {
            "url": "https://dpaste.org/xsWd",
            "lexer": "python",
            "content": "The text body of the snippet."
            }


    - expires – (optional) A keyword to indicate the lifetime of a snippet in seconds. The values are predefined by the server. Calling this with an invalid value returns a HTTP 400 BadRequest together with a list of valid values. Default: 2592000. In the default configuration valid values are:
        - `onetime` — The snippet will be deleted after the first view.
        - `never` — The snippet will never expire.
        - `3600` — The snippet will expire after one hour.
        - `604800` — The snippet will expire after one week.
        - `2592000` — The snippet will expire after one month.

    - filename - (optional) A filename which we use to determine a lexer, if `lexer` is not set. In case we can’t determine a file, the lexer will fallback to `plain` code (no highlighting). A given `lexer` will overwrite any filename! Example:

            {
              "url": "https://dpaste.org/xsWd",
              "lexer": "",
              "filename": "python",
              "content": "The text body of the snippet."
            }
    
        This will create a `python` highlighted snippet. However in this example:

            {
              "url": "https://dpaste.org/xsWd",
              "lexer": "php",
              "filename": "python",
              "content": "The text body of the snippet."
            }
          
        Since the lexer is set too, It will create a `php` highlighted snippet.

### Status Codes
- [**200 OK**](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/200) – No Error.
- [**400 Bad Request**](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400) – One of the above form options was invalid, the response will contain a meaningful error message.


!!! info "Info"

        If you have a standalone installation and your API returns `https://dpaste-base-url.example.org` as the domain, you need to adjust the setting `get_base_url` property. See Settings.

## Third party API integration
**subdpaste**

-  a Sublime Editor plugin: [https://github.com/bartTC/SubDpaste](https://github.com/bartTC/SubDpaste)

**Marmalade**

-  an Emacs plugin: [http://marmalade-repo.org/packages/dpaste_de](http://marmalade-repo.org/packages/dpaste_de)
  
**atom-dpaste**

-  for the Atom editor: [https://atom.io/packages/atom-dpaste](https://atom.io/packages/atom-dpaste)

**dpaste-magic**

-  an iPython extension: [https://pypi.org/project/dpaste-magic/](https://pypi.org/project/dpaste-magic/)

You can also paste your file content to the API via curl, directly from the command line:


```bash
$ alias dpaste="curl -F 'format=url' -F 'content=<-' https://dpaste.org/api/"
$ cat foo.txt | dpaste
https://dpaste.org/ke2pB
```

!!! hint "Note"

        If you wrote or know a third party dpaste plugin or extension, please open an Issue on Github and I will added here.