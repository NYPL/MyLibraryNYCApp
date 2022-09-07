import React, { Component, useState, useEffect } from 'react';
import HaveQuestions from "./HaveQuestions";
import AccessDigitalResources from "./AccessDigitalResources";
import axios from 'axios';
import { HorizontalRule, Button, HStack, Accordion, Link, List, ButtonGroup } from '@nypl/design-system-react-components';
import ReactOnRails from 'react-on-rails';
import { BrowserRouter as Router, Link as ReactRouterLink } from "react-router-dom";


function CalendarOfEvents(props) {

  const [calendarFileName, setCalendarFileName] = useState([])

  useEffect(() => {
    getCalendarFileName();
  }, []);

  const getCalendarFileName = () => {
    axios.get('/home/get_mln_file_name', {headers: {"Content-Type": "application/json", 'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content") }})
      .then(res => {
        setCalendarFileName(res.data.mln_calendar_file_name);
      })
      .catch(function (error) {
       console.log(error);
    })
  }

  return (
    <div className="calendarButton">
      <ButtonGroup>
        <Button id="calendar-of-events-button" buttonType="noBrand">
          <Link id="calendar-of-events-link" className="calendar_link" target="_blank" href={ "//"+ process.env.MLN_INFO_SITE_HOSTNAME + "/home/calendar_event/" + calendarFileName } > Calendar of Events </Link>
        </Button>

        <Button id="menu-of-services-button" buttonType="noBrand"> 
          <Link id="menu-of-services-link" className="calendar_link" target="_blank" href={ "//"+ process.env.MLN_INFO_SITE_HOSTNAME + "/assets/2021_2022_MyLibraryNYC_Menu_of_Services_for_Educators.pdf" } > Menu of Services </Link>
        </Button>
      </ButtonGroup>
    </div>
  )
}

export default CalendarOfEvents;