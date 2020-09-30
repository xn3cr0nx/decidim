((exports) => {
  const { AutoLabelByPositionComponent, AutoButtonsByPositionComponent, createDynamicFields, createSortList } = exports.DecidimAdmin;

  const wrapperSelector = ".meeting-services";
  const fieldSelector = ".meeting-service";

  const autoLabelByPosition = new AutoLabelByPositionComponent({
    listSelector: ".meeting-service:not(.hidden)",
    labelSelector: ".card-title span:first",
    onPositionComputed: (el, idx) => {
      $(el).find("input[name$=\\[position\\]]").val(idx);
    }
  });

  const autoButtonsByPosition = new AutoButtonsByPositionComponent({
    listSelector: ".meeting-service:not(.hidden)",
    hideOnFirstSelector: ".move-up-service",
    hideOnLastSelector: ".move-down-service"
  });

  const createSortableList = () => {
    createSortList(".meeting-services-list:not(.published)", {
      handle: ".service-divider",
      placeholder: '<div style="border-style: dashed; border-color: #000"></div>',
      forcePlaceholderSize: true,
      onSortUpdate: () => { autoLabelByPosition.run() }
    });
  };

  const hideDeletedService = ($target) => {
    const inputDeleted = $target.find("input[name$=\\[deleted\\]]").val();

    if (inputDeleted === "true") {
      $target.addClass("hidden");
      $target.hide();
    }
  };

  createDynamicFields({
    placeholderId: "meeting-service-id",
    wrapperSelector: wrapperSelector,
    containerSelector: ".meeting-services-list",
    fieldSelector: fieldSelector,
    addFieldButtonSelector: ".add-service",
    removeFieldButtonSelector: ".remove-service",
    moveUpFieldButtonSelector: ".move-up-service",
    moveDownFieldButtonSelector: ".move-down-service",
    onAddField: () => {
      createSortableList();

      autoLabelByPosition.run();
      autoButtonsByPosition.run();
    },
    onRemoveField: () => {
      autoLabelByPosition.run();
      autoButtonsByPosition.run();
    },
    onMoveUpField: () => {
      autoLabelByPosition.run();
      autoButtonsByPosition.run();
    },
    onMoveDownField: () => {
      autoLabelByPosition.run();
      autoButtonsByPosition.run();
    }
  });

  createSortableList();

  $(fieldSelector).each((idx, el) => {
    const $target = $(el);

    hideDeletedService($target);
  });

  autoLabelByPosition.run();
  autoButtonsByPosition.run();

  const $form = $(".edit_meeting, .new_meeting, .copy_meetings");

  if ($form.length > 0) {
    const $privateMeeting = $form.find("#private_meeting");
    const $transparent = $form.find("#transparent");

    const toggleDisabledHiddenFields = () => {
      const enabledPrivateSpace = $privateMeeting.find("input[type='checkbox']").prop("checked");
      $transparent.find("input[type='checkbox']").attr("disabled", "disabled");

      if (enabledPrivateSpace) {
        $transparent.find("input[type='checkbox']").attr("disabled", !enabledPrivateSpace);
      }
    };

    $privateMeeting.on("change", toggleDisabledHiddenFields);
    toggleDisabledHiddenFields();

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

    $meetingTypeOfMeeting.on("change", (ev) => {
      const $target = $(ev.target);
      toggleDependsOnSelect($target, $meetingLocation, "in_person");
      toggleDependsOnSelect($target, $meetingOnlineMeetingLink, "online");
    });

    toggleDependsOnSelect($meetingTypeOfMeeting, $meetingLocation, "in_person");
    toggleDependsOnSelect($meetingTypeOfMeeting, $meetingOnlineMeetingLink, "online");

    $meetingRegistrationType.on("change", (ev) => {
      const $target = $(ev.target);
      toggleDependsOnSelect($target, $meetingRegistrationTerms, "on_this_platform");
      toggleDependsOnSelect($target, $meetingAvailableSlots, "on_this_platform");
      toggleDependsOnSelect($target, $meetingExternalRegistrationLink, "another_registration_system");
    });

    toggleDependsOnSelect($meetingRegistrationType, $meetingRegistrationTerms, "on_this_platform");
    toggleDependsOnSelect($meetingRegistrationType, $meetingAvailableSlots, "on_this_platform");
    toggleDependsOnSelect($meetingRegistrationType, $meetingExternalRegistrationLink, "another_registration_system");
  }
})(window);
