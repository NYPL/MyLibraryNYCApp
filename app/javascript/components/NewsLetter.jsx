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
  Heading
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

          <div style={{ display: this.state.display_block }}>
            <div className="NewsLetterHeaderStyles text_center">Learn about new teacher sets, best practices & exclusive events when you sign up for the MyLibraryNYC Newsletter!</div>
            <SearchBar onSubmit={this.handleSubmit} textInputProps={{ labelText: "Item Search", placeholder: "Enter your email" }} />{<br/>}

            <HelperErrorText id="error-helperText" isError={true}>
              <div style={{ display: this.state.isError }}>
                {this.state.message}
              </div>
            </HelperErrorText>
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