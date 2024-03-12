import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from "axios";
import {
  TemplateAppContainer,
  Heading,
} from "@nypl/design-system-react-components";

const CalendarEventError = () => {
  const [mlnCalendarEvent, setMlnCalendarEvent] = useState("");

  useEffect(() => {
    axios
      .get("/home/calendar_event")
      .then((res) => {
        setMlnCalendarEvent(res.data.calendar_event);
      })
      .catch(function (error) {
        console.log(error);
      });
  }, []);

  const eventErrorMessage = () => {
    if (mlnCalendarEvent && mlnCalendarEvent.length <= 0) {
      return (
        <Heading
          marginBottom="15em"
          size='heading5'
          id="mln-calendar-event-error-id"
          level="h3"
          text="MyLibraryNyc calendar not found."
        />
      );
    }
  };

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentTop={eventErrorMessage()}
    />
  );
};

export default CalendarEventError;
