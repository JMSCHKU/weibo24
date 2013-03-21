require 'rubygems'
require 'json'
require 'rest_client'

file = open("lp.json")
json = file.read
parsed = JSON.parse(json)
i = 2

parsed["hits"].each do |hit|
	user_id = hit["user_id"]
	text = hit["text"]
	last_post_date = hit["last_post_date"]

# RestClient.log=STDOUT # Optionally turn on logging

	q = '{
    		"post" : { 
			"user_id" : "' + user_id.to_s() + '",
			"text" : "test",
			"last_post_date" : "' + last_post_date + '"
	 	}
	}'

	uri = 'http://localhost:9200/weibo/post/' + i.to_s()

	p uri
	p q

	r = JSON.parse \
      		RestClient.get( uri,
                	      params: { source: q } )

	puts r

	i=i+1
end
