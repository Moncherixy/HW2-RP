class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @movies = Movie.all
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @sort = params[:sort] || session[:sort]
    @ratings_to_show = @all_ratings
    @checked_ratings = params[:ratings] || session[:ratings]
    
    if !@checked_ratings
      session[:ratings] = {}
      @all_ratings.each do |rating|
        session[:ratings][rating] = 1
      end
      @checked_ratings = session[:ratings]
    end
    
    
    if !(params[:sort] == session[:sort] && params[:ratings] == session[:ratings])
      params[:sort] = session[:sort] = @sort
      params[:ratings] = session[:ratings] = @checked_ratings
      flash.keep
      redirect_to movies_path(:sort=>params[:sort], :ratings =>params[:ratings])
    end
    
    # @rating_array = {}
    # @all_ratings.each do |rating|
    #   @rating_array[rating] = !@checked_ratings.nil? && @checked_ratings.keys.include?(rating)
    # end
    
    session[:sort] = @sort
    session[:ratings] = @checked_ratings
    
    
    @movies = Movie.order @sort
    if @checked_ratings
      @movies = Movie.where(:rating => @checked_ratings.keys).order @sort
    end
    
    
    # if params[:sort] == "title"
    #   @TitleClass = "hilite"
    #   @ReleaseDateClass = ""
    # elsif params[:sort] == "release_date"
    #   @TitleClass = ""
    #   @ReleaseDateClass = "hilite"
    # else
    #   @TitleClass = ""
    #   @ReleaseDateClass = ""
    # end
    
    @rating_array = []
    @movies.each do |movie_table|
      @rating_array << movie_table[:rating]
    end
    
    @movies = @movies.uniq
    @ratings_to_show = @rating_array.uniq
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
