import React, { Component, useState } from 'react';
import PropTypes from 'prop-types';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";
import { Link, Icon, List, VStack, HorizontalRule } from "@nypl/design-system-react-components";


export default class MobileNavbarSubmenu extends Component {

  constructor(props) {
    super(props);

    this.state = {
      activeButton: '',
    };
  }

  render() {
    const mobileActiveClass = this.props.mobileActive ? 'mobileActive' : '';

    return (
        <div className="navMenu-wrapper">
          <List type="ul" noStyling marginLeft="s" marginBottom="s">
            <li marginTop="s">
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
}

MobileNavbarSubmenu.propTypes = {
  lang: PropTypes.string,
  className: PropTypes.string,
  urlType: PropTypes.string,
  mobileActive: PropTypes.bool,
};

MobileNavbarSubmenu.defaultProps = {
  lang: 'en',
  className: 'navMenu',
  urlType: 'relative',
  mobileActive: false,
};
