$LOAD_PATH.unshift "."
load 'server.rb'
map "/V1" do 
  run $v1_app
end
map "/V2" do
  run $v2_app
end



