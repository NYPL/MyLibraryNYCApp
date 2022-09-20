import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Button, SearchBar, Select, TextInput, HelperErrorText, DSProvider, 
  TemplateAppContainer, Text, FormField, Form, Notification
} from '@nypl/design-system-react-components';
import validator from 'validator'

export default function SignOut(props) {

  const [logged_out, setLoggedOut] = useState("")


  const signOutMessage = () => {
    if (logged_out) {
      return "Signed out successfully"
    }
  }

  return (
      <DSProvider>
        <TemplateAppContainer
          breakout={<><AppBreadcrumbs />
            {signOutMessage()}
          </>}
        />
      </DSProvider>
  )
  
}