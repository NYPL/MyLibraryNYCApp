import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Button, ButtonTypes,
  SearchBar, Select, Input,
  SearchButton, Card, CardHeading, CardLayouts,
  CardContent,
  MDXCreateElement,
  Heading,
  Image,
  List
} from '@nypl/design-system-react-components';



export default class TeacherSetOrder extends React.Component {

  constructor(props) {
    super(props);
    this.state = { access_key: this.props.match.params.access_key, hold: this.props.holddetails.hold };
  }
  

  render() {
    let hold = this.state.hold;

    return (
      <>
        <AppBreadcrumbs />
        <div className="layout-container nypl-ds">
          <main className="main main--with-sidebar nypl-ds">
            <div className="content-primary content-primary--with-sidebar-right">

              <div className="content-top card_details">
                <div style={{ display: "grid", "grid-gap": "2rem", "grid-template-columns": "repeat(1, 1fr)" }}>
                  <Card layout={CardLayouts.Horizontal} border className="faq_list">

                    <CardHeading level={4} id="heading3">
                      Your order has been received by our system and will be soon delivered to your school. Check your email inbox for further details.
                    </CardHeading>

                  </Card>
                </div>
              </div>
            </div>

            <div className="content-secondary content-secondary--with-sidebar-right">
            
            </div>
          </main>
        </div>
      </>

  )}


}