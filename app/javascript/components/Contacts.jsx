import React from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import { DSProvider, TemplateAppContainer } from '@nypl/design-system-react-components';
const Contacts = (props) => {
  return (
    <>
      <AppBreadcrumbs />
      <DSProvider>
        <TemplateAppContainer
          breakout=""
          contentPrimary={
            <div className="contacts_page">
              <div className="contacts_page_text">
                Have a question about library cards, your account, or {<br/>}
                library staff visiting your school for professional development?
              </div>{<br/>}{<br/>}

              <div className="contact_email_text">
                For schools in The Bronx, Manhattan, and Staten Island{<br/>}
                <a className="contact_email" href="mailto:mylibrarynyc@nypl.org">mylibrarynyc@nypl.org</a>{<br/>}{<br/>}


                For schools in Brooklyn{<br/>}
                <a className="contact_email" href="mailto:mylibrarynyc@bklynlibrary.org">mylibrarynyc@bklynlibrary.org</a>{<br/>}{<br/>}


                For schools in Queens{<br/>}
                <a className="contact_email" href="mailto:mylibrarynyc@queenslibrary.org">mylibrarynyc@queenslibrary.org</a>{<br/>}{<br/>}

                General questions{<br/>}
                <a className="contact_email" href="mailto:help@mylibrarynyc.org">help@mylibrarynyc.org</a>{<br/>}{<br/>}


                Delivery Questions{<br/>}
                <a className="contact_email" href="mailto:delivery@mylibrarynyc.org">delivery@mylibrarynyc.org</a>{<br/>}{<br/>}

                <span className="help-text contacts_page_text">Have questions about MyLibraryNYC or how to join?</span>{<br/>}

                Search our list of schools to see if your school already participates{<br/>}
                <a className="contact_email" href="http://www.mylibrarynyc.org/about/participating-schools">Participating schools</a>{<br/>}{<br/>}


                To find out if your school is eligible to participate in the program next year{<br/>}
                Call me <a className="contact_email" href="http://nycdoe.libguides.com/home">DOE Office of Library Services</a> at 917-521-3734.

              </div>
            </div>
          }
          contentSidebar=""
          sidebar="right"          
        />
      </DSProvider>
    </>
  )
}

export default Contacts;