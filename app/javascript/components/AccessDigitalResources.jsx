import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import { Accordion, Link, List, Heading } from '@nypl/design-system-react-components';

export default class AccessDigitalResources extends Component {

  constructor(props) {
    super(props);
  }


  Databases(){
    return <Accordion
      accordionLabel="Database"
      inputId={"accordionBtn-" + 1}
      modifiers={[
        'faq'
      ]}>
      <React.Fragment key=".{1}">
        <p className="plain_text">
          <br/>
          Access databases from anywhere with an internet connection by entering the barcode on the back of your MyLibraryNYC card."<br/><br/>
            <a className="href_link" href="http://www.bklynlibrary.org/eresources">Brooklyn Public Library Articles and Databases</a>
             <div>Provides a list of databases for children, teens, and adults.</div><br/>

            <a className="href_link" href="http://www.nypl.org/collections/articles-databases">New York Public Library Databases</a><br/>
              Offers the option to limit searches by audience to children or teens/young adults.<br/><br/>

            <a className="href_link" href="https://www.queenslibrary.org/research/research-databases">Queens Public Library Databases</a><br/>
            Features a list of databases intended for schoolwork.<br/><br/>

            See your school librarian if you encounter technical issues or need further assistance. You may also <a href="http://www.mylibrarynyc.org/contacts-links">contact</a> your public library for help.<br/><br/>

        </p>
      </React.Fragment>
    </Accordion>
  }


  EbooksAndMore() {
    return <Accordion
      accordionLabel="E-Books and More"
      inputId={"accordionBtn-" + 2}
      modifiers={[
        'faq'
      ]}>
      <React.Fragment key=".{2}">
        <p className="plain_text">
          <br/>
          Find titles for children and young adults in your public library’s ebook collection. <br/><br/>
          <a className="href_link" href="http://www.bklynlibrary.org/e-books-and-more">Brooklyn Public Library Ebooks</a><br/>
          <a className="href_link" href="http://www.nypl.org/ebooks">New York Public Library Ebooks</a><br/>
          <a className="href_link" href="https://www.queenslibrary.org/help/how-to-access-digital-media/eBooks">Queens Public Library Ebooks</a><br/><br/>
        </p>
      </React.Fragment>
    </Accordion>
  }


  OtherDigitalResources() {
    return <Accordion
      accordionLabel="Other Resources"
      inputId={"accordionBtn-" + 3}
      modifiers={[
        'faq'
      ]}>
      <React.Fragment key=".{3}">
        <p className="plain_text">
          <br/>
          <a className="href_link" href="http://www.bklynlibrary.org/brooklyncollection/connections">Brooklyn Connections</a><br/>
          Gives rare access to original archival materials in Brooklyn Public Library's Brooklyn Collection while students complete customized, standards-based projects.<br/><br/>

          <a className="href_link" href="http://www.nypl.org/blog/subject/7716">NYPL Common Core Resources</a><br/>
          Lists Common Core resources developed by teachers and librarians.<br/><br/>

          <a className="href_link" href="http://digitalcollections.nypl.org/">NYPL Digital Collections</a><br/>
          Contains over 800,000 digitized items from NYPL’s vast holdings. Many of them are primary source materials.<br/><br/>

          <a className="href_link" href="https://www.queenslibrary.org/programs-activities/teens/homework-resources">Queens Public Library Homework Help</a><br/>
          Gathers trusted resources that help students tackle their homework.<br/><br/>

          <a className="href_link" href="https://www.engageny.org/resource/empire-state-information-fluency-continuum">Empire State Information Fluency Continuum</a><br/>
          Identifies three information literacy standards, indicators for each standard, and the skills that students should develop by grades 2, 5, 8, and 12.<br/><br/>

          <a className="href_link" href="http://schools.nyc.gov/Academics/CommonCoreLibrary/default.htm">NYDOE Common Core Library</a><br/>
          Provides Common Core-aligned tasks, professional development resources, and more.
        </p>
      </React.Fragment>
    </Accordion>
  }

  AccessResources() {
    return <div className="nypl-ds"><List  modifiers={['no-list-styling' ]} type="ul">
      <li>
        {this.Databases()}
      </li>

      <li>
        {this.EbooksAndMore()}
      </li>

      <li>
        {this.OtherDigitalResources()}
      </li>
    </List>
    </div>
  }


  render() {
    return (
      <div className="alignment">
        <div className="access_digital_resources">Access Digital Resources</div>
        {this.AccessResources()}
      </div>
    )
  }

}