import React, { useEffect } from "react";
import AppBreadcrumbs from "./../AppBreadcrumbs";
import HaveQuestions from "./../HaveQuestions/HaveQuestions";
import {
  TemplateAppContainer,
  Heading,
  Table,
  Text,
  Link,
  useColorMode,
} from "@nypl/design-system-react-components";

function Contact() {
  const { colorMode } = useColorMode();
  useEffect(() => {
    document.title = "Contact | MyLibraryNYC";
    if (env.RAILS_ENV !== "test") {
      window.scrollTo(0, 0);
    }
  }, []);

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentPrimary={
        <div id="contacts-page">
          <Heading
            id="general-information-heading"
            level="h2"
            size="heading3"
            marginBottom="s"
            text="General Information"
          />
          <Text size="default" marginBottom="l">
            Have a question about library cards, your account or delivery?
          </Text>
          <Table
            columnHeaders={["Information", "Contact Emails"]}
            className={`${colorMode} contactInfo`}
            useRowHeaders
            tableData={[
              [
                <Text key="general-ino" noSpace className={`${colorMode}`}>
                  General Information
                </Text>,
                <Link
                  key="mln-help-email-key"
                  id="mln-help-email"
                  href="mailto:help@mylibrarynyc.org"
                >
                  help@mylibrarynyc.org
                </Link>,
              ],
              [
                <Text key="delivery-questions" noSpace className={`${colorMode}`}>
                  Delivery Questions
                </Text>,
                <Link
                  key="delivery-questions-link"
                  id="mln-delivery-email"
                  href="mailto:delivery@mylibrarynyc.org"
                >
                  delivery@mylibrarynyc.org
                </Link>,
              ],
            ]}
          />
          <Heading
            id="library-cards-account"
            marginTop="xl"
            level="h2"
            size="heading3"
            text="Professional Development"
          />
          <Text marginTop="s" marginBottom="l" size="default">
            Want to find out about library staff visiting your school?
          </Text>
          <Table
            columnHeaders={["Information", "Contact Emails"]}
            className={`${colorMode} contactInfo`}
            useRowHeaders
            tableData={[
              [
                <Text key="mln-nypl-email-text" noSpace>
                  The Bronx, Manhattan and Staten Island
                </Text>,
                <Link
                  key="mln-nypl-email-link"
                  id="mln-nypl-email"
                  href="mailto:mylibrarynyc@nypl.org"
                >
                  mylibrarynyc@nypl.org
                </Link>,
              ],
              [
                <Text key="brooklyn-text" noSpace>
                  Brooklyn
                </Text>,
                <Link
                  key="mln-brooklyn-link"
                  id="mln-brooklyn-email"
                  href="mailto:mylibrarynyc@bklynlibrary.org"
                >
                  mylibrarynyc@bklynlibrary.org
                </Link>,
              ],

              [
                <Text key="mln-queens-email-text" noSpace>
                  Queens
                </Text>,
                <Link
                  key="mln-queens-email-link"
                  id="mln-queens-email"
                  href="mailto:mylibrarynyc@queenslibrary.org"
                >
                  mylibrarynyc@queenslibrary.org
                </Link>,
              ],
            ]}
          />
          <Heading
            id="my-library-nyc-questions-secondary"
            level="h2"
            marginTop="xl"
            size="heading3"
            text="Joining MyLibraryNYC"
          />
          <Text marginTop="s" marginBottom="l" size="default">
            Do you have questions about MyLibraryNYC or how to join?
          </Text>
          <Heading
            id="my-library-nyc-questions-tertiary"
            level="h3"
            size="heading5"
            text="Find Your School"
          />
          <Text marginTop="s" marginBottom="l" size="default">
            Search our list of schools to see if your school already
            participates.
          </Text>
          <Link id="mln-ps-link" type="external" href="http://www.mylibrarynyc.org/participating-schools">
            Participating schools
          </Link>
          <Heading
            id="eligibility"
            marginTop="l"
            level="h3"
            size="heading5"
            text="Eligibility"
          />
          To find out if your school is eligible to participate in the program
          next year Call the
          <Link
            marginTop="s"
            marginBottom="l"
            id="eligible-to-participate-in-program"
            href="https://nycdoe.libguides.com/home"
          >
            {" "}
            DOE Office of Library Services
          </Link>
          <Table
            columnHeaders={["Information", "Contact Number"]}
            className={`${colorMode} contactInfo`}
            useRowHeaders
            tableData={[
              [
                <Text key="phone-text" noSpace>
                  Phone
                </Text>,
                <Text key="phone-number">917-521-3734</Text>,
              ],
              [
                <Text key="website-text" noSpace>
                  Website
                </Text>,
                <Link
                  key="doe-ofc-link"
                  href="http://nycdoe.libguides.com/home"
                >
                  DOE Office of Library Services
                </Link>,
              ],
            ]}
          />
        </div>
      }
      contentSidebar={<HaveQuestions />}
      sidebar="right"
    />
  );
}

export default Contact;
