class AddFieldsToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_meetings_meetings, :type_of_meeting, :string
    add_column :decidim_meetings_meetings, :online_meeting_link, :string
    add_column :decidim_meetings_meetings, :registration_type, :string
    add_column :decidim_meetings_meetings, :external_registration_system_link, :string
    add_column :decidim_meetings_meetings, :terms_and_conditions, :boolean
  end
end
