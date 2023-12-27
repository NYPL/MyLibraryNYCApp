import React, { useEffect } from "react";
import { Notification, Icon } from "@nypl/design-system-react-components";

export default function SignUpMsg(props) {
  useEffect(() => {
    window.scrollTo(0, 0);
  })
  const details = props.signUpDetails;
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
