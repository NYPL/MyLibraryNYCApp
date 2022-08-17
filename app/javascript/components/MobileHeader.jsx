import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import ReactTappable from 'react-tappable';
import FocusTrap from 'focus-trap-react';
import MobileNavbarSubmenu from "./MobileNavbarSubmenu";
import mlnLogoRed from '../images/MyLibrary_NYC_Red.png'
import Vector from '../images/Vector.png'
import axios from 'axios';
import { BrowserRouter as Router, Redirect, Link as ReactRouterLink, useHistory } from "react-router-dom";

import { Link, Flex, Icon, HStack, Image, List, Spacer, HorizontalRule, Center, Box, Logo, Square} from "@nypl/design-system-react-components";

import { LionLogoIcon, LocatorIcon, MenuIcon, 
         LoginIcon, LoginIconSolid, SearchIcon, XIcon } from '@nypl/dgx-svg-icons';
import { extend as _extend } from 'underscore';
import mlnLogoRed1 from '../images/MLN_Logo_red.png'


export default function MobileHeader(props) {

  let history = useHistory();

  const [mobileMenuActive, setMobileMenuActive] = useState(false)

  const showMobileMenu = event => {
    return <MobileNavbarSubmenu />
  }

  const signInAccountDetails = () => {
    if (props.details.userSignedIn) {
      return <li id="mobile-mln-navbar-account-link">
              <ReactRouterLink to="/account_details" className="nav-link-colors" >
                <Icon align="right" color="ui.black" decorative iconRotation="rotate0" id="mobile-account-icon-id" name="utilityAccountFilled" size="large" type="default" />
              </ReactRouterLink>
          </li>
    } else {
        return <li id="mobile-mln-navbar-signin-link">
          <ReactRouterLink to="/signin" className="nav-link-colors">
            <Icon align="right" color="ui.black" decorative iconRotation="rotate0" id="mobile-signin-icon-id" name="actionExit" size="large" type="default" />
          </ReactRouterLink>
        </li>
    }
  }


  function mobileSignOut(){
    axios.delete('/logout')
      .then(res => {
        if (res.data.status == 200 && res.data.logged_out == true) {
          props.details.handleLogout(false)
          props.details.handleSignOutMsg(res.data.sign_out_msg, false)
          props.details.hideSignUpMessage(false)
          setMobileMenuActive(!mobileMenuActive)
          history.push("/");
        }
      })
      .catch(function (error) {
        console.log(error);
    })    
  }

  const navMenuSignInAccountDetails = () => {
    if (props.details.userSignedIn) {
      return <li> 
              <ReactRouterLink className="mobileSubmenu" onClick={mobileSignOut}>Sign Out</ReactRouterLink>
              <HorizontalRule align="right" className="mobileHorizontalRule"/>
            </li>
    } else {
        return <li>
                  <Link className="mobileSubmenu" href="/signin">Sign In</Link>
                  <HorizontalRule align="right" className="mobileHorizontalRule"/>
                </li>
    }
  }

  return (
    <Flex alignItems="center" id="mln-mobile-header-topWrapper">
      <ReactRouterLink to="/">
        <Logo id="mln-mobile-header-logo" decorative name="mlnColor" size="xsmall" />
      </ReactRouterLink>
      <Spacer />         
      <List id="mobile-mln-navbar-list" type="ul" inline noStyling marginTop="s" marginRight="xs" >
        <HStack spacing="xs">
          <li id="mobile-mln-navbar-ts-link">
            <ReactRouterLink to="/teacher_set_data" className="nav-link-colors">
              <Icon align="right" color="ui.black" decorative iconRotation="rotate0" id="icon-id" name="search" size="large" type="default" />
            </ReactRouterLink>
          </li>
          {signInAccountDetails()}
          <li>
            <Icon onClick={() => setMobileMenuActive(!mobileMenuActive)} id="mobile-sub-menu"  align="right" color="ui.black" decorative iconRotation="rotate0" id="icon-id" name="utilityHamburger" size="large" type="default" />
            <Box id="mobile-navbar-submenu-list" >
              <List noStyling type="ul" className={mobileMenuActive? "nav-links-mobile" : "nav-links-none"}>
                <li>
                  <Square marginTop="xs" position="absolute" right="s" size="50px" bg="var(--nypl-colors-ui-gray-xx-dark)">
                    <Icon onClick={() => setMobileMenuActive(!mobileMenuActive)} color="ui.white" align="right" name="close" size="large" type="default"  /> 
                  </Square>
                </li>
                <li>
                  <Center>
                    <Link marginTop="l" href="/">
                      <Logo id="mln-mobile-nav-menu-header-logo" marginTop="m" decorative name="mlnColor" size="small" />
                    </Link>
                 </Center>
                </li>

                {navMenuSignInAccountDetails()}

                <li>
                  <Link className="mobileSubmenu" href="/contacts">Contact</Link>
                  <HorizontalRule align="right" className="mobileHorizontalRule"/>
                </li>
                
                <li>
                  <Link className="mobileSubmenu" href="/faq">FAQ</Link>
                  <HorizontalRule align="right" className="mobileHorizontalRule"/>
                </li>
                
                <li>
                  <Link className="mobileSubmenu" href="/participating-schools">Participating Schools</Link>
                  <HorizontalRule align="right" className="mobileHorizontalRule"/>
                </li>
                
                <li id="mln-navbar-social-media-link" className="mobileSubmenu nav__menu-item socialMediaIcon" >
                  <Link type="action" target="_blank" href="https://twitter.com/mylibrarynyc/">
                    <Icon align="right" color="ui.white" decorative iconRotation="rotate0" id="icon-id" name="socialTwitter" size="medium" type="default" />
                  </Link>
                
                  <Link type="action" target="_blank" href="https://www.instagram.com/mylibrarynyc/" marginLeft="s">
                    <Icon align="right" color="ui.white" decorative iconRotation="rotate0" id="icon-id" name="socialInstagram" size="medium" type="default" />
                  </Link>
                </li>
              </List>
            </Box>
          </li>
        </HStack>
      </List>
    </Flex>
  )
  
}
