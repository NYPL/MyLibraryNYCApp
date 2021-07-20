import React from 'react';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import { Link, LinkTypes } from "@nypl/design-system-react-components";


const url = "http://dev-www.mylibrarynyc.local:3000/"
  
const Navbar = () => {
  return (
   <div className="app-header">
    <ul>
      <li className="navMenuFont header-navMenu-list mln-home-page-logo float-left">
        <Link className="nav-link-colors" type={LinkTypes.Action}>
          <ReactRouterLink to="/" className="nav-link-colors"><img border="0" src="/assets/MLN_Logo_red.png"/></ReactRouterLink>
        </Link>
      </li>
    </ul>

      <div className="navMenuList" >
        <ul className="float-right">
          <li className="navMenuFont header-navMenu-list sign_in">          
            <Link className="nav-link-colors" type={LinkTypes.Action}>
              <ReactRouterLink to="/users/start" className="nav-link-colors float-right">Sign In</ReactRouterLink>
            </Link>
          </li>

          
          <li className="navMenuFont header-navMenu-list search_teacher_sets">
            <Link className="nav-link-colors" type={LinkTypes.Action}>
              <ReactRouterLink to="/faq" className="nav-link-colors float-right">Search Teacher Sets</ReactRouterLink>
            </Link>
          </li>

          <li className="navMenuFont header-navMenu-list contacts">
            <Link className="nav-link-colors" type={LinkTypes.Action}>
              <ReactRouterLink to="/contacts" className="nav-link-colors float-right">Contacts</ReactRouterLink>
            </Link>
          </li>
          

          <li className="navMenuFont header-navMenu-list faqs">
            <Link className="nav-link-colors" type={LinkTypes.Action}>
              <ReactRouterLink to="/faq" className="nav-link-colors float-right">FAQs</ReactRouterLink>
            </Link>
          </li>


          <li className="navMenuFont header-navMenu-list participating_schools">
            <Link className="nav-link-colors" type={LinkTypes.Action}>
              <ReactRouterLink to="/participating-schools" className="nav-link-colors float-right">Participating Schools</ReactRouterLink>
            </Link>

          </li>
        </ul>
      </div>
    </div>
  );
};
  
export default Navbar;