gem 'thrift'
# Load generated files
$version = ARGV.shift || "v1"
$LOAD_PATH.unshift "#{$version}/gen"
Dir[$version+"/gen/*.rb"].each { |f| require File.basename(f) }

# This is client verison 1
module V1
  def run(client)

    print "Invoke client lookup with argument 1: "
    account = client.lookup 1, AIS::Mode::PARTNER, true
    print "received account: #{account.inspect}\n"

    account = AIS::Account.new id:100, name:'Xerex', key: 'Foo'

    print "Invoke client update with #{account.inspect}: "
    v = client.update(account)
    print "received #{v.inspect}\n"
  end
end


module V2
  # The V2 client is source compatible with V1: V1 can be used
  # without any changes to the source.
  include V1
end

module V3

  # Changes are needed to the client source in order to upgrade to the V3
  # generated stubs, enumerated below.

  def run(client)
    print "Invoke client lookup with argument 1: "
    # (1) Need to add new argument to lookup call
    # (2) Removed active argument from call
    account = client.lookup 1, AIS::Mode::PARTNER, "a*"
    print "received account: #{account.inspect}\n"

    # (3) Remove key field and add parent field
    # (4) Renamed Account struct to AccountID
    account = AIS::AccountID.new id:100, name:'Xerex', parent: 100
    print "Invoke client update with #{account.inspect}: "
    v = client.update(account)
    print "received #{v.inspect}\n"

  end
end


transport = Thrift::HTTPClientTransport.new("http://localhost:3000/accounts")
client = AIS::Accounts::Client.new(Thrift::BinaryProtocol.new(transport))

include Module.const_get($version.upcase)
run(client)
puts "Success!"
