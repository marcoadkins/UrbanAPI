require 'json'
require 'rest-client'
require 'sinatra/base'


class UrbanApi < Sinatra::Base
  SLACK_TOKEN = 'MYFITCBvIUnM2DEOLGuCyhWU'

  before do
    halt 401 if params[:token] != SLACK_TOKEN
  end

  get '/define' do
    content_type :json
    response = JSON.parse(RestClient.get('http://api.urbandictionary.com/v0/define?term=' + params['text']))
    { response_type: 'in_channel', text: "*Top three urban definitions for #{params['text']}*", attachments: [mrkdwn_in: ['text', 'fields'], text: get_definitions(response)] }.to_json
  end

  def get_definitions response
    definitions = ''
    (0..2).each do |i|
      definitions += "*#{(i+1).to_s}.* " + response['list'][i]['definition'] + "\n"
    end
    definitions
  end
end
