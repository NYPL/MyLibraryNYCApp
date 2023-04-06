import React from "react";
import { useNavigate } from "react-router-dom";
import {
  Link,
  Icon,
  List,
  Flex,
  Spacer,
  Logo,
  Box,
  useColorMode,
  useColorModeValue,
} from "@nypl/design-system-react-components";
import DarkModeToggle from "./../DarkModeToggle/DarkModeToggle";

import AccountDetailsSubMenu from "./../AccountDetailsSubMenu";

export default function Navbar(props) {
  const navigate = useNavigate();
  const { colorMode } = useColorMode();

  const socialMediaIconColor = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );

  const hideHomeSignUpMsg = () => {
    props.hideSignUpMessage(true);
    navigate("/");
  };

  const hideSignInMsg = () => {
    props.hideSignInMessage(true);
  };

  return (
    <div id="mln-navbar" className="header-topWrapper">
      <Flex alignItems="center">
        <Link href="/" onClick={hideHomeSignUpMsg}>
          <Logo
            id="mln-nav-bar-header-logo"
            marginLeft="m"
            decorative
            name="mlnColor"
            size="small"
          />
        </Link>

        <Spacer />

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
            id="mln-navbar-social-media-link"
            className={`${colorMode} nav-link-colors nav__menu-item socialMediaIcon`}
          >
            <Link
              marginRight="xs"
              type="action"
              target="_blank"
              href="https://twitter.com/mylibrarynyc/"
            >
              <Icon
                align="right"
                color={socialMediaIconColor}
                className="navBarIcon"
                decorative
                iconRotation="rotate0"
                id="social-twitter-icon-id"
                name="socialTwitter"
                size="large"
                type="default"
              />
            </Link>

            <Link
              type="action"
              target="_blank"
              href="https://www.instagram.com/mylibrarynyc/"
            >
              <Icon
                align="right"
                color={socialMediaIconColor}
                className="navBarIcon"
                decorative
                iconRotation="rotate0"
                id="social-instagram-icon-id"
                name="socialInstagram"
                size="large"
                type="default"
              />
            </Link>
          </li>
        </List>
      </Flex>

      <Box
        position="fixed"
        bottom={{ base: "xs", md: "auto" }}
        left={{ base: "xs", md: "auto" }}
        right={{ base: "xs", md: "xs" }}
        top={{ base: "auto", md: "xs" }}
        zIndex="2"
        display="flex"
        flexDir="column"
      >
        <DarkModeToggle />
      </Box>
    </div>
  );
}
