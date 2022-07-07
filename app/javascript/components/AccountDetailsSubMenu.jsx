import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import { Route, BrowserRouter as Router, Switch , Redirect, Link as ReactRouterLink, withRouter} from "react-router-dom";

import axios from 'axios';
import AppBreadcrumbs from "./AppBreadcrumbs";
import Home from "./Home";
import {
  Input, TextInput, List, Icon, Form, Button, FormRow, InputTypes, Label, FormField, 
  DSProvider, TemplateAppContainer, Select, Heading, Link, LinkTypes, Box, HStack
} from '@nypl/design-system-react-components';


class AccountDetailsSubMenu extends React.Component {

  constructor(props) {
    super(props);
    this.state = { user_signed_in: this.props.userSignedIn, showAboutMenu: false}
    this.handleHover = this.handleHover.bind(this);
    this.handleLeave = this.handleLeave.bind(this);
  }

  redirectToHome = () => {
   const { history } = this.props;
   if(history) history.push({ pathname: '/' });
  }

  signInAccountLinks() {
    if (!this.props.userSignedIn) {
      return <li className="nav__submenu-item"> <ReactRouterLink to="/signin"> <Button className="signin_nav_button" buttonType="noBrand">Sign In</Button> </ReactRouterLink> </li>
    }
  }

  handleHover = (event) => {
    this.setState({ showAboutMenu: true });
  };

  handleLeave = (event) => {
    this.setState({ showAboutMenu: false });
  };

  showAccountSigninLink() {
    if (this.props.userSignedIn) {
      return <>
        <ReactRouterLink to="/account_details" className="nav-link-colors navBarDropDown" onMouseEnter={this.handleHover}>
        <Icon className="navBarIcon" align="right" color="ui.black" decorative iconRotation="rotate0" id="icon-id" name="utilityAccountFilled" size="medium" type="default" />
          My Account{' '}
          <Icon id="account-arrow-drop-down" size="small" className="navBarIcon">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512">
              <path d="M310.6 246.6l-127.1 128C176.4 380.9 168.2 384 160 384s-16.38-3.125-22.63-9.375l-127.1-128C.2244 237.5-2.516 223.7 2.438 211.8S19.07 192 32 192h255.1c12.94 0 24.62 7.781 29.58 19.75S319.8 237.5 310.6 246.6z"/>
            </svg>
          </Icon>
        </ReactRouterLink>
      </>
    } else {
      return <>
        <ReactRouterLink to="/signin" className="nav-link-colors navBarDropDown" onMouseEnter={this.handleHover}>
        <Icon className="navBarIcon" align="right" color="ui.black" decorative iconRotation="rotate0" id="icon-id" name="actionExit" size="medium" type="default" />
            Sign In{' '}
            <Icon id="signin-arrow-drop-down" size="small" className="navBarIcon" >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512">
              <path d="M310.6 246.6l-127.1 128C176.4 380.9 168.2 384 160 384s-16.38-3.125-22.63-9.375l-127.1-128C.2244 237.5-2.516 223.7 2.438 211.8S19.07 192 32 192h255.1c12.94 0 24.62 7.781 29.58 19.75S319.8 237.5 310.6 246.6z"/>
            </svg>
          </Icon>
        </ReactRouterLink>

      </>
    }
  }

  signOut = event => {
    axios.delete('/logout')
      .then(res => {
        if (res.data.status == 200 && res.data.logged_out == true) {
          this.setState({ user_signed_in: false, showAboutMenu: false });
          this.props.handleSignOutMsg(res.data.sign_out_msg, false)
          this.props.hideSignUpMessage(false)
          this.redirectToHome()          
        }
      })
      .catch(function (error) {
        console.log(error);
    })    
  }

  AccountOrderLink() {
    if (this.props.userSignedIn) {
      return <>
        <List id="navbar-account-details" type="ol" inline={false} noStyling={false} className="nav__submenu account_details">
          <li className="nav__submenu-item">
            <ReactRouterLink className="navBarDropDown" to="/account_details">
              <Icon align="right" className="navBarIcon" color="var(--nypl-colors-ui-gray-dark)" decorative iconRotation="rotate0" id="icon-id" name="actionSettings" size="medium" type="default" />
              Settings
            </ReactRouterLink>
          </li>

          <li className="nav__submenu-item">
            <ReactRouterLink className="navBarDropDown" to="/account_details">
              <Icon align="right" className="navBarIcon" color="var(--nypl-colors-ui-gray-dark)" decorative iconRotation="rotate0" id="icon-id" name="check" size="medium" type="default" />
              My Orders
            </ReactRouterLink>
          </li>

          <li className="nav__submenu-item">
            <ReactRouterLink className="navBarDropDown" onClick={this.signOut}>
              <Icon align="right" className="navBarIcon" color="var(--nypl-colors-ui-gray-dark)" decorative iconRotation="rotate0" id="icon-id" name="actionPower" size="medium" type="default" />
              Sign Out
            </ReactRouterLink>
          </li>
        </List>
      </>
    } else {
      return <>
          <List id="navbar-account-details" type="ol" inline={false} noStyling={false} className="nav__submenu signin_details">
            <li className="nav__submenu-item">
              <ReactRouterLink to="/signin">
                <Button className="signin_nav_button" buttonType="noBrand">Sign In</Button>
              </ReactRouterLink>
            </li>

            <li className="nav__submenu-item" >
              <ReactRouterLink className="navBarDropDown" to="/signin">
                <Icon className="navBarIcon" align="right" color="var(--nypl-colors-ui-gray-dark)" decorative iconRotation="rotate0" id="icon-id" name="utilityAccountFilled" size="medium" type="default" />
                My Account
              </ReactRouterLink>
            </li>
            <li className="nav__submenu-item">
              <ReactRouterLink className="navBarDropDown" to="/signup">
                <Icon className="navBarIcon" align="right" color="var(--nypl-colors-ui-gray-dark)" decorative iconRotation="rotate0" id="icon-id" name="utilityAccountFilled" size="medium" type="default" />
                Not Registered? Please Sign Up
              </ReactRouterLink>
            </li>
          </List>
      </>
    }
  }

  render() {
    return (
      <>
        { this.showAccountSigninLink() }
        { this.state.showAboutMenu && <Box>
            {this.AccountOrderLink() }
        </Box>}
      </>
    )
  }
}

export default withRouter(AccountDetailsSubMenu);
