class MoviesController < ApplicationController
  #create a sort value that will hold the type of sort user wants
  @@sort_val = nil
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies=Movie.all
    @all_ratings = Movie.all_ratings
    @checked_ratings = params[:ratings] || session[:ratings]
    @@sort_val = params[:sort_val] || session[:sort_val]
    
    @movies=@movies.order(@@sort_val)
    
    if @checked_ratings == nil
      @checked_ratings = @all_ratings
      session[:sort_val] = @@sort_val
    else
      session[:ratings] = @checked_ratings
      session[:sort_val] = @@sort_val
      
      #Select only the movies with the selected ratings
      @movies=Movie.where(:rating => @checked_ratings.keys)
    end
    
    #sort movies based on the value at :sort_val
    #@movies=@movies.order(@@sort_val)
    if @@sort_val == 'title'
      @title_header = 'highlight'
    elsif @@sort_val == 'release_date'
      @release_header ='highlight'
    end
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
