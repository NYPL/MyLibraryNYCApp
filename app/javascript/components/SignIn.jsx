import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import axios from 'axios';
import Collapsible from 'react-collapsible';
import {
  Button, SearchBar, Select, TextInput, HelperErrorText, DSProvider, 
  TemplateAppContainer, Icon, Notification, Card,
  CardHeading, CardContent, Text, Form, FormField, FormRow
} from '@nypl/design-system-react-components';
import validator from 'validator'
import { BrowserRouter as Router, Link as ReactRouterLink } from "react-router-dom";
import { Link } from "@nypl/design-system-react-components";

export default class SignIn extends Component {

  constructor(props) {
    super(props);
    this.state = { email: "", invali_email_msg: "", user_signed_in: this.props.userSignedIn, isInvalid: false };
  }


  componentDidMount() {
    if(this.props.userSignedIn && this.props.location.pathname == "/signin") {
      window.location = "http://" + process.env.MLN_INFO_SITE_HOSTNAME + "/account_details"
      return false;
    }
  }

  handleEmail = event => {
    this.setState({
      email: event.target.value, isInvalid: false
    })
  }

  handleValidation() {
    if (this.state.email == "") {
      this.setState({isInvalid: true, invali_email_msg: "Please enter a valid email address"});
      return false;
    }
  }

  redirectToHome = (user_return_to) => {
    const { history } = this.props;
    if(history) history.push({ pathname: "/" + user_return_to, state: { userSignedIn: true } });
  }

  handleSubmit = event => {
    event.preventDefault();
    if (this.state.email == "") {
      this.setState({isInvalid: true, invali_email_msg: "Please enter a valid email address"});
      return false;
    }

    if (!validator.isEmail(this.state.email)) {
      this.setState({isInvalid: true, invali_email_msg: "Please enter a valid email address"});
      return false;
    }

    axios.post('/login', {
      email: this.state.email
    }).then(res => {
      if (res.data.logged_in) {
        this.state.userSignedIn = true;
        this.props.handleSignInMsg(res.data.sign_in_msg, true)
        this.props.hideSignInMessage(false)
        this.redirectToHome(res.data.user_return_to)
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
      <TemplateAppContainer
        breakout={<AppBreadcrumbs />}
        contentPrimary={
          <>
            <Collapsible trigger={<><Text noSpace size="caption">Your DOE Email Address <Icon align="left" color="ui.black" iconRotation="rotate0" name="action_help_default" size="small" /></Text></>}>
              <Notification className="signInEmailAlert" noMargin notificationType="announcement" showIcon={false}
              notificationContent={
                <Text noSpace size="mini">Your DOE email address will look like jsmith@schools.nyc.gov, 
                  consisting of your first initial plus your last name. It may also contain a numeral after your name ( jsmith2@schools.nyc.gov, jsmith3@schools.nyc.gov, etc.). Even if you do not check your DOE email regularly, please use it to sign in. You can provide an alternate email address later for delivery notifications and other communications.
                </Text>} />
            </Collapsible> 
            
            <Form id="sign-in-form">
              <FormRow>
                <FormField>
                  <TextInput id="sign-in-text-input" className="signInEmail" type="email" onChange={this.handleEmail} required invalidText={this.state.invali_email_msg} isInvalid={this.state.isInvalid} />
                  <Button id="sign-in-button" buttonType="noBrand" className="signInButton" onClick={this.handleSubmit}>Sign In</Button>
                </FormField>
              </FormRow>
            </Form>
            <div className="sign-up-link">
              <Text id="not-registered-text" noSpace size="caption">Not Registered ? Please
                <span> </span>
                <Link id="sign-up-link" type="action">
                  <ReactRouterLink to="/signup">Sign Up</ReactRouterLink>
                </Link>
              </Text>
            </div>
          </>
        }
        contentSidebar={<div className="have_questions_section"><HaveQuestions /></div>}
        sidebar="right"
      />
    )
  }
}
