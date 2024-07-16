import React, { useState } from 'react';
import { Route, BrowserRouter as Router, Routes } from "react-router-dom";
import Header from "../components/Header";
import Footer from "../components/Footer/Footer";
import Home from "../components/Home/Home";
import Faqs from "../components/Faqs/Faqs";
import Contact from "../components/Contact/Contact";
import Banner from "../components/Banner";
import ParticipatingSchools from "../components/ParticipatingSchools/ParticipatingSchools";
import SignIn from "../components/SignIn/SignIn";
import SignUp from "../components/SignUp/SignUp";
import SearchTeacherSets from "../components/SearchTeacherSets";
import Accounts from "../components/Accounts";
import MobileNavbarSubmenu from "../components/MobileNavbarSubmenu";
import TeacherSetDetails from "../components/TeacherSetDetails";
import TeacherSetOrder from "../components/TeacherSetOrder/TeacherSetOrder";
import CancelTeacherSetOrder from "../components/CancelTeacherSetOrder";
import TeacherSetBooks from "../components/TeacherSetBooks/TeacherSetBooks";
import CalendarEventError from "../components/CalendarEventError";
import NewsletterConfirmation from "../components/NewsletterConfirmation";
import PageNotFound from "../components/PageNotFound/PageNotFound";

import { DSProvider, ColorModeScript } from '@nypl/design-system-react-components';

export default function AppRoutes(props) {
  const [hold, setHold] = useState("")
  const [teacher_set, setTeacherSet] = useState("")
  const {userSignedIn, setUserSignedIn} = props
  const [signout_msg, setsignout_msg] = useState("")
  const [signin_msg, setsignin_msg] = useState("")
  const [hide_signout_msg, sethide_signout_msg] = useState("")
  const [hide_signin_msg, sethide_signin_msg] = useState("")
  const [status_label, setstatus_label] = useState("")
  const [signedUpMessage, setSignedUpMessage] = useState("")

  const handleLogin = (logginIn) => {
    setUserSignedIn(logginIn)
  }

  const handleSignedUpMsg = (signedUpMsg) => {
    setSignedUpMessage(signedUpMsg)
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
    <>
      <ColorModeScript initialColorMode={"light" | "dark" | "system"} />
      <DSProvider>
        <Router>
          <Banner />
          <Header userSignedIn={userSignedIn} handleSignOutMsg={handleSignOutMsg} hideSignUpMessage={hideSignUpMessage} hideSignInMessage={hideSignInMessage} handleLogout={handleLogout} />
          <Routes>
            <Route exact path='/' element={<Home userSignedIn={userSignedIn} hideSignOutMsg={hide_signout_msg} signoutMsg={signout_msg} />} />
            <Route path='/faq' element={<Faqs userSignedIn={userSignedIn} hideSignInMsg={hide_signin_msg} signInMsg={signin_msg} />} />
            <Route path='/contact' element={ <Contact userSignedIn={userSignedIn} hideSignInMsg={hide_signin_msg} signInMsg={signin_msg} />} />
            <Route path='/participating-schools' element={ <ParticipatingSchools userSignedIn={userSignedIn} hideSignInMsg={hide_signin_msg} signInMsg={signin_msg} />} />
            <Route path='/signin' element={ <SignIn userSignedIn={userSignedIn} handleSignInMsg={handleSignInMsg} hideSignInMessage={hideSignInMessage} handleLogin={handleLogin} />} />
            <Route path='/signup' element={ <SignUp userSignedIn={userSignedIn} handleLogin={handleLogin} handleSignedUpMsg={handleSignedUpMsg} />} />
            <Route path='/teacher_set_data' element={ <SearchTeacherSets userSignedIn={userSignedIn} hideSignInMsg={hide_signin_msg} signInMsg={signin_msg} signedUpMessage={signedUpMessage}/>} />
            <Route path='/secondary_menu' element={ <MobileNavbarSubmenu />} />
            <Route path='/account_details' element={ <Accounts />} />
            <Route path='/teacher_set_details/:id' element={ <TeacherSetDetails handleTeacherSetOrderedData={handleTeacherSetOrderedData}/>} />
            <Route path='/ordered_holds/:access_key' element={ <TeacherSetOrder holddetails={hold} teachersetdetails={teacher_set} statusLabel={status_label}/>} />
            <Route path='/holds/:id/cancel' element={ <CancelTeacherSetOrder /> } />
            <Route path='/book_details/:id' element={ <TeacherSetBooks /> } />
            <Route path='/home/calendar_event/error' element={ <CalendarEventError /> } />
            <Route path='/newsletter_confirmation' element={ <NewsletterConfirmation /> } />
            <Route path="*" element={<PageNotFound />} />
          </Routes>
          <footer className="footer"> <Footer /></footer>
        </Router>
      </DSProvider>
    </>
  )
}