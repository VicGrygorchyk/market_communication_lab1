Rails.application.routes.draw do
  resources :question_to_answers
  resources :answers
  resources :results
  resources :questions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
