import React, { useState } from "react";
import axios from "axios";
import { Link as ReactRouterLink, useNavigate } from "react-router-dom";
import {
  Link,
  Flex,
  Icon,
  List,
  Spacer,
  HorizontalRule,
  Center,
  Box,
  Logo,
  Button,
  useColorModeValue,
} from "@nypl/design-system-react-components";

import ColorMode from "./ColorMode/ColorMode";

export default function MobileHeader(props) {
  const navigate = useNavigate();
  const [mobileMenuActive, setMobileMenuActive] = useState(false);
  const mlnLogo = useColorModeValue("mlnColor", "mlnWhite");

  const iconColors = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );

  const signInAccountDetails = () => {
    if (props.details.userSignedIn) {
      return (
        <li id="mobile-mln-navbar-account-link">
          <Link href="/account_details" className="nav-link-colors">
            <Icon
              align="right"
              color={iconColors}
              decorative
              iconRotation="rotate0"
              id="mobile-account-icon-id"
              name="utilityAccountFilled"
              size="large"
              type="default"
            />
          </Link>
        </li>
      );
    } else {
      return (
        <li id="mobile-mln-navbar-signin-link">
          <ReactRouterLink to="/signin" className="nav-link-colors" aria-label="Sign in">
            <Icon
              align="right"
              color={iconColors}
              decorative
              iconRotation="rotate0"
              id="mobile-signin-icon-id"
              name="actionExit"
              size="large"
              type="default"
            />
          </ReactRouterLink>
        </li>
      );
    }
  };

  function mobileSignOut() {
    axios
      .delete("/users/logout")
      .then((res) => {
        if (res.data.status === 200 && res.data.logged_out === true) {
          props.details.handleLogout(false);
          props.details.handleSignOutMsg(res.data.sign_out_msg, false);
          props.details.hideSignUpMessage(false);
          setMobileMenuActive(!mobileMenuActive);
          navigate("/");
        }
      })
      .catch(function (error) {
        console.log(error);
      });
  }

  const navMenuSignInAccountDetails = () => {
    if (props.details.userSignedIn) {
      return (
        <li>
          <ReactRouterLink className="mobileSubmenu" onClick={mobileSignOut}>
            Sign Out
          </ReactRouterLink>
          <HorizontalRule align="right" className="mobileHorizontalRule" />
        </li>
      );
    } else {
      return (
        <li>
          <Link className="mobileSubmenu" href="/signin" aria-label="Sign in">
            Sign In
          </Link>
          <HorizontalRule align="right" className="mobileHorizontalRule" />
        </li>
      );
    }
  };

  return (
    <Flex alignItems="center" id="mln-mobile-header-topWrapper">
      <ReactRouterLink to="/">
        <Logo
          id="mln-mobile-header-logo"
          decorative
          name={mlnLogo}
          size="xsmall"
          marginLeft="s"
        />
      </ReactRouterLink>
      <Spacer />
      <nav>
        <List
          id="mobile-mln-navbar-list"
          key="mobile-mln-navbar-list-key"
          type="ul"
          inline
          noStyling
          marginTop="s"
          marginRight="xs"
        >
          <li id="mobile-mln-navbar-ts-link">
            <ReactRouterLink
              to="/teacher_set_data"
              className="nav-link-colors"
              aria-label="Search teacher sets"
            >
              <Icon
                align="right"
                color={iconColors}
                decorative
                iconRotation="rotate0"
                id="mobile-search-ts-icon-id"
                name="utilitySearch"
                size="large"
                type="default"
              />
            </ReactRouterLink>
          </li>
          {signInAccountDetails()}
          <li>{<ColorMode />}</li>
          <li>
            <button aria-label="Show main menu" onClick={() => setMobileMenuActive(!mobileMenuActive)}>
              <Icon
                id="mobile-sub-menu"
                align="right"
                color={iconColors}
                decorative
                iconRotation="rotate0"
                name="utilityHamburger"
                size="large"
                type="default"
              />
            </button>
            <Box id="mobile-navbar-submenu-list">
              <List
                key="mobile-navbar-submenu-list-key"
                noStyling
                type="ul"
                className={
                  mobileMenuActive ? "nav-links-mobile" : "nav-links-none"
                }
              >
                <li>
                  <Button
                    marginTop="xs"
                    position="absolute"
                    right="s"
                    top="xs"
                    size="50px"
                    className="mobile-submenu-close-btn"
                    bg="var(--nypl-colors-ui-gray-xx-dark)"
                    aria-label="Close main menu"
                    buttonType="secondary"
                    id="mobile-submenu-close-btn"
                  >
                    <Icon
                      onClick={() => setMobileMenuActive(!mobileMenuActive)}
                      color="ui.white"
                      align="right"
                      name="close"
                      size="large"
                      type="default"
                    />
                  </Button>
                </li>
                <li>
                  <Center>
                    <Link marginTop="l" href="/">
                      <Logo
                        id="mln-mobile-nav-menu-header-logo"
                        marginTop="m"
                        decorative
                        name="mlnColor"
                        size="small"
                      />
                    </Link>
                  </Center>
                </li>

                {navMenuSignInAccountDetails()}

                <li>
                  <Link className="mobileSubmenu" href="/contact">
                    Contact
                  </Link>
                  <HorizontalRule
                    align="right"
                    className="mobileHorizontalRule"
                  />
                </li>

                <li>
                  <Link className="mobileSubmenu" href="/faq">
                    FAQ
                  </Link>
                  <HorizontalRule
                    align="right"
                    className="mobileHorizontalRule"
                  />
                </li>

                <li>
                  <Link className="mobileSubmenu" href="/participating-schools">
                    Participating Schools
                  </Link>
                  <HorizontalRule
                    align="right"
                    className="mobileHorizontalRule"
                  />
                </li>

                <li
                  id="mln-navbar-social-media-link"
                  className="mobileSubmenu socialMediaIcon"
                >
                  <Link
                    type="action"
                    target="_blank"
                    href="https://twitter.com/mylibrarynyc/"
                  >
                    <Icon
                      align="right"
                      color="ui.white"
                      decorative
                      iconRotation="rotate0"
                      id="icon-id"
                      name="socialTwitter"
                      size="medium"
                      type="default"
                    />
                  </Link>

                  <Link
                    type="action"
                    target="_blank"
                    href="https://www.instagram.com/mylibrarynyc/"
                    marginLeft="s"
                  >
                    <Icon
                      align="right"
                      color="ui.white"
                      decorative
                      iconRotation="rotate0"
                      id="icon-id"
                      name="socialInstagram"
                      size="medium"
                      type="default"
                    />
                  </Link>
                </li>
              </List>
            </Box>
          </li>
        </List>
      </nav>
    </Flex>
  );
}
