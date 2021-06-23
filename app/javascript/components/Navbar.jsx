import React from 'react';
import {NavLink}  from 'react-router-dom'

import { Link, LinkTypes} from '@nypl/design-system-react-components';

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
            <NavLink className="nav-link-colors" to='/users/start'
              type={LinkTypes.Default} attributes={{ target: '_blank'}}> Sign In 
            </NavLink>
          </li>

          <li className="navMenuFont header-navMenu-list search_teacher_sets">
            <NavLink className="nav-link-colors"  to='/faq'
              type={LinkTypes.Default} attributes={{ target: '_blank'}}> Search Teacher Sets 
            </NavLink>
          </li>

          <li className="navMenuFont header-navMenu-list contacts">
            <NavLink className="nav-link-colors"  to='/help'
              type={LinkTypes.Default} attributes={{ target: '_blank'}}> Contacts
            </NavLink>
          </li>

          <li className="navMenuFont header-navMenu-list faqs">
            <NavLink className="nav-link-colors" to='/faq'
              type={LinkTypes.Default} attributes={{ target: '_blank'}}> FAQs
            </NavLink>
          </li>


          <li className="navMenuFont header-navMenu-list participating_schools">
            <NavLink className="nav-link-colors" to='/participating-schools' 
              type={LinkTypes.Default} attributes={{ target: '_blank'}}> Participating Schools
            </NavLink>
          </li>
        </ul>
      </div>
    </div>
  );
};
  
export default Navbar;