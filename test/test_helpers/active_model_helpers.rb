module ActiveModelHelpers
  def assert_validation_errors(attribute, record)
    assert_not record.validate
    assert_includes record.errors, attribute
  end

  def assert_no_validation_errors(attribute, record)
    record.validate

    assert_not_includes record.errors, attribute
  end
end
