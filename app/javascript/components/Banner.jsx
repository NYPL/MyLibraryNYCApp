import React from "react";
import { NavLink } from "react-router-dom";
import Navbar from "./Navbar";
import "../styles/application.scss"

function Banner() {
  return (
    <div className="header-globalAlerts">
      <div className="header-globalAlerts-box">
      	<div className="header-globalAlerts-box-item">
      		<p>
		        We are now accepting teacher set returns. Teacher set deliveries are still currently suspended. Please email 
		        <a href="help@mylibrarynyc.org"> help@mylibrarynyc.org </a> for all general questions and 
		        <a href="delivery@mylibrarynyc.org"> delivery@mylibrarynyc.org </a> for all delivery questions.
		      </p>
      	</div>
      </div>
    </div>
  );
}

export default Banner;
