#!/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'json'
require 'rubberband'
require 'easy_translate'
require 'open-uri'

EasyTranslate.api_key = 'AIzaSyAuUC3yOwInxjMD1UaqPkbJCvl_umc8LOI'

file = open("http://research.jmsc.hku.hk/social/sinaweibo/lp.json")
json = file.read
parsed = JSON.parse(json)
i = 2

#define rchomp
class String
  def rchomp(sep = $/)
    self.start_with?(sep) ? self[sep.size..-1] : self
  end
end

#client = ElasticSearch.new('http://127.0.0.1:9200', :index => "weibo2", :type => "post")
client = ElasticSearch.new('http://127.0.0.1:9200')
client.default_index = "weibo"
client.default_type = "post"
#client.delete_index("weibo") # This should be COMMENTED OUT normally
#client.create_index("weibo") # This should be COMMENTED OUT normally
client.update_mapping({
	:dynamic => "false",
	:properties => {
		:id => {:type => :integer},
		:user_id => {:type => :long},
		:text => {:type => :string},
		:english_text => {:type => :string},
		:picture_url => {:type => :string},
		:created_at => {:type => :date }
	},
}, :index => "weibo", :type => "post")

parsed["hits"].each do |hit|
	begin
		user_id = hit["user_id"]
		status_id = hit["status_id"]

		#Check if alraedy exists in the index before doing any further processing
		exists = client.get(status_id)

		#if exists.attributes[:exists] != true
		if exists.nil?
			text = hit["text"]
			english_text = EasyTranslate.translate(text, :to => :english)
			#english_text = "dummy"

			picture_url = ""
			picture_url = (hit["original_pic"] || picture_url)
			picture_url = (hit["rt_original_pic"] || picture_url)
			
			created_at = hit["created_at"].tr(" ", "T")

			puts "Loading index " + i.to_s + ": " + user_id.to_s + ", " + status_id.to_s + ", " + text + ", " + english_text + ", " + picture_url + ", " + created_at
			client.index({:user_id => user_id, :text => text, :english_text => english_text, :picture_url => picture_url, :created_at => created_at}, :id => status_id)		
		else
			# Do nothing, as it already exists in the index
			#puts "Skipping _id " + status_id.to_s + " because it already exists."
		end
	rescue Exception => e
		puts "Failed: " + e.to_s
	end

	i=i+1
end
