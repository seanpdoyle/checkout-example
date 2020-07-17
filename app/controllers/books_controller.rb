class BooksController < ApplicationController
  def index
    books = Book.all

    render locals: {books: books}
  end

  def show
    book = Book.find(params[:id])

    render locals: {book: book}
  end
end
