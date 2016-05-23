
require 'rubygems'
require 'ruote'
require 'ruote/storage/fs_storage'


engine = Ruote::Engine.new(
	Ruote::Worker.new(Ruote::FsStorage.new("ruote_work")))

engine.register_participant :test1 do |workitem|
	workitem.fields['message'] = { text: 'hello', author: 'Alice' }
end

engine.register_participant :text2 do |workitem|
	puts "I received message from #{workitem.fields['message']['author']}"
end

proc = Ruote.process_definition name: 'text' do
	sequence do
		participant :text1
		participant :text2
	end
end

wfid = engine.launch(proc)
engine.wait_for(wfid)
