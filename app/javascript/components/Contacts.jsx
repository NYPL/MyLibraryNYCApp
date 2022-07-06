import React from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";

import { DSProvider, TemplateAppContainer } from '@nypl/design-system-react-components';
const Contacts = (props) => {
  return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <div id="contacts-page">
              <div className="contacts_page_text">
                Have a question about library cards, your account, or {<br/>}
                library staff visiting your school for professional development?
              </div>{<br/>}{<br/>}

              <div id="contact-school-emails" className="contact_email_text">
                For schools in The Bronx, Manhattan, and Staten Island{<br/>}
                <a id="mln-nypl-email" className="contact_email" href="mailto:mylibrarynyc@nypl.org">mylibrarynyc@nypl.org</a>{<br/>}{<br/>}


                For schools in Brooklyn{<br/>}
                <a id="mln-brooklyn-email" className="contact_email" href="mailto:mylibrarynyc@bklynlibrary.org">mylibrarynyc@bklynlibrary.org</a>{<br/>}{<br/>}


                For schools in Queens{<br/>}
                <a id="mln-queens-email" className="contact_email" href="mailto:mylibrarynyc@queenslibrary.org">mylibrarynyc@queenslibrary.org</a>{<br/>}{<br/>}

                General questions{<br/>}
                <a id="mln-help-email" className="contact_email" href="mailto:help@mylibrarynyc.org">help@mylibrarynyc.org</a>{<br/>}{<br/>}


                Delivery Questions{<br/>}
                <a id="mln-delivery-email" className="contact_email" href="mailto:delivery@mylibrarynyc.org">delivery@mylibrarynyc.org</a>{<br/>}{<br/>}

                <span className="help-text contacts_page_text">Have questions about MyLibraryNYC or how to join?</span>{<br/>}

                Search our list of schools to see if your school already participates{<br/>}
                <a id="mln-ps-link" className="contact_email" href="http://www.mylibrarynyc.org/schools">Participating schools</a>{<br/>}{<br/>}


                To find out if your school is eligible to participate in the program next year{<br/>}
                Call me <a id="doe-service" className="contact_email" href="http://nycdoe.libguides.com/home">DOE Office of Library Services</a> at 917-521-3734.

              </div>
            </div>
          }
          contentSidebar={<HaveQuestions />}
          sidebar="right"          
        />
  )
}

export default Contacts;