import React from "react";
import { NavLink } from "react-router-dom";
import Navbar from "./Navbar";
import AppBreadcrumbs from "./AppBreadcrumbs";
import MobileHeader from "./MobileHeader"

function Header() {
  return (
  	<div className="content-header">
  		<div className="header-wrapper">
	    	<Navbar />
	    	<MobileHeader />
	    </div>
    </div>
  );
}
export default Header;
