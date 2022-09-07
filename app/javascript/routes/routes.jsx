import React, { Component, useState, useEffect } from 'react';
import { Route, BrowserRouter as Router, Switch , Redirect} from "react-router-dom";

import Header from "../components/Header";
import Footer from "../components/Footer";
import Home from "../components/Home";
import Faqs from "../components/Faqs";
import Navbar from "../components/Navbar";
import Contacts from "../components/Contacts";
import Banner from "../components/Banner";
import ParticipatingSchools from "../components/ParticipatingSchools";
import AppBreadcrumbs from "../components/AppBreadcrumbs";
import SignIn from "../components/SignIn";
import SignUp from "../components/SignUp";
import SignOut from "../components/SignOut";
import CalendarOfEvents from "../components/CalendarOfEvents";
import SearchTeacherSets from "../components/SearchTeacherSets";
import Accounts from "../components/Accounts";
import MobileNavbarSubmenu from "../components/MobileNavbarSubmenu";
import TeacherSetDetails from "../components/TeacherSetDetails";
import TeacherSetOrder from "../components/TeacherSetOrder";
import CancelTeacherSetOrder from "../components/CancelTeacherSetOrder";
import TeacherSetBooks from "../components/TeacherSetBooks";
import CalendarEventError from "../components/CalendarEventError";
import { render } from "react-dom";
import { DSProvider, TemplateAppContainer } from '@nypl/design-system-react-components';
import AccountDetailsSubMenu from "../components/AccountDetailsSubMenu";


export default function Routes(props) {
  const [hold, setHold] = useState("")
  const [teacher_set, setTeacherSet] = useState("")
  const {userSignedIn, setUserSignedIn} = props
  const [signout_msg, setsignout_msg] = useState("")
  const [signin_msg, setsignin_msg] = useState("")
  const [hide_signout_msg, sethide_signout_msg] = useState("")
  const [hide_signin_msg, sethide_signin_msg] = useState("")
  const [status_label, setstatus_label] = useState("")


  const handleLogin = (logginIn) => {
    setUserSignedIn(logginIn)
  }

  const handleLogout = (loggedOut) => {
    setUserSignedIn(loggedOut)
  }

  const handleTeacherSetOrderedData = (hold, teacher_set, status_label) => {
    setHold(hold)
    setTeacherSet(teacher_set)
    setstatus_label(status_label)
  }

  const handleSignOutMsg = (signoutMsg, userSignedIn) => {
    setsignout_msg(signoutMsg)
    setUserSignedIn(userSignedIn)
  }

  const handleSignInMsg = (signInMsg, userSignedIn) => {
    console.log(userSignedIn)
    setsignin_msg(signInMsg)
    setUserSignedIn(userSignedIn)
  }

  const hideSignUpMessage = (hideSignoutMessage) => {
    sethide_signout_msg(hideSignoutMessage)
  }

  const hideSignInMessage = (hideSignInMessage) => {
    sethide_signin_msg(hideSignInMessage)
  }


  return (
    <DSProvider>
        <Router>
          <div id="mln-main-content">
            <Banner />
            <Header userSignedIn={userSignedIn} handleSignOutMsg={handleSignOutMsg} hideSignUpMessage={hideSignUpMessage} hideSignInMessage={hideSignInMessage} handleLogout={handleLogout} />
            <Switch>
              <Route exact path='/'
                render={ routeProps => (
                  <Home {...routeProps} component={Home} userSignedIn={userSignedIn} hideSignOutMsg={hide_signout_msg} signoutMsg={signout_msg} />
                ) }
              />
              <Route
                path='/faq'
                render={routeProps => (
                  <Faqs {...routeProps} component={Faqs} userSignedIn={userSignedIn} hideSignInMsg={hide_signin_msg} signInMsg={signin_msg} />
                )}
              />
              <Route
                path='/contacts'
                render={routeProps => (
                  <Contacts {...routeProps} component={Contacts} userSignedIn={userSignedIn} hideSignInMsg={hide_signin_msg} signInMsg={signin_msg} />
                )}
              />
              <Route
                path='/participating-schools'
                render={routeProps => (
                  <ParticipatingSchools {...routeProps} component={ParticipatingSchools} userSignedIn={userSignedIn} hideSignInMsg={hide_signin_msg} signInMsg={signin_msg} />
                )}
              />
              <Route
                path='/signin'
                render={routeProps => (
                  <SignIn {...routeProps} component={SignIn} userSignedIn={userSignedIn} handleSignInMsg={handleSignInMsg} hideSignInMessage={hideSignInMessage} handleLogin={handleLogin} />
                )}
              />
              <Route
                path='/signup'
                render={routeProps => (
                  <SignUp {...routeProps} component={SignUp} userSignedIn={userSignedIn} handleLogin={handleLogin} />
                )}
              />

              <Route path="/signout" component={SignOut} />                
              <Route
                path='/teacher_set_data'
                render={routeProps => (
                  <SearchTeacherSets {...routeProps} component={SearchTeacherSets} userSignedIn={userSignedIn} hideSignInMsg={hide_signin_msg} signInMsg={signin_msg} />
                )}
              />
              <Route path="/secondary_menu" component={MobileNavbarSubmenu} />
              <Route path="/account_details" component={Accounts} />
              <Route
                path='/teacher_set_details/:id'
                render={routeProps => (
                  <TeacherSetDetails {...routeProps} handleTeacherSetOrderedData={handleTeacherSetOrderedData} />
                )}
              />
              <Route
                path='/ordered_holds/:access_key'
                render={routeProps => (
                  <TeacherSetOrder {...routeProps} holddetails={hold} teachersetdetails={teacher_set} statusLabel={status_label} />
                )}
              />

              <Route path="/holds/:id/cancel" component={CancelTeacherSetOrder} />
              <Route path="/book_details/:id" component={TeacherSetBooks} />
              <Route path="/home/calendar_event/error" component={CalendarEventError} />
            </Switch>
            <footer className="footer"> <Footer /></footer>
          </div>
        </Router>
    </DSProvider>
  )
}