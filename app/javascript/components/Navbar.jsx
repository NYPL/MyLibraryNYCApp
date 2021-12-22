import React, { Component, useState } from 'react';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import { Link, LinkTypes, Icon } from "@nypl/design-system-react-components";
import mlnLogoRed from '../images/MLN_Logo_red.png'


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
      return <Link type={LinkTypes.Action}>
        <ReactRouterLink to="/account_details" className="nav-link-colors ">Account</ReactRouterLink>
      </Link>
    } else {
      return <Link type={LinkTypes.Action}>
        <ReactRouterLink to="/signin" className="nav-link-colors ">Sign In</ReactRouterLink>
      </Link>
    }
}

render() {

  return (
   <div className="header-topWrapper">
      <ReactRouterLink to="/">
        <div className="header-logo"><img border="0" src={mlnLogoRed}/></div>
      </ReactRouterLink>
    
      <nav className="header-buttons" style={styles.headerNav}>
        <ul className="float-right">
          <li>           
            {this.showAccountSigninLink()}
          </li>

          
          <li>
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/teacher_set_data" className="nav-link-colors ">Search Teacher Sets</ReactRouterLink>
            </Link>
          </li>

          <li>
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/contacts" className="nav-link-colors ">Contacts</ReactRouterLink>
            </Link>
          </li>
          

          <li>
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/faq" className="nav-link-colors ">FAQs</ReactRouterLink>
            </Link>
          </li>


          <li>
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/participating-schools" className="nav-link-colors ">Participating Schools</ReactRouterLink>
            </Link>
          </li>
        </ul>
      </nav>
    </div>
  );
  }
};