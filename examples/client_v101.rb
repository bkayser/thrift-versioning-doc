$LOAD_PATH.unshift "."
require 'client_base'
require 'thrift'

$LOAD_PATH.unshift "1.0.1/gen"
require "accounts_types.rb"
require "accounts_constants.rb"
require "accounts.rb"
require 'client_v100'

# The V2 client is source compatible with V1: V1 can be used
# without any changes to the source.
class V1_0_1 < V1_0_0

end

if __FILE__ == $0
  client = V1_0_1.new(V1::Accounts::Client)
  client.run()
  puts "Success!"
end