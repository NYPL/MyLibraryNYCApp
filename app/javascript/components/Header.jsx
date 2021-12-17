import React, { Component, useState } from 'react';
import { NavLink } from "react-router-dom";
import Navbar from "./Navbar";
import AppBreadcrumbs from "./AppBreadcrumbs";
import MobileHeader from "./MobileHeader"
import ReactDOM from "react-dom";
import { render } from "react-dom";
import { BrowserRouter } from "react-router-dom";


export default class Header extends Component {

  constructor(props) {
    super(props); 
    this.state = { user_signed_in: this.props.userSignedIn}
  }

  render() {
    return (
    	<div className="content-header">
    		<div className="header-wrapper">
  	    	<Navbar userSignedIn={this.state.user_signed_in} />
  	    	<MobileHeader />
  	    </div>
      </div>
    )
  }
}