import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import Collapsible from 'react-collapsible';
import {
  Button, ButtonTypes, SearchBar, Select, TextInput, TextInputTypes, HelperErrorText, DSProvider, 
  TemplateAppContainer, Icon, Notification, Card, NotificationTypes,
  CardHeading, CardContent, CardLayouts, HeadingLevels, Text, Form, FormField, FormRow
} from '@nypl/design-system-react-components';
import validator from 'validator'
import { BrowserRouter as Router, Link as ReactRouterLink } from "react-router-dom";
import { Link, LinkTypes } from "@nypl/design-system-react-components";

export default class SignIn extends Component {

  constructor(props) {
    super(props);
    this.state = { email: "", invali_email_msg: "", user_signed_in: this.props.userSignedIn, isInvalid: false };
  }

  handleSearchKeyword = event => {    
    this.setState({
      email: event.target.value
    })
  }

  handleEmail = event => {
    this.setState({
      email: event.target.value
    })

    if (!validator.isEmail(event.target.value)) {
      this.state.isInvalid = true
      this.state.invali_email_msg = "Please enter a valid email address"

    }else {
      this.state.isInvalid = false
    }
  }

  handleValidation() {
    if (this.state.email == "") {
      this.setState({isInvalid: true, invali_email_msg: "Please enter a valid email address"});
      console.log("ooooooooo")
      return false;
    }
  }

  // # need  to modify below code
  handleSubmit = event => {
    event.preventDefault();
    console.log(this.state.email == "")
    if (this.state.email == "") {
      this.setState({isInvalid: true, invali_email_msg: "Please enter a valid email address"});
      console.log("ooooooooo")
      return false;
    }

    axios.post('/login', {
        email: this.state.email
     }).then(res => {
        if (res.data.logged_in) {
          window.location = "http://" + process.env.MLN_INFO_SITE_HOSTNAME + '/' + res.data.user_return_to
          return false;
        } else {
          this.setState({isInvalid: true, invali_email_msg: "Please enter a valid email address"});
        }
      })
      .catch(function (error) {
       console.log(error)
    })
    
  }

  render() {
    return (
      <DSProvider>
      <TemplateAppContainer
        breakout={<AppBreadcrumbs />}

        contentPrimary={
          <>
            <Collapsible trigger={<><Text noSpace displaySize="caption">Your DOE Email Address <Icon align="left" color="ui.black" iconRotation="rotate0" name="action_help_default" size="small" /></Text></>}>
              <Notification className="signInEmailAlert" noMargin notificationType={NotificationTypes.Announcement} showIcon={false}
              notificationContent={
                <Text noSpace displaySize="mini">Your DOE email address will look like jsmith@schools.nyc.gov, 
                  consisting of your first initial plus your last name. It may also contain a numeral after your name ( jsmith2@schools.nyc.gov, jsmith3@schools.nyc.gov, etc.). Even if you do not check your DOE email regularly, please use it to sign in. You can provide an alternate email address later for delivery notifications and other communications.
                </Text>} />
            </Collapsible> 
            
            <Form>
              <FormRow>
                <FormField>
                  <TextInput className="signInEmail" type={TextInputTypes.email} onChange={this.handleEmail} required invalidText={this.state.invali_email_msg} isInvalid={this.state.isInvalid} />
                  <Button buttonType={ButtonTypes.NoBrand} className="signInButton" onClick={this.handleSubmit}>Sign In</Button>
                </FormField>
              </FormRow>
            </Form>
            <div className="sign-up-link">
              <Text noSpace displaySize="caption">Not Registered ? Please
                <span> </span>
                <Link type={LinkTypes.Action}>
                  <ReactRouterLink to="/signup">Sign Up</ReactRouterLink>
                </Link>
              </Text>
            </div>
          </>
        }
        contentSidebar={<></>}
        sidebar="right"
      />
      </DSProvider>
    )
  }
}
