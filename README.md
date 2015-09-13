# syfi package

Find and open a file belonging to the following in a Symfony project:
* service id
* class
* resource (eg. @AppBundle/Resources/config/services.yml)
* twig template shorthand (eg. AppBundle:Layout:index.html.twig)
* doctrine entity model shorthand (eg. AppBundle:User)

Just select one of the above in your symfony project, press alt+ctrl+o or choose
"Find in Symfony project" from the context menu and the file will be opened in a
new tab.

## How it works?

It executes a simple php script that loads tha AppKernel and bootstrap cache
from your symfony project, and then attempts to find the service by id in the
container, the file of the class through ReflectionClass, the resource by
calling locateResource() on the kernel, or twig template and doctrine through
some asumed default services (doctrine's entity manager and templating).

This command line tool can be used without atom if wants to. Just smylink it to
*~/bin* or whatever and use it like this from your Symfony application root:
```bash
$ syfi-cli [some class id/classname/resource]
```
The output would be the filename belonging to the search string.

## Limitations

The package assumes that the first opened project in Atom is set to a Symfony
application root. So app/bootstrap.php.cache and app/AppKernel.php should exist.
For doctrine model or twig template parsing to work, those services should also
be present and correctly configured.

The package obviously also requires a working configured php cli environment
on your machine.

If a single string is selected that is not obviously a class (does not containe
a backslash), not a twig template (does not end with .twig), is not a doctrine
model (it does not have a single colon in it) and can not be accessed through
the service container the script searches for the first php file named like the
string and opens that.

There might be some OS specific limitations too, because I personally only
tested it in Linux. Please feel free to add issues if you find OS X/Windows
bugs.
