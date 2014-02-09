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
$version = ARGV.shift or raise "Version argument required"
full_version = "V#{$version.gsub '.', '_'}"   # V1_0_0
major_version = full_version[/[^_]*/]         # V1
$LOAD_PATH.unshift "."
$LOAD_PATH.unshift "#{$version}/gen"
require "#$version/gen/accounts_types.rb"
require "#$version/gen/accounts_constants.rb"
require "#$version/gen/accounts.rb"

class ClientBase
  attr_reader :client

  def initialize client
    @client = client
  end

  def run()
    lookup
    update
  end

end

# This is client verison 1
class V1_0_0 < ClientBase

  def lookup
    print "Invoke client lookup with argument 1: "
    account = client.lookup 1, V1::Mode::PARTNER, true
    print "received account: #{account.inspect}\n"
  end

  def update
    account = V1::Account.new id:100, name:'Xerex', key: 'Foo'
    print "Invoke client update with #{account.inspect}: "
    v = client.update(account)
    print "received #{v.inspect}\n"
  end
end


# The V2 client is source compatible with V1: V1 can be used
# without any changes to the source.
class V1_0_1 < V1_0_0

end

class V1_1_0 < ClientBase

  # Changes are needed to the client source in order to upgrade to the V3
  # generated stubs, enumerated below.

  def lookup
    print "Invoke client lookup with argument 1: "
    # (1) Need to add new argument to lookup call
    # (2) Removed active argument from call
    account = client.lookup 1, V1::Mode::PARTNER, "a*"
    print "received account: #{account.inspect}\n"
  end

  def update
    # (3) Remove key field and add parent field
    # (4) Renamed Account struct to AccountID
    account = V1::AccountID.new id:100, name:'Xerex', parent: 100
    print "Invoke client update with #{account.inspect}: "
    v = client.update(account)
    print "received #{v.inspect}\n"
  end

end

class V2_0_0 < ClientBase

  def lookup  
    print "Invoke client lookup with argument 1: "
    account = client.lookup 1, V2::Mode::PARTNER, "a*"
    print "received account: #{account.inspect}\n"
  end

  def update
    account = V2::AccountID.new id:100, name:'Xerex', parent: 100
    print "Invoke client update with #{account.inspect}: "
    v = client.update_account(account)
    print "received #{v.inspect}\n"
  end
end



transport = Thrift::HTTPClientTransport.new("http://localhost:3000/#{major_version}/accounts")
server_proxy_class = Module.const_get(major_version)::Accounts::Client
server = server_proxy_class.new(Thrift::BinaryProtocol.new(transport))

client = Module.const_get(full_version).new(server)
client.run()
puts "Success!"
