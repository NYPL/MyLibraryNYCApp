import React, { Component, useState } from 'react';
import HaveQuestions from "./HaveQuestions";
import AppBreadcrumbs from "./AppBreadcrumbs";
import SignedInMsg from "./SignedInMsg";
import axios from 'axios';
import {
  Input, TextInput, List, DSProvider, TemplateAppContainer, Text, Heading, HorizontalRule, Link
} from '@nypl/design-system-react-components';



export default class ParticipatingSchools extends Component {

  constructor(props) {
    super(props);
    this.state = { schools: [], search_school: "", anchor_tags: [], school_not_found: "", isInvalid: false};
    this.handleChange = this.handleChange.bind(this);

  }

  componentDidMount() {
    axios.get('/schools')
      .then(res => {
        this.setState({ schools: res.data.schools, anchor_tags: res.data.anchor_tags });
      })
      .catch(function (error) {
        console.log(error);
    })
  }

  AnchorTags() {
    let school_anchors = this.state.schools.map((school, i) => { return school['alphabet_anchor']})
    return this.state.anchor_tags.map((anchor, i) => {
        if (school_anchors.includes(anchor)) {
          return <Link marginRight="xs" style={{"text-decoration": "none"}} fontWeight="bold" href={"#" + anchor}> {anchor} </Link>
        } else {
          if (anchor != '#') {
            return <a style={{"text-decoration": "none", "font-weight": "bold", "color": "var(--nypl-colors-ui-gray-medium)", "margin-right": "8px"}}>{anchor}</a>
          }
        }
    })
  }

  Schools() {
    this.state.school_not_found = ""
    this.state.isInvalid = false;
    let schoolsCount = 0;

     let schoolsData = this.state.schools.map((data, i) => {
      let filteredSchools = data['school_names'].filter (
        (school) => {
          let value = this.state.search_school.trim().toLowerCase();
          if (school.toLowerCase().indexOf(value) > -1) {
            schoolsCount++;
            return (school.toLowerCase().indexOf(value) > -1) 
          } 
        }
      );

      if(filteredSchools.length > 0) {
        return <List id={"participating-schools-list-" + data['alphabet_anchor']} noStyling>
          <li id={"ps-name-" + data['alphabet_anchor']} key={i} className="schoolList alphabet_anchor">
            <a id={"ps-name-link-" + data['alphabet_anchor']} className="alphabet_anchor" name={data['alphabet_anchor']}>
              <Heading level="three" size="tertiary">{data['alphabet_anchor']}</Heading>
            </a>
          </li>
          {filteredSchools.map((school, index) =>
            <li fontWeight="heading.callout" id={"ps-name-" + data['alphabet_anchor'] + '-' + index} key={index}>{school}<br/></li>
          )}
        </List>
      } 
    })
    if (schoolsCount === 0) {
      return <Text marginTop="m" isItalic size="default" color="var(--nypl-colors-ui-error-primary)">There are no results that match your search criteria.</Text>
    } else {
      return schoolsData
    }
  }
 
  handleChange = event => {
    this.setState({search_school: event.target.value});
  }

  render() {
    return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentTop={<SignedInMsg signInDetails={this.props} />}
          contentPrimary={
            <>
            <Heading id="find-your-school" level="two" size="secondary" text="Find Your School" />
            <HorizontalRule id="ts-detail-page-horizontal-rulel" className="teacherSetHorizontal" />
            <Heading marginTop="l" id="your-school-participate-in-mln" level="three" size="tertiary" text="Does your school participate in MyLibraryNYC?" />
            
            <TextInput
              fontWeight="text.tag"
              helperText="Start typing the name of your school."
              attributes={{
                'aria-describedby': 'Choose wisely.',
                'aria-label': 'Enter school name',
                pattern: '[a-z0-9]',
                tabIndex: 0
              }}
              onChange={this.handleChange}
              id="participating-school"
              labelText="Search by Name"
              placeholder="School name"
              invalidText={this.state.school_not_found}
              isInvalid={this.state.isInvalid}
              showLabel
            />
            <Text marginTop="l" size="default" fontWeight="medium"> Filter by Name</Text>
            {this.AnchorTags()}
           <div id="participating-schools-list">{this.Schools()}</div>
          </>
          }
          contentSidebar={<HaveQuestions />}
          sidebar="right" 
        />
    )
  }
}
