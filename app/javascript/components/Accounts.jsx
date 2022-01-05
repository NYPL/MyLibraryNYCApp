import React, { Component, useState } from 'react';

import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Input, TextInput, List, Form, Button, FormRow, InputTypes, ButtonTypes, Label, FormField, 
  DSProvider, TemplateAppContainer, Select, Heading, HeadingLevels, Link, LinkTypes
} from '@nypl/design-system-react-components';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";


export default class Accounts extends Component {

  constructor(props) {
    super(props);
    this.state = {contact_email: "", current_user: "", school: "", alt_email: "", email: "", schools: "", school_id: "", holds: ""}
  }


  componentDidMount() {
    axios.get('/account').then(res => {
      if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + ":3000/users/start") {
        window.location = res.request.responseURL;
        return false;
      }
      else {
        let account_details = res.data.accountdetails
        this.setState({ contact_email: account_details.contact_email, school: account_details.school, email: account_details.email,
        alt_email: account_details.alt_email, schools: account_details.schools, current_user: account_details.current_user,
        holds: account_details.holds })
      }
    }).catch(function (error) {
        console.log("cancel order fail")
        console.log(error)
    })
  }


  handleSubmit = event => {
    event.preventDefault();
    console.log(event.target.value + "eveveveve")
    axios.put('/users', {
        user: { alt_email: this.state.alt_email, school_id: '1234' }
     }).then(res => {
        console.log(res)
      })
      .catch(function (error) {
       console.log(error)
    })
  }

  handleAltEmail = event => {
    this.setState ({ alt_email: event.target.value})
  }


  handleSchool = event => {
    this.setState ({ school_id: event.target.value })
  }


  Schools() {
    return Object.entries(this.state.schools).map((school, i) => {
      return (
        <option key={school[1]} value={school[1]}>{school[0]}</option>
      )
    }, this);
  }
  

  HoldsDetails() {
    return <List noStyling>
      {this.state.holds.map((hold, index) =>
        <div>hold.created_at</div>
      )}
    </List>
  }

  render() {
    let user_name = this.state.current_user.first_name

    return (
      <DSProvider>
      <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <>
              <div style={{display: 'flex'}}>
                <Heading id="heading-three" level={HeadingLevels.Three} text={'Hello, ' + user_name} /> 
                <Link type={LinkTypes.Action}>
                  <ReactRouterLink to="/signout"> (Sign Out)</ReactRouterLink>
                </Link>
              </div>          
              <Form onSubmit={this.handleSubmit} method="put">
                <FormField>
                  <TextInput
                    isRequired
                    showOptReqLabel={false}
                    labelText="Your DOE Email Address"
                    id="alt_email"
                    value={this.state.alt_email}
                    onChange={this.handleAltEmail}
                  />
                </FormField>
                <FormField>
                  <Select id="school_id" labelText="Your School" value='1645' showLabel showOptReqLabel={false} onChange={this.handleSchool}>
                    {this.Schools()}
                  </Select>
                </FormField>
                <Button buttonType={ButtonTypes.Callout} className="accountButton" onClick={this.handleSubmit}> Update Account Information </Button>
              </Form>
              {<br/>}
              <Heading level={HeadingLevels.Three} text='Your Orders' />
            </>
          }
          contentSidebar={<></>}
          sidebar="right"
        />
      </DSProvider>
    )
  }
}