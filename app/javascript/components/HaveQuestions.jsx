import React, { Component, useState } from 'react';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import { Link, Heading } from "@nypl/design-system-react-components";

export default class HaveQuestions extends Component {
	
	constructor(props) {
    super(props);
  }

	render() {
    return (
      <>
        <Heading id="heading-tertiary" level="one" size="tertiary" text="Have Questions?" />
      	<div id="have-questions-links" className="have_questions_links">
	      	Visit Our
	      	<Link id="home-faq-link" type="action" target="_blank">
	          <ReactRouterLink to="/faq"  target="_blank" className="home_page_left">Faq Page</ReactRouterLink>
	        </Link>
	        {<br/>}
	        Or Get in
	        <Link id="home-contact-link" type="action">
	          <ReactRouterLink to="/contacts" target="_blank" className="home_page_left">Contact Us</ReactRouterLink>
	        </Link>
	      </div>
      </>
    )
  }
}