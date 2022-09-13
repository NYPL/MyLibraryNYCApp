import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import axios from 'axios';

import {
  Button,
  SearchBar,
  Select,
  Input,
  SearchButton,
  InputTypes,
  Icon,
  HelperErrorText,
  LibraryExample,
  Heading, TextInput, Form, FormField, FormRow, SimpleGrid, ButtonGroup, Text, Box, Center, ProgressIndicator, VStack, Stack, useNYPLBreakpoints
} from '@nypl/design-system-react-components';



export default function NewsLetter(props) {

  const [message, setMessage] = useState("")
  const [error_msg, setErrorMsg] = useState({})
  const [email, setEmail] = useState("")
  const [display_block, setDisplayBlock] = useState("block")
  const [display_none, setDisplayNone] = useState("none")
  const [buttonDisabled, setButtonDisabled] = useState(false)
  const [isInvalid, setIsInvalid] = useState(false)
  const [successFullySignedUp, setSuccessFullySignedUp] = useState(false)

  const { isLargerThanSmall, isLargerThanMedium, isLargerThanMobile, isLargerThanLarge, isLargerThanXLarge } = useNYPLBreakpoints();

  const handleNewsLetterEmail = (event) => {
    setEmail(event.target.value)
    setIsInvalid(false)
  }

  const handleSubmit = (event) => {
    event.preventDefault()
    setButtonDisabled(true)

     axios.get('/news_letter/index', {
        params: {
          email: email
        }
     })
      .then(res => {
          setMessage(res.data.message)

          if (res.data.status == "success") {
            setDisplayNone("block")
            setDisplayBlock("none")
            setIsInvalid(false)
            setSuccessFullySignedUp(true)
          } else {
            setDisplayNone("none")
            setDisplayBlock("block")
            setIsInvalid(true)
            setButtonDisabled(false)
          }
      })
      .catch(function (error) {
       setButtonDisabled(false)
       console.log(error)
    })
  }

  const newLetterSignup = (event) => {
    if (successFullySignedUp) {
      return <VStack gap="m" justifyContent="center">
        <Heading
          level="two"
          size="callout"
          maxWidth="640px"
          noSpace
          textAlign="center"
        > Thank you for signing up to the MyLibraryNYC Newsletter!
        </Heading>
        <Heading
          level="three"
          size="callout"
          maxWidth="640px"
          noSpace
          textAlign="center"
        > Check your email to learn about teacher sets, best practices & exclusive events.
        </Heading>
      </VStack>
    } else {
      return <VStack gap="l" justifyContent="center">
        <Heading
          level="two"
          size="callout"
          maxWidth="640px"
          noSpace
          textAlign="center"
        >
          Learn about new teacher sets, best practices &amp; exclusive
          events when you sign up for the MyLibraryNYC Newsletter!
        </Heading>
        <Stack
          direction={isLargerThanMobile ? "row" : "column"}
          width="100%"
          alignItems="flex-start"
          justifyContent="center"
        >
          <TextInput
            helperText="jdoe@domain.com"
            id="news-letter-text-input"
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
    }
  }

  const submitButtonaAndProgressBar = () => {
    if (buttonDisabled) {
      return <ProgressIndicator
        darkMode
        id="news-letter-progress-bar-indicator"
        isIndeterminate
        indicatorType="circular"
        labelText="Progress"
        showLabel
        size="small"
        value={1}
      />
    } else {
      return <Button
        id="news-letter-button"
        buttonType="noBrand"
        width={isLargerThanMobile ? null : "100%"}
        onClick={handleSubmit}
      >
        Submit
      </Button>
    }
  }

  return (
    <Box bg="ui.bg.default" p="l">
      <VStack gap="l" justifyContent="center">
        {newLetterSignup()}
      </VStack>
    </Box>
  )
}