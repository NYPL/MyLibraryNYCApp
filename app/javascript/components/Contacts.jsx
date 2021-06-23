import React from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";

const Contacts = (props) => {
  return (
    <div>
    	<AppBreadcrumbs />
      <h1 className="pg--title">Contacts</h1>
  		<div className="pg--content">
  			Have a question about library cards, your account, or 
    		library staff visiting your school for professional development?
  		</div>
    </div>
  );
}

export default Contacts;