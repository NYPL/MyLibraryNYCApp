import React from "react";
import Navbar from "./NavBar/Navbar";
import MobileHeader from "./MobileHeader";
import { SkipNavigation } from "@nypl/design-system-react-components";
export default function Header(props) {
  return (
    <>
      <SkipNavigation />
      <Navbar
        userSignedIn={props.userSignedIn}
        handleSignOutMsg={props.handleSignOutMsg}
        hideSignUpMessage={props.hideSignUpMessage}
        hideSignInMessage={props.hideSignInMessage}
        handleLogout={props.handleLogout}
      />
      <MobileHeader details={props} />
    </>
  );
}
