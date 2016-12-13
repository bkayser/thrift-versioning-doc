require 'rubygems'
require 'bundler/setup'
require 'thrift'

# This app will invoke several calls on the Accounts service.
# It will use the client stubs of the version given on the command line,
# ie, 1.0.0, 1.1.0, etc.
#
# The calls invoked on the service are defined in modules specific
# to the version of the server.  The client code for 1.0.0 and 1.0.1 is identical.
# The client calls in the 1.1.0 and 2.0.0 modules have changes required
# for those specific server versions.
#
# The point of this is to demonstrate that all the clients within a major version
# will successfully connect to the latest revision of that version of the server.
#
$LOAD_PATH.unshift "."

class ClientBase
  attr_reader :client

  def initialize server_proxy_class
    # The 3rd to last segment of the proxy class will be the version
    major_version = server_proxy_class.name.split("::")[-3]
    url = "http://localhost:9292/#{major_version}/accounts"
    transport = Thrift::HTTPClientTransport.new(url)
    @client = server_proxy_class.new(Thrift::BinaryProtocol.new(transport))
    puts "using server at #{url}..."
  end

  def run()
    lookup
    update
  end

end

