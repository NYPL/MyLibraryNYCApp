import React, { Component, useState } from 'react';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

import { Link, Heading, VStack, Grid, GridItem, HStack } from "@nypl/design-system-react-components";

export default class HaveQuestions extends Component {
  
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <>
        <Heading id="heading-tertiary" level="four" size="tertiary" text="Have Questions?" />
        <div id="have-questions-links">
            <p>Visit Our{' '}
              <Link marginTop="s" id="home-faq-link" type="action" target="_blank">
                <ReactRouterLink to="/faq"  target="_blank">Faq Page</ReactRouterLink>
              </Link>
            </p>
            <p style={{"margin-top": "-12px"}}>Or{' '}
              <Link marginTop="xss" id="home-contact-link" type="action">
                <ReactRouterLink to="/contacts" target="_blank"> Contact Us</ReactRouterLink>
              </Link>
            </p>
        </div>
      </>
    )
  }
}