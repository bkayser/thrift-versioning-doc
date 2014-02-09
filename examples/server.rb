require 'thrift'
# Load generated files
$LOAD_PATH.unshift File.expand_path("../1.1.0/gen", __FILE__)
$LOAD_PATH.unshift File.expand_path("../2.0.0/gen", __FILE__)

require '1.1.0/gen/accounts_types.rb'
require '1.1.0/gen/accounts_constants.rb'
require '1.1.0/gen/accounts.rb'

require '2.0.0/gen/accounts_types.rb'
require '2.0.0/gen/accounts_constants.rb'
require '2.0.0/gen/accounts.rb'

module Server
  class Version1
    def lookup mode, id, name
      puts "lookup: id:#{id} mode:#{mode} name:#{name}"
      return V1::AccountID.new name: name, id: id, parent: 1
    end
    def update account
      return account
    end
  end
  class Version2
    def lookup mode, id, name
      puts "lookup: id:#{id} mode:#{mode} name:#{name}"
      return V2::AccountID.new name: name, id: id, parent: 1
    end
    def update_account account
      return account
    end
  end
end

v1_processor = V1::Accounts::Processor.new(Server::Version1.new)
v2_processor = V2::Accounts::Processor.new(Server::Version2.new)

$v1_app = Thrift::ThinHTTPServer::RackApplication.for("/accounts", v1_processor, Thrift::BinaryProtocolFactory.new)
$v2_app = Thrift::ThinHTTPServer::RackApplication.for("/accounts", v2_processor, Thrift::BinaryProtocolFactory.new)


