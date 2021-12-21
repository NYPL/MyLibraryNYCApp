import React, { Component, useState } from 'react';

import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Input, TextInput, List, Form, Button, FormRow, InputTypes, ButtonTypes, Label, FormField, 
  DSProvider, TemplateAppContainer, Select
} from '@nypl/design-system-react-components';



export default class Accounts extends Component {

  constructor(props) {
    super(props);
    this.state = {contact_email: "", school: "", alt_email: "", email: "", schools: ""}
  }


  componentDidMount() {
    axios.get('/account').then(res => {
      console.log(res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + ":3000/users/start")
      if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + ":3000/users/start") {
        window.location = res.request.responseURL;
        return false;
      }
      else {
        let account_details = res.data.accountdetails
        this.setState({ contact_email: account_details.contact_email, school: account_details.school, email: account_details.email,
        alt_email: account_details.alt_email, schools: account_details.schools })
      }
    }).catch(function (error) {
        console.log("cancel order fail")
        console.log(error)
    })
  }


  Schools() {
    return Object.entries(this.state.schools).map((school, i) => {
      return (
        <option key={school[1]} value={school[1]}>{school[0]}</option>
      )
    }, this);
  }
  

  render() {
    return (
      <DSProvider>
      <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <>                
              <Form onSubmit={this.handleSubmit}>
                <FormField>
                  <TextInput
                    isRequired
                    showOptReqLabel={false}
                    labelText="Preferred email address for Reservation Notifications"
                    id="alt_email"
                  />
                </FormField>
                <FormField>
                  <Select id="school_id" labelText="Your School" name="color" showLabel showOptReqLabel={false} >
                    {this.Schools()}
                  </Select>
                </FormField>

                <Button buttonType={ButtonTypes.NoBrand} onClick={this.handleSubmit}> Update Account Information </Button>
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