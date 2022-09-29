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
              <Heading id="general-information-heading" level="two" size="secondary" marginBottom="s" text="General Information"/>
              <Text size="default" marginBottom="l">Have a question about library cards, your account or delivery?</Text>
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

              <Heading id="library-cards-account" marginTop="xl" level="two" size="secondary" text="Professional Development"/>
              <Text marginTop="s" marginBottom="l" size="default">Want to find out about library staff visiting your school?</Text>
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

              <Heading id="my-library-nyc-questions" level="two" marginTop="xl" size="secondary" text="Joining MyLibraryNYC"/>
              <Text marginTop="s" marginBottom="l" size="default">Do you have questions about MyLibraryNYC or how to join?</Text>
            
              <Heading id="my-library-nyc-questions" level="three" size="tertiary" text="Find Your School"/>
              <Text marginTop="s" marginBottom="l" size="default">Search our list of schools to see if your school already participates.</Text>
              <Link id="mln-ps-link" href="http://www.mylibrarynyc.org/schools">Participating schools</Link>

              <Heading id="eligibility" marginTop="l" level="three" size="tertiary" text="Eligibility"/>
              To find out if your school is eligible to participate in the program next year Call the 
              <Link marginTop="s" marginBottom="l" id="eligible-to-participate-in-program" href="https://nycdoe.libguides.com/home"> DOE Office of Library Services</Link>
              <Table
                columnHeaders={["Information", "Contact Number"]}
                className="contactInfo"
                useRowHeaders
                tableData={[
                  [
                    <Text>Phone</Text>,
                    <Text>917-521-3734</Text>
                  ],
                  [
                    <Text>Website</Text>,
                    <Link href="http://nycdoe.libguides.com/home">DOE Office of Library Services</Link>
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