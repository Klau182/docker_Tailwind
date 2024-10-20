Rails.application.routes.draw do
  devise_for :users
 
  authenticated(:user) do #cuando el usuario esta autenticado
    root "pages#index", as: :authenticaded_root #mostrara el index
  end  

  unauthenticated(:user) do  #cuando el ususario no esta autenticado
    root "pages#landing_page" #se mostrara el landing page
  end  
  
end
