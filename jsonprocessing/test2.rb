require 'rubygems'
require 'json'
require 'rubberband'

file = open("lp.json")
json = file.read
parsed = JSON.parse(json)
i = 2

client = ElasticSearch.new('http://127.0.0.1:9200', :index => "weibo", :type => "post")

parsed["hits"].each do |hit|
	user_id = hit["user_id"]
	text = hit["text"]
	created_at = hit["created_at"]

# RestClient.log=STDOUT # Optionally turn on logging
	client.index({:user_id => user_id, :text => text, :created_at => created_at}, :id => i)	

	i=i+1
end
