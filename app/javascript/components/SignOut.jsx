import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Button, SearchBar, Select, TextInput, HelperErrorText, DSProvider, 
  TemplateAppContainer, Text, FormField, Form, Notification
} from '@nypl/design-system-react-components';
import validator from 'validator'

export default class SignOut extends Component {

  constructor(props) {
    super(props);
    this.state = { logged_out: ""  }
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