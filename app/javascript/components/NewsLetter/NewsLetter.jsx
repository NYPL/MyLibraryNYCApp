import React, { useState, useRef } from "react";
import axios from "axios";
import validator from "validator";
import {
  Text,
  Box,
  Link,
  useNYPLBreakpoints,
  NewsletterSignup,
} from "@nypl/design-system-react-components";

export default function NewsLetter() {
  const [message, setMessage] = useState("");
  const [email, setEmail] = useState("");
  const [isInvalidEmail, setIsInvalidEmail] = useState(false);
  const [successFullySignedUp, setSuccessFullySignedUp] = useState(false);
  const [confirmationHeading, setConfirmationHeading] = useState("");
  const newsLetterMsgRef = useRef(null);
  const [view, setView] = React.useState("form");

  const handleNewsLetterEmail = (event) => {
    setEmail(event.target.value);
    setIsInvalidEmail(false);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    if (!validator.isEmail(email)) {
      setIsInvalidEmail(true);
      setView("form");
      return;
    } else {
      setView("submitting");
    }
    axios
      .get("/news_letter/index", {
        params: {
          email: email,
        },
      })
      .then((res) => {

        if (res.data.status === "success") {
          setSuccessFullySignedUp(true);
          setView("confirmation");
          setConfirmationHeading("Thank you for signing up to the Newsletter!");
        } else if (res.data.status === "error" && res.data.message === 'That email is already subscribed to the MyLibraryNYC newsletter.') {
          setConfirmationHeading("Thank you for signing up for our newsletter!");
        } else if (
          res.data.status === "error" &&
          res.data.message ===
            "That email is already subscribed to the MyLibraryNYC newsletter."
        ) {
          setView("confirmation");
          setConfirmationHeading("That email is already subscribed to the newsletter.");
        }
        else {
          console.log("error")
          setView("error");
          setMessage("An error has occurred.");
        }
      })
      .catch(function (error) {
        console.log(error);
      });
  };

  const newLetterSignup = () => {
    return (
      <NewsletterSignup
        id="news-letter-text-input"
        view={view}
        isInvalidEmail={isInvalidEmail}
        valueEmail={email}
        onChange={handleNewsLetterEmail}
        onSubmit={handleSubmit}
        showPrivacyLink={false}
        title="Sign up for our newsletter"
        descriptionText="Learn about new teacher sets, best practices, and exclusive events when you sign up for the MyLibraryNYC Newsletter!"
        confirmationHeading={confirmationHeading}
        errorHeading={message}
        highlightColor="brand.primary"
        errorText={
          <Text noSpace size="body2">
            Please refresh this page and try again. If this error persists,
            <Link
              type="action"
              target="_blank"
              href="mailto:help@mylibrarynyc.org"
            >
              contact our e-mail team.
            </Link>
          </Text>
        }
        confirmationText="Check your email to learn about teacher sets, best practices, and exclusive events."
      />
    );
  };

  return (
    <Box ref={newsLetterMsgRef} id="news-letter-success-msg">
      {newLetterSignup()}
    </Box>
  );
}
