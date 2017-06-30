class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  def index
    @users = User.all
    @movies = Movie.all
    @movie_sessions = MovieSession.all
  end
  
end
