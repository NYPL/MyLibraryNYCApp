import PropTypes from 'prop-types';
import React, { Component, useState, useEffect } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import axios from 'axios';
import Collapsible from 'react-collapsible';
import {
  Button, SearchBar, Select, TextInput, HelperErrorText, DSProvider, 
  TemplateAppContainer, Icon, Notification, Card,
  CardHeading, CardContent, Text, Form, FormField, FormRow
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
        console.log("Loggedin")
        setUserSignedIn(true)
        props.handleLogin(true)
        props.handleSignInMsg(res.data.sign_in_msg, true)
        props.hideSignInMessage(false)
        navigate(res.data.user_return_to, { state: { userSignedIn: true } });
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
          <Collapsible trigger={<><Text noSpace size="caption">Your DOE Email Address <Icon align="left" color="ui.black" iconRotation="rotate0" name="action_help_default" size="small" /></Text></>}>
            <Notification className="signInEmailAlert" noMargin notificationType="announcement" showIcon={false}
            notificationContent={
              <Text noSpace size="mini">Your DOE email address will look like jsmith@schools.nyc.gov, 
                consisting of your first initial plus your last name. It may also contain a numeral after your name ( jsmith2@schools.nyc.gov, jsmith3@schools.nyc.gov, etc.). Even if you do not check your DOE email regularly, please use it to sign in. You can provide an alternate email address later for delivery notifications and other communications.
              </Text>} />
          </Collapsible> 
          
          <Form id="sign-in-form">
            <FormRow>
              <FormField>
                <TextInput id="sign-in-text-input" className="signInEmail" type="email" onChange={handleEmail} required invalidText={invali_email_msg} isInvalid={isInvalid} />
                <Button id="sign-in-button" className="signin-button" size="small" buttonType="noBrand" onClick={handleSubmit}>Sign In</Button>
              </FormField>
            </FormRow>
          </Form>
          <div className="sign-up-link">
            <Text id="not-registered-text" noSpace size="caption">Not Registered ? Please
              <span> </span>
              <Link id="sign-up-link" type="action">
                <ReactRouterLink to="/signup">Sign Up</ReactRouterLink>
              </Link>
            </Text>
          </div>
        </>
      }
      contentSidebar={<HaveQuestions />}
      sidebar="right"
    />
  )
  
}
