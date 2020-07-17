require "application_system_test_case"

class VisitorViewsABookTest < ApplicationSystemTestCase
  test "visitor views a book" do
    ruby_science = books(:ruby_science)

    visit root_path
    click_on ruby_science.title

    assert_book ruby_science
    assert_rich_text ruby_science.description
    assert_rich_text ruby_science.table_of_contents
  end

  def assert_rich_text(rich_text)
    assert_includes page.html, rich_text.body.to_html
  end
end
