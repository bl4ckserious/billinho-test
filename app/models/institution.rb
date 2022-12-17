# frozen_string_literal: true

class Institution < ApplicationRecord
  has_many :enrollments, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :cnpj, presence: true, uniqueness: true, numericality: { only_integer: true }, length: { is: 14 }
end
