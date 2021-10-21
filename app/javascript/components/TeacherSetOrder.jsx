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
  Link, LinkTypes
} from '@nypl/design-system-react-components';



export default class TeacherSetOrder extends React.Component {

  constructor(props) {
    super(props);
    this.state = { access_key: this.props.match.params.access_key, 
                   hold: this.props.holddetails, 
                   teacher_set: this.props.teachersetdetails };
  }
  

  componentDidMount() {
    if (typeof this.state.hold == 'string') {
      axios.get('/holds/' + this.props.match.params.access_key)
        .then(res => {
          this.setState({ teacher_set: res.data.teacher_set, 
                          hold: res.data.hold });
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

  OrderDetails() {
    return <List id="nypl-list2" title="" type="dl">
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
        Order Placed
      </dt>
      <dd className="orderDetails">
        {this.state.hold["created_at"]}
      </dd>
    </List>
  }

  render() {  
    return (
      <>
        <AppBreadcrumbs />
        <div className="layout-container nypl-ds">
          <main className="main main--with-sidebar nypl-ds">
            <div className="content-primary content-primary--with-sidebar-right">
              <div className="content-top card_details">
                  <Card layout={CardLayouts.Horizontal} border className="faq_list">
                    <CardHeading level={4} id="heading1">
                      Your order has been received by our system and will be soon delivered to your school. Check your email inbox for further details.
                    </CardHeading>

                    <CardContent>
                     { this.TeacherSetTitle() }
                    </CardContent>

                    <CardContent>
                     { this.TeacherSetDescription() }
                    </CardContent>

                    <CardContent>
                      { this.OrderDetails() }
                    </CardContent>

                    <CardActions>
                      <Link type={LinkTypes.Button} href={"/holds/" + this.props.match.params.access_key + "/cancel"} >
                        Cancel My Order
                      </Link>

                    </CardActions>

                  </Card>
              </div>
            </div>

            <div className="content-secondary content-secondary--with-sidebar-right"></div>
          </main>
        </div>
      </>
  )}


}