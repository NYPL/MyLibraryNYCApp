import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import axios from 'axios';
import { ReactRouterLink } from "react-router-dom";
import {
  Button,
  SearchBar, Select, Input,
  SearchButton, Card, CardHeading,
  CardContent, CardActions,
  MDXCreateElement,
  Heading, Image, List, Link, DSProvider, Notification, Icon, TemplateAppContainer, Text, HorizontalRule, StatusBadge
} from '@nypl/design-system-react-components';



export default class TeacherSetOrder extends React.Component {

  constructor(props) {
    super(props);
    this.state = { access_key: this.props.match.params.access_key, 
                   hold: this.props.holddetails, 
                   teacher_set: this.props.teachersetdetails, status_label: this.props.statusLabel };
  }
  

  componentDidMount() {

    if (typeof this.state.hold == 'string') {
      axios.get('/holds/' + this.props.match.params.access_key)
        .then((res) => {
          const { data } = res;
          // This fix depending on the nypl design  system.
          if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin") {
            window.location = res.request.responseURL;
            return false;
          } else {
            this.setState({ teacher_set: res.data.teacher_set, hold: res.data.hold, status_label: res.data.status_label });
          }
      })
      .catch(function (error) {
        console.log(error); 
      })
    }
  }

  TeacherSetTitle() {
    return <div>{this.state.teacher_set["title"]}</div>
  }

  TeacherSetDescription() {
    return <div>{this.state.teacher_set["description"]}</div>
  }

  OrderMessage() {
    const order_message = "Your order has been received by our system and will be soon delivered to your school!. Check your email inbox for further details." 
    const cancelled_message = "Your order has been cancelled. If you want to reorder this Teacher Set please contact us at the help@mylibrarynyc.org."
    return this.state.hold["status"] == 'cancelled' ? cancelled_message : order_message
  }

  showCancelButton() {
    return this.state.hold.status == 'cancelled' ? 'none' : 'block'
  }

  OrderDetails() {
    return <List marginTop="l" id="order-confirmation-list-details" title="Order Details" type="dl">
        <dt>
          Teacher Set
        </dt>
        <dd>
          {this.teacherSetCardDetails()}
        </dd>
        <dt>
          Quantity
        </dt>
        <dd>
          {this.state.hold["quantity"]}
        </dd>
        <dt>
          Order Placed
        </dt>
        <dd>
          {this.state.hold["created_at"]}
        </dd>
        <dt>
          Status
        </dt>
        <dd>
          {this.state.hold["status"]}
        </dd>
      </List>
  }

  teacherSetCardDetails() {
    if (this.state.teacher_set) {
      let ts = this.state.teacher_set
      let title = ts.title? ts.title : " "
      let availability_status_badge =  (ts.availability === "available") ? "medium" : "low"
      let availability = ts.availability !== undefined ? ts.availability : ""
      return <div>
          <Card id="book-page-ts-card-details" layout="row">
            
            <CardContent id="book-page-ts-suitabilities"> {ts.suitabilities_string} </CardContent>
            <CardContent id="book-page-ts-availability"> 
              <StatusBadge level={availability_status_badge}>{availability}</StatusBadge>
            </CardContent>
            <CardContent id="book-page-ts-description"> {ts.description} </CardContent>
          </Card>
      </div>
    }
  }


  CancelButton() {
    return <div style={{ display: this.showCancelButton() }}>
      <Button id="order-cancel-button" className="cancel-button" buttonType="secondary" >
        <Link className="href_link cancelOrderButton" href={"/holds/" + this.props.match.params.access_key + "/cancel"} > Cancel My Order </Link>
      </Button>
      </div>
  }

  render() {
    let confirmationMsg = this.state.hold.status == 'cancelled' ? 'Cancel Order' : 'Order Confirmation'
    return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <>
              <Heading id="order-confirmation-heading" level="two" size="secondary" text={confirmationMsg} />
              <HorizontalRule id="ts-detail-page-horizontal-rulel" className="teacherSetHorizontal" />
              { this.OrderMessage() }
              { this.OrderDetails() }
              { this.CancelButton() }

              <Link  marginTop="l" href="/teacher_set_data" id="ts-details-link-page" type="action" target='_blank'>
                <Icon name="arrow" iconRotation="rotate90" size="small" align="left" />
                Back to Search Teacher Sets Page
              </Link>
            </>
          }
        contentSidebar={<div className="have_questions_section"><HaveQuestions /></div>}
        sidebar="right"
      />
  )}
}