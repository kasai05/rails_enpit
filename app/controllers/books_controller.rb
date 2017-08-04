require 'net/https'
require 'uri'
require 'json'

class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
   #map display  
   # url =  "http://ip-api.com/json/"
   # res = urlopen(url).read().decode('utf-8')
   # @lat = json.loads(res)['lat']
   # @lon = json.loads(res)['lon']
   # @city = json.loads(res)['city']
  end

  # GET /books/1
  # GET /books/1.json
  def show
    author = @book.author
    logger.debug "著者は#{author}です。googleBookApiを呼び出します。"
    uri  = URI.parse URI.encode "https://www.googleapis.com/books/v1/volumes?q=#{author}"
    json = Net::HTTP.get(uri)
    rst  = JSON.parse(json)
    @abooks = []
    rst["items"].each {|item|
      info = item["volumeInfo"]
      if info["language"] != "ja" then
        logger.debug "日本語以外の書籍のためスキップします。\n"
        next
      end
      title = info["title"]
      desc  = info["description"]
      @abooks.push({"title" => title, "desc" => desc})
      logger.debug "title:#{title}_____desc#{desc}\n"
    }
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :author)
    end
end
