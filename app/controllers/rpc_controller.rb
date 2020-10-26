
require 'electrb'

class RpcController < ApplicationController
  skip_before_action :verify_authenticity_token
  def receive
    yaml = Pathname.new(Rails.root.join('config', 'elect.yml')) 
    config = YAML.load(ERB.new(yaml.read).result).deep_symbolize_keys
    config = config[Rails.env.to_sym]
    client = Electrb::Client.new(config[:host], config[:port])
    response = client.request(params[:method], *params[:params])
    pp response
    render json: response.to_json
  rescue => e
    pp e.backtrace
    render json: { message: e.message }
  end  
end