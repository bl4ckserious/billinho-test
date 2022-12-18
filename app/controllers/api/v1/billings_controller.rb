# frozen_string_literal: true

module Api
  module V1
    class BillingsController < ApplicationController
      include Paginable

        def index
            bills = Billing.page(current_page).per(count)

            render json: { bills: bills.as_json(except: %i[created_at updated_at])}, status: :ok
        end

        def show
            bill = Billing.find(params[:id])

            render json: { bill: bill.as_json(except: %i[created_at updated_at])}, status: :ok
        end

        def update 
            billing = Billing.find(params[:id])

            if billing.update(invoice_params)
                render json: {message: 'Bill updated', data:billing..as_json(except: %i[created_at updated_at])}, status: :ok
            else
                render json: {status:'ERROR', message: 'Bill not updated', data:billing.erros}, status: :unprocessable_entity
            end
        end
        
        private

        def invoice_params
            params.permit(:enrollment_id, :amount, :due_date, :status)
        end
    end
  end
end
