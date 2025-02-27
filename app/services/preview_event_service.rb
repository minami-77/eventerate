class PreviewEventService
  def self.clear_sessions
    session.delete(:selected_activities)
    session.delete(:generated_activities)
  end
end
