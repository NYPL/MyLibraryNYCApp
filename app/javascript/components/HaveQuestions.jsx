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
      	<div className="have_questions"> Have Questions? </div>
      	<div className="have_questions_links">
	      	Visit Our
	      	<Link type={LinkTypes.Action} target="_blank">
	          <ReactRouterLink to="/faq"  target="_blank" className="home_page_left">Faq Page</ReactRouterLink>
	        </Link>
	        {<br/>}
	        Or Get in
	        <Link type={LinkTypes.Action}>
	          <ReactRouterLink to="/contacts" target="_blank" className="home_page_left">Touch With Us</ReactRouterLink>
	        </Link>
	      </div>
      </>
    )
  }
}