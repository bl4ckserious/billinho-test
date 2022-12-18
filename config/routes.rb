# frozen_string_literal: true

Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :students
      resources :institutions
      resources :billings
      resources :enrollments
    end
  end
end
