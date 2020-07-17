class BooksController < ApplicationController
  def index
    books = Book.all

    render locals: {books: books}
  end
end
