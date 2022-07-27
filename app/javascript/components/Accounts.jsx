import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import axios from 'axios';

import {
  Input, TextInput, List, Form, Button, FormRow, InputTypes, Label, FormField, 
  DSProvider, TemplateAppContainer, Select, Heading, Link, LinkTypes, Table, Notification, Pagination, Icon
} from '@nypl/design-system-react-components';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";


export default class Accounts extends Component {

  constructor(props) {
    super(props);
    this.state = {contact_email: "", current_user: "", teacher_set: "", school: "", alt_email: "", email: "", schools: "", school_id: "", holds: "", password: "", message: "", cancel_message: "", cancel_button_display: "block", setComputedCurrentPage: 1, total_pages: ""}
  }

  componentDidMount() {
    axios.get('/account', { params: { page: this.state.setComputedCurrentPage } } ).then(res => {
      if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin") {
        window.location = res.request.responseURL;
        return false;
      }
      else {
        let account_details = res.data.accountdetails
        this.setState({ contact_email: account_details.contact_email, school: account_details.school, email: account_details.email,
        alt_email: account_details.alt_email, schools: account_details.schools, current_user: account_details.current_user,
        holds: account_details.holds, school_id: account_details.school.id, password: account_details.current_password, total_pages: account_details.total_pages })
      }
    }).catch(function (error) {
        console.log("cancel order fail")
        console.log(error)
    })
  }

  handleSubmit = event => {
    event.preventDefault();
    axios.put('/registrations/'+ this.state.current_user.id , {
        user: { alt_email: this.state.alt_email, school_id: this.state.school_id, current_password: this.state.password }
     }).then(res => {
        if (res.data.status == "updated") {
          this.setState ({ message: res.data.message })
        }
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
    if (this.state.holds) {
      return this.state.holds.map((hold, index) => (
           [ hold["created_at"], hold["quantity"], hold["title"], this.statusLabel(hold), this.cancelButton(hold, index) ]
          )
        )
    }
  }

  statusLabel(hold) {
    return hold["status_label"]
  }

  cancelButton(hold, index) {
    if (hold["status"] == "new") {
      return <div> <div style={{display: "flex"}} id={index}> {this.orderCancelConfirmation(hold, index)} </div> </div>
    } else {
      return null;
    }
  }

  cancelOrder(value, access_key, cancel_button_index) {
    this.state.cancel_message = ""
    axios.put('/holds/'+ access_key, { hold_change: { status: 'cancelled' } 
     }).then(res => {
        if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin") {
          window.location = res.request.responseURL;
          return false;
        } else {
          if (res.data.hold.status == "cancelled") {
            this.setState({cancel_button_display: 'none'})
            this.state.cancel_message = "Successfully Cancelled"

            let updatedHolds = this.state.holds.map( (obj, index) => {
             if(index === cancel_button_index) {
               return Object.assign({}, obj, {
                 status: "cancelled", status_label: "Cancelled"
               });
             }
             return obj;
          });
          this.setState({
            holds : updatedHolds
          });

            // if (this.state.holds) {
            //   return this.state.holds.map((hold, index) => (
            //       [ hold["created_at"], hold["quantity"], hold["title"], this.statusLabel(hold), this.cancelButton(hold, index) ]
            //     )
            //   )
            // }
          }
        }
      })
      .catch(function (error) {
        console.log(error)
    })
  }


  orderCancelConfirmation(hold, index) {
    return <div id={"cancel_"+ hold["access_key"]}>
      <Button className="accountCancelOrder" buttonType="secondary"> 
        <Link className="href_link cancelOrderButton" href={"/holds/" + hold["access_key"] + "/cancel"} > Cancel My Order </Link>
      </Button>
    </div>


  }

  AccountUpdatedMessage() {
    if (this.state.message !== "") {
      return <Notification ariaLabel="Account Notification" id="account-details-notification" className="accountNotificationMsg"
        showIcon={false}
        notificationType="announcement"
        notificationContent={<><Icon align="none" color="ui.black" iconRotation="rotate0" name="action_check_circle" size="small"/>{this.state.message}</>}
      />
    }
  }

  OrderDetails() {
    return <>
      <Heading id="your-orders-text" level="three" text='Your Orders' />
      <Table
        columnHeaders={[
          'Order Placed',
          'Quantity',
          'Title',
          'Status',
          ''
        ]}
        showRowDividers={true}
        columnHeadersBackgroundColor="var(--nypl-colors-ui-gray-x-light-cool)"
        tableData={this.HoldsDetails()}
        id="ts-order-details-list"
      />
    </>
  }

  displayOrders() {
    if (this.state.holds.length > 0) {
      return this.OrderDetails()
     } else {
      return "No orders yet"
     }
  }

  onPageChange = (page) => {
    this.state.setComputedCurrentPage = page;
    axios.get('/account', { params: { page: page } }).then(res => {
      if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin") {
        window.location = res.request.responseURL;
        return false;
      }
      else {
        let account_details = res.data.accountdetails
        this.setState({ contact_email: account_details.contact_email, school: account_details.school, email: account_details.email,
        alt_email: account_details.alt_email, schools: account_details.schools, current_user: account_details.current_user,
        holds: account_details.holds, school_id: account_details.school.id, password: account_details.current_password })
      }
    }).catch(function (error) {
        console.log("cancel order fail")
        console.log(error)
    })
  };

  render() {
    let user_name = this.state.current_user.first_name

    return (
      <TemplateAppContainer
          breakout={<><AppBreadcrumbs />{ this.AccountUpdatedMessage() }</>}
          contentPrimary={
            <>
              <div style={{display: 'flex'}}>
                <Heading id="account-user-name" level="three" text={'Hello, ' + user_name} />
              </div>

              <Form id="account-details-form" onSubmit={this.handleSubmit} method="put">
                <FormField>
                  <TextInput
                    isRequired
                    showOptReqLabel={false}
                    labelText="Your DOE Email Address"
                    id="account-details-input"
                    value={this.state.alt_email}
                    onChange={this.handleAltEmail}
                  />
                </FormField>
                <FormField>
                  <Select id="ad-select-schools" labelText="Your School" value={this.state.school_id} showLabel showOptReqLabel={false} onChange={this.handleSchool}>
                    {this.Schools()}
                  </Select>
                </FormField>
                <Button id="ad-submit-button" buttonType="noBrand" className="accountButton" onClick={this.handleSubmit}> Update Account Information </Button>
              </Form>
              {<br/>}
              {this.displayOrders()}
              {<br/>}
              <Pagination id="ad-pagination"className="accocuntOrderPagination" currentPage={1} onPageChange={this.onPageChange}  pageCount={this.state.total_pages} />
            </>
          }
          contentSidebar={<div className="have_questions_section"><HaveQuestions /></div>}
          sidebar="right"
    />)
  }
}