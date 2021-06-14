
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
    render json: { "jsonrpc": "2.0", id: params[:id], "result": response }
  rescue => e
    raise e
  end  
end
