require "application_system_test_case"

class VisitorNavigatesBackToLibraryFromABookTest < ApplicationSystemTestCase
  test "visitor navigates back to library from a book" do
    ruby_science = books(:ruby_science)

    visit book_path(ruby_science)
    click_on translate("books.show.library")

    assert_text translate("books.index.title")
    assert_book ruby_science
  end
end
