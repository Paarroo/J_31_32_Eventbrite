# Contrôleur pour les inscriptions gratuites
class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :create, :destroy ]
  before_action :set_attendance, only: [ :destroy ]

  # POST /events/:event_id/attendances (pour événements gratuits)
  def create
    if @event.user == current_user
      redirect_to @event, alert: "Vous ne pouvez pas vous inscrire à votre propre événement."
      return
    end

    if @event.participants.include?(current_user)
      redirect_to @event, alert: "Vous participez déjà à cet événement."
      return
    end

    unless @event.free?
      redirect_to new_event_payment_path(@event), notice: "Cet événement est payant."
      return
    end

    @attendance = Attendance.new(
      user: current_user,
      event: @event,
      payment_status: 'free'
    )

    if @attendance.save
      redirect_to @event, notice: "🎉 Inscription confirmée !"
    else
      redirect_to @event, alert: "Erreur lors de l'inscription : #{@attendance.errors.full_messages.join(', ')}"
    end
  end

  # DELETE /events/:event_id/attendances/:id
  def destroy
    unless @attendance.user == current_user
      redirect_to @attendance.event, alert: "Vous ne pouvez pas annuler cette participation."
      return
    end

    @attendance.destroy!
    redirect_to @attendance.event, notice: "✅ Votre inscription a été annulée."
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_attendance
    @attendance = current_user.attendances.find(params[:id])
  end
end
