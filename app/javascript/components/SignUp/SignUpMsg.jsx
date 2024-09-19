import React, { useEffect } from "react";
import { Banner } from "@nypl/design-system-react-components";

export default function SignUpMsg(props) {
  const details = props.signUpDetails;

  useEffect(() => {
    if (
      details.userSignedIn &&
      details.signedUpMessage !== "" && env.RAILS_ENV !== "test"
    ) {
      window.scrollTo(0, 0);
    }
  })
  
  const notification = () => {
    if (
      details.userSignedIn &&
      details.signedUpMessage !== ""
    ) {
      return (
        <Banner
          id="sign-up-notification"
          ariaLabel="SignUp Notification"
          mb="l"
          content={details.signedUpMessage}
          heading="Registration Successful!"
          type="positive"
        />
      );
    } else {
      return null;
    }
  };

  return notification();
}
