import React, { useState } from 'react';
import Navbar from "./Navbar";
import MobileHeader from "./MobileHeader"

export default function Header(props) {
  return (
    <>
      <Navbar userSignedIn={props.userSignedIn} handleSignOutMsg={props.handleSignOutMsg} hideSignUpMessage={props.hideSignUpMessage} hideSignInMessage={props.hideSignInMessage} handleLogout={props.handleLogout}/>
      <MobileHeader details={props}/>
    </>
  )
}