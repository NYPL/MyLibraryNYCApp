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
      <div className="navMenuFont mln-home-page-logo">
        <img border="0" src="/assets/MLN_Logo_red.png"/>
      </div>

      <div className="navMenuList" >
        <ul className="float-right" >
          <li className="navMenuFont header-navMenu-list sign_in">
            <Link className="nav-link-colors" href='/users/start'> Sign In </Link>
          </li>

          
          <li className="navMenuFont header-navMenu-list search_teacher_sets">
            <Link className="nav-link-colors" type={LinkTypes.Action}>
              <ReactRouterLink to="/faq" className="nav-link-colors">Search Teacher Sets</ReactRouterLink>
            </Link>
          </li>

          <li className="navMenuFont header-navMenu-list contacts">
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/contacts" className="nav-link-colors">Contacts</ReactRouterLink>
            </Link>
          </li>
          

          <li className="navMenuFont header-navMenu-list faqs">
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/faq" className="nav-link-colors">FAQs</ReactRouterLink>
            </Link>
          </li>


          <li className="navMenuFont header-navMenu-list participating_schools">
            <Link type={LinkTypes.Action}>
              <ReactRouterLink to="/participating-schools" className="nav-link-colors">Participating Schools</ReactRouterLink>
            </Link>

          </li>
        </ul>
      </div>
    </div>
  );
};
  
export default Navbar;