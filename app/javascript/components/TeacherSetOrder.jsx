import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import axios from 'axios';
import {
  Button,
  SearchBar, Select, Input,
  SearchButton, Card, CardHeading,
  CardContent, CardActions,
  MDXCreateElement,
  Heading, Image, List, Link, DSProvider, Notification, Icon, TemplateAppContainer, Text
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
    const order_message = "Your order has been received by our system and will be soon delivered to your school. Check your email inbox for further details." 
    const cancelled_message = "Your order has been cancelled. If you want to reorder this Teacher Set please contact us at the help@mylibrarynyc.org."
    return this.state.hold["status"] == 'cancelled' ? cancelled_message : order_message
  }

  showCancelButton() {
    return this.state.hold.status == 'cancelled' ? 'none' : 'block'
  }

  OrderDetails() {
    return <div className="tsOrderDetails">
      <List id="nypl-list2" className="listType" title="" type="dl">
        <dt className="orderDetails font-weight-500">
          Quantity
        </dt>
        <dd className="orderDetails">
          {this.state.hold["quantity"]}
        </dd>

        <dt className="orderDetails font-weight-500">
          Status
        </dt>
        <dd className="orderDetails">
          {this.state.hold["status"]}
        </dd>
        <dt className="orderDetails font-weight-500">
          Placed
        </dt>
        <dd className="orderDetails">
          {this.state.hold["created_at"]}
        </dd>
      </List>
    </div>
  }

  CancelButton() {
    return <div style={{ display: this.showCancelButton() }}> <Button className="cancel-button" buttonType="noBrand">
        <Link className="href_link whiteColor" href={"/holds/" + this.props.match.params.access_key + "/cancel"} > Cancel My Order </Link>
      </Button>
      </div>
  }

  render() {
    return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <>
              <Card id="ts-order-card-details" border className="orderPage">
                <CardHeading id="ts-order-msg" className="order_message">
                  <Icon id="ts-order-msg-icon" align="left" color="ui.black" iconRotation="rotate0" name="action_check_circle" size="medium" />
                  { this.OrderMessage() }
                </CardHeading>

                <CardHeading id="ts-order-title" className="order_page_title">
                  { this.TeacherSetTitle() }
                </CardHeading>

                <CardContent id="ts-order-desc" className="order_page_desc">
                  { this.TeacherSetDescription() }
                </CardContent>

                <CardContent id="ts-order-page-details">
                  { this.OrderDetails() }
                </CardContent>
                
                <CardContent id="ts-order-cancel-button">
                  { this.CancelButton() }
                </CardContent>

                {<br/>}
                <a id="ts-details-link-page" href="/teacher_set_data">Go To Search Teacher Sets Page</a>
              </Card>
            </>
          }
        contentSidebar={<div className="have_questions_section"><HaveQuestions /></div>}
        sidebar="right"
      />
  )}
}