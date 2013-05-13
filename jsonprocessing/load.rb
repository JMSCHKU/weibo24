#!/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'json'
require 'rubberband'
require 'easy_translate'

EasyTranslate.api_key = 'AIzaSyAuUC3yOwInxjMD1UaqPkbJCvl_umc8LOI'

file = open("lp.json")
json = file.read
parsed = JSON.parse(json)
i = 2

client = ElasticSearch.new('http://127.0.0.1:9200', :index => "weibo", :type => "post")
#client.delete_index("weibo")
#client.create_index("weibo")
#client.update_mapping({
#	:dynamic => "false",
#	:properties => {
#		:id => {:type => :integer},
#		:user_id => {:type => :long},
#		:text => {:type => :string},
#		:english_text => {:type => :string},
#		:created_at => {:type => :string }
#	},
#}, :index => "weibo", :type => "post")

parsed["hits"].each do |hit|
	begin
		user_id = hit["user_id"]
		text = hit["text"]
		english_text = EasyTranslate.translate(text, :to => :english)
		created_at = hit["created_at"]

		puts "Loading: " + user_id.to_s + ", " + text + ", " + english_text + ", " + created_at
	
# RestClient.log=STDOUT # Optionally turn on logging
		client.index({:user_id => user_id, :text => text, :english_text => english_text, :created_at => created_at}, :id => i)	
	rescue Exception => e
		puts "Failed: " + e.to_s
	end

	i=i+1
end
