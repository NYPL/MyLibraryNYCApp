import React from "react";
import { NavLink } from "react-router-dom";
import Navbar from "./Navbar";
import AlertMessage from "./AlertMessage";

function Header() {
  return (
  <div>
		  <div className="app-navigation">
  			<AlertMessage />
		    <div className="app-header">
		      <Navbar />
		    </div>
			</div>
  </div>
  );
}
export default Header;
