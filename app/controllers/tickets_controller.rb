class TicketsController < ApplicationController
  load_and_authorize_resource :cinema
  load_and_authorize_resource :hall, through: :cinema
  load_and_authorize_resource :movie_session, through: :hall
  authorize_resource class: false
  
  def reserve_ticket
    if seat_available?
      start_reservation_timer
      reserve_seats
      redirect_to cinema_hall_movie_session_url(@cinema, @hall, @movie_session, 
        seat: params[:seat])
    else
      redirect_to cinema_hall_movie_session_url(@cinema, @hall, @movie_session, 
        seat: params[:seat])
    end
  end
  
  def buy_ticket
    if @movie_session.reserved_seats[params[:seat]] == current_user.id
      @movie_session.update(seats: @movie_session.seats.merge!(
        {params[:seat] => "taken"} ))
      render pdf: "ticket", template: "ticket.html.erb"
    else
      redirect_to cinema_hall_movie_session_url(@cinema, @hall, @movie_session),
        alert: 'Your reservation has expired.'
    end
    
  end
  
  
  private
  
  def seat_available?
    if @movie_session.seats[params[:seat]] == "taken" ||
      @movie_session.seats[params[:seat]] == "reserved"
      return false
    else
      return true
    end
  end
  
  def reserve_seats
    @movie_session.update(
      seats: @movie_session.seats.merge!( {params[:seat] => "reserved"} ),
      reserved_seats: @movie_session.reserved_seats.merge!( 
        {params[:seat] => current_user.id} ))
  end
  
  def start_reservation_timer
    ReservationTimerJob.set(wait: 30.seconds).perform_later(
      @movie_session, params[:seat])
  end
  
end
