import React, { useEffect } from "react";
import { Notification, Icon } from "@nypl/design-system-react-components";

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
        <Notification
          icon={
            <Icon name="actionCheckCircleFilled" color="ui.success.primary" />
          }
          ariaLabel="SignUp Notification"
          id="sign-up-notification"
          notificationHeading="Registration Successful!"
          notificationType="announcement"
          notificationContent={details.signedUpMessage}
        />
      );
    } else {
      return null;
    }
  };

  return notification();
}
