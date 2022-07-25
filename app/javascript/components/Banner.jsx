import React from "react";
import { NavLink } from "react-router-dom";
import Navbar from "./Navbar";
import "../styles/application.scss"
import { Notification, Link } from '@nypl/design-system-react-components';

function Banner() {
  return (
    <Notification ariaLabel="Banner Notification" id="banner-notification" className="bannerMessage" isCentered showIcon={false} dismissible notificationType="announcement" notificationContent={<>
      We are now accepting teacher set returns. Teacher set deliveries are still currently suspended. Please email 
    <Link href="mailto:help@mylibrarynyc.org"> help@mylibrarynyc.org </Link> for all general questions and 
    <Link href="mailto:delivery@mylibrarynyc.org"> delivery@mylibrarynyc.org </Link> for all delivery questions.</>} />
  );
}

export default Banner;
