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
  Pagination, Checkbox, DSProvider, TemplateAppContainer, HeroTypes, VStack, HeadingLevels
} from '@nypl/design-system-react-components';

import bookImage from '../images/book.png'



const styles = {
  heroCampaign: {
    background: "#F5F5F5"
  }
}


export default class Home extends Component {

  constructor(props) {
    super(props);
    this.state = { teacher_sets: [], facets: [], ts_total_count: "", error_msg: {}, email: "", 
                   display_block: "block", display_none: "none", setComputedCurrentPage: 1, 
                   computedCurrentPage: 1, pagination: "", keyword: new URLSearchParams(this.props.location.search).get('keyword') };
  }


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

        console.log(this.state.facets);


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

    console.log(event.target.value + " kskkkkk")

    if (this.state.keyword !== null) {
      this.props.history.push("/teacher_set_data"+ "?keyword=" + this.state.keyword)
    } else {
      this.props.history.push("/teacher_set_data")
    }
    this.getTeacherSets()
  }


  
  handleSearchKeyword = event => {

    //console.log(event + "  ololololo")
    // this.setState({ 
    //   keyword: event.target.value
    // })
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
          <HorizontalRule align="left" height="3px" width="856px" />
        </div>
        </div>
    })
  }


  TeacherSetFacets() {
    return this.state.facets.map((ts, i) => {
      return <div className="nypl-ds">{<br/>}

      <div> { ts.label } </div>
        { ts.items.map((item, index) =>
          <div> <Checkbox id="test_id" labelText={item["label"]} showLabel />  </div>
        )}
      </div>
    })
  }
  render() {
    return (
      <DSProvider>
        <TemplateAppContainer
          breakout={
                    <Hero heroType={HeroTypes.Campaign} 
                          heading={<Heading level={HeadingLevels.One} 
                          id="campaign-hero" text="Welcome To MyLibrary NYC" />} 
                          subHeaderText="We provide participating schools with enhanced library privileges including fine-free student and educator library cards, school delivery and the exclusive use of 6,000+ Teacher Sets designed for educator use in the classroom; and student and educator access to the unparalleled digital resources of New York City's public library systems as well as instructional support and professional development opportunities." 
                          backgroundImageSrc={heroCampaignBg} 
                          image={<Image alt="Image example" blockName="hero" src={heroCampaignLeft}/>} />}
          
          contentPrimary={
                <div>
                  <HorizontalRule align="left" height="3px" width="856px" />
                  <div className="medium_font">Search For Teacher Sets</div>
                  <SearchBar onSubmit={this.handleSubmit} textInputProps={{ labelText: "Item Search", placeholder: "Enter teacher-set",  onChange: this.handleSearchKeyword()}} />{<br/>}
                  <HorizontalRule align="left" height="3px" width="856px" />
                  <div className="medium_font"> Professional Development & Exclusive Programs</div>
                  <div className="plain_text">MyLibraryNYC educators can participate in workshops on a wide variety of subjects, aligned to New York State's 
                    Learning Standards to encourage reading and learning. From author talks to school programs, participating 
                    MyLibraryNYC schools can access a range of exciting programming.
                  </div>
                  <CalendarOfEvents />
                  <HorizontalRule align="left" height="3px" width="856px" />
                  <AccessDigitalResources />
                </div>
              }
          contentSidebar={<div className="have_questions_section"><HaveQuestions /></div>}
          sidebar="right"
          footer={<div><NewsLetter /></div>}
          
        />
      </DSProvider>
    )
  }
}
