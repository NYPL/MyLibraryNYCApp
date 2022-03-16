import React, { Component, useState } from 'react';

import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Input, TextInput, List, DSProvider, TemplateAppContainer, Text
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
          return <a href={"#" + anchor}> {anchor} </a>
        } else {
          if (anchor != '#') {
            return anchor
          }
        }
    })
  }

  Schools() {
    this.state.school_not_found = ""
    this.state.isInvalid = false;

    return this.state.schools.map((data, i) => {
      let filteredSchools = data['school_names'].filter (
        (school) => {
          let value = this.state.search_school.trim().toLowerCase();
          return school.toLowerCase().indexOf(value) > -1
        }
      );

      if(filteredSchools.length > 0) {
        return <List id="participating-schools-list" noStyling>
          <li id={"ps-list-" + i} key={i} className="schoolList alphabet_anchor">
            <a id={"ps-alphabet-anchor-" + i}className="alphabet_anchor_padding" name={data['alphabet_anchor']}>{data['alphabet_anchor']}</a>
          </li>
          {filteredSchools.map((school, index) =>
            <li id={"ps-alphabet-anchor-" + index} key={index}>{school}<br/></li>
          )}
        </List>
      }
    })
  }
 
  handleChange = event => {
    this.setState({search_school: event.target.value});
  }

  render() {
    return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <>
            <Text displaySize="default" id="your-school-participate-in-mln-text" isBold>Does your school participate in MyLibraryNYC?</Text>
            <Text displaySize="default" id="find-school-name-text" className="schoolList">Find your school using the following links:</Text>
            {this.AnchorTags()}
            <Text displaySize="default" id="enter-school-name-text">or type the name of your school in the box below</Text>{<br/>}
              <TextInput
                attributes={{
                  'aria-describedby': 'Choose wisely.',
                  'aria-label': 'Enter school name',
                  pattern: '[a-z0-9]',
                  tabIndex: 0
                }}
                onChange={this.handleChange}
                id="participating-school"
                labelText="Enter school name"
                placeholder="Enter school name"
                invalidText={this.state.school_not_found}
                isInvalid={this.state.isInvalid}
                showLabel={false}
              />
            {this.Schools()}
          </>
          }
          contentSidebar={<></>}
          sidebar="right" 
        />
    )
  }
}
