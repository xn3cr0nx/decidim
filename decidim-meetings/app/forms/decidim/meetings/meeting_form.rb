# frozen_string_literal: true

module Decidim
  module Meetings
    # This class holds a Form to create/update meetings for Participants and UserGroups.
    class MeetingForm < Decidim::Form
      attribute :title, String
      attribute :description, String
      attribute :location, String
      attribute :location_hints, String

      attribute :address, String
      attribute :latitude, Float
      attribute :longitude, Float
      attribute :start_time, Decidim::Attributes::TimeWithZone
      attribute :end_time, Decidim::Attributes::TimeWithZone
      attribute :decidim_scope_id, Integer
      attribute :decidim_category_id, Integer
      attribute :user_group_id, Integer
      attribute :online_meeting_link, String
      attribute :registration_type, String
      attribute :type_of_meeting, String
      attribute :external_registration_system_link, String
      attribute :terms_and_conditions, Boolean
      attribute :available_slots, Integer, default: 0
      attribute :registration_terms, String

      TYPE_OF_MEETING = %w(in_person online).freeze
      REGISTRATION_TYPE = %w(registration_disabled on_this_platform another_registration_system).freeze

      validates :title, presence: true
      validates :description, presence: true
      validates :type_of_meeting, presence: true
      validates :location, presence: true, if: ->(form) { form.type_of_meeting == "in_person" }
      validates :address, presence: true, if: ->(form) { form.type_of_meeting == "in_person" }
      validates :address, geocoding: true, if: ->(form) { form.type_of_meeting == "in_person" && Decidim.geocoder.present? }
      validates :online_meeting_link, presence: true, if: ->(form) { form.type_of_meeting == "online" }
      validates :registration_terms, presence: true, if: ->(form) { form.registration_type == "on_this_platform" }
      validates :available_slots, numericality: { greater_than_or_equal_to: 0 }, if: ->(form) { form.registration_type == "on_this_platform" }
      validates :start_time, presence: true, date: { before: :end_time }
      validates :external_registration_system_link, presence: true, if: ->(form) { form.registration_type == "another_registration_system" }
      validates :end_time, presence: true, date: { after: :start_time }
      validates :terms_and_conditions, presence: true
      validates :registration_type, presence: true

      validates :current_component, presence: true
      validates :category, presence: true, if: ->(form) { form.decidim_category_id.present? }
      validates :scope, presence: true, if: ->(form) { form.decidim_scope_id.present? }
      validates :decidim_scope_id, scope_belongs_to_component: true, if: ->(form) { form.decidim_scope_id.present? }

      delegate :categories, to: :current_component

      def map_model(model)
        self.decidim_category_id = model.categorization.decidim_category_id if model.categorization
        presenter = MeetingPresenter.new(model)
        self.title = presenter.title(all_locales: false)
        self.description = presenter.description(all_locales: false)
      end

      alias component current_component

      # Finds the Scope from the given decidim_scope_id, uses the compoenent scope if missing.
      #
      # Returns a Decidim::Scope
      def scope
        @scope ||= @decidim_scope_id ? current_component.scopes.find_by(id: @decidim_scope_id) : current_component.scope
      end

      # Scope identifier
      #
      # Returns the scope identifier related to the meeting
      def decidim_scope_id
        @decidim_scope_id || scope&.id
      end

      def category
        return unless current_component

        @category ||= categories.find_by(id: decidim_category_id)
      end

      def type_of_meeting_select
        TYPE_OF_MEETING.map do |type|
          [
            I18n.t("type_of_meeting.#{type}", scope: "decidim.meetings"),
            type
          ]
        end
      end

      def registration_type_select
        REGISTRATION_TYPE.map do |type|
          [
            I18n.t("registration_type.#{type}", scope: "decidim.meetings"),
            type
          ]
        end
      end
    end
  end
end
