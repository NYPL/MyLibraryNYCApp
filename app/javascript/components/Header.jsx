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
    this.state = { user_signed_in: this.props.userSignedIn }
  }

  render() {
    return (
      <>
        <Navbar userSignedIn={this.props.userSignedIn} handleSignOutMsg={this.props.handleSignOutMsg} hideSignUpMessage={this.props.hideSignUpMessage}/>
        <MobileHeader />
      </>
    )
  }
}