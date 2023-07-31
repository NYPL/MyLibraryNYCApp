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
  Square,
  useColorModeValue,
  useColorMode,
} from "@nypl/design-system-react-components";

export default function MobileHeader(props) {
  const navigate = useNavigate();
  const { colorMode, toggleColorMode } = useColorMode();
  const [mobileMenuActive, setMobileMenuActive] = useState(false);
  const [defaultColorMode, setDefaultColorMode] = useState(
    localStorage.getItem("chakra-ui-color-mode") || "light"
  );
  const mlnLogo = useColorModeValue("mlnColor", "mlnWhite");

  const iconColors = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );

  const darkModeIconColor = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );

  const handleChangeToDarkMode = () => {
    const newColorMode = colorMode === "light" ? "dark" : "light";
    setDefaultColorMode(newColorMode);
    console.log(
      `Color mode is switching from ${colorMode} to ${newColorMode}.`
    );
    toggleColorMode();
  };

  const signInAccountDetails = () => {
    if (props.details.userSignedIn) {
      return (
        <li id="mobile-mln-navbar-account-link">
          <ReactRouterLink to="/account_details" className="nav-link-colors">
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
          </ReactRouterLink>
        </li>
      );
    } else {
      return (
        <li id="mobile-mln-navbar-signin-link">
          <ReactRouterLink to="/signin" className="nav-link-colors">
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

  const displayColorModeIcon = () => {
    if (defaultColorMode === "dark") {
      return (
        <li
          id="mobile-color-mode-icon"
          onClick={handleChangeToDarkMode}
          className="mobileBrightnessIcon"
        >
          <svg
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <g id="icon/image/brightness/5/24px">
              <path
                id="icon/image/brightness_5_24px"
                fillRule="evenodd"
                clipRule="evenodd"
                d="M19.9995 4.185V8.875L23.3095 12.185L19.9995 15.495V20.185H15.3095L11.9995 23.495L8.68945 20.185H3.99945V15.495L0.689453 12.185L3.99945 8.875V4.185H8.68945L11.9995 0.875L15.3095 4.185H19.9995ZM17.9995 18.185V14.665L20.4795 12.185L17.9995 9.705V6.185H14.4795L11.9995 3.705L9.51945 6.185H5.99945V9.705L3.51945 12.185L5.99945 14.665V18.185H9.51945L11.9995 20.665L14.4795 18.185H17.9995ZM11.9995 6.685C8.96945 6.685 6.49945 9.155 6.49945 12.185C6.49945 15.215 8.96945 17.685 11.9995 17.685C15.0295 17.685 17.4995 15.215 17.4995 12.185C17.4995 9.155 15.0295 6.685 11.9995 6.685ZM8.49945 12.185C8.49945 14.115 10.0695 15.685 11.9995 15.685C13.9295 15.685 15.4995 14.115 15.4995 12.185C15.4995 10.255 13.9295 8.685 11.9995 8.685C10.0695 8.685 8.49945 10.255 8.49945 12.185Z"
                fill={darkModeIconColor}
              />
            </g>
          </svg>
        </li>
      );
    } else {
      return (
        <li
          id="mobile-color-mode-icon"
          onClick={handleChangeToDarkMode}
          className="mobileDarkModeIcon"
        >
          <svg
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              fillRule="evenodd"
              clipRule="evenodd"
              d="M0.5 1.70352C1.97 0.853516 3.68 0.353516 5.5 0.353516C11.02 0.353516 15.5 4.83352 15.5 10.3535C15.5 15.8735 11.02 20.3535 5.5 20.3535C3.68 20.3535 1.97 19.8535 0.5 19.0035C3.49 17.2735 5.5 14.0535 5.5 10.3535C5.5 6.65352 3.49 3.43352 0.5 1.70352ZM13.5 10.3535C13.5 5.94352 9.91 2.35352 5.5 2.35352C5.16 2.35352 4.82 2.37352 4.49 2.42352C6.4 4.58352 7.5 7.40352 7.5 10.3535C7.5 13.3035 6.4 16.1235 4.49 18.2835C4.82 18.3335 5.16 18.3535 5.5 18.3535C9.91 18.3535 13.5 14.7635 13.5 10.3535Z"
              fill="black"
            />
          </svg>
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
          <Link href="/teacher_set_data" className="nav-link-colors" aria-label="Search teacher sets">
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
        </li>
        {signInAccountDetails()}

        {displayColorModeIcon()}

        <li>
          <Icon
            onClick={() => setMobileMenuActive(!mobileMenuActive)}
            id="mobile-sub-menu"
            align="right"
            color={iconColors}
            decorative
            iconRotation="rotate0"
            name="utilityHamburger"
            size="large"
            type="default"
          />
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
                <Square
                  marginTop="xs"
                  position="absolute"
                  right="s"
                  size="50px"
                  bg="var(--nypl-colors-ui-gray-xx-dark)"
                >
                  <Icon
                    onClick={() => setMobileMenuActive(!mobileMenuActive)}
                    color="ui.white"
                    align="right"
                    name="close"
                    size="large"
                    type="default"
                  />
                </Square>
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
    </Flex>
  );
}
