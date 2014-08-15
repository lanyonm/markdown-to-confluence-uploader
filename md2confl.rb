#!/usr/bin/env ruby
# encoding: utf-8

require 'confluence-soap'
require 'markdown2confluence'
require 'optparse'

options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "Usage: md2confl.rb [options...] -s <SPACE_NAME> -i <PAGE_ID>\nassumes defaults that can be set in options parsing..."

  # 11437310
  options[:pageId] = nil
  opts.on('-i', '--pageId PAGE_ID', 'REQUIRED. The Confluence page id to upload the converted markdown to.') do |pageId|
    options[:pageId] = pageId
  end

  options[:spaceName] = nil
  opts.on('-s', '--space SPACE_NAME', 'REQUIRED. The Confluence space name in which the page resides.') do |space|
    options[:spaceName] = space
  end

  # set default for Markdown file name and path
  options[:markdownFile] = 'README.md'
  opts.on( '-f', '--markdownFile FILE', "Path to the Markdown file to convert and upload. Defaults to '#{options[:markdownFile]}'") do |file|
    options[:markdownFile] = file
  end

  # set default for Confluence server
  options[:server] = 'http://confluence.example.com'
  opts.on( '-c', '--server CONFLUENCE_SERVER', "The Confluence server to upload to. Defaults to '#{options[:server]}'") do |server|
   options[:server] = server
  end

  options[:user] = nil
  opts.on('-u', '--user USER', 'The Confluence user. Can also be specified by the \'CONFLUENCE_USER\' environment variable.') do |pageId|
    options[:user] = pageId
  end

  options[:password] = nil
  opts.on('-p', '--password PASSWORD', 'The Confluence user\'s password. Can also be specified by the \'CONFLUENCE_PASSWORD\' environment variable.') do |pageId|
    options[:password] = pageId
  end

  options[:verbose] = false
  opts.on('-v', '--verbose', 'Output more information') do
    options[:verbose] = true
  end

  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end
end

optparse.parse!

# space_name and page_id are required arguments
raise OptionParser::MissingArgument, '-s SPACE_NAME is a required argument' if options[:spaceName].nil?
raise OptionParser::MissingArgument, '-p PAGE_ID is a required argument' if options[:pageId].nil?

user = ENV['CONFLUENCE_USER'] || options[:user] || ''
password = ENV['CONFLUENCE_PASSWORD'] || options[:password] || ''

opts = options[:verbose] ? {} : {log: false}
cs = ConfluenceSoap.new("#{options[:server]}/rpc/soap-axis/confluenceservice-v2?wsdl", user, password, opts)

pages = cs.get_pages("NNA")
uploader_page = pages.detect { |page| page.id == options[:pageId] }

if uploader_page.nil?
  puts "exiting... could not find pageId: #{options[:pageId]}"
  exit
end

begin
  text = File.read(options[:markdownFile])
  @convertedText = "#{Kramdown::Document.new(text).to_confluence}"
rescue Exception => ex
  warn "There was an error running the converter: \n#{ex}"
end

@convertedText = "#{@convertedText}\n\n(rendered at #{Time.now.getutc} by confluence-uploader)"

uploader_page.content = cs.convert_wiki_to_storage_format(@convertedText)
options = {minorEdit: true, versionComment: 'updated by confluence-uploader'}
cs.update_page(uploader_page)
