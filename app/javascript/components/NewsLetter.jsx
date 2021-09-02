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
    this.state = {message: "", error_msg: {}, email: "", display_block: "block", display_none: "none",  isError: "none", buttondisabled: false, buttonColor: '#000000'};
    this.handleSubmit = this.handleSubmit.bind(this);
    this.state.disable = false
    this.state.setDisable = false
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
            this.state.buttonColor = "#000000"
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
            <SearchBar onSubmit={this.handleSubmit}>
              <Input
                id="email"
                value={this.state.email}
                placeholder="Enter your email"
                required={true}
                type={InputTypes.text}
                onChange={this.handleNewsLetterEmail}
              />
              <Button
                disabled={this.state.buttondisabled}
                buttonType={ButtonTypes.Primary}
                id="button"
                type="submit"
                style={{background: this.state.buttonColor}}
              >
                Submit
              </Button>
            </SearchBar>

            <HelperErrorText id="error-helperText" isError={true}>
              <div style={{ display: this.state.isError }}>
                {this.state.message}
              </div>
            </HelperErrorText>
          </div>
          
          <div style={{ display: this.state.display_none }}>
            <div className="NewsLetterHeaderStyles">
              Thank you for sign up for MyLibraryNYC Newsletter!
            </div>
            Check your email to learn about teacher sets, best practices & exclusive events.
          </div>

        </div>
      </div>
    )
  }
}