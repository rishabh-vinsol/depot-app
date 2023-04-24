Rails.application.routes.draw do
  match '/*path', to: redirect('404'), via: :all, constraints: ->(req) {req.headers['User-Agent'] =~ /Firefox/}
  get "admin" => "admin#index"
  namespace :admin do
    get "reports" => "reports#index"
    resources :categories do
      resources :products, path:"/books", as: 'books', controller: '/products', only: :index, constraints: { category_id: /\d+/ }
      resources :products, to: redirect('/'), path:"/books"
    end
  end
  controller :sessions do
    get "login" => :new
    post "login" => :create
    delete "logout" => :destroy
  end
  get "sessions/create"
  get "sessions/destroy"
  resources :users do
    get "orders", on: :collection
    get "line_items", on: :collection
  end

  get "myorders", to: "users#orders"
  get "my-items", to: "users#line_items"

  resources :products, path: '/books' do
    get :who_bought, on: :member
  end

  resources :support_requests, only: [:index, :update]

  scope "(:locale)" do
    resources :orders
    resources :line_items
    resources :carts
    root "store#index", as: "store_index", via: :all
  end
end
