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
    this.state = { email: "", alt_email: "", first_name: "", last_name: "", school_id: "",  pin: "", active_schools: "", errors: {}, fields: {}, firstNameIsValid: false,  lastNameIsValid: false, pinIsValid: false}
  }


  handleSubmit = event => {
    event.preventDefault();
    if (this.handleValidation()) {

    } else {
      console.log(event.target.value + "eveveveve")
      axios.post('/users', {
          user: { email: this.state.email, alt_email: this.state.alt_email, first_name: this.state.first_name,
                  last_name: this.state.last_name, pin: this.state.pin, school_id: '966', allowed_email_patterns: '', error_email_msg: '', is_valid_email: '' }
       }).then(res => {
          // if (res.data.errors) !== null {
          //   console.log(res.data.errors + ' no errors')
          // } else {
          //   console.log(res.data.errors["email"] + " ppppppp")
          // }

        })
        .catch(function (error) {
         console.log(error)
      })
    }
    
  }

  validateEmailDomain(email) {
    let domain = email.split('@')
    console.log(domain + " ddddd")
    let email_domain_is_allowed = this.state.allowed_email_patterns.includes('@' + domain[1])
    console.log(email_domain_is_allowed + "  valid ddddd")
    if (!email_domain_is_allowed) {
      this.state.error_email_msg = 'Enter a valid email address ending in "@schools.nyc.gov" or another participating school domain.'
      this.state.is_valid_email = true
    } else {
      this.state.error_email_msg = ""
      this.state.is_valid_email = false
    }
  }

  handleValidation() {

    let fields = this.state.fields;
    let errors = {};
    let formIsValid = true;

    if (!fields["first_name"]) {
      this.setState({firstNameIsValid: true })
      errors["first_name"] = "Can't be empty";
      this.setState({ errors: errors });
    }


    if (fields["first_name"] && typeof fields["first_name"] == "string") {
      if (!fields["first_name"].match(/^[a-zA-Z]+$/)) {
        this.setState({firstNameIsValid: true })
        errors["first_name"] = "First name is in-valid";
        this.setState({ errors: errors });
      }
    }


    if (!fields["last_name"]) {
      this.setState({lastNameIsValid: true })
      errors["last_name"] = "Can't be empty";
      this.setState({ errors: errors });
    }


    if (fields["last_name"] && typeof fields["last_name"] == "string") {
      if (!fields["last_name"].match(/^[a-zA-Z]+$/)) {
        this.setState({lastNameIsValid: true })
        errors["last_name"] = "Last name is in-valid";
        this.setState({ errors: errors });
      }
    }


    return formIsValid;
  }

  handleEmail = event => {
    this.setState ({ email: event.target.value })
    this.validateEmailDomain(event.target.value)
  }

  handleAltEmail = event => {
    this.setState ({ alt_email: event.target.value })
  }

  handleFirstName(field, e) {
    this.setState({ firstNameIsValid: false})
    let fields = this.state.fields;
     fields[field] = e.target.value
    this.setState({ fields });
    let errors = {}

    if (!this.state.fields["first_name"]) {
      this.setState({firstNameIsValid: true })
      errors['first_name'] = "Can't be empty"
      this.setState({ errors: errors });
    }

    if (this.state.fields["first_name"] && typeof this.state.fields["first_name"] == "string") {
      if (!fields["first_name"].match(/^[a-zA-Z]+$/)) {
        this.setState({firstNameIsValid: true })
        errors["first_name"] = "First name is in-valid";
        this.setState({ errors: errors });
      }
    }
  }

  handleLastName(field, e) {
    this.setState({ lastNameIsValid: false})
    let fields = this.state.fields;
     fields[field] = e.target.value
    this.setState({ fields });
    let errors = {}

    if (!this.state.fields["last_name"]) {
      this.setState({lastNameIsValid: true })
      errors['last_name'] = "Can't be empty"
      this.setState({ errors: errors });
    }

    if (this.state.fields["last_name"] && typeof this.state.fields["last_name"] == "string") {
      if (!fields["last_name"].match(/^[a-zA-Z]+$/)) {
        this.setState({lastNameIsValid: true })
        errors["last_name"] = "Last name is in-valid";
        this.setState({ errors: errors });
      }
    }
  }

  handlePin(field, e) {
    this.setState({ pinIsValid: false})
    let fields = this.state.fields;
     fields[field] = e.target.value
    this.setState({ fields });
    let errors = {}

    if (!this.state.fields["pin"]) {
      this.setState({pinIsValid: true })
      errors['pin'] = "Can't be empty"
      this.setState({ errors: errors });
    }

    if (this.state.fields["pin"] && typeof this.state.fields["pin"] == "string") {
      if (!fields["pin"].match(/^[a-zA-Z]+$/)) {
        this.setState({pinIsValid: true })
        errors["pin"] = "Pin is in-valid";
        this.setState({ errors: errors });
      }
    }
  }

  handleSchool = event => {
    this.setState ({ school_id: event.target.value })
  }

  handlePin = event => {
    this.setState ({ pin: event.target.value })
  }


  Schools() {
    return Object.entries(this.state.active_schools).map((school, i) => {
      return (
        <option key={school[1]} value={school[1]}>{school[0]}</option>
      )
    }, this);
  }


  handleChange(field, e) {
    this.setState({ firstNameIsValid: false })
    

    let fields = this.state.fields;
    fields[field] = e.target.value;

    this.setState({ fields });
    this.handleValidation()
  }


  render() {
    let error_email_msg = this.state.error_email_msg
    let is_valid_email = this.state.is_valid_email

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
                    invalidText={error_email_msg}
                    isInvalid={is_valid_email}
                    helperText="Email address must end with @schools.nyc.gov or a participating school domain."
                  />
                </FormField>

                <FormField>
                  <TextInput
                    showOptReqLabel={true}
                    labelText="Alternate email address"
                    value={this.state.alt_email}
                    onChange={this.handleAltEmail}
                  />

                </FormField>

                <FormField>
                  <TextInput showOptReqLabel={false}
                    labelText="First Name"
                    value={this.state.fields["first_name"]}
                    invalidText={this.state.errors["first_name"]}
                    isInvalid={this.state.firstNameIsValid}
                    onChange={this.handleFirstName.bind(this, "first_name")}
                  />
                </FormField>

                <FormField>
                  <TextInput showOptReqLabel={false}
                    labelText="Last Name"
                    value={this.state.fields["last_name"]}
                    invalidText={this.state.errors["last_name"]}
                    isInvalid={this.state.lastNameIsValid}
                    onChange={this.handleLastName.bind(this, "last_name")}
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
                    onChange={this.handleChange.bind(this, "pin")}
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
