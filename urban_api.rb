require 'json'
require 'rest-client'
require 'sinatra/base'


class UrbanApi < Sinatra::Base
  SLACK_TOKEN = %w[MYFITCBvIUnM2DEOLGuCyhWU DvYfyMK8W7lkphcygTR9p8sd]

  before do
    halt 401 unless SLACK_TOKENS.include?(params[:token])
  end

  get '/define' do
    content_type :json
    response = JSON.parse(RestClient.get('http://api.urbandictionary.com/v0/define?term=' + params['text']))
    { response_type: 'in_channel', text: "*Top urban definitions for #{params['text']}*", attachments: [mrkdwn_in: ['text', 'fields'], text: get_definitions(response)] }.to_json
  end

  def get_definitions response
    definitions = ''
    begin
      if response['list'].count > 2
        (0..2).each do |i|
          definitions += "*#{(i+1).to_s}.* " + response['list'][i]['definition'] + "\n"
        end
      else response['list'].count > 0
        definitions += "*#{(i+1).to_s}.* " + response['list'][0]['definition']
      end
    rescue
      definitions += "*No definitions found.....*"
    end
    definitions
  end
end
