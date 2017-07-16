Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'bitmap#show'

  post 'run_commands', to: 'bitmap#run_commands'
end
