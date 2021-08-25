import React, { Component, useState } from 'react';
import PropTypes from 'prop-types';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import { Link, LinkTypes, Icon } from "@nypl/design-system-react-components";


export default class ContactsFaqsSchoolsNavMenu extends Component {

  constructor(props) {
    super(props);

    this.state = {
      activeButton: '',
    };
  }

	render() {
		const mobileActiveClass = this.props.mobileActive ? 'mobileActive' : '';

	  return (
	    	<div className={this.props.className}>
	        <nav
	          className={`${this.props.className}-wrapper ${mobileActiveClass}`}
	          aria-label="Main Navigation"
	        >

	          <ul className={`${this.props.className}-list`} id="navMenu-List">
	            <li className='menu-list'>
					      <Icon className="testClass" decorative modifiers={[ 'small', 'icon-left' ]} name="brooklyn" />
					      <Link type={LinkTypes.Action}>
					        <ReactRouterLink to="/contacts" className="nav-link-colors nav-menu-link">Contacts</ReactRouterLink>
					      </Link>
					    </li>
					    

					    <li className='menu-list'>
					    	<Icon className="testClass" decorative modifiers={[ 'small', 'icon-left' ]} name="brooklyn" />
					      <Link type={LinkTypes.Action}>
					        <ReactRouterLink to="/faq" className="nav-link-colors nav-menu-link">FAQs</ReactRouterLink>
					      </Link>
					    </li>


					    <li className='menu-list'>
					    	<Icon className="testClass" decorative modifiers={[ 'small']} name="brooklyn" />
					      <Link type={LinkTypes.Action}>
					        <ReactRouterLink to="/participating-schools" className="nav-link-colors nav-menu-link">Participating Schools</ReactRouterLink>
					      </Link>
					    </li>
	          </ul>
	          <div className='icon-div'>
          		<div>
	        			<Link type={LinkTypes.Action}>
					      	<ReactRouterLink to="/" className="nav-link-colors nav-menu-link icon-shuttle">Test</ReactRouterLink>
					   		</Link>
					   	</div>
		        </div>
	        </nav>
	      </div>
	  );
	}
}

ContactsFaqsSchoolsNavMenu.propTypes = {
  lang: PropTypes.string,
  className: PropTypes.string,
  urlType: PropTypes.string,
  mobileActive: PropTypes.bool,
};

ContactsFaqsSchoolsNavMenu.defaultProps = {
  lang: 'en',
  className: 'navMenu',
  urlType: 'relative',
  mobileActive: false,
};
