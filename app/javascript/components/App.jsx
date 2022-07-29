import React, { Component, useState, useEffect } from 'react';
import axios from 'axios';
import Routes from "../routes/routes";
import "../styles/application.scss"

import { DSProvider } from '@nypl/design-system-react-components';

export default function App(props) {

  const [isLoggedIn, setIsLoggedIn] = useState([false])
  const [user, setUser] = useState([])

  useEffect(() => {
    loginStatus();
  }, []);

  const handleLogin = (data) => {
    setIsLoggedIn(true)
    setUser(data.setUser)
  }

  const handleLogout = () => {
    setIsLoggedIn(false)
    setUser(data.setUser)
  }

  const loginStatus = () => {
    axios.get('/logged_in', {withCredentials: true}).then(response => {
      if (response.data.logged_in) {
        handleLogin(response.data)
      } else {
        handleLogout()
      }
    })
    .catch(error => console.log('api errors:', error))
  };


  return (
    <Routes userSignedIn={isLoggedIn}/>
  )
}