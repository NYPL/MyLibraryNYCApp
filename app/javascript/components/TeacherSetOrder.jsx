import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Button, ButtonTypes,
  SearchBar, Select, Input,
  SearchButton, Card, CardHeading, CardLayouts,
  CardContent, CardActions,
  MDXCreateElement,
  Heading,
  Image,
  List,
  Link, LinkTypes, DSProvider, Notification,
  Icon
} from '@nypl/design-system-react-components';



export default class TeacherSetOrder extends React.Component {

  constructor(props) {
    super(props);
    this.state = { access_key: this.props.match.params.access_key, 
                   hold: this.props.holddetails, 
                   teacher_set: this.props.teachersetdetails, status_label: this.props.statusLabel };
  }
  

  componentDidMount() {
    console.log(this.props.match.params.access_key + "ppppp")
    if (typeof this.state.hold == 'string') {
      axios.get('/holds/' + this.props.match.params.access_key)
        .then((res) => {
          const { data } = res;
          console.log(res.data + "oooooooooooooooooooooo")
          // This fix depending on the nypl design  system.
          // if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + "/users/start") {
          //   window.location = res.request.responseURL;
          //   return false;
          // } else {
          //   console.log(res.data.status_label + "status label")
          //   this.setState({ teacher_set: res.data.teacher_set, hold: res.data.hold, status_label: res.data.status_label });
          // }
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
    return <div className="tsDetails">
      <List id="nypl-list2" title="" type="dl">
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

          {/*{console.log(Object.entries(this.state.status_label))}*/}


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
    return <div id="order-cancel-button" style={{ display: this.showCancelButton() }}>
      <Link className="button-color" type={LinkTypes.Button} href={"/holds/" + this.props.match.params.access_key + "/cancel"} > Cancel My Order </Link>
    </div>
  }

  render() {

    return (
      <>
        <AppBreadcrumbs />
        <div className="order-message">
          <Notification>
            {/*<NotificationHeading>*/}
              { this.OrderMessage() }
            {/*</NotificationHeading>*/}
          </Notification>
        </div>

        <div className="layout-container nypl-ds">
          <main className="main main--with-sidebar">
            <div className="content-primary content-primary--with-sidebar-right">
            
              <div className="card_details">
                  <Heading level={4}>
                   { this.TeacherSetTitle() }
                  </Heading>

                 
                  { this.TeacherSetDescription() }

                  { this.OrderDetails() }
              </div>
              
              { this.CancelButton() }

              {<br/>}
              <a href="/teacher_set_data">Go To Search Teacher Sets Page</a>
            </div>
            <div className="content-secondary content-secondary--with-sidebar-right"></div>
          </main>
        </div>
      </>
  )}
}