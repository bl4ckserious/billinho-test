# frozen_string_literal: true

class Student < ApplicationRecord
  has_many :enrollments, dependent: :destroy

  validates :name, :cpf, :payment_method, presence: true
  validates :cpf, uniqueness: true, format: { with: /\A\d{3}\.\d{3}\.\d{3}-\d{2}\z/ }

  validate :validate_cpf

  enum payment_method: { credit_card: 'Cartão de crédito', boleto: 'Boleto' }
end

private

def validate_cpf
    cpf_digits = cpf.gsub(/[^\d]/, '')
    return errors.add(:cpf, "deve ter 11 dígitos") if cpf_digits.length != 11
    return errors.add(:cpf, "deve ser composto apenas por dígitos") if cpf_digits =~ /\D/
  
    weights = [10, 9, 8, 7, 6, 5, 4, 3, 2]
    weights << weights.reduce(0) { |sum, w| sum + w * cpf_digits[w - 1].to_i } % 11
    weights << weights[-1] + weights[0..8].reduce(0) { |sum, w| sum + w * cpf_digits[w - 1].to_i } % 11
    weights = weights.map { |w| w == 10 || w == 11 ? 0 : w }
  
    errors.add(:cpf, "é inválido") unless weights.last == cpf_digits[-1].to_i && weights[-2] == cpf_digits[-2].to_i
  end
  