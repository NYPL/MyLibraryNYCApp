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
  Pagination, Checkbox, DSProvider, TemplateAppContainer, ImageRatios, ImageSizes, HeadingLevels, Slider
} from '@nypl/design-system-react-components';

import bookImage from '../images/book.png'

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

export default class SearchTeacherSets extends Component {

  constructor(props) {
    super(props);
    this.state = { teacher_sets: [], facets: [], ts_total_count: "", error_msg: {}, email: "", 
                   display_block: "block", display_none: "none", setComputedCurrentPage: 1, 
                   computedCurrentPage: 1, pagination: "", keyword: new URLSearchParams(this.props.location.search).get('keyword') };
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
      this.props.history.push("/teacher_set_data"+ "?keyword=" + this.state.keyword)
    }
    this.getTeacherSets()
  }


  
  handleSearchKeyword = event => {
    if (event.target.value == "") {
      delete this.state.keyword;
      this.props.history.push("/teacher_set_data");
      this.getTeacherSets();
    } else {
      this.setState({  keyword: event.target.value })
    }
  }



  onPageChange = (page) => {
    this.state.setComputedCurrentPage = page;

    axios.get('/teacher_sets', {
        params: {
          keyword: this.state.keyword,
          page: page
        }
     }).then(res => {
        this.setState({ teacher_sets: res.data.teacher_sets,  ts_total_count: res.data.total_count });
      })
      .catch(function (error) {
       console.log(error)
    })

  };

  TeacherSetDetails() {
    return this.state.teacher_sets.map((ts, i) => {
      return <div className="teacherSetResults">
        <div style={{ display: "grid", "grid-gap": "2rem", "grid-template-columns": "repeat(1, 1fr)" }}>
          <Card layout={CardLayouts.Row} imageSrc={bookImage} imageAlt="Alt text" imageAspectRatio={ImageRatios.Square} imageSize={ImageSizes.ExtraExtraSmall}>
            <CardHeading level={HeadingLevels.Three} id="row2-heading1">
              <ReactRouterLink to={"/teacher_set_details/" + ts.id}>
                {ts.title}
              </ReactRouterLink>
            </CardHeading>

            
            <CardContent> {ts.suitabilities_string} </CardContent>
            <CardContent> {ts.availability} </CardContent>
            <CardContent> {ts.description} </CardContent>
          </Card>
          <HorizontalRule align="left" height="3px" width="856px" />
        </div>
      </div>
    })
  }

  TeacherSetFacets() {
    return this.state.facets.map((ts, i) => {
      return <div className="nypl-ds">{<br/>}
      <div> { ts.label } </div>
        { ts.items.map((item, index) =>
          <div> <Checkbox id="test_id" labelText={item["label"]} showLabel />  </div>
        )}
      </div>
    })
  }

  TeacherSetSlider() {
    return <>
    </>
  }

  render() {
    return (
      <DSProvider>
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentTop={<>
              <SearchBar onSubmit={this.handleSubmit} className="teachersetSearchBar" 
                textInputProps={{
                  labelText: "Search Teacher set",
                  name: "textInputName",
                  onChange: this.handleSearchKeyword,
                  placeholder: "Search Teacher set",
                  value: this.state.keyword
                }}
              />
              {<br/>}
              <Heading id="heading2" level={2} text="Seach and Find Teacher Sets" />
              <Heading id="heading5" level={5} text="Check Out Newly Arrived Teacher Sets" />
              <HorizontalRule align="left" height="3px" width="856px" className="teacherSetHorizontal"/>
            </>
          }
          contentPrimary={
              <>
                <div>{this.TeacherSetDetails()}</div>
                <div style={{ display: this.state.pagination }}>
                  <Pagination currentPage={1} onPageChange={this.onPageChange}  pageCount={this.state.ts_total_count} />
                </div>
              </>
            }
          contentSidebar={<>
              {this.TeacherSetFacets()}
          </>}
          sidebar="left" 
        />
      </DSProvider>
    )
  }
}

SearchTeacherSets.defaultProps = {
  keyword: null
};

