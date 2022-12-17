# frozen_string_literal: true

class Student < ApplicationRecord
  has_many :enrollments, dependent: :destroy

  validates :name, :cpf, :payment_method, presence: true
  validates :cpf, uniqueness: true, numericality: { only_integer: true }, length: { is: 11 }

  enum payment_method: { credit_card: 'Cartão de crédito', boleto: 'Boleto' }
end
