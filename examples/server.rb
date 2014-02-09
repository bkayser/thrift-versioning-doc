gem 'thrift'
gem 'thin'
# Load generated files
$version = ARGV.shift || "v1"
$LOAD_PATH.unshift File.expand_path("../#{$version}/gen", __FILE__)
Dir["#$version/gen/*.rb"].each { |f| require File.basename(f) }

module Server

  class V1
    def lookup id, mode, active
      puts "lookup: id:#{id} mode:#{mode} active:#{active}"
      return AIS::Account.new name: "Binditty", key: 'CA01', id: 1000
    end
    def update account
    end
  end

  class V2 < V1
    def lookup id, mode, active
      puts "lookup: id:#{id} mode:#{mode} active:#{active}"
      return AIS::Account.new name: "Binditty", id: 1000, parent: 1
    end
    def update account
      return account
    end
  end

  class V3 < V2
    def lookup mode, id, name
      puts "lookup: id:#{id} mode:#{mode} name:#{name}"
      return AIS::AccountID.new name: name, id: id, parent: 1
    end
  end
end

handler = Server.const_get($version.upcase).new
processor = AIS::Accounts::Processor.new(handler)
server = Thrift::ThinHTTPServer.new processor, port: 3000, path: '/accounts'
puts "Starting the Accounts Service version #$version..."
server.serve()

