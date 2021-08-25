import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import ReactTappable from 'react-tappable';
import FocusTrap from 'focus-trap-react';
import ContactsFaqsSchoolsNavMenu from "./ContactsFaqsSchoolsNavMenu";

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import { Link, LinkTypes } from "@nypl/design-system-react-components";

import { LionLogoIcon, LocatorIcon, MenuIcon, 
         LoginIcon, LoginIconSolid, SearchIcon, XIcon } from '@nypl/dgx-svg-icons';
import { extend as _extend } from 'underscore';

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
    margin: '0 0 0 4px',
    lineHeight: 'normal',
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
  let icon = <MenuIcon ariaHidden fill="#000" focusable={false} />;
  let buttonStyles = styles.inactiveMenuButton;
  let buttonLabel = 'Open Navigation';
  let dialogWindow = null;
  const active = this.state.activeButton === 'navMenu';

  if (active) {
    mobileMenuClass = ' active';
    icon = <XIcon ariaHidden fill="#FFF" focusable={false} />;
    buttonStyles = styles.activeMenuButton;
    buttonLabel = 'Close Navigation';
    dialogWindow = (
      <ContactsFaqsSchoolsNavMenu />
    );
  }

  // The desired initialFocus selector only exists when active:
  const initialFocus = active ? 'ul.header-mobile-navMenu-list li:first-of-type a' : null;



  return (
    <li style={styles.listItem}>
      <FocusTrap
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
      <div className={this.props.className} style={styles.base}>
        <Link type={LinkTypes.Action}>
          <ReactRouterLink to="/">
          <img className="homeLogo" border="0" src="/assets/MLN_Logo_red.png"/></ReactRouterLink>
        </Link>
        <ul style={styles.list} >
          <li style={styles.listItem}>
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/users/start" className="nav-link-colors">
                <LoginIcon ariaHidden fill="#000" focusable={false} />
              </ReactRouterLink>
            </Link>
          </li>
          <li style={styles.listItem}>
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/teacher_set_data" className="nav-link-colors">
                <SearchIcon ariaHidden fill="#000" focusable={false} />
              </ReactRouterLink>
            </Link>
            </li>
          {this.renderMenuButton()}
        </ul>
      </div>
    );
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
