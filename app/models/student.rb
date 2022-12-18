# frozen_string_literal: true

class Student < ApplicationRecord
  has_many :enrollments, dependent: :destroy

  validates :name, :cpf, :payment_method, presence: true
  validates :cpf, uniqueness: true, format: { with: /\A\d{3}\.\d{3}\.\d{3}-\d{2}\z/ }

  validate :validate_cpf

  enum payment_method: { credit_card: 'Cartão de crédito', boleto: 'Boleto' }

  private

  def validate_cpf
    cpf = self.cpf.gsub(/[.-]/, '')
    if cpf.length != 11 || cpf.chars.uniq.length == 1
      errors.add(:cpf, 'não é válido')
      return false
    end

    digit1 = calculate_digit1(cpf)
    digit2 = calculate_digit2(cpf, digit1)

    if cpf[9].to_i != digit1 || cpf[10].to_i != digit2
      errors.add(:cpf, 'não é válido')
      return false
    end

    true
  end

  def calculate_digit1(cpf)
    sum = 0
    9.times do |i|
      sum += (10 - i) * cpf[i].to_i
    end
    digit = sum % 11
    digit = digit < 2 ? 0 : 11 - digit
  end

  def calculate_digit2(cpf, _digit1)
    sum = 0
    10.times do |i|
      sum += (11 - i) * cpf[i].to_i
    end
    digit = sum % 11
    digit = digit < 2 ? 0 : 11 - digit
  end
end
