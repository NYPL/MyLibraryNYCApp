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

import AccountDetailsSubMenu from "./../AccountDetailsSubMenu";

export default function Navbar(props) {
  const navigate = useNavigate();
  const { colorMode, toggleColorMode} = useColorMode();
  console.log(localStorage.getItem('chakra-ui-color-mode'))
  const [defaultColorMode, setDefaultColorMode] = useState(localStorage.getItem('chakra-ui-color-mode') ||  "light");
  const mlnLogo = useColorModeValue("mlnColor", "mlnWhite");

  const darkModeIconColor = useColorModeValue(
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

  const handleChangeToDarkMode = () => {
    const newColorMode = colorMode === "light" ? "dark" : "light";
    setDefaultColorMode(newColorMode)
    console.log(
      `Color mode is switching from ${colorMode} to ${newColorMode}.`
    );
    toggleColorMode();
  };

  const displayColorModeIcon = () => {
    if (defaultColorMode === "dark") {
      return <button id="color-mode-button" arial-label="Switch to light mode" onClick={handleChangeToDarkMode}>
        <svg aria-hidden="true" width="20" height="20" viewBox="0 0 24 25" fill="none" xmlns="http://www.w3.org/2000/svg">
        <title>sun icon</title>
        <g id="icon/image/brightness/5/24px">
        <path id="icon/image/brightness_5_24px" fill-rule="evenodd" clip-rule="evenodd" d="M19.9995 4.185V8.875L23.3095 12.185L19.9995 15.495V20.185H15.3095L11.9995 23.495L8.68945 20.185H3.99945V15.495L0.689453 12.185L3.99945 8.875V4.185H8.68945L11.9995 0.875L15.3095 4.185H19.9995ZM17.9995 18.185V14.665L20.4795 12.185L17.9995 9.705V6.185H14.4795L11.9995 3.705L9.51945 6.185H5.99945V9.705L3.51945 12.185L5.99945 14.665V18.185H9.51945L11.9995 20.665L14.4795 18.185H17.9995ZM11.9995 6.685C8.96945 6.685 6.49945 9.155 6.49945 12.185C6.49945 15.215 8.96945 17.685 11.9995 17.685C15.0295 17.685 17.4995 15.215 17.4995 12.185C17.4995 9.155 15.0295 6.685 11.9995 6.685ZM8.49945 12.185C8.49945 14.115 10.0695 15.685 11.9995 15.685C13.9295 15.685 15.4995 14.115 15.4995 12.185C15.4995 10.255 13.9295 8.685 11.9995 8.685C10.0695 8.685 8.49945 10.255 8.49945 12.185Z" fill={darkModeIconColor}/>
        </g>
        </svg>
      </button>
    } else {
      return <button id="color-mode-button"  arial-label="Switch to dark mode" onClick={handleChangeToDarkMode}>
        <svg aria-hidden="true" width="20" height="20" viewBox="0 0 16 21" fill="none" xmlns="http://www.w3.org/2000/svg">
        <title>moon icon</title>
        <g>
          <path fill-rule="evenodd" clip-rule="evenodd" d="M0.5 1.70352C1.97 0.853516 3.68 0.353516 5.5 0.353516C11.02 0.353516 15.5 4.83352 15.5 10.3535C15.5 15.8735 11.02 20.3535 5.5 20.3535C3.68 20.3535 1.97 19.8535 0.5 19.0035C3.49 17.2735 5.5 14.0535 5.5 10.3535C5.5 6.65352 3.49 3.43352 0.5 1.70352ZM13.5 10.3535C13.5 5.94352 9.91 2.35352 5.5 2.35352C5.16 2.35352 4.82 2.37352 4.49 2.42352C6.4 4.58352 7.5 7.40352 7.5 10.3535C7.5 13.3035 6.4 16.1235 4.49 18.2835C4.82 18.3335 5.16 18.3535 5.5 18.3535C9.91 18.3535 13.5 14.7635 13.5 10.3535Z" fill="black"/>
        </g>
        </svg>
      </button>
    }         
  }

  return (
    <div id="mln-navbar" className="header-topWrapper">
      <Flex alignItems="center">
        <Link href="/" onClick={hideHomeSignUpMsg}>
          <Logo
            id="mln-nav-bar-header-logo"
            marginLeft="m"
            decorative
            name={mlnLogo}
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
            id="color-mode-icon"
            className={`${colorMode} colorModeIcon`}
          >
            
              {displayColorModeIcon()}
          </li>
        </List>
      </Flex>
    </div>
  );
}
