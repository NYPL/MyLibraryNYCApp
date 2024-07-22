import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Link,
  List,
  Flex,
  Spacer,
  Logo,
  useColorMode,
  useColorModeValue,
} from "@nypl/design-system-react-components";

import AccountDetailsSubMenu from "../AccountDetailsSubMenu/AccountDetailsSubMenu";
import ColorModeComponent from "./../ColorMode/ColorMode";

export default function Navbar(props) {
  const navigate = useNavigate();
  const { colorMode } = useColorMode();
  const mlnLogo = useColorModeValue("mlnColor", "mlnWhite");
  const hideHomeSignUpMsg = () => {
    props.hideSignUpMessage(true);
    if (env.RAILS_ENV !== "test") {
      navigate("/");
    }
  };
  
  const hideSignInMsg = () => {
    props.hideSignInMessage(true);
  };

  return (
      <div id="mln-navbar" className="header-topWrapper">
        <Flex alignItems="center">
          <Link href="/" onClick={hideHomeSignUpMsg} aria-label="MyLibraryNYC homepage">
            <Logo
              id="mln-nav-bar-header-logo"
              marginLeft="m"
              decorative
              name={mlnLogo}
              size="small"
              className="desktopMlnLogo"
            />
          </Link>
          <Spacer />
          <nav>
            <List
              id="mln-navbar-list"
              type="ul"
              inline
              noStyling
              key="mln-navbar-list-key"
            >
              <li id="mln-navbar-ts-link">
                <Link
                  marginRight="m"
                  href="/teacher_set_data"
                  onClick={hideSignInMsg}
                  className={`${colorMode} nav-link-colors`}
                >
                  Search Teacher Sets
                </Link>
              </li>

              <li id="mln-navbar-contacts-link">
                <Link
                  href="/contact"
                  onClick={hideSignInMsg}
                  className={`${colorMode} nav-link-colors`}
                >
                  Contact
                </Link>
              </li>

              <li id="mln-navbar-faq-link">
                <Link
                  marginLeft="m"
                  marginRight="m"
                  href="/faq"
                  onClick={hideSignInMsg}
                  className={`${colorMode} nav-link-colors`}
                >
                  FAQ
                </Link>
              </li>

              <li id="mln-navbar-ps-link">
                <Link
                  marginRight="m"
                  href="/participating-schools"
                  onClick={hideSignInMsg}
                  className={`${colorMode} nav-link-colors`}
                >
                  Participating Schools
                </Link>
              </li>

              <li id="mln-navbar-ad-link" className={`${colorMode} nav__menu-item`}>
                <AccountDetailsSubMenu
                  userSignedIn={props.userSignedIn}
                  handleSignOutMsg={props.handleSignOutMsg}
                  hideSignUpMessage={props.hideSignUpMessage}
                  handleLogout={props.handleLogout}
                />
              </li>

              <li
                id="color-mode-icon"
                className={`${colorMode} colorModeIcon`}
              > {<ColorModeComponent />}
              </li>
            </List>
          </nav>
        </Flex>
      </div>
  );
}
