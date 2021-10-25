import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
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
  HorizontalRule,
  Heading,
  Card, 
  CardHeading, 
  CardContent,
  CardLayouts,
  CardImageRatios,
  CardImageSizes,
  Pagination, Checkbox
} from '@nypl/design-system-react-components';

import bookImage from '../images/book.png'

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";


export default class SearchTeacherSetsBox extends Component {

  constructor(props) {
    super(props);
    this.state = { teacher_sets: [], facets: [], ts_total_count: "", error_msg: {}, email: "", 
                   display_block: "block", display_none: "none", setComputedCurrentPage: 1, 
                   computedCurrentPage: 1, pagination: "" };
  }


  componentDidMount() {
    if (this.state.keyword !== "" ) {
      this.getTeacherSets()
    }
  }
  
  
  getTeacherSets() {
    axios.get('/teacher_sets', {
        params: {
          keyword: this.state.keyword
        }
     }).then(res => {
        this.setState({ teacher_sets: res.data.teacher_sets,  facets: res.data.facets,
                        ts_total_count: res.data.total_count });

        console.log(this.state.facets);


        if (res.data.total_count > 20) {
          this.state.pagination = 'block';
        } else {
          this.state.pagination = 'none';
        }
      })
      .catch(function (error) {
       console.log(error)
    })
  }


  handleSubmit = event => {
    event.preventDefault();

    if (this.state.keyword !== null) {
      console.log(this.props.history)
      this.props.history.push("/teacher_set_data"+ "?keyword=" + this.state.keyword)
    }
    this.getTeacherSets()
  }


  handleSearchKeyword = event => {
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

