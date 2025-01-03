import React from "react";
import { Banner } from "@nypl/design-system-react-components";

export const renderInactiveSchoolMessage = (isSchoolActive) => {
  if (isSchoolActive === false) {
    return (
      <Banner
        content={<>
          Your school is inactive, so your account is restricted. Please contact help@mylibrarynyc.org.
        </>}
        type="warning"
      />
    );
  }
  return null;  // Return null if the school is active
};

