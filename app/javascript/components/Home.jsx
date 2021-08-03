import React, { Component, useState } from 'react';

import HaveQuestions from "./HaveQuestions";
import SearchTeacherSets from "./SearchTeacherSets";
import AccessDigitalResources from "./AccessDigitalResources";
import CalendarOfEvents from "./CalendarOfEvents";

import { HorizontalRule, ButtonTypes, Button } from '@nypl/design-system-react-components';
import ReactOnRails from 'react-on-rails';




export default class Home extends Component {

  constructor(props) {
    super(props);
  }
  
  render() {
    return (
      <>
        <main className="main main--with-sidebar">
          <div className="content-top">
            <div className="hero_campaigh_height"> </div>
            <div className="float-left">
              <HorizontalRule />
              <div className="home_page_text alignment">Search For Teacher Sets</div>
              <SearchTeacherSets />
            </div>
          <div className="have_questions_section"><HaveQuestions /></div>
          </div>

          <div className="content-primary">
            <div className="HorizontalLine"><HorizontalRule /></div>
            <div className="home_page_text alignment">
              Professional Development & Exclusive Programs
            </div>
              
            <div className="plain_text alignment home_page_padding">MyLibraryNYC educators can participate in workshops on a wide variety of subjects, aligned to New York State’s 
              Learning Standards to encourage reading and learning. From author talks to school programs, participating 
              MyLibraryNYC schools can access a range of exciting programming.
            </div>
   
           <CalendarOfEvents />

            <div className="HorizontalLine"><HorizontalRule /></div>
            <AccessDigitalResources />

            <div className="content-bottom">

            </div>
          </div>
          <div className="content-secondary content-secondary--with-sidebar-right">

          </div>
        </main>
      </>
    )
  }
}
