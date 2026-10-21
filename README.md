markdown-to-confluence-uploader
-----------
> [!WARNING]
> **This project is no longer maintained** and has been archived. It was last updated in 2017 and its dependencies are out of date. It also depends on Confluence's SOAP remote API, which Atlassian removed in Confluence 7.0, so it won't work against current Confluence Server, Data Center or Cloud. It's kept for reference only.

A simple Ruby script to automate the conversion of Markdown files to Confluence storage format and then upload them to a Confluence server.  It uses [markdown2confluence](https://github.com/jedi4ever/markdown2confluence) to get the markdown to Confluence wiki format and then the [confluence-soap](https://github.com/intridea/confluence-soap) to convert wiki format to storage format and then upload to Confluence.

Running
-------

	$ ./md2confl.rb -s <SPACE_NAME> -i <PAGE_ID>

A full list of options can be found by running `md2confl.rb --help`:

	Usage: md2confl.rb [options...] -s <SPACE_NAME> -i <PAGE_ID>
	assumes defaults that can be set in options parsing...
	    -i, --pageId PAGE_ID             REQUIRED. The Confluence page id to upload the converted markdown to.
	    -s, --space SPACE_NAME           REQUIRED. The Confluence space name in which the page resides.
	    -f, --markdownFile FILE          Path to the Markdown file to convert and upload. Defaults to 'README.md'
	    -c, --server CONFLUENCE_SERVER   The Confluence server to upload to. Defaults to 'http://confluence.example.com'
	    -u, --user USER                  The Confluence user. Can also be specified by the 'CONFLUENCE_USER' environment variable.
	    -p, --password PASSWORD          The Confluence user's password. Can also be specified by the 'CONFLUENCE_PASSWORD' environment variable.
	    -v, --verbose                    Output more information
	    -h, --help                       Display this screen


Installation
------------
This assumes you have a functioning version of Ruby that's at least 1.9.3 (I tested with 2.1.1) and have [Bundler](http://bundler.io/) installed.

	bundle install

