import React  from 'react';
import { Link as ReactRouterLink } from "react-router-dom";

import { Link, Heading, VStack, Grid, GridItem, HStack } from "@nypl/design-system-react-components";


export default function HaveQuestions(props) {

  return (
    <>
      <Heading id="heading-tertiary" level="two" size="tertiary" text="Have Questions?" />
      <div id="have-questions-links">
        <p className="visitOurText">Visit Our{' '}
          <Link id="home-faq-link" type="action" target="_blank">
            <ReactRouterLink to="/faq"  target="_blank">Faq Page</ReactRouterLink>
          </Link>
        </p>
        <p>Or{' '}
          <Link id="home-contact-link" type="action">
            <ReactRouterLink to="/contacts" target="_blank"> Contact Us</ReactRouterLink>
          </Link>
        </p>
      </div>
    </>
  )
}
