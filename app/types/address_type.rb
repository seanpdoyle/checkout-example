class AddressType < ActiveRecord::Type::Value
  def cast(value)
    if value.is_a?(String)
      Address.new(
        ActiveSupport::JSON.decode(value)
      )
    else
      Address.new(value)
    end
  end

  def serialize(value)
    value.attributes.to_json
  end
end
