import React from 'react';
import {
  Nav,
  NavLink,
  Bars,
  NavMenu,
  NavBtn,
  NavBtnLink,
} from './NavbarElements';

import { Link, LinkTypes} from '@nypl/design-system-react-components';

const url = "http://dev-www.mylibrarynyc.local:3000/"
  
const Navbar = () => {
  return (
    <>
      <div className="app-container">
            <div className="navMenuFont mln-home-page-logo">
              <img border="0" src="/assets/MLN_Logo_red.png"/>
            </div>
          <ul className="float-right">

            <li className="navMenuFont header-navMenu-list sign_in">
              <Link className="nav-link-colors" href={`${url}faq`}
                type={LinkTypes.Default} attributes={{ target: '_blank'}}> Sign In 
              </Link>
            </li>

            <li className="navMenuFont header-navMenu-list search_teacher_sets">
              <Link className="nav-link-colors" href={`${url}faq`} 
                type={LinkTypes.Default} attributes={{ target: '_blank'}}> Search Teacher Sets 
              </Link>
            </li>

            <li className="navMenuFont header-navMenu-list contacts">
              <Link className="nav-link-colors" href={`${url}faq`} 
                type={LinkTypes.Default} attributes={{ target: '_blank'}}> Contacts
              </Link>
            </li>

            <li className="navMenuFont header-navMenu-list faqs">
              <Link className="nav-link-colors" href={`${url}faq`} 
                type={LinkTypes.Default} attributes={{ target: '_blank'}}> FAQs
              </Link>
            </li>


            <li className="navMenuFont header-navMenu-list participating_schools_link">
              <Link className="nav-link-colors" href={`${url}faq`} 
                type={LinkTypes.Default} attributes={{ target: '_blank'}}> Participating Schools
              </Link>
            </li>

          </ul>
      </div>
    </>
  );
};
  
export default Navbar;