# syfi package

Find and open a file belonging to selected service id, class or resource in a
Symfony project.

Just select the service id, class name or resource name starting with a '@' in
your symfony project, press alt+ctrl+o or choose "Find in Symfony project" from
the context menu and the file will be opened in a new tab.

## How it works?

It executes a simple php script that loads tha AppKernel and bootstrap cache
from your symfony project, and then attempts to find the service by id in the
container, the file of the class through ReflectionClass, or the resource by
calling locateResource() on the kernel.

This command line tool can be used without atom if wants to. Just smylink it to
*~/bin* or whatever and use it like this from your Symfony application root:
```bash
$ syfi-cli [some class id/classname/resource]
```
The output would be the filename belonging to the search string.

## Limitations

The package assumes that the first opened project in Atom is set to a Symfony
application root. So app/bootstrap.php.cache and app/AppKernel.php should exist.

Not to mention it obviously requires a working configured php cli environment
on your machine.

Also while it does not necessary require the full class name to be selected,
if it just gets a string that does not contain a backslash and is not a service
id it searches for the first.

There might be some OS specific limitations too, because I personally only
tested it in Linux. Please feel free to add issues if you find OS X/Windows
bugs.
