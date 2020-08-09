json.call(payment, :email, :name)

json.address do
  json.call(payment, :city, :country, :line1, :line2, :postal_code, :state)
end
