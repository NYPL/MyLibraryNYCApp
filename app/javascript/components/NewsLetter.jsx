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
  Heading, TextInput, Form, FormField, FormRow, SimpleGrid, ButtonGroup, Text, Box, Center
} from '@nypl/design-system-react-components';


export default class NewsLetter extends Component {

  constructor(props) {
    super(props);
    this.state = {message: "", error_msg: {}, email: "", display_block: "block", display_none: "none", buttondisabled: false, isInvalid: false};
    this.handleSubmit = this.handleSubmit.bind(this);
  }


  handleNewsLetterEmail = event => {
    this.setState({
      email: event.target.value, isInvalid: false
    })
  }

  handleSubmit = event => {
    event.preventDefault()
    this.setState({
      buttondisabled: true,
    })

     axios.get('/news_letter/index', {
        params: {
          email: this.state.email
        }
     })
      .then(res => {
          this.state.message = res.data.message;
          if (res.data.status == "success") {
            this.setState({display_none: 'block', display_block: 'none', isInvalid: false})
          } else {
            this.setState({display_none: 'none', display_block: 'block', isInvalid: true})
          }
      })
      .catch(function (error) {
       console.log(error)
    })
  }


  render() {
    return ( 
      <Box bg="var(--nypl-colors-ui-gray-light-cool)" color="var(--nypl-colors-ui-black)" padding="m" borderRadius="sm" overflow="hidden">
        <Center>
          <div style={{ display: this.state.display_block }}>
            <Text noSpace fontWeight="heading.callout">Learn about new teacher sets, best practices &</Text>
            <Text fontWeight="heading.callout">exclusive events when you sign up for the MyLibraryNYC Newsletter!</Text>
            <Form id="news-letter-form" gap="grid.xs">
              <FormRow>
                <FormField>
                  <TextInput id="news-letter-text-input" type="email" onChange={this.handleNewsLetterEmail} required  invalidText={this.state.message} isInvalid={this.state.isInvalid} />
                </FormField>
                
                <FormField>
                  <ButtonGroup>
                    <Button id="news-letter-button" buttonType="noBrand" onClick={this.handleSubmit}>Submit</Button>
                  </ButtonGroup>
                </FormField>
              </FormRow>
            </Form>
          </div>
          
          <div style={{ display: this.state.display_none }}>
            <Text noSpace id="news-letter-success-msg" fontWeight="heading.callout">
              Thank you for signing up to the MyLibraryNYC Newsletter!
            </Text>
            <Text fontWeight="text.mini"> Check your email to learn about teacher sets, best practices & exclusive events.</Text>
          </div>
        </Center>
      </Box>
    )
  }
}