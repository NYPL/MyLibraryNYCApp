import React, { Component, useState } from 'react';
import { NavLink } from "react-router-dom";
import Navbar from "./Navbar";
import AppBreadcrumbs from "./AppBreadcrumbs";
import MobileHeader from "./MobileHeader"
import ReactDOM from "react-dom";
import { render } from "react-dom";
import { BrowserRouter } from "react-router-dom";


export default function Header(props) {

  const [userSignedIn, setUserSignedIn] = useState(props.userSignedIn)

  return (
    <>
      <Navbar userSignedIn={props.userSignedIn} handleSignOutMsg={props.handleSignOutMsg} hideSignUpMessage={props.hideSignUpMessage} hideSignInMessage={props.hideSignInMessage} handleLogout={props.handleLogout}/>
      <MobileHeader details={props}/>
    </>
  )
}