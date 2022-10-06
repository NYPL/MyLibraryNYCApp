import React, { useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import { TemplateAppContainer } from '@nypl/design-system-react-components';

export default function SignOut(props) {

  const [loggedOut, setLoggedOut] = useState("")


  const signOutMessage = () => {
    if (loggedOut) {
      return "Signed out successfully"
    }
  }

  return (
    <TemplateAppContainer
      breakout={<><AppBreadcrumbs />
        {signOutMessage()}
      </>}
    />
  )
  
}