# frozen_string_literal: true

module Api
  module V1
    class EnrollmentsController < ApplicationController
      include Paginable

      def index
        enrollments = Enrollment.page(current_page).per(count)
        items = []

        enrollments.each do |e|
          bills = Billing.where(enrollment_id: e.id)
          items << {
            id: e.id,
            student_id: e.student_id,
            institution_id: e.institution_id,
            amount: e.amount,
            installments: e.installments,
            due_day: e.due_day,
            bills: bills.as_json(except: %i[created_at updated_at])
          }
        end

        render json: { page: current_page, items: }, status: :ok
      end

      def show
        enrollment = Enrollment.find(params[:id])

        render json: { status: 'SUCCESS', message: 'Enrollment loaded', data: enrollment }, status: :ok
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
        enrollment = Institution.find(params[:id])

        if enrollment.update(enrollment_params)
          render json: { status: 'SUCCESS', message: 'Institution updated', data: enrollment }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Institution not updated', data: enrollment }, status: :unprocessable_entity
        end
      end

      def destroy
        enrollment = Institution.find(params[:id])
        enrollment.destroy

        render json: { status: 'SUCCESS', message: 'Institution deleted', data: enrollment }, status: :ok
      end

      private

      def enrollment_params
        params.permit(:student_id, :institution_id, :amount, :installments, :due_day)
      end
    end
  end
end
