import React, { Component, useState } from 'react';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import { Link, LinkTypes, Icon, List } from "@nypl/design-system-react-components";
import mlnLogoRed from '../images/MLN_Logo_red.png'
//import AccountDetailsSubMenu from "./AccountDetailsSubMenu";


const styles = {
  headerNav: {
    position: 'absolute',
    top: '28px',
    display: 'block',
  }
}

  
export default class Navbar extends Component {

  constructor(props) {
    super(props);
    this.state = { user_signed_in: this.props.userSignedIn}
  }


showAccountSigninLink() {
    if (this.state.user_signed_in) {
      return <ReactRouterLink to="/account_details" className="nav-link-colors ">Account</ReactRouterLink>
    } else {
      return <ReactRouterLink to="/signin" className="nav-link-colors ">Sign In</ReactRouterLink>
    }

}

render() {

  return (
   <div className="header-topWrapper">
      <ReactRouterLink to="/">
        <div className="header-logo"><img border="0" src={mlnLogoRed}/></div>
      </ReactRouterLink>
    
      <List type="ul" inline noStyling className="header-buttons" className="float-right">

        <ReactRouterLink to="/teacher_set_data" className="nav-link-colors ">Search Teacher Sets</ReactRouterLink>

        <ReactRouterLink to="/contacts" className="nav-link-colors ">Contacts</ReactRouterLink>

        <ReactRouterLink to="/faq" className="nav-link-colors ">FAQs</ReactRouterLink>

        <ReactRouterLink to="/participating-schools" className="nav-link-colors ">Participating Schools</ReactRouterLink>

        {this.showAccountSigninLink()}

      </List>
    </div>
  );
  }
};