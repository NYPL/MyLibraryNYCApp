import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';

import {
  Button,
  ButtonTypes,
  SearchBar,
  Select,
  TextInput, TextInputTypes, HelperErrorText
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

  console.log(regex.test(this.state.email))

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
  console.log("sss")
  axios.post('/login', {
      email: this.state.email
   }).then(res => {        
      console.log(res);
    })
    .catch(function (error) {
     console.log(error)
  })
}


render() {
  return (
      <>
      <AppBreadcrumbs />
        <div className="layout-container nypl-ds">
          <main className="main main--with-sidebar nypl-ds">
            <div className="content-primary content-primary--with-sidebar-right card_details">       

              <TextInput labelText="Your DOE Email Address" placeholder="example@email.com" type={TextInputTypes.email} 
                onChange={this.handleEmail} required />

              <HelperErrorText id="error-helperText" isError={true}>
                <div style={{ display: this.state.error_display }}>
                  {this.state.invali_email_msg}
                </div>
              </HelperErrorText>
              <Button buttonType={ButtonTypes.Primary} className="signInButton" onClick={this.handleSubmit}>Sign In</Button>
            </div>


          <div className="content-secondary content-secondary--with-sidebar-right">
            
          </div>

        </main>
      </div>
      </>
    );
  }
}
