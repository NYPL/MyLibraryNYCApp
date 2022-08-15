import React, { Component, useState } from 'react';
import PropTypes from 'prop-types';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";
import { Link, Icon, List, VStack, HorizontalRule } from "@nypl/design-system-react-components";


export default function MobileNavbarSubmenu(props) {

  const mobileActiveClass = this.props.mobileMenuActive ? 'mobileMenuActive' : '';


  return (
    <div className="navMenu-wrapper">
      <List type="ul" noStyling marginLeft="s" marginBottom="s">
        <li style={{"margin-top": "16px"}}>
          <ReactRouterLink className="mobileSubmenu" to="/signin">Sign In</ReactRouterLink>
          <HorizontalRule align="left" className="mobileHorizontalRule"/>
        </li>
        <li>
          <ReactRouterLink className="mobileSubmenu" to="/contacts">Contact</ReactRouterLink>
          <HorizontalRule align="left" className="mobileHorizontalRule"/>
        </li>
        
        <li>
          <ReactRouterLink className="mobileSubmenu" to="/faq">FAQ</ReactRouterLink>
          <HorizontalRule align="left" className="mobileHorizontalRule"/>
        </li>
        
        <li>
          <ReactRouterLink className="mobileSubmenu" to="/participating-schools">Participating Schools</ReactRouterLink>
          <HorizontalRule align="left" className="mobileHorizontalRule"/>
        </li>
        
        <li id="mln-navbar-social-media-link" style={{"margin-bottom": "16px"}} className="nav__menu-item socialMediaIcon" >
          <Link type="action" target="_blank" href="https://twitter.com/mylibrarynyc/">
            <Icon align="right" color="ui.white" decorative iconRotation="rotate0" id="icon-id" name="socialTwitter" size="medium" type="default" />
          </Link>
        
          <Link type="action" target="_blank" href="https://www.instagram.com/mylibrarynyc/" marginLeft="s">
            <Icon align="right" color="ui.white" decorative iconRotation="rotate0" id="icon-id" name="socialInstagram" size="medium" type="default" />
          </Link>
        </li>
      </List>
    </div>
 );
  
}

