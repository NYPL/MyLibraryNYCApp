import PropTypes from 'prop-types';
import React, { Component, useState, useEffect } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import axios from 'axios';
import Collapsible from 'react-collapsible';
import {
  Button, SearchBar, Select, TextInput, HelperErrorText, DSProvider, 
  TemplateAppContainer, Icon, Notification, Card,
  CardHeading, CardContent, Text, Form, FormField, FormRow, Heading, HorizontalRule
} from '@nypl/design-system-react-components';
import validator from 'validator'
import { BrowserRouter as Router, Link as ReactRouterLink, useNavigate, useLocation } from "react-router-dom";
import { Link } from "@nypl/design-system-react-components";

export default function SignIn(props) {
  const navigate = useNavigate();
  const location = useLocation();
  const [email, setEmail] = useState("")
  const [invali_email_msg, setInvalidEmailMsg] = useState("")
  const [user_signed_in, setUserSignedIn] = useState(props.userSignedIn)
  const [isInvalid, setIsInvalid] = useState(false)


  useEffect(() => {
    if(props.userSignedIn && location.pathname == "/signin") {
      navigate('/account_details')
      return false;
    }
  }, []);


  const handleEmail = event => {
    setEmail(event.target.value)
    setIsInvalid(false)
  }

  const handleValidation = () => {
    if (email == "") {
      setInvalidEmailMsg("Please enter a valid email address")
      setIsInvalid(true)
      return false;
    }
  }


  const handleSubmit = event => {
    event.preventDefault();
    if (email == "") {
      setInvalidEmailMsg("Please enter a valid email address")
      setIsInvalid(true)
      return false;
    }

    if (!validator.isEmail(email)) {
      setInvalidEmailMsg("Please enter a valid email address")
      setIsInvalid(true)
      return false;
    }

    axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector("meta[name='csrf-token']").getAttribute("content")
    axios.post('/users/login', { user: { email: email } } 
    ).then(res => {
      if (res.data.logged_in) {
        setUserSignedIn(true)
        props.handleLogin(true)
        props.handleSignInMsg(res.data.sign_in_msg, true)
        props.hideSignInMessage(false)
        console.log(res.data.user_return_to)
        console.log(location)
        navigate('/'+res.data.user_return_to, { state: { userSignedIn: true } });
        return false;
      } else {
        setInvalidEmailMsg("Please enter a valid email address")
        setIsInvalid(true)
      }
    })
      .catch(function (error) {
       console.log(error)
    })
  }

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentPrimary={
        <>
          <Heading id="sign-in-heading-id" level="two" size="secondary" text="Sign In" />
          <HorizontalRule id="ts-detail-page-horizontal-rulel" marginTop="s" className="teacherSetHorizontal" />
          <Collapsible trigger={<><Text marginTop="l" noSpace size="caption" fontWeight="heading.secondary">Your DOE Email Address <Icon align="right" color="ui.black" style={{marginBottom: "-3"}} iconRotation="rotate0" name="actionHelpDefault" size="medium" type="default"/></Text></>}>
            <Notification className="signInEmailAlert" noMargin notificationType="announcement" showIcon={false}
            notificationContent={
              <Text noSpace size="caption">Your DOE email address will look like <b>jsmith@schools.nyc.gov</b>, 
                consisting of your first initial plus your last name. It may also contain a numeral after your name (<b>jsmith2@schools.nyc.gov, jsmith3@schools.nyc.gov, etc.</b>). Even if you do not check your DOE email regularly, please use it to sign in. You can provide an alternate email address later for delivery notifications and other communications.
              </Text>} />
          </Collapsible> 
          
          <TextInput id="sign-in-text-input" marginTop="xs" type="text" placeholder="Enter email address" onChange={handleEmail} required invalidText={invali_email_msg} helperText="Ex:jsmith@schools.nyc.gov" isInvalid={isInvalid} />
          <Button id="sign-in-button" marginTop="l" className="signin-button" size="small" buttonType="noBrand" onClick={handleSubmit}>Sign In</Button>
              
          <Text id="not-registered-text" marginTop="xs" noSpace fontWeight="text.tag">Not Registered ? Please 
            <Link href="/signup" id="sign-up-link" type="action" marginLeft="xxs">Sign Up</Link>
          </Text>
        </>
      }
      contentSidebar={<HaveQuestions />}
      sidebar="right"
    />
  )
  
}
