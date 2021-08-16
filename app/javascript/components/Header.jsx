import React from "react";
import { NavLink } from "react-router-dom";
import Navbar from "./Navbar";
import AppBreadcrumbs from "./AppBreadcrumbs";
import MobileHeader from "./MobileHeader"

function Header() {
  return (
  	<div className="content-header">
    	<Navbar />
    	<MobileHeader />
    </div>
  );
}
export default Header;
