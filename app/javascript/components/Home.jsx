import React, { Component, useState } from 'react';

import HaveQuestions from "./HaveQuestions";
import SearchTeacherSetsBox from "./SearchTeacherSetsBox";
import AccessDigitalResources from "./AccessDigitalResources";
import CalendarOfEvents from "./CalendarOfEvents";
import NewsLetter from "./NewsLetter";
import heroCampaignBg from '../images/hero_campaign_bg.jpg'
import heroCampaignLeft from '../images/hero_campaign_left.jpg'
import ReactOnRails from 'react-on-rails';
import axios from 'axios';
import {
  Hero,
  Image,
  Button,
  ButtonTypes,
  SearchBar,
  Select,
  Input,
  SearchButton,
  InputTypes,
  Icon,
  IconNames,
  HelperErrorText,
  LibraryExample,
  HorizontalRule,
  Heading,
  Card, 
  CardHeading, 
  CardContent,
  CardLayouts,
  Pagination, Checkbox, DSProvider, TemplateAppContainer, HeroTypes, VStack, HeadingLevels, NotificationTypes, Notification, Text
} from '@nypl/design-system-react-components';

import bookImage from '../images/book.png'



const styles = {
  heroCampaign: {
    background: "#F5F5F5"
  }
}


export default class Home extends React.Component {

  state = { userSignedIn: this.props.userSignedIn, teacher_sets: [], facets: [], ts_total_count: "", error_msg: {}, email: "", 
                 display_block: "block", display_none: "none", setComputedCurrentPage: 1, 
                 computedCurrentPage: 1, pagination: "", keyword: new URLSearchParams(this.props.location.search).get('keyword') };

  componentDidMount() {
    if (this.state.keyword !== "" ) {
      this.getTeacherSets()
    }
  }

  getTeacherSets() {
    axios.get('/teacher_sets', {
        params: {
          keyword: this.state.keyword
        }
     }).then(res => {
        this.setState({ teacher_sets: res.data.teacher_sets,  facets: res.data.facets,
                        ts_total_count: res.data.total_count });
        if (res.data.total_count > 20) {
          this.state.pagination = 'block';
        } else {
          this.state.pagination = 'none';
        }
      })
      .catch(function (error) {
       console.log(error)
    })
  }

  handleSubmit = event => {
    event.preventDefault();
    if (this.state.keyword !== null) {
      this.props.history.push("/teacher_set_data"+ "?keyword=" + this.state.keyword)
    } else {
      this.props.history.push("/teacher_set_data")
    }
    this.getTeacherSets()
  }

  handleSearchKeyword = event => {
    this.setState({ 
      keyword: event.target.value
    })
  }

  onPageChange = (page) => {
    this.state.setComputedCurrentPage = page;
    axios.get('/teacher_sets', {
        params: {
          keyword: this.state.keyword,
          page: page
        }
     }).then(res => {
        this.setState({ teacher_sets: res.data.teacher_sets,  ts_total_count: res.data.total_count });
      })
      .catch(function (error) {
       console.log(error)
    })
  };

  TeacherSetDetails() {
    return this.state.teacher_sets.map((ts, i) => {
      return <div className="teacherSetResults">
        <div style={{ display: "grid", "grid-gap": "2rem", "grid-template-columns": "repeat(1, 1fr)" }}>

          <Card className="" layout={CardLayouts.Horizontal} center imageSrc={bookImage} imageAlt="Alt text">
            <CardHeading level={3} id="heading1">
              <ReactRouterLink to={"/teacher_set_details/" + ts.id} className="removelink">
                {ts.title}
              </ReactRouterLink>
            </CardHeading>
            
            <CardContent> {ts.suitabilities_string} </CardContent>
            <CardContent> {ts.availability} </CardContent>
            <CardContent> {ts.description} </CardContent>
          </Card>
          <HorizontalRule align="left" height="3px" />
        </div>
        </div>
    })
  }

  TeacherSetFacets() {
    return this.state.facets.map((ts, i) => {
      return <div>{<br/>}

      <div> { ts.label } </div>
        { ts.items.map((item, index) =>
          <div> <Checkbox id="test_id" labelText={item["label"]} showLabel />  </div>
        )}
      </div>
    })
  }

  SignedUpMessage() {
    if (!this.state.userSignedIn) {
      return <Notification ariaLabel="SignOut Notification" id="sign-out-notification" className="signOutMessage" dismissible notificationType={NotificationTypes.Announcement} notificationContent={<>
      Signed out successfully.</>} />
    }
  }

  render() {
    return (
        <TemplateAppContainer
          breakout={<>{this.SignedUpMessage()}
                    <Hero heroType={HeroTypes.Campaign} 
                          heading={<Heading level={HeadingLevels.One} 
                          id="mln-campaign-hero" text="Welcome To MyLibrary NYC" />} 
                          subHeaderText="We provide participating schools with enhanced library privileges including fine-free student and educator library cards, school delivery and the exclusive use of 6,000+ Teacher Sets designed for educator use in the classroom; and student and educator access to the unparalleled digital resources of New York City's public library systems as well as instructional support and professional development opportunities." 
                          backgroundImageSrc={heroCampaignBg} 
                          image={<Image id="mln-hero-image" alt="Mln hero image" blockName="hero" src={heroCampaignLeft}/>} /></>}
          
          contentPrimary={
                <>
                  <HorizontalRule id="home-horizonta-1" align="left" height="3px" />
                  <Heading level={HeadingLevels.Three}>Search For Teacher Sets</Heading>
                  <SearchBar id="home-page-teacher-set-search" labelText="home-page-teacher-set-search-label" onSubmit={this.handleSubmit} textInputProps={{ labelText: "Teacherset Search label", name: "teacherSetInputName", placeholder: "Enter teacher-set",  onChange: this.handleSearchKeyword}} />{<br/>}
                  <HorizontalRule id="home-horizontal-2" align="left" height="3px" />
                  <Heading id="professional-heading" level={HeadingLevels.Three}>Professional Development & Exclusive Programs</Heading>
                  <Text displaySize="default">
                    MyLibraryNYC educators can participate in workshops on a wide variety of subjects, aligned to New York State's 
                    Learning Standards to encourage reading and learning. From author talks to school programs, participating 
                    MyLibraryNYC schools can access a range of exciting programming.
                  </Text>
                  <CalendarOfEvents />
                  <HorizontalRule id="home-horizontal-3" align="left" height="3px" />
                  <AccessDigitalResources />
                </>
              }
          contentSidebar={<div className="have_questions_section"><HaveQuestions /></div>}
          sidebar="right"
          footer={<div><NewsLetter /></div>}
        />
    )
  }
}
