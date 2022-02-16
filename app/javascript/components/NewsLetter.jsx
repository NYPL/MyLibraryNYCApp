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
  Heading, TextInput, TextInputTypes, Form, FormField, FormRow, SimpleGrid, ButtonGroup
} from '@nypl/design-system-react-components';


export default class NewsLetter extends Component {

  constructor(props) {
    super(props);
    this.state = {message: "", error_msg: {}, email: "", display_block: "block", display_none: "none",  isError: "none", buttondisabled: false};
    this.handleSubmit = this.handleSubmit.bind(this);
  }


  handleNewsLetterEmail = event => {
    this.state.isError = 'none'
    
    this.setState({
      email: event.target.value
    })
  }

  handleSubmit = event => {
    event.preventDefault()
    this.setState({
      buttondisabled: true,
      buttonColor: '#CCC'
    })

     axios.get('/news_letter/index', {
        params: {
          email: this.state.email
        }
     })
      .then(res => {
          if (res.data.status == "success") {
            this.state.display_none = 'block'
            this.state.display_block = 'none' 
          } else {
            this.state.buttondisabled = false
            this.state.isError = 'block'
          }
          this.setState({ message: res.data.message });
      })
      .catch(function (error) {
       console.log(error)
    })
    
  }


  render() {
    return (
      <div className="newsLetter">
        <div className="newsLetterBox">
        <SimpleGrid columns={1}>
          <Form spacing="s">
            <div style={{ display: this.state.display_block }}>
              <div className="NewsLetterHeaderStyles text_center">Learn about new teacher sets, best practices & exclusive events when you sign up for the MyLibraryNYC Newsletter!</div>
                <ButtonGroup>
                  <FormRow>
                    <FormField>
                      <TextInput type={TextInputTypes.email} onChange={this.handleNewsLetterEmail} required  invalidText={this.state.message} />
                    </FormField>
                    <FormField>
                      <Button buttonType={ButtonTypes.NoBrand} onClick={this.handleSubmit}>Submit</Button>
                    </FormField>
                  </FormRow>
                </ButtonGroup>
            </div>
          </Form>
        </SimpleGrid>
          
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