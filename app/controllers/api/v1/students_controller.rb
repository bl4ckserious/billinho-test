# frozen_string_literal: true

module Api
  module V1
    class StudentsController < ApplicationController
      include Paginable
      def index
        students = Student.page(current_page).per(count)

        render json: { page: current_page, items: students.as_json(except: %i[created_at updated_at]) }, status: :ok
      end

      def show
        student = Student.find(params[:id])

        render json: { status: 'SUCCESS', message: 'Loaded student', data: student }, status: :ok
      end

      def create
        student = Student.new(student_params)

        if student.save
          render json: { id: student.id }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Student not saved', data: student.erros }, status: :unprocessable_entity
        end
      end

      def update
        student = Student.find(params[:id])

        if student.update(student_params)
          render json: { status: 'SUCCESS', message: 'Updated data', data: student.as_json(except: %i[created_at updated_at]) }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Data not updated', data: student.as_json(except: %i[created_at updated_at]) }, status: :unprocessable_entity
        end
      end

      def destroy
        student = Student.find(params[:id])
        student.destroy

        render json: { status: 'SUCCESS', message: 'Deleted student', data: student }, status: :ok
      end

      private

      def student_params
        params.permit(:name, :cpf, :birth_date, :payment_method)
      end
    end
  end
end
