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
    this.state = { email: "", alt_email: "", first_name: "", last_name: "", school_id: "",  
                   pin: "", active_schools: "", errors: {}, fields: {}, firstNameIsValid: false,  
                   lastNameIsValid: false, pinIsValid: false, schoolIsValid: false}
  }


  componentDidMount() {
    axios.get('/sign_up_details').then(res => {
      this.setState( { active_schools: res.data.activeSchools, allowed_email_patterns: res.data.emailMasks } )
    }).catch(function (error) {
       console.log(error)
    })
  }

  handleSubmit = event => {
    event.preventDefault();
    if (this.handleValidation()) {

    } else {
      axios.post('/users', {
          user: { email: this.state.email, alt_email: this.state.alt_email, first_name: this.state.first_name,
                  last_name: this.state.last_name, pin: this.state.pin, school_id: '', allowed_email_patterns: '', error_email_msg: '', is_valid_email: '' }
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
    let email_domain_is_allowed = this.state.allowed_email_patterns.includes('@' + domain[1])
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

    if (!fields["first_name"]) {
      this.setState({firstNameIsValid: true })
      this.state.errors['first_name'] = "Can't be empty";
    }

    if (fields["first_name"] && typeof fields["first_name"] == "string") {
      if (!fields["first_name"].match(/^[a-zA-Z]+$/)) {
        this.setState({firstNameIsValid: true })
        this.state.errors['first_name'] = "First name is in-valid";
      }
    }

    if (!fields["last_name"]) {
      this.setState({lastNameIsValid: true })
      this.state.errors['last_name'] = "Can't be empty";
    }

    if (fields["last_name"] && typeof fields["last_name"] == "string") {
      if (!fields["last_name"].match(/^[a-zA-Z]+$/)) {
        this.setState({lastNameIsValid: true })
        this.state.errors['last_name'] = "Last name is in-valid";
      }
    }

    if (!fields["pin"]) {
      this.setState({pinIsValid: true })
      this.state.errors['pin'] = "Can't be empty";
    }

    if (fields["pin"] && typeof fields["pin"] == "string") {
      if (!fields["pin"].match(/^[a-zA-Z]+$/)) {
        this.setState({pinIsValid: true })
        this.state.errors['pin'] = "PIN is in-valid";
      }
    }

    if (!fields["school_id"]) {
      this.setState({schoolIsValid: true })
      this.state.errors['school_id'] = "Please select school"
    }
  }

  handleEmail = event => {
    this.setState ({ email: event.target.value })
    this.validateEmailDomain(event.target.value)
  }

  handleAltEmail = event => {
    this.setState ({ alt_email: event.target.value })
  }

  handleFirstName(field, e) {
    this.setState({ firstNameIsValid: false, first_name: e.target.value})

    let fields = this.state.fields;
     fields[field] = e.target.value
    this.setState({ fields });

    if (!this.state.fields["first_name"]) {
      this.setState({firstNameIsValid: true })
      this.state.errors['first_name'] = "Can't be empty"
    }

    if (this.state.fields["first_name"] && typeof this.state.fields["first_name"] == "string") {
      if (!fields["first_name"].match(/^[a-zA-Z]+$/)) {
        this.setState({firstNameIsValid: true })
        this.state.errors['first_name'] = "First name is in-valid";
      }
    }
  }

  handleLastName(field, e) {
    this.setState({ lastNameIsValid: false, last_name: e.target.value})
    let fields = this.state.fields;
     fields[field] = e.target.value
    this.setState({ fields });

    if (!this.state.fields["last_name"]) {
      this.setState({lastNameIsValid: true })
      this.state.errors['last_name'] = "Can't be empty"
    }

    if (this.state.fields["last_name"] && typeof this.state.fields["last_name"] == "string") {
      if (!fields["last_name"].match(/^[a-zA-Z]+$/)) {
        this.setState({lastNameIsValid: true })
        this.state.errors['last_name'] = "Last name is in-valid";
      }
    }
  }

  handlePin(field, e) {
    this.setState({ pinIsValid: false, pin: e.target.value})

    let fields = this.state.fields;
     fields[field] = e.target.value
    this.setState({ fields });

    if (!this.state.fields["pin"]) {
      this.setState({pinIsValid: true })
      this.state.errors['pin'] = "Can't be empty"
    }

    if (this.state.fields["pin"] && !(/^[0-9\b]+$/).test(fields["pin"])) {
      this.setState({pinIsValid: true })
      this.state.errors['pin'] = "PIN is in-valid. It may only contain numbers";
    } else if (this.state.fields["pin"] && typeof this.state.fields["pin"] == "string") {
      if (fields["pin"].length < 4  || fields["pin"].length > 32) {
        this.setState({pinIsValid: true })
        this.state.errors['pin'] = "Pin must be 4 to 32 characters";
      }
    }
  }

  handleSchool(field, e) {
    this.setState({ schoolIsValid: false, school_id: e.target.value })
    let fields = this.state.fields;
     fields[field] = e.target.value
    this.setState({ fields });

    if (!this.state.fields["school_id"]) {
      this.setState({schoolIsValid: true })
      this.state.errors['school_id'] = "Please select school"
    }
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

    let first_name_invalid = this.state.firstNameIsValid
    let last_name_invalid = this.state.lastNameIsValid
    let pin_is_invalid = this.state.pinIsValid
    let school_is_invalid = this.state.schoolIsValid

    let last_name_error_msg = this.state.errors["last_name"]
    let first_name_error_msg = this.state.errors["first_name"]
    let pin_error_msg = this.state.errors["pin"]
    let school_error_msg = this.state.errors["school_id"]

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
                    invalidText={first_name_error_msg}
                    isInvalid={first_name_invalid}
                    onChange={this.handleFirstName.bind(this, "first_name")}
                  />
                </FormField>

                <FormField>
                  <TextInput showOptReqLabel={false}
                    labelText="Last Name"
                    value={this.state.fields["last_name"]}
                    invalidText={last_name_error_msg}
                    isInvalid={last_name_invalid}
                    onChange={this.handleLastName.bind(this, 'last_name')}
                  />
                </FormField>

                <FormField>
                  <Select id="school_id" 
                    labelText="Your School" 
                    value='' 
                    showLabel 
                    showOptReqLabel={false}
                    invalidText={school_error_msg}
                    isInvalid={school_is_invalid}
                    onChange={this.handleSchool.bind(this, 'school_id')}>
                    {this.Schools()}
                  </Select>
                </FormField>

                <FormField>
                  <TextInput 
                    isRequired
                    showOptReqLabel={true}
                    labelText="Pin"
                    value={this.state.fields["pin"]}
                    invalidText={pin_error_msg}
                    isInvalid={pin_is_invalid}
                    onChange={this.handlePin.bind(this, 'pin')}
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
