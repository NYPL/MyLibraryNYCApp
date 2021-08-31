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
    this.state = {message: "", error_msg: {}, email: "", display_block: "block", display_none: "none",  isError: "none"};
    this.handleSubmit = this.handleSubmit.bind(this);
  }


  handleNewsLetterEmail = event => {
    this.state.isError = 'none'
    
    this.setState({
      email: event.target.value
    })
  }

  handleSubmit = event => {
    this.state.isError = 'none'
    event.preventDefault()
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
            <Heading className="newsLetterHeader"
              id="heading1"
              level={3}
              text="Learn about new teacher sets, best practices &amp; exclusive events when you sign up fo ra "
            />
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
                buttonType={ButtonTypes.Primary}
                id="button"
                type="submit"
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
            <Heading className="newsLetterHeader"
              id="heading1"
              level={3}
              text="Thank you for sign up for MyLibraryNYC Newsletter! "
            />
            Check your email to learn about new teacher sets, best practice & exclusive events.
          </div>

        </div>
      </div>
    )
  }
}