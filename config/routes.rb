Rails.application.routes.draw do
  post 'quiz', to: 'quiz#solver'
  get '*path' => redirect('/')
end
