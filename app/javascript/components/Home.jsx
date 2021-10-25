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
  CardImageRatios,
  CardImageSizes,
  Pagination, Checkbox
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

    console.log(this.state.keyword + "kskkkkk")

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

          <Card className="" layout={CardLayouts.Horizontal} center imageSrc={bookImage} imageAlt="Alt text" imageAspectRatio={CardImageRatios.Square} imageSize={CardImageSizes.Small}>
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
      <>
      <div>
        <Hero
          backgroundImageSrc={heroCampaignBg}
          heading={<Heading blockName="hero" id="1" level={1} text="Welcome To MyLibrary NYC"/>}
          heroType="CAMPAIGN"
          style={styles.heroCampaign}
          image={<Image alt="Image example" blockName="hero" src={heroCampaignLeft}/>}
          subHeaderText="We provide participating schools with enhanced library privileges including fine-free student and educator library cards, school delivery and the exclusive use of 6,000+ Teacher Sets designed for educator use in the classroom; and student and educator access to the unparalleled digital resources of New York City’s public library systems as well as instructional support and professional development opportunities."/>
        
        <main className="main main--with-sidebar">
          <div className="content-top nypl-ds">
            <HorizontalRule align="left" height="3px" width="856px" />
            <div className="float-left">
              <div className="medium_font">Search For Teacher Sets</div>
              <div className="search_teacher_sets">
                <SearchBar onSubmit={this.handleSubmit} >
                  <Input
                    id="input"
                    value={this.state.keyword}
                    placeholder="Enter teacher-set"
                    required={true}
                    type={InputTypes.text}
                    onChange={this.handleSearchKeyword}
                  />
                  <Button
                    buttonType={ButtonTypes.Primary}
                    id="button"
                    type="submit"
                  >
                    Search
                  </Button>
                </SearchBar>
              </div>
            </div>
            <div className="have_questions_section"><HaveQuestions /></div>
          </div>

          <div className="content-primary content-primary--with-sidebar-right">
            <div className="nypl-ds">
              <HorizontalRule align="left" height="3px" width="856px" />
              <div className="medium_font">
                Professional Development & Exclusive Programs
              </div>
                
              <div className="plain_text">MyLibraryNYC educators can participate in workshops on a wide variety of subjects, aligned to New York State’s 
                Learning Standards to encourage reading and learning. From author talks to school programs, participating 
                MyLibraryNYC schools can access a range of exciting programming.
              </div>
     
              <CalendarOfEvents />

              <HorizontalRule align="left" height="3px" width="856px" />

              <AccessDigitalResources />
            </div>
          </div>

          <div className="content-secondary content-secondary--with-sidebar-right">
            
          </div>
        </main>
        <div className="nypl-ds">
          <NewsLetter />
        </div>
      </div>
      </>
    )
  }
}
