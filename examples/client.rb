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
    print "Invoke account lookup with id 1001: "
    account = client.lookup 1001, V1::Mode::PARTNER, true
    print "received account: #{account.inspect}\n"
    print "Invoke account lookup with bad id, -1: "
    begin
      account = client.lookup -1, V1::Mode::PARTNER, "b*"
      print "received account: #{account.inspect}\n"
    rescue V1::InvalidAccountException => e
      print "received exception: #{e}\n"
    end
  end

  def update
    account = new_account(1010)
    print "Invoke account update with #{account.inspect}: "
    v = client.update(account)
    print "received #{v.inspect}\n"
    begin
      # (7) Raises exception when the id <= 0
      print "Invoke account update with bad id, -1: "
      account.id = -1
      v = client.update(account)
      print "received: #{v.inspect}\n"
    rescue V1::InvalidAccountException => e
      print "received exception: #{e}\n"
    end
  end

  private

  def new_account(id)
    V1::Account.new id: id, name:'Xerex', key: 'Foo'
  end

end


# The V2 client is source compatible with V1: V1 can be used
# without any changes to the source.
class V1_0_1 < V1_0_0

end

class V1_1_0 < V1_0_1

  # Changes are needed to the client source in order to upgrade to the V3
  # generated stubs, enumerated below.

  def lookup
    print "Invoke client lookup with argument 1: "
    # (1) Need to add new argument to lookup call
    # (2) Removed active argument from call
    # (3) Changed order of arguments in lookup
    # (4) Removed exception from signature.
    account = client.lookup V1::Mode::PARTNER, 1001, "aaaa"
    print "received account: #{account.inspect}\n"
  end

  private

  def new_account(id)
    # (5) Remove key field and add parent field
    # (6) Renamed Account struct to AccountID
    account = V1::AccountID.new id: id, name:'Xerex', parent: 100
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



transport = Thrift::HTTPClientTransport.new("http://localhost:9292/#{major_version}/accounts")
server_proxy_class = Module.const_get(major_version)::Accounts::Client
server = server_proxy_class.new(Thrift::BinaryProtocol.new(transport))

client = Module.const_get(full_version).new(server)
client.run()
puts "Success!"
