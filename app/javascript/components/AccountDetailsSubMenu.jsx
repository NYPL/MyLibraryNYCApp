import React, { useState } from "react";
import { Link as ReactRouterLink, useNavigate } from "react-router-dom";
import axios from "axios";
import {
  List,
  Icon,
  Link,
  Box,
  useColorMode,
  useColorModeValue,
} from "@nypl/design-system-react-components";

function AccountDetailsSubMenu(props) {
  const navigate = useNavigate();
  const { colorMode } = useColorMode();
  //const [user_signed_in, setUserSignedIn] = useState(props.userSignedIn);
  const [showAboutMenu, setShowAboutMenu] = useState(false);

  const handleHover = () => {
    setShowAboutMenu(true);
  };

  const signInIconColor = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );

  const accountIconColor = useColorModeValue(
    "var(--nypl-colors-ui-gray-dark)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );

  const showAccountSigninLink = () => {
    if (props.userSignedIn) {
      return (
        <>
          <Link
            href="/account_details"
            marginRight="m"
            className={`${colorMode} nav-link-colors navBarDropDown`}
            onMouseEnter={handleHover}
          >
            <Icon
              className="navBarIcon"
              align="right"
              color={signInIconColor}
              decorative
              iconRotation="rotate0"
              id="icon-id"
              name="utilityAccountFilled"
              size="medium"
              type="default"
            />
            My Account{" "}
            <Icon
              id="account-arrow-drop-down"
              size="small"
              className={`${colorMode} navBarIcon signinNavArrow`}
              color={signInIconColor}
            >
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512">
                <path d="M310.6 246.6l-127.1 128C176.4 380.9 168.2 384 160 384s-16.38-3.125-22.63-9.375l-127.1-128C.2244 237.5-2.516 223.7 2.438 211.8S19.07 192 32 192h255.1c12.94 0 24.62 7.781 29.58 19.75S319.8 237.5 310.6 246.6z" />
              </svg>
            </Icon>
          </Link>
        </>
      );
    } else {
      return (
        <>
          <Link
            href="/signin"
            marginRight="m"
            className={`${colorMode} nav-link-colors navBarDropDown`}
            onMouseEnter={handleHover}
          >
            <Icon
              className={`${colorMode} navBarIcon`}
              align="right"
              color={signInIconColor}
              decorative
              iconRotation="rotate0"
              id="icon-id"
              name="actionExit"
              size="medium"
              type="default"
            />
            Sign In{" "}
            <Icon
              id="signin-arrow-drop-down"
              size="small"
              color={signInIconColor}
              className={`${colorMode} navBarIcon signinNavArrow`}
            >
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512">
                <path d="M310.6 246.6l-127.1 128C176.4 380.9 168.2 384 160 384s-16.38-3.125-22.63-9.375l-127.1-128C.2244 237.5-2.516 223.7 2.438 211.8S19.07 192 32 192h255.1c12.94 0 24.62 7.781 29.58 19.75S319.8 237.5 310.6 246.6z" />
              </svg>
            </Icon>
          </Link>
        </>
      );
    }
  };

  const signOut = () => {
    axios
      .delete("/users/logout", {
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document
            .querySelector("meta[name='csrf-token']")
            .getAttribute("content"),
        },
      })
      .then((res) => {
        if (res.data.status === 200 && res.data.logged_out === true) {
          props.handleLogout(false);
          // setUserSignedIn(false);
          setShowAboutMenu(false);
          props.handleSignOutMsg(res.data.sign_out_msg, false);
          props.hideSignUpMessage(false);
          navigate("/");
        }
      })
      .catch(function (error) {
        console.log(error);
      });
  };

  const AccountOrderLink = () => {
    if (props.userSignedIn) {
      return (
        <>
          <List
            id="navbar-account-details-user-signed-in"
            key="navbar-account-details-user-signed-in-key"
            type="ol"
            inline={false}
            noStyling={false}
            className={`${colorMode} nav__submenu account_details`}
          >
            <li className={`${colorMode} nav__submenu-item`}>
              <Link
                className={`${colorMode} textDecorationNone navBarDropDown`}
                href="/account_details"
              >
                <Icon
                  align="right"
                  className="navBarIcon"
                  color={accountIconColor}
                  decorative
                  iconRotation="rotate0"
                  id="icon-id"
                  name="actionSettings"
                  size="medium"
                  type="default"
                />
                Settings
              </Link>
            </li>

            <li className={`${colorMode} nav__submenu-item`}>
              <Link
                className={`${colorMode} textDecorationNone navBarDropDown`}
                href="/account_details"
              >
                <Icon
                  align="right"
                  className="navBarIcon"
                  color={accountIconColor}
                  decorative
                  iconRotation="rotate0"
                  id="icon-id"
                  name="check"
                  size="medium"
                  type="default"
                />
                My Orders
              </Link>
            </li>

            <li className={`${colorMode} nav__submenu-item`}>
              <ReactRouterLink
                className={`${colorMode} textDecorationNone navBarDropDown`}
                onClick={signOut}
              >
                <Icon
                  align="right"
                  className="navBarIcon"
                  color={accountIconColor}
                  decorative
                  iconRotation="rotate0"
                  id="icon-id"
                  name="actionPower"
                  size="medium"
                  type="default"
                />
                Sign Out
              </ReactRouterLink>
            </li>
          </List>
        </>
      );
    } else {
      return (
        <>
          <List
            id="navbar-account-details"
            key="navbar-account-details-key"
            type="ol"
            inline={false}
            noStyling={false}
            className={`${colorMode} nav__submenu signin_details`}
          >
            <li className={`${colorMode} nav__submenu-item`}>
              <Link
                href="/signin"
                type="buttonPrimary"
                className={`${colorMode} textDecorationNone signin_nav_button`}
              >
                Sign in
              </Link>
            </li>

            <li className={`${colorMode} nav__submenu-item`}>
              <Link
                className={`${colorMode} navBarDropDown textDecorationNone`}
                href="/signin?settingType=account"
              >
                <Icon
                  className="navBarIcon"
                  align="right"
                  color={accountIconColor}
                  decorative
                  iconRotation="rotate0"
                  id="icon-id"
                  name="utilityAccountFilled"
                  size="medium"
                  type="default"
                />
                My Account
              </Link>
            </li>
            <li className={`${colorMode} nav__submenu-item`}>
              <Link
                className={`${colorMode} navBarDropDown textDecorationNone`}
                href="/signup"
              >
                <Icon
                  className="navBarIcon"
                  align="right"
                  color={accountIconColor}
                  decorative
                  iconRotation="rotate0"
                  id="icon-id"
                  name="actionRegistration"
                  size="medium"
                  type="default"
                />
                Not registered? {<br />} Please sign up
              </Link>
            </li>
          </List>
        </>
      );
    }
  };

  return (
    <>
      {showAccountSigninLink()}
      {showAboutMenu && <Box>{AccountOrderLink()}</Box>}
    </>
  );
}

export default AccountDetailsSubMenu;
