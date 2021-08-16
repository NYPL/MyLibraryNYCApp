import React, { Component, useState } from 'react';

import HaveQuestions from "./HaveQuestions";
import SearchTeacherSetsBox from "./SearchTeacherSetsBox";
import AccessDigitalResources from "./AccessDigitalResources";
import CalendarOfEvents from "./CalendarOfEvents";

import { HorizontalRule, ButtonTypes, Button, Hero,  Heading, Image} from '@nypl/design-system-react-components';
import ReactOnRails from 'react-on-rails';




export default class Home extends Component {

  constructor(props) {
    super(props);
  }
  
  render() {
    return (
      <>
      <div>
        <Hero
          backgroundImageSrc="/assets/hero_campaign_bg.jpg"
          heading={<Heading blockName="hero" id="1" level={1} text="Welcome To MyLibrary NYC"/>}
          heroType="CAMPAIGN"
          image={<Image alt="Image example" blockName="hero" src="/assets/hero_campaign_left.png"/>}
          subHeaderText="We provide participating schools with enhanced library privileges including fine-free student and educator library cards, school delivery and the exclusive use of 6,000+ Teacher Sets designed for educator use in the classroom; and student and educator access to the unparalleled digital resources of New York City’s public library systems as well as instructional support and professional development opportunities."/>
        
        <main className="main main--with-sidebar">
          <div className="content-top">
            <div className="float-left">
              <HorizontalRule />
              <div className="home_page_text alignment">Search For Teacher Sets</div>
              <SearchTeacherSetsBox />
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
      </div>
      </>
    )
  }
}
