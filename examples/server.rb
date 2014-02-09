gem 'thrift'
gem 'thin'
# Load generated files
$version = ARGV.shift || "1.1.0"
full_version = "V#{$version.gsub '.', '_'}"   # V1_0_0
major_version = full_version[/[^_]*/]         # V1
$LOAD_PATH.unshift File.expand_path("../#{$version}/gen", __FILE__)
Dir["#$version/gen/*.rb"].each { |f| require File.basename(f) }

module Server

  class V1_0_0
    def lookup id, mode, active
      puts "lookup: id:#{id} mode:#{mode} active:#{active}"
      return V1::Account.new name: "Binditty", key: 'CA01', id: 1000
    end
    def update account
    end
  end

  class V1_0_1 < V1_0_0
    def lookup id, mode, active
      puts "lookup: id:#{id} mode:#{mode} active:#{active}"
      return V1::Account.new name: "Binditty", id: 1000, parent: 1
    end
    def update account
      return account
    end
  end

  class V1_1_0 < V1_0_1
    def lookup mode, id, name
      puts "lookup: id:#{id} mode:#{mode} name:#{name}"
      return V1::AccountID.new name: name, id: id, parent: 1
    end
  end
end

handler = Server.const_get(full_version).new
processor = Module.const_get(major_version)::Accounts::Processor.new(handler)
server = Thrift::ThinHTTPServer.new processor, port: 3000, path: "/#{major_version}/accounts"
puts "Starting the Accounts Service version #$version..."
server.serve()

