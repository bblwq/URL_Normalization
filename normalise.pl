#!/usr/bin/perl
# Author: Weiqi Liu
# Assignment 1: Perl and CGI

use CGI qw(:all);
use LWP::Simple qw(get);

print header, "\n",
  start_html({-title=>'URL normalisation',
              -author=>'sgwliu6@liverpool.ac.uk'}), "\n";

print h1("URL normalisation"), "\n";

print start_form({-method => "POST",
                  -action => "http://cgi.csc.liv.ac.uk/".
                           "cgi-bin/cgiwrap/x4wl3/normalise.pl"});

print "URL: ";
print textfield({-name => 'URL',
                 -size => 200}), "\n";

print br(), br(), "\n";

print submit({-name => 'submit',
              -value => 'Process'}), "\n";

print br(), br(), "\n";

# The user has click the "Process" button.
if (param('submit')) {
  $_ = param('URL');

  # The user input is empty.
  if ($_ eq "") {
    print "The input is empty!";
  }

  # The user input constitutes a syntactically correct URL.
  elsif (/([a-zA-Z]+)\:\/\/([^\:\?\#\/]+)(\:\d+)?\/([^\?\#]*)(\?[^\#]+)?(\#\S+)?/) {
    ($scheme,$domain,$port,$path,$query,$fragment) = (/([a-zA-Z]+)\:\/\/([^\:\?\#\/]+)(\:\d+)?\/([^\?\#]*)(\?[^\#]+)?(\#\S+)?/);
    #print "SCHEME: $scheme\n", br();
    #print "DOMAIN: $domain\n", br();
    #print "PORT: $port\n", br();
    #print "PATH: $path\n", br();
    #print "QUERY: $query\n", br();
    #print "FRAGMENT: $fragment\n", br(), br();

    # Convert the scheme and host to lower case.
	$scheme = "\L$scheme\E";
	$domain = "\L$domain\E";

    # Remove duplicate slashes.
    $path =~ s!\/\/!\/!g;

    # Remove default directory indexes.
    $path =~ s!default.asp|index.html|index.htm|index.php|index.shtml!!;

    # Remove default ports.
    $_ = "$scheme\:\/\/$domain$port";
    if (/\Ahttps:\/\/[^\:\?\#\/]+:443/) {
      $port = "";
    }
    if (/\Ahttp:\/\/[^\:\?\#\/]+:80/) {
      $port = "";
    }

    # Remove dot-segments.
    $input = $path;
    $output = "";
    while ($input ne "") {
      $_ = $input;
	  # The input buffer begins with a prefix of "../" or "./".
	  if (/^\.\.?\/(.*)/) {
        $input =~ s!^\.\.?\/(.*)!\1!;
      }
	  # The input buffer begins with a prefix of "/./" or "/.".
	  elsif (/^\/\.\/(.*)/) {
        $input =~ s!^\/\.\/(.*)!\/\1!;
      }
	  # The input buffer begins with a prefix of "/../" or "/..".
      elsif (/^\/\.\.\/?(.*)/) {
        $input =~ s!^\/\.\.\/?(.*)!\/\1!;
		$output =~ s!(.*)([^\/]+)$!\1!;
		$output =~ s!(.*)\/$!\1!;
      }
	  # The input buffer consists only of "." or "..".
      elsif ($input eq "." || $input eq "..") {
        $input = "";
      }
      else {
        if (/(^\/?[^\/]*)(\/?.*)/) {
          $input = $2;
          $output .= $1;
        }
      }
    }
    $path = $output;
    $path =~ s!^\/(.*)!\1!;

    print "Result: $scheme\:\/\/$domain$port\/$path$query$fragment";
  }

  # The user input does not constitutes a syntactically correct URL.
  else {
    print "The URL constitutes a syntax error!";
  }
}

print end_form, end_html;