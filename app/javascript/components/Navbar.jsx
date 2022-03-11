import React, { Component, useState } from 'react';
import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import axios from 'axios';
import { Link, LinkTypes, Icon, List, ListTypes, Button, ButtonTypes, Box, Image, ImageSizes, ImageRatios} from "@nypl/design-system-react-components";
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
      return <li className="nav__submenu-item"> <ReactRouterLink to="/signin"> <Button className="signin_nav_button" buttonType={ButtonTypes.NoBrand}>Sign In</Button> </ReactRouterLink> </li>
    }
  }

  signOut() {
    axios.delete('/logout')
      .then(res => {
        if (res.data.status == 200 && res.data.logged_out == true) {
          window.location = "http://" + process.env.MLN_INFO_SITE_HOSTNAME;
          return false;
        }
      })
      .catch(function (error) {
        console.log(error);
    })    
  }

  AccountOrderLink() {
    if (this.state.user_signed_in) {
      return <>
        <li className="nav__submenu-item"><ReactRouterLink className="nav-link-colors" to="/account_details">My Account & Orders</ReactRouterLink></li>
        <li className="nav__submenu-item"><ReactRouterLink className="nav-link-colors" onClick={this.signOut}>Sign Out</ReactRouterLink></li>
      </>
    } else {
      return <>
        <li className="nav__submenu-item" ><ReactRouterLink className="nav-link-colors" to="/signin">My Account & Orders</ReactRouterLink></li>
        <li className="nav__submenu-item"><ReactRouterLink className="nav-link-colors" to="/signup">Not Registered ? Please Sign Up</ReactRouterLink></li>
      </>
    }
  }

  render() {
    return (
      <Box>
        <List id="navbar-account-details" type={ListTypes.Ordered} inline={false} noStyling={false} className="nav__submenu">
          {this.signInAccountLinks()}
          {this.AccountOrderLink()}
        </List>
      </Box>
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
      return <>
        <ReactRouterLink to="/account_details" className="nav-link-colors" onMouseEnter={this.handleHover}>Account{' '}
          <Icon id="account-arrow-drop-down-id" size="small">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512">
              <path d="M310.6 246.6l-127.1 128C176.4 380.9 168.2 384 160 384s-16.38-3.125-22.63-9.375l-127.1-128C.2244 237.5-2.516 223.7 2.438 211.8S19.07 192 32 192h255.1c12.94 0 24.62 7.781 29.58 19.75S319.8 237.5 310.6 246.6z"/>
            </svg>
          </Icon>
        </ReactRouterLink>
      </>
    } else {
      return <>
        <ReactRouterLink to="/signin" className="nav-link-colors" onMouseEnter={this.handleHover}>Sign In{' '}
          <Icon id="signin-arrow-drop-down-id" size="small">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512">
              <path d="M310.6 246.6l-127.1 128C176.4 380.9 168.2 384 160 384s-16.38-3.125-22.63-9.375l-127.1-128C.2244 237.5-2.516 223.7 2.438 211.8S19.07 192 32 192h255.1c12.94 0 24.62 7.781 29.58 19.75S319.8 237.5 310.6 246.6z"/>
            </svg>
          </Icon>
        </ReactRouterLink>
      </>
    }
  }

  render() {
    return (
      <div id="mln-navbar-id" className="header-topWrapper">
        <ReactRouterLink to="/">
          <div id="mln-header-logo" className="header-logo">
            <Image id="mln-header-logo" className="header-logo" alt="Alt text" imageSize={ImageSizes.Small} src={mlnLogoRed} />
          </div>
        </ReactRouterLink>
      
        <List id="mln-navbar-list" type="ul" inline noStyling className="header-buttons" className="float-right">

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