import React, {useState} from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";

import { DSProvider, TemplateAppContainer, Heading, Flex, HStack, Table, Text, Link} from '@nypl/design-system-react-components';

function Contacts(props) {
  return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <div id="contacts-page">
              <Heading id="general-information-heading" level="two" size="secondary" text="General Information"/>
              <Text size="default">Have a question about library cards, your account or delivery?</Text>
              <Table
                  columnHeaders={["Information", "Contact Emails"]}
                  className="contactInfo"
                  useRowHeaders
                  tableData={[
                    [
                      <Text>General Information</Text>,
                      <Link id="mln-help-email" href="mailto:help@mylibrarynyc.org">help@mylibrarynyc.org</Link>,
                    ],
                    [ 
                      <Text>Delivery Questions</Text>,
                      <Link id="mln-delivery-email" href="mailto:delivery@mylibrarynyc.org">delivery@mylibrarynyc.org</Link>
                    ]
                  ]}
              />

              <Heading id="library-cards-account" marginTop="30px" level="two" size="secondary" text="Professional Development"/>
              <div>Want to find out about library staff visiting your school?</div>
              <Table
                  columnHeaders={["Information", "Contact Emails"]}
                  className="contactInfo"
                  useRowHeaders
                  tableData={[
                    [
                      <Text>The Bronx, Manhattan and Staten Island</Text>,
                      <Link id="mln-nypl-email" href="mailto:mylibrarynyc@nypl.org">mylibrarynyc@nypl.org</Link>
                    ],
                    [
                      <Text>Brooklyn</Text>,
                      <Link id="mln-brooklyn-email" href="mailto:mylibrarynyc@bklynlibrary.org">mylibrarynyc@bklynlibrary.org</Link>
                    ],

                    [
                      <Text>Queens</Text>,
                      <Link id="mln-queens-email" href="mailto:mylibrarynyc@queenslibrary.org">mylibrarynyc@queenslibrary.org</Link>
                    ]
                  ]}
              />

              <Heading id="my-library-nyc-questions" level="two" marginTop="30px" size="secondary" text="Joining MyLibraryNYC"/>
              <div>Do you have questions about MyLibraryNYC or how to join?</div>
            
              <Heading id="my-library-nyc-questions" level="three" marginTop="30px" size="tertiary" text="Find Your School"/>
              <div>Search our list of schools to see if your school already participates.</div>
              <Link id="mln-ps-link" href="http://www.mylibrarynyc.org/schools">Participating schools</Link>

              <Heading id="eligibility" level="three" marginTop="30px" size="tertiary" text="Eligibility"/>
              To find out if your school is eligible to participate in the program next year Call the 
              <Link id="eligible-to-participate-in-program" href="https://nycdoe.libguides.com/home"> DOE Office of Library Services</Link>
              <Table
                marginTop="s"
                columnHeaders={["Information", "Contact Number"]}
                className=""
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
          contentSidebar={<HaveQuestions />}
          sidebar="right"          
        />
  )
}

export default Contacts;