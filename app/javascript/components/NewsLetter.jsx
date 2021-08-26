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
  }


  componentDidMount() {
    axios.get('/schools')
      .then(res => {
        this.setState({ schools: res.data.schools });
      })
      .catch(function (error) {
        console.log(error);
    })
  }
  
  
  render() {
    return (
      <div className="newsLetter">
        <div className="newsLetterBox">
          <Heading className="newsLetterHeader"
            id="heading1"
            level={3}
            text="Learn about new teacher sets, best practices &amp; exclusive events when you sign up fo ra "
          />
          <SearchBar>
            <Input
              id="input"
              placeholder="Enter your email"
              required={true}
              type={InputTypes.text}
            />
            <Button
              buttonType={ButtonTypes.Primary}
              id="button"
              type="submit"
            >
              Submit
            </Button>
          </SearchBar>
        </div>
      </div>
    )
  }
}