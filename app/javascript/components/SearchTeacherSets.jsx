import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import qs from 'qs';

import {
  Button, 
  ButtonGroup,
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
  Pagination, Checkbox, DSProvider, TemplateAppContainer, ImageRatios, ImageSizes, HeadingLevels, Slider, CheckboxGroup, Notification, NotificationTypes, Flex, Spacer, Text, TextDisplaySizes, Box, Toggle, HeadingDisplaySizes, ToggleSizes, IconRotationTypes, IconSizes, IconAlign
} from '@nypl/design-system-react-components';

import bookImage from '../images/book.png'

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

export default class SearchTeacherSets extends Component {

  constructor(props) {
    super(props);
    this.state = { userSignedIn: this.props.userSignedIn, teacher_sets: [], facets: [], ts_total_count: 0, error_msg: {}, email: "", 
                   display_block: "block", display_none: "none", setComputedCurrentPage: 1, total_pages: 0,
                   computedCurrentPage: 1, pagination: "none", keyword: new URLSearchParams(this.props.location.search).get('keyword'), query_params: {}, selected_facets: {}, params: {}, grade_begin: -1, grade_end: 12 };
  }

  componentDidMount() {
    const params = Object.assign({ keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end }, this.state.selected_facets)
    this.getTeacherSets(params)
  }



  getTeacherSets(params) {
    axios.get('/teacher_sets', {params: params}).then(res => {
      this.setState({ teacher_sets: res.data.teacher_sets, facets: res.data.facets,
                      ts_total_count: res.data.total_count, total_pages: res.data.total_pages });
      if (res.data.teacher_sets.length > 0 && res.data.total_count > 20 ) {
        this.setState({ pagination: 'block' })
      } else {
        this.setState({ pagination: 'none' })
      }
    })
    .catch(function (error) {
     console.log(error)
    })
  }

  getGrades = grades => {
    const [grade_begin_val, grade_end_val] = grades;
    const grade_begin =  grade_begin_val == -1? 'Pre-K' :  grade_begin_val == 0 ? 'K' :  grade_begin_val;
    const grade_end = grade_end_val == -1? 'Pre-K' :  grade_end_val == 0 ? 'K' :  grade_end_val;

    this.setState({ grade_begin: grade_begin, grade_end: grade_end })
    this.state.params = Object.assign({ keyword: this.state.keyword, grade_begin: grade_begin_val, grade_end: grade_end_val}, this.state.selected_facets)
    this.getTeacherSets(this.state.params)
  };

  handleSubmit = event => {
    event.preventDefault();
    const params = Object.assign({ keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end}, this.state.selected_facets)
    this.getTeacherSets(params)
  }

  handleSearchKeyword = event => {
    if (event.target.value == "") {
      delete this.state.keyword;
      delete this.state.selected_facets;
      this.props.history.push("/teacher_set_data");
      this.getTeacherSets(Object.assign({ keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end}, this.state.selected_facets));
    } else {
      this.setState({ keyword: event.target.value, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end })
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
      return <div className="teacherSetResults" id="teacher-set-results">
        <div style={{ display: "grid", "grid-gap": "2rem", "grid-template-columns": "repeat(1, 1fr)" }}>
          <Card id="ts-details" layout={CardLayouts.Row} imageSrc={bookImage} imageAlt="Alt text" imageAspectRatio={ImageRatios.Square} imageSize={ImageSizes.ExtraExtraSmall}>
            <CardHeading level={HeadingLevels.Three} id="ts-order-details">
              <ReactRouterLink to={"/teacher_set_details/" + ts.id}>{ts.title}</ReactRouterLink>
            </CardHeading>
            <CardContent id="ts-suitabilities">{ts.suitabilities_string}</CardContent>
            <CardContent id="ts-availability">{ts.availability}</CardContent>
            <CardContent id="ts-description">{ts.description}</CardContent>
          </Card>
          <HorizontalRule id="ts-horizontal-rule" align="left" height="3px" />
        </div>
      </div>
    })
  }

  SelectedFacets(field, event) {
    if (field == 'area of study') {
      this.state.selected_facets[field] = event
    } else if (field == 'availability') {
      this.state.selected_facets[field] = event
    } else if (field == 'set type') {
      this.state.selected_facets[field] = event
    } else if (field == 'language') {
      this.state.selected_facets[field] = event
    } else if (field == 'subjects') {
      this.state.selected_facets[field] = event
    }
    this.state.selected_facets

    if (this.state.keyword !== null) {
      this.state.params = Object.assign({ keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end}, this.state.selected_facets)
    } else {
      this.state.params = Object.assign({ grade_begin: this.state.grade_begin, grade_end: this.state.grade_end}, this.state.selected_facets)
    }

    this.getTeacherSets(this.state.params)
  };

  TeacherSetFacets() {

    if (this.state.teacher_sets && this.state.teacher_sets.length <= 0) {
      return <Heading id="ts-results-not-found" level={5} text="No Results Found" />
    }

    return this.state.facets.map((ts, i) => {
      return <>
          <div className="bold" style={{textTransform: "capitalize"}}> {ts.label} </div> 
          <CheckboxGroup id={"ts-checkbox-group"} defaultValue={[]} isRequired  layout="column" name={ts.label} onChange={this.SelectedFacets.bind(this, ts.label)} optReqFlag={false} >
            { ts.items.map((item, index) =>
              <Flex marginTop="var(--nypl-space-xs)" marginRight="0px">
                <Checkbox id={"ts-checkbox-"+ index} labelText={item["label"]} value={item["value"].toString()} />
                <Spacer />
                <Text id={"ts-count-"+ index} displaySize={TextDisplaySizes.Caption}>{item["count"]}</Text>
              </Flex>
            ) }{<br/>}
          </CheckboxGroup>
        </>
    })
  }

  SignedInMessage() {
    if (this.state.userSignedIn) {
      return <Notification ariaLabel="SignIn Notification" id="sign-in-notification" className="signUpMessage" dismissible notificationType={NotificationTypes.Announcement} notificationContent={<>
      Signed in successfully</>} />
    }
  }

  TeacherSetGradesSlider() {
    const grade_begin = this.state.grade_begin == -1? 'Pre-K' :  this.state.grade_begin
    return <>
      <Slider
        id="ts_slider-range"
        isRangeSlider
        labelText={"Grades Range   " + grade_begin + " To " + this.state.grade_end}
        max={12}
        min={-1}
        onChange={this.getGrades}
        optReqFlag={false}
        showBoxes={false}
        showHelperInvalidText
        showLabel
        showValues={false}
        step={1}
      />
     {/* <Flex marginTop="var(--nypl-space-xs)" marginRight="0px">
        <Text displaySize={TextDisplaySizes.Caption}>
          {this.state.grade_begin}
        </Text>
        <Spacer />
        <Text displaySize={TextDisplaySizes.Caption}>{this.state.grade_end}</Text>
      </Flex>*/}
    </>
  }

  render() {
    return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentTop={<>
              {this.SignedInMessage()}
              <SearchBar id="ts-search" labelText="Teacher-Set SearchBar" onSubmit={this.handleSubmit} className="teachersetSearchBar" 
                textInputProps={{
                  id: "ts-input",
                  labelText: "Search Teacher set",
                  name: "TeacherSetInputName",
                  onChange: this.handleSearchKeyword,
                  placeholder: "Search Teacher set",
                  value: this.state.keyword
                }}
              />
              {<br/>}
              <Heading id="search-and-find-teacher-sets-header" displaySize={HeadingDisplaySizes.Primary} level={HeadingLevels.Two} text="Search and Find Teacher Sets" additionalStyles={{ pt: "var(--nypl-space-m)" }} />
              <HorizontalRule id="ts-horizontal-rule" className="teacherSetHorizontal" />
              <Flex>
                <Heading id="check-out-teacher-sets" level={HeadingLevels.Three}>
                  Check Out Newly Arrived Teacher Sets
                </Heading>
                <Spacer />
                <label
                  htmlFor="sort-by-select"
                  style={{
                    display: "inline-block",
                    marginRight: "var(--nypl-space-s)",
                    fontWeight: "bold",
                  }}
                >
                  Sort By
                </label>
                <Select
                  id="ts-sort-by-select"
                  name="sortBy"
                  labelText="Sort By"
                  showLabel={false}
                  showOptReqLabel={false}
                >
                  <option value="option">Option 1</option>
                  <option value="option">Option 2</option>
                </Select>
              </Flex>              
            </>
          }
          contentPrimary={
              <>
                <div>{this.TeacherSetDetails()}</div>
                <div style={{ display: this.state.pagination }} >
                  <Flex alignItems="baseline">
                    <ButtonGroup>
                      <Button id="teacher-sets-scroll-to-top" buttonType={ButtonTypes.Secondary} 
                        onClick={() =>
                          window.scrollTo({
                            top: 100,
                            behavior: "smooth",
                          })
                        }
                      >
                        Back to Top
                        <Icon name={IconNames.Arrow} iconRotation={IconRotationTypes.Rotate180} size={IconSizes.Small} className="backToTopIcon" align={IconAlign.Right} />
                      </Button>
                    </ButtonGroup>
                    <Spacer />
                    <div>
                      <Pagination id="ts-pagination" className="teacher_set_pagination" currentPage={1} onPageChange={this.onPageChange}  pageCount={this.state.total_pages} />
                    </div>
                  </Flex>
                </div>
              </>
            }
          contentSidebar={<Box id="ts-all-facets" bg="var(--nypl-colors-ui-gray-x-light-cool)" padding="var(--nypl-space-m)">
              <Heading displaySize={HeadingDisplaySizes.Tertiary} level={HeadingLevels.Three} > Refine Results </Heading>
              {this.TeacherSetGradesSlider()}{<br/>}
              {this.TeacherSetFacets()}
          </Box>}
          sidebar="left" 
        />
    )
  }
}

SearchTeacherSets.defaultProps = {
  keyword: null
};

