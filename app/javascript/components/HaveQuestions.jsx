import React, { Component, useState } from 'react';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import { Link, LinkTypes } from "@nypl/design-system-react-components";

export default class HaveQuestions extends Component {
	
	constructor(props) {
    super(props);
  }

	render() {
    return (
      <>
      	<div id="have-questions" className="have_questions">Have Questions?</div>
      	<div id="have-questions-links" className="have_questions_links">
	      	Visit Our
	      	<Link id="home-faq-link" type={LinkTypes.Action} target="_blank">
	          <ReactRouterLink to="/faq"  target="_blank" className="home_page_left">Faq Page</ReactRouterLink>
	        </Link>
	        {<br/>}
	        Or Get in
	        <Link id="home-contact-link" type={LinkTypes.Action}>
	          <ReactRouterLink to="/contacts" target="_blank" className="home_page_left">Contact Us</ReactRouterLink>
	        </Link>
	      </div>
      </>
    )
  }
}