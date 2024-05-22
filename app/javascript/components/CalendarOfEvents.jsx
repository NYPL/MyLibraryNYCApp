import React, { useState, useEffect } from "react";
import axios from "axios";
import { HStack, Button } from "@nypl/design-system-react-components";

function CalendarOfEvents() {
  const [calendarFileName, setCalendarFileName] = useState("");
  const [menuOfServicesFileName, setMenuOfServicesFileName] = useState("");

  useEffect(() => {
    getCalendarFileNames();
  }, []);

  const getCalendarFileNames = () => {
    axios
      .get("/home/get_mln_file_names", {
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']"),
        },
      })
      .then((res) => {
        setCalendarFileName(res.data.mln_calendar_file_name);
        setMenuOfServicesFileName(res.data.menu_of_services_file_name);
      })
      .catch(function (error) {
        console.log(error);
      });
  };

  const handleCalendarOfEvents = () => {
    const href = "//" + env.MLN_INFO_SITE_HOSTNAME + "/home/calendar_event/" + calendarFileName;
    window.location.href = href;
  }

  const handleMenuOfServices = () => {
    const href = "//" + env.MLN_INFO_SITE_HOSTNAME + "/menu_of_services/" + menuOfServicesFileName;
    window.location.href = href;
  }

  return (
    <div className="calendarButton">
      <HStack gap="xs" marginTop="s">
        <Button
          buttonType="noBrand"
          id="calendar-of-events-link"
          className="calendar_link"
          onClick={handleCalendarOfEvents}
        >
          {" "}
          Calendar of Events{" "}
        </Button>
        <Button
          buttonType="noBrand"
          id="menu-of-services-link"
          className="calendar_link"
          onClick={handleMenuOfServices}
        >
          {" "}
          Menu of Services{" "}
        </Button>
      </HStack>
    </div>
  );
}

export default CalendarOfEvents;
