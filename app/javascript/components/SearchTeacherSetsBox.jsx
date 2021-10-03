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
  LibraryExample
} from '@nypl/design-system-react-components';


export default class SearchTeacherSetsBox extends Component {

  constructor(props) {
    super(props);
    this.state = { teacher_sets: "", error_msg: {}, keyword: "", display_block: "block", display_none: "none" };
  }
  
  handleSubmit = event => {
    event.preventDefault();

    console.log(this.state.keyword)

     axios.get('/teacher_sets', {
        params: {
          keyword: this.state.keyword
        }
     }).then(res => {
        this.setState({ teacher_sets: res.data.teacher_sets });
      })
      .catch(function (error) {
       console.log(error)
    })
  }


  handleNewsLetterEmail = event => {    
    this.setState({
      keyword: event.target.value
    })
  }

  render() {
    return (
      <>
        <div className="search_teacher_sets">
          <SearchBar onSubmit={this.handleSubmit} >
            <Input
              id="input"
              value={this.state.keyword}
              placeholder="Enter teacher-set"
              required={true}
              type={InputTypes.text}
              onChange={this.handleNewsLetterEmail}
            />
            <Button
              buttonType={ButtonTypes.Primary}
              id="button"
              type="submit"
            >
              Search
            </Button>
          </SearchBar>
        </div>
      </>
    )
  }
}

