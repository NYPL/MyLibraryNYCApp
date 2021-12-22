import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Button, ButtonTypes, SearchBar, Select, TextInput, TextInputTypes, HelperErrorText, DSProvider, 
  TemplateAppContainer, HeadingLevels, Text, FormField, Form
} from '@nypl/design-system-react-components';


export default class SignUp extends Component {

  constructor(props) {
    super(props);
    this.state = { email: "", alt_email: "", first_name: "", last_name: "", school_id: "",  pin: "", active_schools: ""}
  }


  handleSubmit = event => {
    event.preventDefault();
    console.log(event.target.value + "eveveveve")
    axios.post('/users', {
        user: { email: this.state.email, alt_email: this.state.alt_email, first_name: this.state.first_name,
                last_name: this.state.last_name, pin: this.state.pin, school_id: '1234' }
     }).then(res => {
        console.log(res)
      })
      .catch(function (error) {
       console.log(error)
    })
  }

  componentDidMount() {
    axios.get('/active_schools').then(res => {
      this.setState({ active_schools: res.data.activeSchools})
    }).catch(function (error) {
       console.log(error)
    })
  }

  handleEmail = event => {
    console.log(event.target.value + ' email')
    this.setState ({ email: event.target.value})
  }

  handleAltEmail = event => {
    console.log(event.target.value + 'alt email')
    this.setState ({ alt_email: event.target.value})
  }

  handleFirstName = event => {
    console.log(event.target.value + 'first_name')
    this.setState ({ first_name: event.target.value})
  }

  handleLastName = event => {
    console.log(event.target.value + 'last_name')
    this.setState ({ last_name: event.target.value})
  }

  handleSchool = event => {
    console.log(event.target.value + 'school_id')
    this.setState ({ school_id: event.target.value})
  }

  handlePin = event => {
    console.log(event.target.value + 'pin')
    this.setState ({ pin: event.target.value})
  }


  Schools() {
    return Object.entries(this.state.active_schools).map((school, i) => {
      return (
        <option key={school[1]} value={school[1]}>{school[0]}</option>
      )
    }, this);
  }


  render() {
    return (
      <DSProvider>
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <>
              <Form>
                <FormField>
                  <TextInput
                    isRequired
                    showOptReqLabel={true}
                    labelText="Your DOE Email Address"
                    value={this.state.email}
                    onChange={this.handleEmail}
                    helperText="Email address must end with @schools.nyc.gov or a participating school domain."
                  />
                </FormField>

                <FormField>
                  <TextInput
                    isRequired
                    showOptReqLabel={true}
                    labelText="Your DOE Email Address"
                    value={this.state.alt_email}
                    onChange={this.handleAltEmail}
                    helperText="Email address must end with @schools.nyc.gov or a participating school domain."
                  />
                </FormField>

                <FormField>
                  <TextInput showOptReqLabel={false}
                    labelText="First Name"
                    value={this.state.first_name}
                    onChange={this.handleFirstName}
                  />
                </FormField>

                <FormField>
                  <TextInput showOptReqLabel={false}
                    labelText="Last Name"
                    value={this.state.last_name}
                    onChange={this.handleLastName}
                  />
                </FormField>

                <FormField>
                  <Select id="school_id" labelText="Your School" value='1645' showLabel showOptReqLabel={false} onChange={this.handleSchool}>
                    {this.Schools()}
                  </Select>
                </FormField>

                <FormField>
                  <TextInput 
                    isRequired
                    showOptReqLabel={true}
                    labelText="Pin"
                    value={this.state.pin}
                    onChange={this.handlePin}
                    helperText="Your PIN serves as the password for your account. Make sure it is a number you will remember. Your PIN must be 4 digits. It cannot contain a digit that is repeated 3 or more times (0001, 5555) and cannot be a pair of repeated digits (1212, 6363)."
                  />
                </FormField>

                <Button onClick={this.handleSubmit} buttonType={ButtonTypes.Callout} className="accountButton"> Sign Up </Button>
              </Form>
            </>
          }
          contentSidebar={<></>}
          sidebar="right"
        />
      </DSProvider>
    )
  }
}