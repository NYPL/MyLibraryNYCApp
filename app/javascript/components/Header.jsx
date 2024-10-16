import React from "react";
import Navbar from "./NavBar/Navbar";
import MobileHeader from "./MobileHeader";
import {
  SkipNavigation,
  useNYPLBreakpoints,
} from "@nypl/design-system-react-components";
export default function Header(props) {
  const { isLargerThanLarge } = useNYPLBreakpoints();
  const displayNavbar = () => {
    if (isLargerThanLarge) {
      return (
        <Navbar
          userSignedIn={props.userSignedIn}
          handleSignOutMsg={props.handleSignOutMsg}
          hideSignUpMessage={props.hideSignUpMessage}
          hideSignInMessage={props.hideSignInMessage}
          handleLogout={props.handleLogout}
        />
      );
    } else {
      return <MobileHeader details={props} />;
    }
  };
  return (
    <>
      <SkipNavigation />
      {displayNavbar()}
    </>
  );
}
