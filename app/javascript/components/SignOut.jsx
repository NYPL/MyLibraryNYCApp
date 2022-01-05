import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Button, ButtonTypes, SearchBar, Select, TextInput, TextInputTypes, HelperErrorText, DSProvider, 
  TemplateAppContainer, HeadingLevels, Text, FormField, Form, Notification, NotificationTypes
} from '@nypl/design-system-react-components';
import validator from 'validator'

export default class SignOut extends Component {

  constructor(props) {
    super(props);
    this.state = { logged_out: ""  }
  }


  componentDidMount() {
    axios.post('/users/signout', {
        email: 'consultdg@nypl.org'
     })
      .then(res => {
        this.setState({ logged_out: res.data.logged_out });
        if (res.data.logged_out) {
          window.location = "http://" + process.env.MLN_INFO_SITE_HOSTNAME + ':3000/'
          return false;
        }
      })
      .catch(function (error) {
        console.log(error);
    })    
  }

  signOutMessage() {
    if (this.state.logged_out) {
      return "Signed out successfully"
    }
  }

  render() {
    return (
        <DSProvider>
          <TemplateAppContainer
            breakout={<><AppBreadcrumbs />
              {this.signOutMessage()}
            </>}
          />
        </DSProvider>
    )
  }

}