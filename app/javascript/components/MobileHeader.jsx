import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import ReactTappable from 'react-tappable';
import FocusTrap from 'focus-trap-react';
import MobileNavbarSubmenu from "./MobileNavbarSubmenu";
import mlnLogoRed from '../images/MyLibrary_NYC_Red.png'
import Vector from '../images/Vector.png'

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import { Link, Flex, Icon, HStack, Image, List, Spacer, HorizontalRule, Center, Box, Logo, Square} from "@nypl/design-system-react-components";

import { LionLogoIcon, LocatorIcon, MenuIcon, 
         LoginIcon, LoginIconSolid, SearchIcon, XIcon } from '@nypl/dgx-svg-icons';
import { extend as _extend } from 'underscore';
import mlnLogoRed1 from '../images/MLN_Logo_red.png'


export default function MobileHeader(props) {

  const [mobileMenuActive, setMobileMenuActive] = useState(false)

  const showMobileMenu = event => {
    return <MobileNavbarSubmenu />
  }


  return (
    <Flex alignItems="center" id="mln-mobile-header-topWrapper">
      <ReactRouterLink to="/">
        <Image id="mln-header-logo" alt="Alt text" className="header-logo homeLogo" additionalImageStyles={{ "background-color": "var(--nypl-colors-ui-white)", "width": "7em", "margin-left": "1em"}} size="small" src={mlnLogoRed} />
        <Image id="mln-header-logo" alt="Alt text" className="header-logo homeLogo" additionalImageStyles={{ "background-color": "var(--nypl-colors-ui-white)", "width": "7em", "margin-left": "1em"}} size="small" src={Vector} />
      </ReactRouterLink>
      <Spacer />         
      <List id="mobile-mln-navbar-list" type="ul" inline noStyling marginTop="s" marginRight="xs" >
        <HStack spacing="xxs">
          <li id="mobile-mln-navbar-ts-link">
            <ReactRouterLink to="/teacher_set_data" className="nav-link-colors">
              <Icon align="right" color="ui.black" decorative iconRotation="rotate0" id="icon-id" name="search" size="medium" type="default" />
            </ReactRouterLink>
          </li>
          <li id="mobile-mln-navbar-signin-link">
            <ReactRouterLink to="/signin" className="nav-link-colors">
              <Icon align="right" color="ui.black" decorative iconRotation="rotate0" id="icon-id" name="actionExit" size="medium" type="default" />
            </ReactRouterLink>
          </li>

            <li>
             
                <Icon onClick={() => setMobileMenuActive(!mobileMenuActive)} id="mobile-sub-menu"  align="right" color="ui.black" decorative iconRotation="rotate0" id="icon-id" name="utilityHamburger" size="medium" type="default" />
                
                <Box id="mobile-navbar-submenu-list" >
                  <List noStyling className={mobileMenuActive? "nav-links-mobile" : "nav-links-none"}>
                    <Square top="s" position="absolute" right="s" size="50px" bg="var(--nypl-colors-ui-gray-xx-dark)">
                      <Icon onClick={() => setMobileMenuActive(!mobileMenuActive)} color="ui.white" align="right" name="close" size="large" type="default"  /> 
                    </Square>
                    <li>
                      <Center>
                        <Link href="/">
                          <Logo id="mln-mobile-header-logo" marginTop="m" decorative name="mlnColor" size="small" />
                        </Link>
                     </Center>
                    </li>
                    <li>
                      <Link className="mobileSubmenu" href="/signin">Sign In</Link>
                      <HorizontalRule align="right" className="mobileHorizontalRule"/>
                    </li>
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
                    
                    <li id="mln-navbar-social-media-link" style={{"margin-bottom": "16px"}} className="mobileSubmenu nav__menu-item socialMediaIcon" >
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
