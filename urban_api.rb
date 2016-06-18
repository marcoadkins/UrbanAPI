require 'json'
require 'rest-client'
require 'sinatra'

set port: 4444

get '/define/:term' do
  response = JSON.parse(RestClient.get('http://api.urbandictionary.com/v0/define?term=' + params['term']))
  { definitions: get_definitions(response, nil) }.to_json
end

get '/define/:term/:number' do
  response = JSON.parse(RestClient.get('http://api.urbandictionary.com/v0/define?term=' + params['term']))
  { definitions: get_definitions(response, params['number'].to_i) }.to_json
end

def get_definitions response, number = nil
  number ||= 0
  definitions = []
  (0..number).each do |i|
    definitions << response['list'][i]['definition']
  end
  definitions
end

# {
#     "response_type": "in_channel",
#     "text": "Here are the top three definitions:",
#     "attachments": [
#         {
#             "text": "#123456 http://domain.com/ticket/123456 \n
#             #123457 http://domain.com/ticket/123457 \n
#             #123458 http://domain.com/ticket/123458 \n
#             #123459 http://domain.com/ticket/123459 \n
#             #123460 http://domain.com/ticket/123460"
#         }
#     ]
# }

