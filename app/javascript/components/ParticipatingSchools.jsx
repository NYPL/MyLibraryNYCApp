import React, { Component, useState } from 'react';

import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Input, TextInput, List, DSProvider, TemplateAppContainer
} from '@nypl/design-system-react-components';



export default class ParticipatingSchools extends Component {

  constructor(props) {
    super(props);
    this.state = { schools: [], search_school: "", anchor_tags: []};
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
    return this.state.schools.map((data, i) => {
      let filteredSchools = data['school_names'].filter (
        (school) => {
          let value = this.state.search_school.trim().toLowerCase();
          return school.toLowerCase().indexOf(value) > -1
        }
      );

      if(filteredSchools.length > 0) {
        return <List noStyling>
          <li key={i} className="schoolList alphabet_anchor">
            <a className="alphabet_anchor_padding" name={data['alphabet_anchor']}>{data['alphabet_anchor']}</a>
          </li>
          {filteredSchools.map((school, index) =>
            <li key={index}>{school}<br/></li>
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
      <>
        <DSProvider>
          <TemplateAppContainer
            breakout={<AppBreadcrumbs />}
            contentPrimary={
              <div className="navbarPages">
              <div className="bold">Does your school participate in MyLibraryNYC?</div>
              <div className="schoolList">Find your school using the following links:</div>
              {this.AnchorTags()}
              <div className="  ">or type the name of your school in the box below</div>{<br/>}
                <TextInput
                  attributes={{
                    'aria-describedby': 'Choose wisely.',
                    'aria-label': 'Enter school name',
                    maxLength: 10,
                    pattern: '[a-z0-9]',
                    tabIndex: 0
                  }}
                  onChange={this.handleChange}
                  id="search_participating_school"
                  labelText="Enter school name"
                  placeholder="Enter school name"
                  type="text"
                  showLabel={false}
                />
              {this.Schools()}
            </div>
            }
            contentSidebar={<></>}
            sidebar="right" 
          />
        </DSProvider>
      </>
    )
  }
}