class Address
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :line1, :string
  attribute :line2, :string
  attribute :city, :string
  attribute :state, :string
  attribute :postal_code, :string
  attribute :country, :string

  validates :line1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, length: { is: 5 }
  validates :country, presence: true
end
