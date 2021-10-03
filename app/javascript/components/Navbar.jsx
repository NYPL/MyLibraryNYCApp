import React from 'react';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import { Link, LinkTypes, Icon } from "@nypl/design-system-react-components";

const styles = {
  headerNav: {
    position: 'absolute',
    top: '28px',
    display: 'block',
  }
}

  
const Navbar = () => {
  return (
   <div className="header-topWrapper">

      <ReactRouterLink to="/">
        <div className="header-logo"><img border="0" src="/assets/MLN_Logo_red.png"/></div>
      </ReactRouterLink>
    
      <nav className="header-buttons" style={styles.headerNav}>
        <ul className="float-right">
          <li>          
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/users/start" className="nav-link-colors ">Sign In</ReactRouterLink>
            </Link>
          </li>

          
          <li>
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/teacher_set_data" className="nav-link-colors ">Search Teacher Sets</ReactRouterLink>
            </Link>
          </li>

          <li>
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/contacts" className="nav-link-colors ">Contacts</ReactRouterLink>
            </Link>
          </li>
          

          <li>
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/faq" className="nav-link-colors ">FAQs</ReactRouterLink>
            </Link>
          </li>


          <li>
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/participating-schools" className="nav-link-colors ">Participating Schools</ReactRouterLink>
            </Link>
          </li>
        </ul>
      </nav>
    </div>
  );
};
  
export default Navbar;