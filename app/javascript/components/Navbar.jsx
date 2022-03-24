import React, { Component, useState } from 'react';
import {
  BrowserRouter as Router,
  Link as ReactRouterLink, useHistory
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


import AccountDetailsSubMenu from "./AccountDetailsSubMenu";


export default class Navbar extends React.Component {

  constructor(props) {
    super(props);
    this.state = { user_signed_in: this.props.userSignedIn, showAboutMenu: false}
  }

  render() {
    return (
      <div id="mln-navbar" className="header-topWrapper">
        <ReactRouterLink to="/">
          <div id="mln-header-logo" className="header-logo">
            <Image id="mln-header-logo" className="header-logo" alt="Alt text" imageSize={ImageSizes.Small} src={mlnLogoRed} />
          </div>
        </ReactRouterLink>
      
        <List id="mln-navbar-list" type="ul" inline noStyling className="header-buttons" className="float-right">

          <li id="mln-navbar-ts-link"><ReactRouterLink to="/teacher_set_data" className="nav-link-colors">Search Teacher Sets</ReactRouterLink></li>

          <li id="mln-navbar-contacts-link"><ReactRouterLink to="/contacts" className="nav-link-colors">Contacts</ReactRouterLink></li>

          <li id="mln-navbar-faq-link"><ReactRouterLink to="/faq" className="nav-link-colors">FAQs</ReactRouterLink></li>

          <li id="mln-navbar-ps-link"><ReactRouterLink to="/participating-schools" className="nav-link-colors ">Participating Schools</ReactRouterLink></li>

          <li id="mln-navbar-ad-link" className="nav__menu-item">
            <AccountDetailsSubMenu userSignedIn={this.state.user_signed_in} handleSignOutMsg={this.props.handleSignOutMsg} />
          </li>
        </List>
      </div>
    );
  }
};