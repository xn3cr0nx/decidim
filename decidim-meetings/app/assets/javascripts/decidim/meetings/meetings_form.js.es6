(function() {
  $(() => {
    const $form = $(".meetings_form");
    if ($form.length > 0) {
      const $meetingTypeOfMeeting = $form.find("#meeting_type_of_meeting");
      const $meetingOnlineMeetingLink = $form.find("#meeting_online_meeting_link")
      const $meetingLocation = $form.find("#location");
      const $meetingRegistrationType = $form.find("#meeting_registration_type");
      const $meetingRegistrationTerms = $form.find("#meeting_registration_terms");
      const $meetingAvailableSlots = $form.find("#meeting_available_slots");
      const $meetingExternalRegistrationLink = $form.find("#meeting_external_registration_system_link");

      const toggleDependsOnSelect = ($target, $showDiv, type) => {
        const value = $target.val();
        $showDiv.hide();
        if (value === type) {
          $showDiv.show();
        }
      };

      $meetingRegistrationType.on("change", (ev) => {
        const $target = $(ev.target);
        toggleDependsOnSelect($target, $meetingRegistrationTerms, "on_this_platform");
        toggleDependsOnSelect($target, $meetingAvailableSlots, "on_this_platform");
        toggleDependsOnSelect($target, $meetingExternalRegistrationLink, "another_registration_system");
      });

      toggleDependsOnSelect($meetingRegistrationType, $meetingRegistrationTerms, "on_this_platform");
      toggleDependsOnSelect($meetingRegistrationType, $meetingAvailableSlots, "on_this_platform");
      toggleDependsOnSelect($meetingRegistrationType, $meetingExternalRegistrationLink, "another_registration_system");

      $meetingTypeOfMeeting.on("change", (ev) => {
        const $target = $(ev.target);
        toggleDependsOnSelect($target, $meetingLocation, "in_person");
        toggleDependsOnSelect($target, $meetingOnlineMeetingLink, "online");
      });

      toggleDependsOnSelect($meetingTypeOfMeeting, $meetingLocation, "in_person");
      toggleDependsOnSelect($meetingTypeOfMeeting, $meetingOnlineMeetingLink, "online");
    }
  })
}(window));
