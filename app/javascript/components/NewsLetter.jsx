import React, { useState, useRef } from "react";
import axios from "axios";
import validator from "validator";
import {
  Button,
  Text,
  Box,
  ProgressIndicator,
  Link,
  useNYPLBreakpoints,
  NewsletterSignup,
} from "@nypl/design-system-react-components";

export default function NewsLetter() {
  const [errorMessage, setErrorMessage] = useState("");
  const [email, setEmail] = useState("");
  const [buttonDisabled, setButtonDisabled] = useState(false);
  const [isInvalid, setIsInvalid] = useState(false);
  const [successFullySignedUp, setSuccessFullySignedUp] = useState(false);
  const { isLargerThanMobile } = useNYPLBreakpoints();
  const newsLetterMsgRef = useRef(null);
  const [view, setView] = React.useState("form");

  const handleNewsLetterEmail = (event) => {
    setEmail(event.target.value);
    setIsInvalid(false);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    if (!validator.isEmail(email)) {
      setIsInvalid(true);
      setView('form');
      return
    } else {
      setView('submitting');
    }
    axios
      .get("/news_letter/index", {
        params: {
          email: email,
        },
      })
      .then((res) => {
        setTimeout(() => {
          const nlTextInputlement = document.getElementById(
            "news-letter-text-input"
          );
          if (nlTextInputlement) {
            nlTextInputlement.focus();
          }
        }, 1);

        if (res.data.status === "success") {
          setIsInvalid(false);
          setSuccessFullySignedUp(true);
          setView('confirmation')
          // Set focus to the element
          setTimeout(() => {
            const newsLetterElement = document.getElementById(
              "news-letter-msg-box"
            );
            if (newsLetterElement) {
              newsLetterElement.focus();
            }
          }, 1);
        } else {
          setView('error')
          setErrorMessage("An error has occurred.")
        }
      })
      .catch(function (error) {
        setButtonDisabled(false);
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
      isInvalidEmail={isInvalid}
      valueEmail={email}
      onChange={handleNewsLetterEmail}
      onSubmit={handleSubmit}
      showPrivacyLink={false}
      title="Sign Up for Our Newsletter"
      descriptionText="Learn about new teacher sets, best practices & exclusive events when you sign up for the MyLibraryNYC Newsletter!"
      confirmationHeading="Thank you for signing up to the Newsletter!"
      errorHeading={errorMessage}
      highlightColor="brand.primary"
      errorText={<Text noSpace size="body2">
        Please refresh this page and try again. If this error persists,
        <Link
            type="action"
            target="_blank"
            href="mailto:help@mylibrarynyc.org"
          >
            contact our e-mail team.
        </Link>
        </Text>}
      confirmationText="Check your email to learn about teacher sets, best practices & exclusive events."
      />
    );
  }

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

  const submitButtonaAndProgressBar = () => {
    if (buttonDisabled) {
      return (
        <ProgressIndicator
          darkMode
          id="news-letter-progress-bar-indicator"
          isIndeterminate
          indicatorType="circular"
          labelText="Progress"
          showLabel
          size="small"
          value={1}
          marginTop="xs"
        />
      );
    } else {
      return (
        <Button
          id="news-letter-button"
          buttonType="noBrand"
          width={isLargerThanMobile ? null : "100%"}
          onClick={handleSubmit}
        >
          Submit
        </Button>
      );
    }
  };

  return (
    <Box
      p="l"
      ref={newsLetterMsgRef}
      id="news-letter-success-msg"
    >
      { newLetterSignup() }
    </Box>
  );
}
