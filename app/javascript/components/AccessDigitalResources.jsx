import React from 'react';
import { Accordion, Link, List, Heading, Text } from '@nypl/design-system-react-components';

export default function AccessDigitalResources(props) {

    return (
      <>
        <Heading id="access-digital-resources-header-text" level="three">Access Digital Resources</Heading>
        <Accordion id="access-digital-resources" accordionData={ [
          {
            label: "Databases",
            panel: (
              <p>
                <Text>Access databases from anywhere with an internet connection by entering the barcode on the back of your MyLibraryNYC card.</Text>
                <a href="http://www.bklynlibrary.org/eresources">Brooklyn Public Library Articles and Databases</a>
                <Text>Provides a list of databases for children, teens, and adults.</Text>
                <a href="http://www.nypl.org/collections/articles-databases">New York Public Library Databases</a>
                <Text>Offers the option to limit searches by audience to children or teens/young adults.</Text>
                <a href="https://www.queenslibrary.org/research/research-databases">Queens Public Library Databases</a>
                <Text>Features a list of databases intended for schoolwork.</Text>
                <Text>See your school librarian if you encounter technical issues or need further assistance. You may also <a href="http://www.mylibrarynyc.org/contacts-links">contact</a> your public library for help.</Text>
              </p>
            ),
          } ]}
        />
        <Accordion marginTop="s" accordionData={ [
          {
            label: "E-Books and More",
            panel: (
              <p>
                <Text>Find titles for children and young adults in your public library’s ebook collection.</Text>
                <Text><a href="http://www.bklynlibrary.org/e-books-and-more">Brooklyn Public Library Ebooks</a></Text>
                <Text><a href="http://www.nypl.org/ebooks">New York Public Library Ebooks</a></Text>
                <Text><a href="https://www.queenslibrary.org/help/how-to-access-digital-media/eBooks">Queens Public Library Ebooks</a></Text>
              </p>
            ),
          } ]}
        />
        <Accordion marginTop="s" accordionData={ [
          {
            label: "Other Resources",
            panel: (
              <p>
                <Link style={{"text-decoration": "none"}} href="http://www.bklynlibrary.org/brooklyncollection/connections">Brooklyn Connections</Link>
                <Text >Gives rare access to original archival materials in Brooklyn Public Library's Brooklyn Collection while students complete customized, standards-based projects.</Text>

                <Link style={{"text-decoration": "none"}} href="http://www.nypl.org/blog/subject/7716">NYPL Common Core Resources</Link>
                <Text>Lists Common Core resources developed by teachers and librarians.</Text>

                <Link style={{"text-decoration": "none"}} href="http://digitalcollections.nypl.org/">NYPL Digital Collections</Link>
                <Text>Contains over 800,000 digitized items from NYPL’s vast holdings. Many of them are primary source materials.</Text>

                <Link style={{"text-decoration": "none"}} href="https://www.queenslibrary.org/programs-activities/teens/homework-resources">Queens Public Library Homework Help</Link>
                <Text>Gathers trusted resources that help students tackle their homework.</Text>

                <Link style={{"text-decoration": "none"}} href="https://www.engageny.org/resource/empire-state-information-fluency-continuum">Empire State Information Fluency Continuum</Link>
                <Text>Identifies three information literacy standards, indicators for each standard, and the skills that students should develop by grades 2, 5, 8, and 12.</Text>

                <Link style={{"text-decoration": "none"}} href="http://schools.nyc.gov/Academics/CommonCoreLibrary/default.htm">NYDOE Common Core Library</Link>
                <Text>Provides Common Core-aligned tasks, professional development resources, and more.</Text>
              </p>
            ),
          }] }
        />
    </>)
  }