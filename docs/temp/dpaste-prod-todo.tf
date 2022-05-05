## dpaste production deployment
Runninng dpaste in production is a bit more involved. Ther are multiple ways you could serve dpaste, the easiest one (I think) is by using NGINX. You could also use other webserver like Apache or Caddy, but I prefer NGINX because it’s easy to configure and it’s really solid. *also nginx is lightweight and what dpaste.org has been using.*

For OS choice I recommend debian, Been using it for a long time now and it's really stable. dpaste should *works* on most OS/Distro, if you find a compatibility issue, please open an [issue here](https://github.com/DarrenOfficial/dpaste/issues)

and also you need docker :p, while previously dpaste only works on x86_64, now dpaste ships with amd64, aarch64, ppc64le supports. so you can install them on your raspberry pi I suppose.



### Installing NGINX

You can follow these awesome guide [docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/) to install NGINX on your preferred OS/distribution/freebsd or [with whatever you prefer](https://google.ca).

### Installing Docker
Next step is to get docker installed.

For a quick install of Docker CE, you can run the following command:
```bash
curl -sSL https://get.docker.com/ | CHANNEL=stable bash
```

If you would rather do a manual installation, please reference the official Docker documentation for how to install Docker CE on your server. Some quick links are listed below for commonly supported systems.

- [Debian](https://docs.docker.com/install/linux/docker-ce/debian/#install-docker-ce)
- [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce)
- [CentOS](https://docs.docker.com/install/linux/docker-ce/centos/#install-docker-ce)

!!! attention "Check your Kernel"

    Please be aware that some hosts *(OVH)* install a modified kernel that does not support important docker features. Please check your kernel by running `uname -r`. If your kernel ends in `-xxxx-grs-ipv6-64` or `-xxxx-mod-std-ipv6-64` you're probably using a non-supported kernel.


#### Start docker on boot
```bash
systemctl enable --now docker
```

### Running dpaste

Great, you're *almost* done. Now you need to run dpaste. by using the [above mentioned docker command](#dpaste-with-docker).
or if you want to edit the about page or change the settings you need a `Dockerfile` withe following

#### Dockerfile
```Dockerfile
FROM darrenofficial/dpaste:latest as dpasteprod

WORKDIR /app

RUN ./manage.py migrate

COPY local.py dpaste/settings/local.py
# Optional if you want to edit the about page
# COPY about.html dpaste/templates/dpaste/about.html
```

#### local.py
```py
#
#   Custom settings for production deployment
#

from dpaste.apps import dpasteAppConfig
from dpaste.settings.base import *
from django.utils.safestring import mark_safe
from django.utils.translation import gettext_lazy as _

CSP_IMG_SRC = ("data:",)

HOME_MESSAGE = os.environ.get("HOME_MESSAGE", "")



class ProductionDpasteAppConfig(dpasteAppConfig):
    """
    Customize the original dpaste settings to be sane for production,
    and that means to prevent abuse and spam. 😞
    """

  
    SLUG_LENGTH = 5
    EXPIRE_CHOICES = (
        ("onetime", _("One Time Snippet")),
        ("never", _("Never expires")),
        (3600, _("Expire in 1 hour")),
        (3600 * 24, _("Expire in 24 hours")),
        (3600 * 24 * 7, _("Expire in 1 week")),
        (3600 * 24 * 30, _("Expire in 1 month")),
        (3600 * 24 * 365, _("Expire in 1 year")),
    )
    EXPIRE_DEFAULT = 2592000
    RAW_MODE_ENABLED = True
    RAW_MODE_PLAIN_TEXT = True
    APPLICATION_NAME = "dpaste"
    CACHE_TIMEOUT = 0
    CACHE_HEADER = False

    EXTRA_HEAD_HTML = """
    <style type="text/css">
    header{ background: linear-gradient(to right, #1977e3, #4a90e2); }
    .feature-message { margin: 10px 30px 39px 30px; color: #8c8c8c; font-size: 14px; line-height: 22px; }
    </style>
<meta name="title" content="dpaste.org">
<meta name="description" content="Dpaste is a website where you can store text online for a set period of time. Dpaste is written in Python using the Django framework. ">

<!-- Open Graph / Facebook -->
<meta property="og:type" content="website">
<meta property="og:url" content="https://dpaste.org/">
<meta property="og:title" content="dpaste.org">
<meta property="og:description" content="Dpaste is a website where you can store text online for a set period of time. Dpaste is written in Python using the Django framework. ">
<meta property="og:image" content="">

<!-- Twitter -->
<meta property="twitter:card" content="summary_large_image">
<meta property="twitter:url" content="https://dpaste.org/">
<meta property="twitter:title" content="dpaste.org">
<meta property="twitter:description" content="Dpaste is a website where you can store text online for a set period of time. Dpaste is written in Python using the Django framework. ">
<meta property="twitter:image" content="">
    """

    EXTRA_POST_NEW = (
        f"""
        <div class="feature-message">{HOME_MESSAGE}</div>
    """
        if HOME_MESSAGE
        else ""
    )

    @staticmethod
    def get_base_url(request=None):
        return "https://example-domain.dpaste.org"

    @property
    def CODE_FORMATTER(self):
        """
        Choices list with all "Code" Lexer. Each list
        contains a lexer tuple of:

           (Lexer key,
            Lexer Display Name,
            Lexer Highlight Class)

        If the Highlight Class is not given, PygmentsHighlighter is used.

        To get a current list of available lexers in Pygements do:

        >>> from pygments import lexers
        >>> sorted([(i[1][0], i[0]) for i in lexers.get_all_lexers()])
        [('abap', 'ABAP'),
         ('abnf', 'ABNF'),
         ('ada', 'Ada'),
         ...
        """
        from dpaste.highlight import PlainCodeHighlighter

        return [
            (self.PLAIN_CODE_SYMBOL, "Plain Code", PlainCodeHighlighter),
        ]


if "dpaste.apps.dpasteAppConfig" in INSTALLED_APPS:
    INSTALLED_APPS.remove("dpaste.apps.dpasteAppConfig")
    INSTALLED_APPS.append("dpaste.settings.local.ProductionDpasteAppConfig",)
```