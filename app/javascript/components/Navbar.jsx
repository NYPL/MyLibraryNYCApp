import React, { Component, useState } from 'react';
import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import { Link, LinkTypes, Icon, List, ListTypes, Button, ButtonTypes} from "@nypl/design-system-react-components";
import mlnLogoRed from '../images/MLN_Logo_red.png'


const styles = {
  headerNav: {
    position: 'absolute',
    top: '28px',
    display: 'block',
  }
}

class AccountDetailsSubMenu extends Component {

  constructor(props) {
    super(props);
    this.state = { user_signed_in: this.props.userSignedIn}
  }

  signInAccountLinks() {
    if (!this.state.user_signed_in) {
      return <ReactRouterLink to="/signin"> <Button buttonType={ButtonTypes.NoBrand}>Sign In</Button> </ReactRouterLink>
    }
  }

  AccountOrderLink() {
    if (this.state.user_signed_in) {
      return <ReactRouterLink to="/account_details">My Account & Orders</ReactRouterLink>
    } else {
      return <ReactRouterLink to="/signin">My Account & Orders</ReactRouterLink>
    }
  }

  render() {
    return (
      <List type={ListTypes.Ordered} inline={false} noStyling={false} className="nav__submenu">
        <li className="nav__submenu-item">
          {this.signInAccountLinks()}
        </li>
        <li className="nav__submenu-item">
          {this.AccountOrderLink()}
        </li>
        <li className="nav__submenu-item"><ReactRouterLink to="/signup">Not Registered ? Please Sign Up</ReactRouterLink></li>
      </List>
    )
  }
}


  
  
export default class Navbar extends Component {

  constructor(props) {
    super(props);
    this.state = { user_signed_in: this.props.userSignedIn, showAboutMenu: false}
    this.handleHover = this.handleHover.bind(this);
    this.handleLeave = this.handleLeave.bind(this);
  }

  handleHover = (event) => {
    this.setState({ showAboutMenu: true });
  };

  handleLeave = (event) => {
    this.setState({ showAboutMenu: false });
  };

showAccountSigninLink() {
  if (this.state.user_signed_in) {
    return <ReactRouterLink to="/account_details" className="nav-link-colors" onMouseEnter={this.handleHover}>Account</ReactRouterLink>
  } else {
    return <ReactRouterLink to="/signin" className="nav-link-colors" onMouseEnter={this.handleHover}>Sign In</ReactRouterLink>
  }
}

render() {
  return (
   <div className="header-topWrapper">
      <ReactRouterLink to="/">
        <div className="header-logo"><img border="0" src={mlnLogoRed}/></div>
      </ReactRouterLink>
    
      <List type="ul" inline noStyling className="header-buttons" className="float-right">

        <li><ReactRouterLink to="/teacher_set_data" className="nav-link-colors">Search Teacher Sets</ReactRouterLink></li>

        <li><ReactRouterLink to="/contacts" className="nav-link-colors">Contacts</ReactRouterLink></li>

        <li><ReactRouterLink to="/faq" className="nav-link-colors">FAQs</ReactRouterLink></li>

        <li><ReactRouterLink to="/participating-schools" className="nav-link-colors ">Participating Schools</ReactRouterLink></li>

        <li className="nav__menu-item">
          {this.showAccountSigninLink()}
          { this.state.showAboutMenu && <AccountDetailsSubMenu userSignedIn={this.state.user_signed_in}/> }
        </li>
      </List>
    </div>
  );
  }
};