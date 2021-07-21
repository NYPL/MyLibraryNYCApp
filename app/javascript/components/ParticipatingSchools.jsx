import React, { Component, useState } from 'react';

import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Input, TextInput, List
} from '@nypl/design-system-react-components';



export default class ParticipatingSchools extends Component {

  constructor(props) {
    super(props);
    this.state = { schools: [], search_school: "" };
    this.handleChange = this.handleChange.bind(this);
  }

  componentDidMount() {
    axios.get('/schools')
      .then(res => {
        this.setState({ schools: res.data.schools });
      })
      .catch(function (error) {
          console.log(error);
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
        return <List type="ul">
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
      <main className="main">
        <AppBreadcrumbs />
        <div className="content-primary">
          <div className="participating_schools_list">
            <div className="school_header schoolList bold">Does your school participate in MyLibraryNYC?</div>
            <div className="schoolList">Find your school using the following links:</div>
            <div >
              <a href="##">#</a> <a href="#A">A</a> <a href="#B">B</a> <a href="#C">C</a> <a href="#D">D</a> <a href="#E">E</a> <a href="#F">F</a> <a href="#G">G</a> <a href="#H">H</a> <a href="#I">I</a> <a href="#J">J</a> <a href="#K">K</a> <a href="#L">L</a> <a href="#M">M</a> <a href="#N">N</a> <a href="#O">O</a> <a href="#P">P</a> <a href="#Q">Q</a> <a href="#R">R</a> <a href="#S">S</a> <a href="#T">T</a> <a href="#U">U</a> <a href="#V">V</a> <a href="#W">W</a> <a href="#X">X</a> <a href="#Y">Y</a> <a href="#Z">Z</a>
            </div>
            <div className="schoolList">or type the name of your school in the box below</div>
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
                className="school_inbox"
              />
            {this.Schools()}
          </div>
        </div>
      </main>
    )
  }
}
