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

import { Link, Flex, Icon, HStack, Image, List, Spacer} from "@nypl/design-system-react-components";

import { LionLogoIcon, LocatorIcon, MenuIcon, 
         LoginIcon, LoginIconSolid, SearchIcon, XIcon } from '@nypl/dgx-svg-icons';
import { extend as _extend } from 'underscore';
import mlnLogoRed1 from '../images/MLN_Logo_red.png'

const styles = {
  base: {
    position: 'relative',
    height: '60px',
    padding: 0,
    margin: 0,
  },
  list: {
    margin: 0,
    padding: 0,
    listStyleType: 'none',
    float: 'right',
    lineHeight: 'normal',
  },
  listItem: {
    display: 'inline-block',
    padding: 0,
    margin: '0 -8 0 4px',
    lineHeight: 'normal',
    backgroundColor: '#121212',
  },
  mobileLogoLink: {
    color: '#000',
    backgroundColor: '#FFF',
    textDecoration: 'none',
    display: 'inline-block',
    height: 50,
    width: '50px',
    position: 'absolute',
    left: '10px',
    top: '8px',
    margin: 0,
    padding: 0,
    ':hover': {
      color: '#000',
    },
    ':visited': {
      color: '#000',
    },
  },
  locationsLink: {
    margin: 0,
    padding: '11px 13px',
    display: 'inline-block',
    color: '#000',
    backgroundColor: '#FFF',
  },
  myNyplButton: {
    margin: 0,
    padding: '12px 13px',
    display: 'inline-block',
    border: 'none',
    lineHeight: 'normal',
    verticalAlign: '0px',
  },
  activeMyNyplButton: {
    color: '#FFF',
    backgroundColor: '#2B2B2B',
  },
  inactiveMyNyplButton: {
    color: '#000',
    backgroundColor: '#FFF',
  },
  searchButton: {
    margin: 0,
    padding: '12px 13px',
    display: 'inline-block',
    border: 'none',
    lineHeight: 'normal',
    verticalAlign: '0px',
  },
  activeSearchButton: {
    color: '#FFF',
    backgroundColor: '#1B7FA7',
  },
  inactiveSearchButton: {
    color: '#000',
    backgroundColor: '#FFF',
  },
  menuButton: {
    margin: 0,
    padding: '12px 13px',
    display: 'inline-block',
    border: 'none',
    lineHeight: 'normal',
    verticalAlign: '0px',
  },
  activeMenuButton: {
    color: '#FFF',
    backgroundColor: '#2B2B2B',
  },
  inactiveMenuButton: {
    color: '#000',
    backgroundColor: '#FFF',
  },
};



export default class MobileHeader extends Component {

  constructor(props) {
    super(props);

    this.state = {
      activeButton: '',
    };
  }

/**
 * toggleMobileActiveBtn(activeButton)
 * This function either activates or deactivates the state of the button that was clicked on,
 * to track the active state SCSS styles.
 *
 * @param {String} activeButton
 */
toggleMobileActiveBtn(activeButton) {
  if (activeButton === 'clickSearch') {
    const searchActive = this.state.activeButton === 'search' ? '' : 'search';
    this.setState({ activeButton: searchActive });
  } else if (activeButton === 'mobileMenu') {
    const navMenuActive = this.state.activeButton === 'navMenu' ? '' : 'navMenu';
    this.setState({ activeButton: navMenuActive });
  } else if (activeButton === 'clickLogIn' || activeButton === 'clickMyAccount') {
    const menuActive = this.state.activeButton === 'myNypl' ? '' : 'myNypl';
    this.setState({ activeButton: menuActive });
  }
}

componentDidMount() {
  document.body.addEventListener("click", () => {
    if (this.state.activeButton) {
      this.setState({ activeButton: "" });
    }
  });
}

renderMenuButton() {
  let mobileMenuClass = '';
  let icon = <Icon align="right" color="ui.black" decorative iconRotation="rotate0" id="icon-id" name="utilityHamburger" size="medium" type="default" />;
  let buttonStyles = styles.inactiveMenuButton;
  let buttonLabel = 'Open Navigation';
  let dialogWindow = null;
  const active = this.state.activeButton === 'navMenu';

  if (active) {
    mobileMenuClass = ' active';
    icon = <Icon color="ui.white" align="right" name="close" size="medium" type="default"  />;
    buttonStyles = styles.activeMenuButton;
    buttonLabel = 'Close Navigation';
    dialogWindow = (
      <MobileNavbarSubmenu />
    );
  }

  // The desired initialFocus selector only exists when active:
  const initialFocus = active ? 'ul.header-mobile-navMenu-list li:first-of-type a' : null;


  return (
    <li style={styles.listItem}>
      <FocusTrap
        id="dasdsdd"
        style={{ "margin": "0px -8px 0px 0px", "background-color": "#121212" }}
        focusTrapOptions={{
          initialFocus,
          clickOutsideDeactivates: true,
        }}
      >
        <ReactTappable
          className={`${this.props.className}-menuButton${mobileMenuClass}`}
          component="button"
          style={_extend(styles.menuButton, buttonStyles)}
          onTap={() => this.toggleMobileActiveBtn('mobileMenu')}
          aria-haspopup="true"
          aria-expanded={active ? true : null}
          ref="navMenuBtnFocus"
          onClick="OpenLinks();"
        >
          
        {icon}
        </ReactTappable>
        <div className={`header-mobile-wrapper${mobileMenuClass}`}>
          {dialogWindow}
        </div>
      </FocusTrap>
    </li>
  );
}


  render() {
    return (
      <Flex alignItems="center" id="mln-mobile-header-topWrapper">
        <ReactRouterLink to="/">
          <Image id="mln-header-logo" alt="Alt text" className="header-logo homeLogo" additionalImageStyles={{ "background-color": "var(--nypl-colors-ui-white)", "width": "7em", "margin-left": "1em"}} size="small" src={mlnLogoRed} />
          <Image id="mln-header-logo" alt="Alt text" className="header-logo homeLogo" additionalImageStyles={{ "background-color": "var(--nypl-colors-ui-white)", "width": "7em", "margin-left": "1em"}} size="small" src={Vector} />
        </ReactRouterLink>
        <Spacer />         
        <List id="mobile-mln-navbar-list" type="ul" inline noStyling marginTop="s" marginRight="xs">
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
            {this.renderMenuButton()}
          </HStack>
        </List>
      </Flex>
    )
  }
}



MobileHeader.propTypes = {
  lang: PropTypes.string,
  className: PropTypes.string,
  // locatorUrl: PropTypes.string.isRequired,
  nyplRootUrl: PropTypes.string,
  alt: PropTypes.string,
  isLoggedIn: PropTypes.bool,
  patronName: PropTypes.string,
  // logOutLink: PropTypes.string.isRequired,
  // navData: PropTypes.arrayOf(PropTypes.object).isRequired,
  // urlType: PropTypes.string.isRequired,
};


MobileHeader.defaultProps = {
  lang: 'en',
  isLoggedIn: false,
  patronName: null,
  className: 'mobileHeader',
  nyplRootUrl: '/',
  alt: 'The New York Public Library',
};
