# frozen_string_literal: true

module Api
  module V1
    class EnrollmentsController < ApplicationController
      include Paginable
      include ActionController::HttpAuthentication::Basic::ControllerMethods

      before_action :authenticate

      def index
        enrollments = Enrollment.page(current_page).per(count)
        itemsContent = []

        enrollments.each do |e|
          bills = Billing.where(enrollment_id: e.id)
          items << {
            id: e.id,
            student_id: e.student_id,
            institution_id: e.institution_id,
            amount: e.amount,
            installments: e.installments,
            due_day: e.due_day,
            bills: bills.as_json(except: %i[created_at updated_at enrollment_id])
          }
        end

        render json: { page: current_page, items: itemsContent }, status: :ok
      end

      def show
        enrollment = Enrollment.find(params[:id])

        render json: { data: enrollment.as_json(except: %i[created_at updated_at]) }, status: :ok
      end

      def create
        enrollment = Enrollment.new(enrollment_params)

        if enrollment.save
          bills = Billing.where(enrollment_id: enrollment.id)

          render json: {
            id: enrollment.id,
            student_id: enrollment.student_id,
            ies_id: enrollment.institution_id,
            amount: enrollment.amount,
            installments: enrollment.installments,
            due_day: enrollment.due_day,
            bills: bills.as_json(except: %i[created_at updated_at enrollment_id])
          }, status: :ok
        else
          render json: { status: 'ERROR', message: 'enrollment not saved', data: enrollment.erros }, status: :unprocessable_entity
        end
      end

      def update
        enrollment = Enrollment.find(params[:id])

        if enrollment.update(enrollment_params)
          render json: { status: 'SUCCESS', message: 'Enrollment updated', data: enrollment.as_json(except: %i[created_at updated_at]) }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Enrollment not updated', data: enrollment.as_json(except: %i[created_at updated_at]) }, status: :unprocessable_entity
        end
      end

      def destroy
        enrollment = Enrollment.find(params[:id])
        enrollment.destroy

        render json: { status: 'SUCCESS', message: 'Enrollment deleted', data: enrollment.as_json(except: %i[created_at updated_at]) }, status: :ok
      end

      private

      def enrollment_params
        params.permit(:student_id, :institution_id, :amount, :installments, :due_day)
      end

      def authenticate
        authenticate_or_request_with_http_basic do |username, password|
          username == 'admin_ops' && password == 'billing'
        end
      end
    end
  end
end
