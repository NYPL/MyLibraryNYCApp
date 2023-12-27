import FocusLock from "@chakra-ui/focus-lock";
import React, { useState, useRef } from "react";
import axios from "axios";
import { Link as ReactRouterLink, useNavigate } from "react-router-dom";
import {
  Link,
  Icon,
  List,
  Spacer,
  HorizontalRule,
  Box,
  Logo,
  Button,
  useColorModeValue,
  useCloseDropDown,
  HStack,
} from "@nypl/design-system-react-components";

import ColorMode from "./ColorMode/ColorMode";

export default function MobileHeader(props) {
  const navigate = useNavigate();
  const ref = useRef(null);
  const [mobileMenuActive, setMobileMenuActive] = useState(false);
  useCloseDropDown(setMobileMenuActive, ref);

  const mlnLogo = useColorModeValue("mlnColor", "mlnWhite");
  const iconColors = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );

  const signInAccountDetails = () => {
    if (props.details.userSignedIn) {
      return (
        <Link
          href="/account_details"
          className="nav-link-colors mobileNavbarLinks"
          aria-label="Account Details"
          id="mobile-navbar-account-link-id"
        >
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
      );
    } else {
      return (
        <Link
          href="/signin"
          className="nav-link-colors mobileNavbarLinks"
          aria-label="Sign in"
          id="mobile-navbar-signin-link-id"
        >
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
        </Link>
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
    <HStack alignItems="center" id="mln-mobile-header-topWrapper">
      <Link href="/">
        <Logo
          id="mln-mobile-header-logo"
          decorative
          name={mlnLogo}
          size="xsmall"
          marginLeft="s"
        />
      </Link>
      <Spacer />
      <nav>
        <HStack alignItems="center" display="flex">
          <Box ref={ref}>
            <FocusLock isDisabled={!mobileMenuActive}>
              <Link
                href="/teacher_set_data"
                className="nav-link-colors mobileNavbarLinks"
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
              </Link>
            </FocusLock>
          </Box>
          <Box ref={ref}>
            <FocusLock isDisabled={!mobileMenuActive}>
              {signInAccountDetails()}
            </FocusLock>
          </Box>
          <Box ref={ref}>
            <FocusLock isDisabled={!mobileMenuActive}>
              {<ColorMode />}
            </FocusLock>
          </Box>
          <Box ref={ref}>
            <FocusLock isDisabled={!mobileMenuActive}>
              <Button
                aria-haspopup="true"
                id="mobile-navbar-close-open-button-id"
                aria-label={
                  mobileMenuActive ? "Close Navigation" : "Open Navigation"
                }
                aria-expanded={mobileMenuActive ? true : null}
                buttonType="text"
                onClick={() => {
                  setMobileMenuActive(!mobileMenuActive);
                }}
                className={
                  mobileMenuActive
                    ? "mobile-navmenu-hamburger mobileNavbarButton"
                    : "mobileNavbarButton hamBurger"
                }
              >
                <Icon
                  id="mobile-sub-menu"
                  color={mobileMenuActive ? "ui.white" : iconColors}
                  name={mobileMenuActive ? "close" : "utilityHamburger"}
                  iconRotation="rotate0"
                  decorative
                  type="default"
                  size="large"
                />
              </Button>
              {mobileMenuActive && (
                <Box id="mobile-navbar-submenu-list">
                  <List
                    key="mobile-navbar-submenu-list-key"
                    noStyling
                    type="ul"
                    padding="s"
                    className={
                      mobileMenuActive ? "nav-links-mobile" : "nav-links-none"
                    }
                  >
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
                      <Link
                        className="mobileSubmenu"
                        href="/participating-schools"
                      >
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
              )}
            </FocusLock>
          </Box>
        </HStack>
      </nav>
    </HStack>
  );
}
