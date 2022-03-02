import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Button, ButtonTypes, SearchBar, Select, TextInput, TextInputTypes, HelperErrorText, DSProvider, 
  TemplateAppContainer, HeadingLevels, Text, FormField, Form, Notification, NotificationTypes, Checkbox, CheckboxGroup
} from '@nypl/design-system-react-components';
import validator from 'validator'

export default class SignUp extends Component {

  constructor(props) {
    super(props);
    this.state = { email: "", alt_email: "", first_name: "", last_name: "", school_id: "",  
                   pin: "", active_schools: "", errors: {}, fields: {}, firstNameIsValid: false,  
                   lastNameIsValid: false, pinIsValid: false, schoolIsValid: false, emailIsInvalid: false,
                   altEmailIsvalid: false, messages: {}, news_letter_error: "", show_news_letter_error: false, isCheckedVal: false, signUpmsg: "", isDisabled: false}
    this.verifyNewsLetterEmailInSignUpPage = this.verifyNewsLetterEmailInSignUpPage.bind(this)
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
      axios.post('/registrations', {
          user: { email: this.state.fields["email"], alt_email: this.state.fields["alt_email"], first_name: this.state.fields["first_name"],
                  last_name: this.state.fields["last_name"], pin: this.state.fields["pin"], school_id: this.state.fields["school_id"], news_letter_email: this.state.fields["alt_email"] || this.state.fields["email"] }
       }).then(res => {
          if (res.data.status == "created") {
            this.setState({ signUpmsg: res.data.message })
            window.location = "http://" + process.env.MLN_INFO_SITE_HOSTNAME + "/teacher_set_data";
            return false;
          } else {
            if (res.data.message.alt_email.length > 0) {
              this.state.errors['alt_email'] = res.data.message.alt_email[0]
              this.setState({altEmailIsvalid: true, isDisabled: true })
            }
            if (res.data.message.email.length > 0) {
              this.state.errors["email"] = res.data.message.email[0]
              this.setState({emailIsInvalid: true, isDisabled: true })
            }
            if (res.data.message.first_name.length > 0) {
              this.state.errors["first_name"] = res.data.message.email[0]
              this.setState({firstNameIsValid: true, isDisabled: true })
            }
            if (res.data.message.last_name.length > 0) {
              this.state.errors["email"] = res.data.message.email[0]
              this.setState({lastNameIsValid: true, isDisabled: true })
            }
            if (res.data.message.pin.length > 0) {
              this.state.errors["school_id"] = res.data.message.email[0]
              this.setState({schoolIsValid: true, isDisabled: true })
            }
          }
        })
        .catch(function (error) {
         console.log(error)
      })
    } else {
      
    }
    
  }

  validateEmailDomain(email) {
    let domain = email.split('@')
    let email_domain_is_allowed = this.state.allowed_email_patterns.includes('@' + domain[1])

    if (!email_domain_is_allowed) {
      let msg = 'Enter a valid email address ending in "@schools.nyc.gov" or another participating school domain.'
      this.state.errors['email'] = msg
      this.setState({emailIsInvalid: true, isDisabled: true })
    }
    else {
      this.state.errors['email'] = ""
      this.setState({news_letter_error: "", show_news_letter_error: false, emailIsInvalid: false, isDisabled: false  })
    }

    axios.get('/check_email', { params: { email: email } }).then(res => {
      if (res.data.statusCode !== 404) {
        this.state.errors['email'] = "An account is already registered to this email address. Contact help@mylibrarynyc.org if you need assistance."
        this.setState({emailIsInvalid: true, isDisabled: true })
      }      
    }).catch(function (error) {
       console.log(error)
    })
  }

  validateAltEmailDomain(alt_email) {
    if (alt_email && !validator.isEmail(alt_email)) {
      let msg = 'Enter a valid alternate email'
      this.state.errors['alt_email'] = msg
      this.setState({altEmailIsvalid: true, isDisabled: true, isCheckedVal: false })
    } else {
      this.state.errors['alt_email'] = ""
      this.setState({ altEmailIsvalid: false, isDisabled: false, isCheckedVal: false, news_letter_error: "", show_news_letter_error: false })
    }
  }

  handleValidation() {
    let fields = this.state.fields;
    let formIsValid = true;

    if (!fields["email"]) {
      formIsValid = false;
      this.setState({emailIsInvalid: true, isDisabled: true })
      this.state.errors['email'] = "Email can't be empty";
    }

    if (!fields["first_name"]) {
      formIsValid = false;
      this.setState({firstNameIsValid: true, isDisabled: true })
      this.state.errors['first_name'] = "First name can't be empty";
    }

    if (fields["first_name"] && typeof fields["first_name"] == "string") {
      if (!fields["first_name"].match(/^[a-zA-Z]+$/)) {
        formIsValid = false;
        this.setState({firstNameIsValid: true, isDisabled: true })
        this.state.errors['first_name'] = "First name is in-valid";
      }
    }

    if (!fields["last_name"]) {
      this.setState({lastNameIsValid: true, isDisabled: true })
      formIsValid = false;
      this.state.errors['last_name'] = "Last name can't be empty";
    }

    if (fields["last_name"] && typeof fields["last_name"] == "string") {
      if (!fields["last_name"].match(/^[a-zA-Z]+$/)) {
        formIsValid = false;
        this.setState({lastNameIsValid: true, isDisabled: true })
        this.state.errors['last_name'] = "Last name is in-valid";
      }
    }

    if (!fields["pin"]) {
      formIsValid = false;
      this.setState({pinIsValid: true, isDisabled: true })
      this.state.errors['pin'] = "PIN can't be empty";
    }

    if (fields["pin"] && typeof fields["pin"] == "string") {
      if (!fields["pin"] && !(/^[0-9\b]+$/).test(fields["pin"])) {
        formIsValid = false;
        this.setState({pinIsValid: true, isDisabled: true })
        this.state.errors['pin'] = "PIN is in-valid";
      }
    }

    if (!fields["school_id"]) {
      this.setState({schoolIsValid: true, isDisabled: true })
      formIsValid = false;
      this.state.errors['school_id'] = "Please select school"
    }
    this.showNotifications()
    return formIsValid;
  }

  handleEmail(field, e) {
    this.setState({ emailIsInvalid: false, isDisabled: false })
    this.state.errors['email'] = ""

    let fields = this.state.fields;
    fields[field] = e.target.value
    this.setState({ fields });

    if (!this.state.fields["email"]) {
      this.setState({emailIsInvalid: true, isDisabled: true })
      this.state.errors['email'] = "Email can't be empty"
    }
    this.validateEmailDomain(e.target.value)
    this.showNotifications()
  }

  handleAltEmail(field, e) {
    this.setState ({ altEmailIsvalid: false })
    this.state.errors['alt_email'] = ""

    let fields = this.state.fields;
    fields[field] = e.target.value
    this.setState({ fields });
    this.validateAltEmailDomain(e.target.value)
    this.showNotifications()
  }


  handleFirstName(field, e) {
    this.setState({ firstNameIsValid: false, isDisabled: false})
    this.state.errors['first_name'] = ""

    let fields = this.state.fields;
     fields[field] = e.target.value
    this.setState({ fields });

    if (!this.state.fields["first_name"]) {
      this.setState({firstNameIsValid: true, isDisabled: true })
      this.state.errors['first_name'] = "First name can't be empty"
    }

    if (this.state.fields["first_name"] && typeof this.state.fields["first_name"] == "string") {
      if (!fields["first_name"].match(/^[a-zA-Z]+$/)) {
        this.setState({firstNameIsValid: true, isDisabled: true })
        this.state.errors['first_name'] = "First name is in-valid";
      }
    }
    this.showNotifications()
  }

  handleLastName(field, e) {
    this.setState({ lastNameIsValid: false, isDisabled: false})
    this.state.errors['last_name'] = ""

    let fields = this.state.fields;
     fields[field] = e.target.value
    this.setState({ fields });

    if (!this.state.fields["last_name"]) {
      this.setState({lastNameIsValid: true, isDisabled: true })
      this.state.errors['last_name'] = "Last name can't be empty"
    } 

    if (this.state.fields["last_name"] && typeof this.state.fields["last_name"] == "string") {
      if (!fields["last_name"].match(/^[a-zA-Z]+$/)) {
        this.setState({lastNameIsValid: true, isDisabled: true })
        this.state.errors['last_name'] = "Last name is in-valid";
      }
    }
    this.showNotifications()
  }

  handlePin(field, e) {
    this.setState({ pinIsValid: false, isDisabled: false})
    this.state.errors['pin'] = ""

    let fields = this.state.fields;
     fields[field] = e.target.value
    this.setState({ fields });

    if (!this.state.fields["pin"]) {
      this.setState({pinIsValid: true, isDisabled: true })
      this.state.errors['pin'] = "PIN can't be empty"
    }

    if (this.state.fields["pin"] && !(/^[0-9\b]+$/).test(fields["pin"])) {
      this.setState({pinIsValid: true, isDisabled: true })
      this.state.errors['pin'] = "PIN is in-valid. It may only contain numbers";
    } else if (this.state.fields["pin"] && typeof this.state.fields["pin"] == "string") {
      if (fields["pin"].length < 4  || fields["pin"].length > 32) {
        this.setState({pinIsValid: true, isDisabled: true })
        this.state.errors['pin'] = "Pin must be 4 to 32 characters";
      }
    }
    this.showNotifications()
  }

  handleSchool(field, e) {
    this.setState({ schoolIsValid: false, isDisabled: false })
    this.state.errors['school_id'] = ""

    let fields = this.state.fields;
     fields[field] = e.target.value
    this.setState({ fields });

    if (!this.state.fields["school_id"]) {
      this.setState({schoolIsValid: true, isDisabled: true })
      this.state.errors['school_id'] = "Please select school"
    }
    this.showNotifications()
  }


  Schools() {
    let schools = Object.entries(Object.assign({"-- Select A School -- ": ""}, this.state.active_schools))
    return schools.map((school, i) => {
      return (
        <option key={school[1]} value={school[1]}>{school[0]}</option>
      )
    }, this);
  }


  handleChange(field, e) {
    this.setState({ firstNameIsValid: false})
    let fields = this.state.fields;
    fields[field] = e.target.value;
    this.setState({ fields });
    this.handleValidation()
  }

  showNotifications() {
    if (Object.entries(this.state.errors).length > 0) {
      return 'display_block signUpMessage'
    } else {
      return 'display_none signUpMessage'
    }
  }


  showErrors() {
    return this.state.errors["email"] || this.state.errors["alt_email"] || this.state.errors["first_name"] || this.state.errors["last_name"] || this.state.errors["pin"] ? 'block' : 'none'
  }

  showEmailError() {
    return this.state.errors["email"]? 'block' : 'none'
  }

  showAltEmailError() {
    return this.state.errors["alt_email"]? 'block' : 'none'
  }

  showFirstNamerror() {
    return this.state.errors["first_name"]? 'block' : 'none'
  }

  showLastNamerror() {
    return this.state.errors["last_name"]? 'block' : 'none'
  }

  showPinError() {
    return this.state.errors["pin"]? 'block' : 'none'
  }

  showSchoolError() {
    return this.state.errors["school_id"]? 'block' : 'none'
  }

  verifyNewsLetterEmailInSignUpPage(event) {
    const initial_check = this.state.isCheckedVal;
    this.setState({isCheckedVal: !initial_check})
    
    // If alternate email is present in sign-up page take alternate-email to send news-letters other-wise DOE email.
    const  news_letter_email = this.state.fields["alt_email"] || this.state.fields["email"]

    if (event.target.value == 1 && news_letter_email == undefined) {
      this.setState({news_letter_error: "Please enter a valid email address", show_news_letter_error: true, isDisabled: true, isCheckedVal: false })
    } else {
      this.setState({news_letter_error: "", show_news_letter_error: false, isDisabled: false })
    }

    if (news_letter_email !== undefined) {
      axios.post('/news_letter/validate_news_letter_email_from_user_sign_up_page',  { email: news_letter_email }).then(res => {
        if (event.target.value == 1 && res.data["error"] !== undefined) {
          this.setState({news_letter_error: res.data["error"], show_news_letter_error: true, isCheckedVal: false })
        } else if (event.target.value == 1 && res.data["success"] !== undefined) {
          this.setState({news_letter_error: "", show_news_letter_error: false, isDisabled: false, isCheckedVal: !initial_check })
        }
      })
        .catch(function (error) {
         console.log(error)
      })
    }
  }

  render() {
    let error_email_msg = this.state.errors["email"]
    let email_is_invalid = this.state.emailIsInvalid
    let first_name_invalid = this.state.firstNameIsValid
    let last_name_invalid = this.state.lastNameIsValid
    let pin_is_invalid = this.state.pinIsValid
    let school_is_invalid = this.state.schoolIsValid
    let alt_email_is_invalid = this.state.altEmailIsvalid
    let last_name_error_msg = this.state.errors["last_name"]
    let first_name_error_msg = this.state.errors["first_name"]
    let pin_error_msg = this.state.errors["pin"]
    let school_error_msg = this.state.errors["school_id"]
    let alt_email_error_msg = this.state.errors["alt_email"]

    let error_msgs = this.state.errors
    let email = error_msgs["email"] ? 'display' : 'none'
  

    return (
        <TemplateAppContainer
          breakout={<><AppBreadcrumbs />
            <div style={{ display: this.showErrors() }}>
                <Notification className={this.showNotifications()} notificationType={NotificationTypes.Warning}
                  notificationContent={
                    <Text noSpace className="signUpMessage">
                      <div style={{ display: this.showEmailError() }}> {error_msgs["email"]} {<br/>} </div>
                      <div style={{ display: this.showAltEmailError() }}> {error_msgs["alt_email"]} {<br/>} </div>
                      <div style={{ display: this.showFirstNamerror() }}> {error_msgs["first_name"]} {<br/>} </div>
                      <div style={{ display: this.showLastNamerror() }}> {error_msgs["last_name"]} {<br/>} </div>
                      <div style={{ display: this.showPinError() }}> {error_msgs["pin"]} {<br/>} </div>
                      <div style={{ display: this.showSchoolError() }}> {error_msgs["school_id"]} {<br/>} </div>
                    </Text>
                  } 
                />
              </div>
            </>}
          contentPrimary={
            <>
              <Form>
                <FormField>
                  <TextInput
                    isRequired
                    showOptReqLabel={true}
                    labelText="Your DOE Email Address"
                    value={this.state.fields["email"]}
                    onChange={this.handleEmail.bind(this, "email")}
                    invalidText={error_email_msg}
                    isInvalid={email_is_invalid}
                    helperText="Email address must end with @schools.nyc.gov or a participating school domain."
                  />
                </FormField>

                <FormField>
                  <TextInput
                    showOptReqLabel={true}
                    labelText="Alternate email address"
                    value={this.state.fields['alt_email']}
                    invalidText={alt_email_error_msg}
                    isInvalid={alt_email_is_invalid}
                    onChange={this.handleAltEmail.bind(this, 'alt_email')}
                  />

                </FormField>

                <FormField>
                  <TextInput showOptReqLabel={false}
                    isRequired
                    showOptReqLabel={true}
                    labelText="First Name"
                    value={this.state.fields["first_name"]}
                    invalidText={first_name_error_msg}
                    isInvalid={first_name_invalid}
                    onChange={this.handleFirstName.bind(this, "first_name")}
                  />
                </FormField>

                <FormField>
                  <TextInput showOptReqLabel={false}
                    isRequired
                    showOptReqLabel={true}
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
                    value={this.state.fields["school_id"]}
                    showLabel
                    isRequired
                    showOptReqLabel={true}
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
                
                  <Checkbox
                    id="news_letter_checkbox_id"
                    invalidText={this.state.news_letter_error}
                    isInvalid={this.state.show_news_letter_error}
                    labelText="Select if you would like to receive the MyLibraryNYC email newsletter (we will use your alternate email if supplied above)"
                    isChecked={this.state.isCheckedVal}
                    name="sign_up_page"
                    onChange={this.verifyNewsLetterEmailInSignUpPage}
                    showHelperInvalidText
                    showLabel
                    value="1"
                  />
                
                <FormField>
                  <Button onClick={this.handleSubmit} buttonType={ButtonTypes.Callout} className="accountButton" isDisabled={this.state.isDisabled}> Sign Up </Button>
                </FormField>
              </Form>
            </>
          }
          contentSidebar={<></>}
          sidebar="right"
        />
    )
  }
}
