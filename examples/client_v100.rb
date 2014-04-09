$LOAD_PATH.unshift "."
require 'client_base'
require 'thrift'
$LOAD_PATH.unshift "1.0.0/gen"
require "accounts_types.rb"
require "accounts_constants.rb"
require "accounts.rb"

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

if __FILE__ == $0

  client = V1_0_0.new(V1::Accounts::Client)
  client.run()
  puts "Success!"

end
