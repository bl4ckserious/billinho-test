module Api
    module V1
        class BillingsController < ApplicationController
            include Paginable

            def index 
                bills = Billing.page(current_page).per(count)
                
                render json: {bills: bills}, status: :ok
            end

            def show
                bill = Billing.find(params[:id])

                render json: {bill: bill}, status: :ok
            end
        end
    end
end