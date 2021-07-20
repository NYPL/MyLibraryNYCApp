import React from "react";
import { NavLink } from "react-router-dom";
import Navbar from "./Navbar";
import AppBreadcrumbs from "./AppBreadcrumbs";


function Header() {
  return (
  	<div className="content-header">
    	<Navbar />
    </div>
  );
}
export default Header;
