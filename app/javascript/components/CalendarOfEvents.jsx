import React, { useState, useEffect } from "react";
import axios from "axios";
import {
  Button,
  Link,
  ButtonGroup,
} from "@nypl/design-system-react-components";

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

  return (
    <div className="calendarButton">
      <ButtonGroup marginTop="s">
        <Button id="calendar-of-events-button" buttonType="noBrand">
          <Link
            id="calendar-of-events-link"
            className="calendar_link"
            target="_blank"
            href={
              "//" +
              process.env.MLN_INFO_SITE_HOSTNAME +
              "/home/calendar_event/" +
              calendarFileName
            }
          >
            {" "}
            Calendar of Events{" "}
          </Link>
        </Button>

        <Button id="menu-of-services-button" buttonType="noBrand">
          <Link
            id="menu-of-services-link"
            className="calendar_link"
            target="_blank"
            href={
              "//" +
              process.env.MLN_INFO_SITE_HOSTNAME +
              "/menu_of_services/" +
              menuOfServicesFileName
            }
          >
            {" "}
            Menu of Services{" "}
          </Link>
        </Button>
      </ButtonGroup>
    </div>
  );
}

export default CalendarOfEvents;
