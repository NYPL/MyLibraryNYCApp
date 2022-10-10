import React, { useState } from "react";
import axios from "axios";

import {
  Button,
  Heading,
  TextInput,
  Text,
  Box,
  ProgressIndicator,
  VStack,
  Stack,
  useNYPLBreakpoints,
} from "@nypl/design-system-react-components";

export default function NewsLetter() {
  const [message, setMessage] = useState("");
  const [email, setEmail] = useState("");
  const [buttonDisabled, setButtonDisabled] = useState(false);
  const [isInvalid, setIsInvalid] = useState(false);
  const [successFullySignedUp, setSuccessFullySignedUp] = useState(false);

  const { isLargerThanMobile } = useNYPLBreakpoints();

  const handleNewsLetterEmail = (event) => {
    setEmail(event.target.value);
    setIsInvalid(false);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    setButtonDisabled(true);

    axios
      .get("/news_letter/index", {
        params: {
          email: email,
        },
      })
      .then((res) => {
        setMessage(res.data.message);

        if (res.data.status === "success") {
          setIsInvalid(false);
          setSuccessFullySignedUp(true);
        } else {
          setIsInvalid(true);
          setButtonDisabled(false);
        }
      })
      .catch(function (error) {
        setButtonDisabled(false);
        console.log(error);
      });
  };

  const newLetterSignup = (event) => {
    if (successFullySignedUp) {
      return (
        <VStack justifyContent="center">
          <Heading
            level="two"
            size="callout"
            maxWidth="640px"
            noSpace
            textAlign="center"
          >
            {" "}
            Thank you for signing up to the MyLibraryNYC Newsletter!
          </Heading>
          <Text noSpace>
            Check your email to learn about teacher sets, best practices &
            exclusive events.
          </Text>
        </VStack>
      );
    } else {
      return (
        <VStack gap="m" justifyContent="center">
          <Heading
            level="two"
            size="callout"
            maxWidth="640px"
            noSpace
            textAlign="center"
          >
            Learn about new teacher sets, best practices &amp; exclusive events
            when you sign up for the MyLibraryNYC Newsletter!
          </Heading>
          <Stack
            direction={isLargerThanMobile ? "row" : "column"}
            width="100%"
            alignItems="flex-start"
            justifyContent="center"
          >
            <TextInput
              id="news-letter-text-input"
              type="email"
              labelText="email"
              showLabel={false}
              maxWidth="500px"
              placeholder="your email address"
              width="100%"
              onChange={handleNewsLetterEmail}
              required
              invalidText={message}
              isInvalid={isInvalid}
            />
            {submitButtonaAndProgressBar()}
          </Stack>
        </VStack>
      );
    }
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
    <Box bg="ui.bg.default" p="l">
      {newLetterSignup()}
    </Box>
  );
}
