import React, { Component } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import SignedInMsg from "./SignedInMsg";
import axios from 'axios';
import { titleCase } from "title-case";


import {
  Button, 
  ButtonGroup,
  SearchBar,
  Select,
  Icon,
  HorizontalRule,
  Heading,
  Card, 
  CardHeading, 
  CardContent,
  Pagination, Checkbox, TemplateAppContainer, Slider, CheckboxGroup, Notification, Flex, Spacer, Text, Box, Toggle, StatusBadge, Accordion, SkeletonLoader
} from '@nypl/design-system-react-components';


import { Link as ReactRouterLink } from "react-router-dom";

const sortByOptions =  [{sort_order: 'Date Added: Newest to Oldest', value: 0}, {sort_order: 'Date Added: Oldest to Newest', value: 1}, {sort_order: 'Title: A-Z', value: 2}, {sort_order: 'Title: Z-A', value: 3}]



export default class SearchTeacherSets extends Component {

  constructor(props) {
    super(props);
    this.state = { userSignedIn: this.props.userSignedIn, teacherSets: [], facets: [], tsTotalCount: 0, email: "", 
                   setComputedCurrentPage: 1, totalPages: 0,
                   computedCurrentPage: 1, pagination: "none", keyword: new URLSearchParams(this.props.location.search).get('keyword'), selectedFacets: {}, params: {}, 
                   grade_begin: -1, grade_end: 12, availableToggle: false, availability: "",
                   ts_sort_by_id: "", sortTitleValue: 0, noTsResultsFound: "" };
  }

  componentDidMount() {
    const params = Object.assign({ keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end}, this.state.selectedFacets)
    this.getTeacherSets(params)
  }

  getTeacherSets(params) {
    axios.get('/teacher_sets', {params: params}).then(res => {
      this.setState({ teacherSets: res.data.teacher_sets, facets: res.data.facets,
                      tsTotalCount: res.data.total_count, totalPages: res.data.total_pages, noTsResultsFound: res.data.no_results_found_msg });
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
    const [gradeBeginVal, gradeEndVal] = grades;
    const gradeBegin = gradeBeginVal === -1? 'Pre-K' : gradeBeginVal === 0 ? 'K' : gradeBeginVal;
    const gradeEnd = gradeEndVal === -1? 'Pre-K' :  gradeEndVal === 0 ? 'K' : gradeEndVal;

    this.setState({ grade_begin: gradeBegin, grade_end: gradeEnd })
    this.state.params = Object.assign({ keyword: this.state.keyword, sort_order: this.state.sortTitleValue, availability: this.state.availability, grade_begin: gradeBeginVal, grade_end: gradeEndVal}, this.state.selectedFacets)
    this.getTeacherSets(this.state.params)
  };

  availableResults = (e) => {
    if (this.state.availableToggle === true) {
      this.setState({ availableToggle: false })
      this.setState({ availability: ""})

      this.state.params = Object.assign({ keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end, sort_order: this.state.sortTitleValue, availability: ""}, this.state.selectedFacets)
    } else {
      this.setState({ availableToggle: true, availability: ["available"] })
      this.state.params = Object.assign({ keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end, sort_order: this.state.sortTitleValue, availability: ["available"]}, this.state.selectedFacets)
    }

    this.getTeacherSets(this.state.params)
  };


  handleSubmit = event => {
    event.preventDefault();
    const params = Object.assign({ keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end, sort_order: this.state.sortTitleValue, availability: this.state.availability}, this.state.selectedFacets)
    this.getTeacherSets(params)
  }

  handleSearchKeyword = event => {
    if (event.target.value === "") {
      delete this.state.keyword;
      // delete this.state.selectedFacets;
      // delete this.state.grade_begin;
      // delete this.state.grade_end;
      // delete this.state.sortTitleValue;
      // delete this.state.availability;
      this.props.history.push("/teacher_set_data");
      this.getTeacherSets(Object.assign({ keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end, sort_order: this.state.sortTitleValue, availability: this.state.availability}, this.state.selectedFacets));
    } else {
      this.setState({ keyword: event.target.value, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end, sort_order: this.state.sortTitleValue, availability: this.state.availability })
    }
  }

  onPageChange = (page) => {
    this.state.setComputedCurrentPage = page;
    axios.get('/teacher_sets', {
        params: Object.assign({
          keyword: this.state.keyword,
          page: page,
          sort_order: this.state.sortTitleValue,
          availability: this.state.availability,
          grade_begin: this.state.grade_begin,
          grade_end: this.state.grade_end,
        }, this.state.selectedFacets), 
     }).then(res => {
        this.setState({ teacherSets: res.data.teacher_sets, tsTotalCount: res.data.total_count, sort_order: this.state.sortTitleValue, availability: this.state.availability, keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end});
      })
      .catch(function (error) {
       console.log(error)
    })
  };

  TeacherSetDetails() {
    return this.state.teacherSets.map((ts, i) => {
      let availability_status_badge =  (ts.availability === "available") ? "medium" : "low"
      return <div id="teacher-set-results" style={{"margin-top": "1.5rem"}}>
        <div style={{ display: "grid", "grid-gap": "1rem", "grid-template-columns": "repeat(1, 1fr)" }}>
          <Card id="ts-details" layout="row" imageAlt="Alt text" aspectRatio="square" size="xxsmall">
            <CardHeading level="three" id="ts-order-details">
              <ReactRouterLink to={"/teacher_set_details/" + ts.id}>{ts.title}</ReactRouterLink>
            </CardHeading>
            <CardContent id="ts-suitabilities">{ts.suitabilities_string}</CardContent>
            <CardContent id="ts-availability">
              <StatusBadge level={availability_status_badge}>{titleCase(ts.availability)}</StatusBadge>
            </CardContent>
            <CardContent id="ts-description">{ts.description}</CardContent>
          </Card>
          <HorizontalRule id="ts-horizontal-rule" align="left"  className="tsDetailHorizontalLine"/>
        </div>
      </div>
    })
  }

  SelectedFacets(field, event) {
    if (field === 'area of study') {
      this.state.selectedFacets[field] = event
    } else if (field === 'availability') {
      this.state.selectedFacets[field] = event
    } else if (field === 'set type') {
      this.state.selectedFacets[field] = event
    } else if (field === 'language') {
      this.state.selectedFacets[field] = event
    } else if (field === 'subjects') {
      this.state.selectedFacets[field] = event
    }
    this.state.selectedFacets

    if (this.state.keyword !==null) {
      this.state.params = Object.assign({ keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end, sort_order: this.state.sortTitleValue, availability: this.state.availability}, this.state.selectedFacets)
    } else {
      this.state.params = Object.assign({ grade_begin: this.state.grade_begin, grade_end: this.state.grade_end, sort_order: this.state.sortTitleValue, availability: this.state.availability}, this.state.selectedFacets)
    }
    this.getTeacherSets(this.state.params)
  }

  noResultsFound() {
    if (this.state.teacherSets.length <= 0 && this.state.noTsResultsFound !== ""){
      return <Text marginTop="s" id="ts-results-not-found" level={5}>No Results Found</Text>
    }
  }

  skeletonLoader() {
    if (this.state.noTsResultsFound === "" && this.state.teacherSets.length <= 0) {
      return <SkeletonLoader
          contentSize={4}
          headingSize={2}
          imageAspectRatio="portrait"
          layout="row"
          showImage
          width="900px"
        />
    }
  }

  TeacherSetFacets() {
    return this.state.facets.map((ts, _i) => {
      return <Accordion backgroundColor="var(--nypl-colors-ui-white)" marginTop="s" id={"ts-facet-label " + ts.label} accordionData={ [
            {
              label: <Text isCapitalized noSpace>{ts.label}</Text>,
              panel: (
                <CheckboxGroup isFullWidth id={"ts-checkbox-group"} defaultValue={[]} isRequired={false}  layout="column" name={ts.label} onChange={this.SelectedFacets.bind(this, ts.label)}>
                  { ts.items.map((item, index) =>

                      <Checkbox id={"ts-checkbox-"+ index} value={item["value"].toString()} 
                         labelText={
                           <Flex>
                              <span>{item["label"]}</span>
                              <Spacer />
                              <Text noSpace id={"ts-count-"+ index} size="caption">{item["count"]}</Text>
                          </Flex>
                        }
                     />
                  )}
                </CheckboxGroup>
              ),
            } ]}
      />
    })
  }

  SignedInMessage() {
    if (!this.props.hideSignInMsg && this.props.userSignedIn && this.props.signInMsg !== "") {
      return <Notification ariaLabel="SignIn Notification" id="sign-in-notification" className="signUpMessage" notificationType="announcement" notificationContent={<>
      {this.props.signInMsg}</>} />
    }
  }

  TeacherSetGradesSlider() {
      const grade_begin = this.state.grade_begin === -1? 'Pre-K' :  this.state.grade_begin;
      return <Slider
        id="ts-slider-range"
        isRangeSlider
        labelText={"Grades Range  " + grade_begin + " To " + this.state.grade_end}
        max={12}
        min={-1}
        onChange={this.getGrades}
        showBoxes={false}
        showHelperInvalidText
        showLabel
        showValues={false}
        step={1}
    />
  }

  sortTeacherSetTitle = (e) => {
    this.state.sortTitleValue = e.target.value;
    this.getTeacherSets(Object.assign({ keyword: this.state.keyword, grade_begin: this.state.grade_begin, grade_end: this.state.grade_end, sort_order: this.state.sortTitleValue, availability: this.state.availability}, this.state.selectedFacets));
  };

  teacherSetSideBarResults = (e) => {
    return <Box id="ts-all-facets" bg="var(--nypl-colors-ui-gray-x-light-cool)" padding="var(--nypl-space-m)">
      <Heading size="tertiary" level="three" > Refine Results </Heading>
      <Toggle
        id="toggle"
        isChecked={this.state.availableToggle}
        labelText="Available Now"
        onChange={this.availableResults.bind(this)}
        size="small"
      />{<br/>}
      {this.TeacherSetGradesSlider()}{<br/>}
      {this.TeacherSetFacets()}
    </Box>
  }

  keyword() {
    if (this.state.keyword || this.state.availableToggle === true) {
      let availableNow = ""
      let searchKeyword = ""
      if (this.state.availableToggle === true){
        let availableNow = ', Available Now'
      } else if (this.state.keyword) {
        let searchKeyword = 'for ' + this.state.keyword
      }
      return searchKeyword + "availableNow"
    }
  }

  teacherSetTitleOrder() {
    const sort = sortByOptions.map((ts) => <option id={"ts-sort-by-options-" + ts.value} key={ts.value} value={ts.value}>{ts.sort_order}</option>);
    if (this.state.teacherSets && this.state.teacherSets.length > 0) {
      return <>
        <Flex>                    
          <Select
            id="ts-sort-by-select"
            name="sortBy"
            labelText="Sort By"
            showLabel={false}
            showOptReqLabel={false}
            selectType="default"
            value={this.state.sortTitleValue}
            onChange={this.sortTeacherSetTitle.bind(this)}
          >
            {sort}
          </Select>
        </Flex>
        {this.TeacherSetDetails()}
      </>
    }
  }

  resultsFoundMessage() {
    if ((this.state.tsTotalCount === 0)) {
      return "No results found"
    } else if (this.state.tsTotalCount === 1) {
      return this.state.tsTotalCount + ' result found';
    } else {
      return this.state.tsTotalCount + ' results found';
    }
  }

  render() {
    return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentTop={<>
              {<SignedInMsg signInDetails={this.props} />}
              <Heading id="search-and-find-teacher-sets-header" size="secondary" level="two" text="Search and Find Teacher Sets"  />
              <HorizontalRule id="ts-horizontal-rule" className="teacherSetHorizontal" />
              <SearchBar id="ts-search" noBrandButtonType labelText="Teacher-Set SearchBar" onSubmit={this.handleSubmit} className="" 
                textInputProps={{
                  id: "search-teacher-set",
                  labelText: "Enter a teacher set name",
                  name: "TeacherSetInputName",
                  onChange: this.handleSearchKeyword,
                  placeholder: "Enter a teacher set name",
                  value: this.state.keyword
                }}
              />     
            </>
          }
          contentPrimary={
              <>
                <Text isBold size="default">{this.resultsFoundMessage()}</Text>
                {this.teacherSetTitleOrder()}
                <div style={{ display: this.state.pagination }} >
                  <Flex alignItems="baseline">
                    <ButtonGroup>
                      <Button id="teacher-sets-scroll-to-top" buttonType="secondary"
                        onClick={() =>
                          window.scrollTo({
                            top: 100,
                            behavior: "smooth",
                          })
                        }
                      >
                        Back to Top
                        <Icon name="arrow" iconRotation="rotate180" size="small" className="backToTopIcon" align="right" />
                      </Button>
                    </ButtonGroup>
                    <Spacer />
                    <div>
                      <Pagination id="ts-pagination" className="teacher_set_pagination" currentPage={1} onPageChange={this.onPageChange}  pageCount={this.state.totalPages} />
                    </div>
                  </Flex>
                </div>
              </>
            }
          contentSidebar={<>{this.skeletonLoader()}{this.teacherSetSideBarResults()}</>}
          sidebar="left" 
        />
    )
  }
}

SearchTeacherSets.defaultProps = {
  keyword: null
};