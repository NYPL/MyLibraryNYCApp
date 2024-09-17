import React from "react";
import { Banner } from "@nypl/design-system-react-components";

export default function SignedInMsg(props) {
  const details = props.signInDetails;
  const notification = () => {
    if (
      !details.hideSignInMsg &&
      details.userSignedIn &&
      details.signInMsg !== ""
    ) {
      return (
        <Banner
          id="sign-in-notification"
          ariaLabel="SignIn Notification"
          content="Signed in successfully!"
          type="informative"
        />
      );
    } else {
      return null;
    }
  };

  return notification();
}
