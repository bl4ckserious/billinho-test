module Api
    module V1
        class InstitutionsController < ApplicationController
            include Paginable
            def index 
                institutions = Institution.page(current_page).per(count)

                render json: { data:institutions.as_json(except: %i[created_at updated_at]) }, status: :ok
            end

            def show
                institution = Institution.find(params[:id])

                render json: { data:institution.as_json(except: %i[created_at updated_at]) }, status: :ok
            end

            def create
                institution = Institution.new(institution_params)

                if institution.save
                    render json: { message: 'Institution created', data:institution.as_json(except: %i[created_at updated_at]) }, status: :ok
                else
                    render json: { status: 'ERROR', message: 'Institution not created', data:institution.erros }, status: :unprocessable_entity
                end
            end

            def update 
                institution = Institution.find(params[:id])

                if institution.update(institution_params)
                    render json: { message: 'Institution updated', data:institution.as_json(except: %i[created_at updated_at]) }, status: :ok
                else
                    render json: { message: 'Institution not updated', data:institution }, status: :unprocessable_entity
                end
            end

            def destroy
                institution = Institution.find(params[:id])
                institution.destroy

                render json: { message: 'Institution deleted', data:institution.as_json(except: %i[created_at updated_at]) }, status: :ok
            end

            private 

            def institution_params
                params.permit(:name, :cnpj)
            end
        end
    end
end