# A URL Normalizer
## Rules:
1. Convert the scheme and host to lower case.
1. Remove duplicate slashes. Two adjacent slashes within a URL path should be converted to a single slash.
1. Remove default directory indexes. The default directory indexes, `default.asp`, `index.html`, `index.htm`, `index.php`, `index.shtml` should be removed from URLs.
1. Remove default ports. The default port 80 for http and 443 for https should be removed from URLs.
1. Remove dot-segments. The segments `..` and `.` should be removed from URLs.
## Prerequisites:
1. Enable CGI in Apache: `sudo a2enmod cgi`.
## Required Perl Modules:
1. CGI: To install, run `sudo perl -MCPAN -eshell`, then `install CGI`.
1. LWP::Simple: To install, run `sudo apt-get install libwww-perl`.
