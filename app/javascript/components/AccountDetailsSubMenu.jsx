import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import { Route, BrowserRouter as Router, Switch , Redirect, Link as ReactRouterLink, 
  useLocation,
  useParams, useNavigate} from "react-router-dom";

import axios from 'axios';
import AppBreadcrumbs from "./AppBreadcrumbs";
import Home from "./Home";
import {
  Input, TextInput, List, Icon, Form, Button, FormRow, InputTypes, Label, FormField, 
  DSProvider, TemplateAppContainer, Select, Heading, Link, LinkTypes, Box, HStack
} from '@nypl/design-system-react-components';

function AccountDetailsSubMenu(props) {
  const params = useParams();
  const navigate = useNavigate();
  const [user_signed_in, setUserSignedIn] = useState(props.userSignedIn)
  const [showAboutMenu, setShowAboutMenu] = useState(false)

  const signInAccountLinks = () => {
    if (!props.userSignedIn) {
      return <li className="nav__submenu-item"> <ReactRouterLink to="/signin"> <Button className="signin_nav_button" buttonType="noBrand">Sign In</Button> </ReactRouterLink> </li>
    }
  }

  const handleHover = (event) => {
    setShowAboutMenu(true)
  };

  const handleLeave = (event) => {
    setShowAboutMenu(false)
  };

  const showAccountSigninLink = () => {
    if (props.userSignedIn) {
      return <>
        <Link href="/account_details" className="nav-link-colors navBarDropDown" onMouseEnter={handleHover}>
        <Icon className="navBarIcon" align="right" color="ui.black" decorative iconRotation="rotate0" id="icon-id" name="utilityAccountFilled" size="medium" type="default" />
          My Account{' '}
          <Icon id="account-arrow-drop-down" size="small" className="navBarIcon">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512">
              <path d="M310.6 246.6l-127.1 128C176.4 380.9 168.2 384 160 384s-16.38-3.125-22.63-9.375l-127.1-128C.2244 237.5-2.516 223.7 2.438 211.8S19.07 192 32 192h255.1c12.94 0 24.62 7.781 29.58 19.75S319.8 237.5 310.6 246.6z"/>
            </svg>
          </Icon>
        </Link>
      </>
    } else {
      return <>
        <Link href="/signin" className="nav-link-colors navBarDropDown" onMouseEnter={handleHover}>
        <Icon className="navBarIcon" align="right" color="ui.black" decorative iconRotation="rotate0" id="icon-id" name="actionExit" size="medium" type="default" />
            Sign In{' '}
            <Icon id="signin-arrow-drop-down" size="small" className="navBarIcon" >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512">
              <path d="M310.6 246.6l-127.1 128C176.4 380.9 168.2 384 160 384s-16.38-3.125-22.63-9.375l-127.1-128C.2244 237.5-2.516 223.7 2.438 211.8S19.07 192 32 192h255.1c12.94 0 24.62 7.781 29.58 19.75S319.8 237.5 310.6 246.6z"/>
            </svg>
          </Icon>
        </Link>

      </>
    }
  }

  const signOut = event => {
    axios.delete('/users/logout', { headers: {"Content-Type": "application/json", 'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content") } })
      .then(res => {
        if (res.data.status == 200 && res.data.logged_out == true) {
          props.handleLogout(false)
          setUserSignedIn(false)
          setShowAboutMenu(false)
          props.handleSignOutMsg(res.data.sign_out_msg, false)
          props.hideSignUpMessage(false)
          navigate('/')
          //redirectToHome()  - need to fix asap       
        }
      })
      .catch(function (error) {
        console.log(error);
    })    
  }

  const AccountOrderLink = () => {
    if (props.userSignedIn) {
      return <>
        <List id="navbar-account-details" type="ol" inline={false} noStyling={false} className="nav__submenu account_details">
          <li className="nav__submenu-item">
            <Link className="navBarDropDown" href="/account_details">
              <Icon align="right" className="navBarIcon" color="var(--nypl-colors-ui-gray-dark)" decorative iconRotation="rotate0" id="icon-id" name="actionSettings" size="medium" type="default" />
              Settings
            </Link>
          </li>

          <li className="nav__submenu-item">
            <Link className="navBarDropDown" href="/account_details">
              <Icon align="right" className="navBarIcon" color="var(--nypl-colors-ui-gray-dark)" decorative iconRotation="rotate0" id="icon-id" name="check" size="medium" type="default" />
              My Orders
            </Link>
          </li>

          <li className="nav__submenu-item">
            <ReactRouterLink className="navBarDropDown" onClick={signOut}>
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
              <Link href="/signin">
                <Button id="sign-in-button" className="signin_nav_button" buttonType="noBrand">Sign In</Button>
              </Link>
            </li>

            <li className="nav__submenu-item" >
              <Link className="navBarDropDown" href="/signin">
                <Icon className="navBarIcon" align="right" color="var(--nypl-colors-ui-gray-dark)" decorative iconRotation="rotate0" id="icon-id" name="utilityAccountFilled" size="medium" type="default" />
                My Account
              </Link>
            </li>
            <li className="nav__submenu-item">
              <Link className="navBarDropDown" href="/signup">
                <Icon className="navBarIcon" align="right" color="var(--nypl-colors-ui-gray-dark)" decorative iconRotation="rotate0" id="icon-id" name="actionRegistration" size="medium" type="default" />
                Not Registered? {<br/>} Please Sign Up
              </Link>
            </li>
          </List>
      </>
    }
  }


  return (
    <>
      { showAccountSigninLink() }
      { showAboutMenu && <Box>
          {AccountOrderLink() }
      </Box>}
    </>
  )
}


export default AccountDetailsSubMenu;
