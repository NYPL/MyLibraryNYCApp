import React, { Component, useState } from 'react';

import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Input, TextInput, List
} from '@nypl/design-system-react-components';



export default class Accounts extends Component {

  constructor(props) {
    super(props);
    this.state = { alt_email: "", school_id: ""}
  }


  componentDidMount() {
    axios.put('/users',
      { user: { alt_email: this.state.alt_email, school_id: this.state.school_id } } ).then(res => {

    }).catch(function (error) {
        console.log("cancel order fail")
        console.log(error)
    })
  }


  render() {
    return (
      <>
      <AppBreadcrumbs />
        <main className="main main--with-sidebar nypl-ds">
          <div className="content-primary content-primary--with-sidebar-right">
            <div className="card_details">
              Accounts page
            </div>
          </div>
          
          <div className="content-secondary content-secondary--with-sidebar-right">
            
          </div>
        </main>
      </>
    )
  }
}