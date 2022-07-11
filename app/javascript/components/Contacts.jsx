import React, {useState} from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";

import { DSProvider, TemplateAppContainer, Heading, Flex, HStack, Table } from '@nypl/design-system-react-components';

function Contacts(props) {
  return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <div id="contacts-page">
              <Heading id="general-information-heading" level="two" size="secondary" text="General Information"/>
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

              <Heading id="library-cards-account" marginTop="30px" level="two" size="secondary" text="Library Cards, Your Account or Professional Development"/>
              <div>Have a question about library cards, your account, or library staff visiting your school for professional development?</div>
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
              To find out if your school is eligible to participate in the program next year Call the DOE Office of Library Services.
              <Table
                className="contactsInfo"
                useRowHeaders
                tableData={[
                  [
                    'Phone',
                    '917-521-3734'
                  ],
                  [
                    'Brooklyn',
                    <a id="doe-service" className="contact_email" href="http://nycdoe.libguides.com/home">nycdoe.libguides.com</a> 
                  ]
                ]}
              />              
            </div>
          }
          contentSidebar={<HaveQuestions />}
          sidebar="right"          
        />
  )
}

export default Contacts;