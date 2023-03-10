import React from "react";
import Navbar from "./NavBar/Navbar";
import MobileHeader from "./MobileHeader";

export default function Header(props) {
  return (
    <>
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
