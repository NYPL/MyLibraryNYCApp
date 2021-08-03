import React, { Component, useState } from 'react';

import HaveQuestions from "./HaveQuestions";
import SearchTeacherSets from "./SearchTeacherSets";
import AccessDigitalResources from "./AccessDigitalResources";
import axios from 'axios';
import { Accordion, Link, List } from '@nypl/design-system-react-components';
import { HorizontalRule, ButtonTypes, Button } from '@nypl/design-system-react-components';
import ReactOnRails from 'react-on-rails';
import { BrowserRouter as Router, Link as ReactRouterLink } from "react-router-dom";


class CalendarOfEvents extends Component {
  constructor(props) {
    super(props);
    this.state = {mln_calendar_file_name: "" };
  }

componentDidMount() {
  axios.get('/home/get_mln_file_name')
    .then(res => {
      this.setState({ mln_calendar_file_name: res.data.mln_calendar_file_name });
    })
    .catch(function (error) {
     console.log(error);
  })
}


render() {
  return (
    <div className="alignment" style={{ display: "flex", justifyContent: "flex-start", paddingTop: "34px"}}>
      <Button onclick="" className="calendar_button background_black_color" buttonType={ButtonTypes.Primary}>
          <Link className="calendar_link" target="_blank" href={"http://dev-www.mylibrarynyc.local:3000/home/calendar_event/"+ this.state.mln_calendar_file_name } > Calendar of Events </Link>
      </Button>
      
      <Button className="calendar_button background_black_color" buttonType={ButtonTypes.Primary}> 
        <Link className="calendar_link" target="_blank" href="http://dev-www.mylibrarynyc.local:3000/assets/2018_2019_School_Outreach_Menu_of_Services.pdf" > Menu of Services </Link>
      </Button>
    </div>
  )
  }
}

export default CalendarOfEvents;



