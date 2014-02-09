gem 'thrift'
# Load generated files
$version = ARGV.shift || "1.0.0"
full_version = "V#{$version.gsub '.', '_'}"   # V1_0_0
major_version = full_version[/[^_]*/]         # V1
$LOAD_PATH.unshift "#{$version}/gen"
Dir[$version+"/gen/*.rb"].each { |f| require File.basename(f) }

# This is client verison 1
module V1_0_0

  def run(client)

    print "Invoke client lookup with argument 1: "
    account = client.lookup 1, V1::Mode::PARTNER, true
    print "received account: #{account.inspect}\n"

    account = V1::Account.new id:100, name:'Xerex', key: 'Foo'

    print "Invoke client update with #{account.inspect}: "
    v = client.update(account)
    print "received #{v.inspect}\n"
  end
end


module V1_0_1
  # The V2 client is source compatible with V1: V1 can be used
  # without any changes to the source.
  include V1_0_0
end

module V1_1_0

  # Changes are needed to the client source in order to upgrade to the V3
  # generated stubs, enumerated below.

  def run(client)
    print "Invoke client lookup with argument 1: "
    # (1) Need to add new argument to lookup call
    # (2) Removed active argument from call
    account = client.lookup 1, V1::Mode::PARTNER, "a*"
    print "received account: #{account.inspect}\n"

    # (3) Remove key field and add parent field
    # (4) Renamed Account struct to AccountID
    account = V1::AccountID.new id:100, name:'Xerex', parent: 100
    print "Invoke client update with #{account.inspect}: "
    v = client.update(account)
    print "received #{v.inspect}\n"

  end
end


include Module.const_get(full_version)

transport = Thrift::HTTPClientTransport.new("http://localhost:3000/#{major_version}/accounts")
client_class = Module.const_get(major_version)::Accounts::Client
client = client_class.new(Thrift::BinaryProtocol.new(transport))

run(client)
puts "Success!"
