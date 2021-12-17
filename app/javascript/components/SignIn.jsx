import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import Collapsible from 'react-collapsible';
import {
  Button,
  ButtonTypes,
  SearchBar,
  Select,
  TextInput, TextInputTypes, HelperErrorText, DSProvider, TemplateAppContainer, Icon, 
  Notification, Card, NotificationTypes,
  CardHeading, CardContent, CardLayouts, HeadingLevels, Text
} from '@nypl/design-system-react-components';
import questionCircle from '../images/fa-question-circle.svg'


export default class SignIn extends Component {



constructor(props) {
  super(props);
  this.state = { email: "", invali_email_msg: "", error_display: "none" };
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

  const regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

  if(regex.test(this.state.email) == false) {
    this.state.error_display = "block"
    this.state.invali_email_msg = "Please enter a valid email address"
  }
  else {
    this.state.error_display = "none"
  }
}


// # need  to modify below code

handleSubmit = event => {
  event.preventDefault()
  axios.post('/login', {
      email: this.state.email
   }).then(res => {
      if (res.data.logged_in) {
        window.location = "http://" + process.env.MLN_INFO_SITE_HOSTNAME + ':3000/' + res.data.user_return_to
        return false;
      } else {
        this.setState({error_display: "block", invali_email_msg: "Please enter a valid email address"});
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
              <div className="signInEmailAlert">
                <Notification noMargin notificationType={NotificationTypes.Announcement} 
                notificationContent={
                  <Text noSpace displaySize="mini">Your DOE email address will look like jsmith@schools.nyc.gov, 
                    consisting of your first initial plus your last name. It may also contain a numeral after your name ( jsmith2@schools.nyc.gov, jsmith3@schools.nyc.gov, etc.). Even if you do not check your DOE email regularly, please use it to sign in. You can provide an alternate email address later for delivery notifications and other communications.
                  </Text>} />
              </div>
            </Collapsible> 
            
            <TextInput className="signInEmail" type={TextInputTypes.email} onChange={this.handleEmail} required />
            <HelperErrorText isInvalid>
              <div style={{ display: this.state.error_display }}>
                {this.state.invali_email_msg}
              </div>
            </HelperErrorText>
            <Button buttonType={ButtonTypes.Primary} className="signInButton" onClick={this.handleSubmit}>Sign In</Button>
            <div className="sign-up-link"><Text noSpace displaySize="caption">Not Registered? Please Sign Up </Text></div>
          </>
        }
        contentSidebar={<></>}
        sidebar="right"
      />
      </DSProvider>
    );
  }
}