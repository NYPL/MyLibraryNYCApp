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
  const [buttonDisabled, setButtonDisabled] = useState(false);
  const [isInvalidEmail, setIsInvalidEmail] = useState(false);
  const [successFullySignedUp, setSuccessFullySignedUp] = useState(false);
  const [confirmationHeading, setConfirmationHeading] = useState("");
  const { isLargerThanMobile } = useNYPLBreakpoints();
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
    if (successFullySignedUp) {
      if (env.RAILS_ENV !== "test" && env.RAILS_ENV !== "local") {
        {
          adobeAnalyticsForNewsLetter();
        }
      }
    }
    return (
      <NewsletterSignup
        id="news-letter-text-input"
        view={view}
        isInvalidEmail={isInvalidEmail}
        valueEmail={email}
        onChange={handleNewsLetterEmail}
        onSubmit={handleSubmit}
        showPrivacyLink={false}
        title="Sign Up for Our Newsletter"
        descriptionText="Learn about new teacher sets, best practices & exclusive events when you sign up for the MyLibraryNYC Newsletter!"
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
        confirmationText="Check your email to learn about teacher sets, best practices & exclusive events."
      />
    );
  };

  const adobeAnalyticsForNewsLetter = () => {
    // Push the event data to the Adobe Data Layer
    window.adobeDataLayer = window.adobeDataLayer || [];
    window.adobeDataLayer.push({
      event: "virtual_page_view",
      page_name: "mylibrarynyc|news-letter-signup",
      site_section: "News Letter",
    });

    // Dynamically create and insert the script tag for Adobe Launch
    const script = document.createElement("script");
    script.src = env.ADOBE_LAUNCH_URL; // assuming you are using a bundler that supports environment variables
    script.async = true;
    document.head.appendChild(script);
  };

  return (
    <Box p="l" ref={newsLetterMsgRef} id="news-letter-success-msg">
      {newLetterSignup()}
    </Box>
  );
}
