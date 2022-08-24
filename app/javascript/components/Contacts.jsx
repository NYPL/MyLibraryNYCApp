import React, {useState} from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";

import { DSProvider, TemplateAppContainer, Heading, Flex, HStack, Table, Text } from '@nypl/design-system-react-components';

function Contacts(props) {
  return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <div id="contacts-page">
              <Heading id="general-information-heading" level="two" size="secondary" text="General Information"/>
              <Text size="default">Have a question about library cards, your account or delivery?</Text>
              <Table
                  className="generalInfo"
                  useRowHeaders
                  tableData={[
                    [
                      'General Information',
                       <a id="mln-help-email" className="contact_email" href="mailto:help@mylibrarynyc.org">help@mylibrarynyc.org</a>,
                    ],
                    [ 
                      'Delivery Questions',
                      <a id="mln-delivery-email" className="contact_email" href="mailto:delivery@mylibrarynyc.org">delivery@mylibrarynyc.org</a>
                    ]
                  ]}
              />

              <Heading id="library-cards-account" marginTop="30px" level="two" size="secondary" text="Professional Development"/>
              <div>Want to find out about library staff visiting your school?</div>
              <Table
                  className="libraryCards"
                  useRowHeaders
                  tableData={[
                    [
                      'The Bronx, Manhattan and Staten Island',
                      <a id="mln-nypl-email" className="contact_email" href="mailto:mylibrarynyc@nypl.org">mylibrarynyc@nypl.org</a>
                    ],
                    [
                      'Brooklyn',
                      <a id="mln-brooklyn-email" className="contact_email" href="mailto:mylibrarynyc@bklynlibrary.org">mylibrarynyc@bklynlibrary.org</a>
                    ],

                    [
                      'Queens',
                       <a id="mln-queens-email" className="contact_email" href="mailto:mylibrarynyc@queenslibrary.org">mylibrarynyc@queenslibrary.org</a>

                    ]
                  ]}
              />

              <Heading id="my-library-nyc-questions" level="two" marginTop="30px" size="secondary" text="Joining MyLibraryNYC"/>
              <div>Do you have questions about MyLibraryNYC or how to join?</div>
            
              <Heading id="my-library-nyc-questions" level="three" marginTop="30px" size="tertiary" text="Find Your School"/>
              <div>Search our list of schools to see if your school already participates.</div>
              <a id="mln-ps-link" className="contact_email" href="http://www.mylibrarynyc.org/schools">Participating schools</a>

              <Heading id="eligibility" level="three" marginTop="30px" size="tertiary" text="Eligibility"/>
              To find out if your school is eligible to participate in the program next year Call the 
              <a id="eligible-to-participate-in-program" href="https://nycdoe.libguides.com/home"> DOE Office of Library Services</a>
              <Table
                marginTop="s"
                className="contactsInfo"
                useRowHeaders
                tableData={[
                  [
                    'Phone',
                    '917-521-3734'
                  ]
                ]}
              />              
            </div>
          }
          contentSidebar={<div><HaveQuestions /></div>}
          sidebar="right"          
        />
  )
}

export default Contacts;