import React from "react";
import { NavLink } from "react-router-dom";
import Navbar from "./Navbar";
import "../styles/application.scss"
import { Notification } from '@nypl/design-system-react-components';


function Banner() {
  return (
    <Notification ariaLabel="Banner Notification" id="banner-notification" className="bannerMessage" isCentered showIcon={false} dismissible notificationType="announcement" notificationContent={<>
      We are now accepting teacher set returns. Teacher set deliveries are still currently suspended. Please email 
    <a href="help@mylibrarynyc.org"> help@mylibrarynyc.org </a> for all general questions and 
    <a href="delivery@mylibrarynyc.org"> delivery@mylibrarynyc.org </a> for all delivery questions.</>} />

  );
}

export default Banner;
