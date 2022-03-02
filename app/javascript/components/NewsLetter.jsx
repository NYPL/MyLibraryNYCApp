import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import axios from 'axios';

import {
  Button,
  ButtonTypes,
  SearchBar,
  Select,
  Input,
  SearchButton,
  InputTypes,
  Icon,
  IconNames,
  HelperErrorText,
  LibraryExample,
  Heading, TextInput, TextInputTypes, Form, FormField, FormRow, SimpleGrid, ButtonGroup, GridGaps
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
      <div className="newsLetter">
        <div className="newsLetterBox">
          <div style={{ display: this.state.display_block }}>
            <div className="NewsLetterHeaderStyles text_center">Learn about new teacher sets, best practices & exclusive events when you sign up for the MyLibraryNYC Newsletter!</div>
            <Form spacing={GridGaps.Small}>
              <FormRow>
                <FormField>
                  <TextInput type={TextInputTypes.email} onChange={this.handleNewsLetterEmail} required  invalidText={this.state.message} isInvalid={this.state.isInvalid} />
                  <Button buttonType={ButtonTypes.NoBrand} onClick={this.handleSubmit}>Submit</Button>
                </FormField>
              </FormRow>
            </Form>
          </div>
          
          <div style={{ display: this.state.display_none }}>
            <div className="NewsLetterHeaderStyles">
              Thank you for signing up to the MyLibraryNYC Newsletter!
            </div>
            Check your email to learn about teacher sets, best practices & exclusive events.
          </div>
        </div>
      </div>
    )
  }
}