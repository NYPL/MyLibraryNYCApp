import React from "react";
import { Notification, Icon } from "@nypl/design-system-react-components";

export default function SignedInMsg(props) {
  const details = props.signInDetails;
  const notification = () => {
    if (
      !details.hideSignInMsg &&
      details.userSignedIn &&
      details.signInMsg !== ""
    ) {
      return (
        <Notification
          icon={
            <Icon name="actionCheckCircleFilled" color="ui.success.primary" />
          }
          ariaLabel="SignIn Notification"
          id="sign-in-notification"
          notificationType="announcement"
          notificationContent="Signed in successfully!"
        />
      );
    } else {
      return null;
    }
  };

  return notification();
}
