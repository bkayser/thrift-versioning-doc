$LOAD_PATH.unshift "."
require 'client_base'
require 'thrift'

$LOAD_PATH.unshift "1.1.0/gen"
require "accounts_types.rb"
require "accounts_constants.rb"
require "accounts.rb"
require 'client_v101'

# This is client verison 1.1

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

if __FILE__ == $0
  client = V1_1_0.new(V1::Accounts::Client)
  client.run()
  puts "Success!"
end

