import React, { Component, useState, useEffect } from 'react';
import { NavLink } from "react-router-dom";
import axios from 'axios';
import "../styles/application.scss"
import { Notification, Link } from '@nypl/design-system-react-components';

function Banner() {

  const [bannerText, setBannerText] =  useState("")
  const [bannerTextFound, setBannerTextFound] =  useState("")

  useEffect(() => {
    axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector("meta[name='csrf-token']").getAttribute("content")
    axios.get('/mln_banner_message')
      .then(res => {
        setBannerText(res.data.bannerText)
        setBannerTextFound(res.data.bannerTextFound)
      })
      .catch(function (error) {
        console.log(error);
    })
  }, []);


  const bannerMessage = () => {
    if (bannerText !== undefined && bannerTextFound) {
      return <Notification ariaLabel="Banner Notification" id="banner-notification" notificationType="standard" className="bannerMessage" isCentered showIcon={false} dismissible notificationType="announcement" notificationContent=<div dangerouslySetInnerHTML={{ __html: bannerText }}></div> />
    } else {
      return <></>
    }
  }

  return (
    bannerMessage()
  );
}
export default Banner;
