import { DSProvider } from '@nypl/design-system-react-components';
import React, { Component, useState, useEffect } from 'react';
import axios from 'axios';
import Routes from "../routes/routes";

export default function App(props) {

  const [isLoggedIn, setIsLoggedIn] = useState(props.userSignedIn || false)

  useEffect(() => {
    loginStatus();
  }, []);

  const handleLogin = (data) => {
    setIsLoggedIn(true)
  }

  const handleLogout = () => {
    setIsLoggedIn(false)
  }

  const loginStatus = () => {
    axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector("meta[name='csrf-token']").getAttribute("content")
    axios.get('/logged_in').then(response => {
      if (response.data.logged_in) {
        handleLogin(response.data)
      } else {
        handleLogout()
      }
    })
    .catch(error => console.log('api errors:', error))
  };

  return (
    <Routes userSignedIn={isLoggedIn} setUserSignedIn={setIsLoggedIn}/>
  )
}