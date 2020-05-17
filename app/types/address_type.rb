class AddressType < ActiveRecord::Type::Json
  def serialize(value)
    if value.respond_to?(:attributes)
      super(value.attributes)
    else
      super
    end
  end

  def deserialize(value)
    Address.new(super)
  end
end
