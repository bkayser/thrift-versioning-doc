$LOAD_PATH.unshift "."
require 'client_base'
require 'thrift'

$LOAD_PATH.unshift "2.0.0/gen"
require "2.0.0/gen/accounts_types.rb"
require "2.0.0/gen/accounts_constants.rb"
require "2.0.0/gen/accounts.rb"

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

if __FILE__ == $0
  client = V2_0_0.new(V2::Accounts::Client)
  client.run()
  puts "Success!"
end

