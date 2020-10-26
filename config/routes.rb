Rails.application.routes.draw do
  post '/', to: 'rpc#receive'
end
