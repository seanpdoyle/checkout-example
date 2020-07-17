require "application_system_test_case"

class VisitorViewsABookTest < ApplicationSystemTestCase
  test "visitor views a book" do
    ruby_science = books(:ruby_science)

    visit root_path
    click_on ruby_science.title

    assert_book ruby_science
  end
end
