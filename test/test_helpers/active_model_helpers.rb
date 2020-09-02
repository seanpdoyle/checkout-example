module ActiveModelHelpers
  def assert_validation_errors(attribute, record, context: nil)
    assert_not record.validate(context)
    assert_includes record.errors, attribute
  end

  def assert_no_validation_errors(attribute, record, context: nil)
    record.validate(context)

    assert_not_includes record.errors, attribute
  end
end
