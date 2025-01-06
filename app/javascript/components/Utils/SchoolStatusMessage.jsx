import React from "react";
import { Banner, Link } from "@nypl/design-system-react-components";

export const renderInactiveSchoolMessage = (isSchoolActive) => {
  if (isSchoolActive === false) {
    return (
      <Banner
        content={<>
          Your school is inactive, so your account is restricted. Please contact{' '}
          <Link 
            href="mailto:help@mylibrarynyc.org" 
            target="_blank" 
            rel="noreferrer"
          >
            help@mylibrarynyc.org
          </Link>.
        </>}
        type="warning"
      />
    );
  }
  return null;  // Return null if the school is active
};

