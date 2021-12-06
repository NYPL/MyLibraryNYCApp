import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';

import {
  Button,
  ButtonTypes,
  SearchBar,
  Select,
  TextInput, TextInputTypes, HelperErrorText, DSProvider, TemplateAppContainer, Icon, NotificationContent, Notification, Card,
  CardHeading, CardContent, CardLayouts, HeadingLevels
} from '@nypl/design-system-react-components';


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
        console.log("ppppppppmmmmmm")
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
            <div style={{ border: '1px solid #ccc' }} >
              <Notification className="sign_in_notification_msg"
                dismissible
                id="basic-notification"
                
                notificationContent={<>Your DOE email address will look like jsmith@schools.nyc.gov, consisting of your first initial plus your last name. It may also contain a numeral after your name ( jsmith2@schools.nyc.gov, jsmith3@schools.nyc.gov, etc.). Even if you do not check your DOE email regularly, please use it to sign in. You can provide an alternate email address later for delivery notifications and other communications.</>}
                notificationType="announcement"
              />
            </div>{<br/>}

            <TextInput placeholder="example@email.com" type={TextInputTypes.email} 
              onChange={this.handleEmail} required />
            <HelperErrorText id="error-helperText" isError={true}>
              <div style={{ display: this.state.error_display }}>
                {this.state.invali_email_msg}
              </div>
            </HelperErrorText>
            <Button buttonType={ButtonTypes.Primary} className="signInButton" onClick={this.handleSubmit}>Sign In</Button>
            <div className="sign-up-link">Not Registered? Please Sign Up</div>
          </>
        }
        contentSidebar={<></>}
        sidebar="right"
      />
      </DSProvider>
    );
  }
}