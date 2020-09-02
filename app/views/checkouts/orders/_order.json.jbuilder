json.call(order, :email, :name)

json.address do
  json.call(order, :city, :country, :line1, :line2, :postal_code, :state)
end
