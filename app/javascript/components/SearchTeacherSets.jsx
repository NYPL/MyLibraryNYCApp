import React, { Component, useState, useEffect } from 'react';
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
  Pagination, Checkbox, TemplateAppContainer, Slider, CheckboxGroup, Notification, Flex, Spacer, Text, Box, Toggle, StatusBadge, Accordion, SkeletonLoader, useNYPLBreakpoints
} from '@nypl/design-system-react-components';


import { Link as ReactRouterLink } from "react-router-dom";


export default function SearchTeacherSets(props) {

  const [teacherSets, setTeacherSets] = useState([])
  const [facets, setFacets] = useState([])
  const [tsTotalCount, setTsTotalCount] = useState(0)
  const [totalPages, setTotalPages] = useState(0)
  const [pagination, setPagination] = useState("none")
  const [keyword, setKeyWord] = useState(new URLSearchParams(props.location.search).get('keyword') || "")
  const [selectedFacets, setSelectedFacets] = useState({})
  const [params, setParams] = useState({})
  const [grade_begin, setGradeBegin] = useState(-1)
  const [grade_end, setGradeEnd] = useState(12)
  const [availableToggle, setAvailableToggle] = useState(false)
  const [availability, setAvailability] = useState("")
  const [sortTitleValue, setSortTitleValue] = useState(0)
  const [noTsResultsFound, setNoTsResultsFound] = useState("")
  const [sort_order, setSortOrder] = useState("")
  const [computedCurrentPage, setComputedCurrentPage] = useState(1)
  const { isLargerThanSmall, isLargerThanMedium, isLargerThanMobile, isLargerThanLarge, isLargerThanXLarge } = useNYPLBreakpoints();


  useEffect(() => {
    const params = Object.assign({ keyword: keyword, grade_begin: grade_begin, grade_end: grade_end}, selectedFacets)
    getTeacherSets(params)
  }, []);


  const getTeacherSets = (params) => {
    axios.get('/teacher_sets', {params: params}).then(res => {
      setTeacherSets(res.data.teacher_sets)
      setFacets(res.data.facets)
      setTsTotalCount(res.data.total_count)
      setTotalPages(res.data.total_pages)
      setNoTsResultsFound(res.data.no_results_found_msg)

      if (res.data.teacher_sets.length > 0 && res.data.total_count > 20 ) {
        setPagination("block")
      } else {
        setPagination("none")
      }
    })
    .catch(function (error) {
       console.log(error)
    })
  }


  const  handleSubmit = (event) => {
    event.preventDefault()
    const params = Object.assign({ keyword: keyword, grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: availability}, selectedFacets)
    getTeacherSets(params)
  }

  const handleSearchKeyword = (event) => {
    setKeyWord(event.target.value)
    if (event.target.value === "") {
      getTeacherSets(Object.assign({ keyword: "", grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: availability}, selectedFacets));
    }
  }

  const resultsFoundMessage = () => {
    if (noTsResultsFound !== "" && tsTotalCount === 0) {
      return "No results found"
    } else if (tsTotalCount === 1) {
      return tsTotalCount + ' result found'
    } else if (tsTotalCount >= 1) {
      return tsTotalCount + ' results found'
    }
  }

  const teacherSetTitleOrder = () => {
    if (teacherSets.length >= 1) {
      let sortByOptions = [{sort_order: 'Date Added: Newest to Oldest', value: 0}, {sort_order: 'Date Added: Oldest to Newest', value: 1}, {sort_order: 'Title: A-Z', value: 2}, {sort_order: 'Title: Z-A', value: 3}]
      return <Flex>                    
          <Select
            id="ts-sort-by-select"
            name="sortBy"
            selectType="default"
            value={sortTitleValue}
            onChange={sortTeacherSetTitle.bind(this)}
            labelText="Sort By"
          >
            {sortByOptions.map((s) => <option id={"ts-sort-by-options-" + s.value} key={s.value} value={s.value}>{s.sort_order}</option>)}
          </Select>
      </Flex>
    }
  }

  const teacherSetDetails = () => {
    return teacherSets.map((ts, i) => {
      let availability_status_badge =  (ts.availability === "available") ? "medium" : "low"
      return <div id={"teacher-set-results-" + i}>
          <Card id={"ts-details-" + i} marginTop="m" layout="row" aspectratio="square" size="xxsmall">
            <CardHeading level="three" id={"ts-order-details-" + i}>
              <ReactRouterLink to={"/teacher_set_details/" + ts.id}>{ts.title}</ReactRouterLink>
            </CardHeading>
            <CardContent id={"ts-suitabilities-"+ i}>{ts.suitabilities_string}</CardContent>
            <CardContent id={"ts-availability-"+ i}>
              <StatusBadge level={availability_status_badge}>{titleCase(ts.availability)}</StatusBadge>
            </CardContent>
            <CardContent id={"ts-description-"+ i}>{ts.description}</CardContent>
          </Card>
          <HorizontalRule id={"ts-horizontal-rule-"+ i} align="left"  className="tsDetailHorizontalLine"/>
      </div>
    })
  }

  const onPageChange = (page) => {
    setComputedCurrentPage(page);
    axios.get('/teacher_sets', {
        params: Object.assign({
          keyword: keyword,
          page: page,
          sort_order: sortTitleValue,
          availability: availability,
          grade_begin: grade_begin,
          grade_end: grade_end,
        }, selectedFacets), 
     }).then(res => {
        // this.setState({ teacherSets: res.data.teacher_sets, tsTotalCount: res.data.total_count, sort_order: sortTitleValue, availability: availability, keyword: keyword, grade_begin: grade_begin, grade_end: grade_end});
        setKeyWord(keyword)
        setTeacherSets(res.data.teacher_sets)
        setFacets(res.data.facets)
        setTsTotalCount(res.data.total_count)
        setSortTitleValue(sortTitleValue)
        setAvailability(availability)
        setGradeBegin(grade_begin)
        setGradeEnd(grade_end)
        setNoTsResultsFound(res.data.no_results_found_msg)

      })
      .catch(function (error) {
       console.log(error)
    })
  };

  const availableResults = () => {
    if (availableToggle === true) {
      setAvailableToggle(false)
      setAvailability("")
      getTeacherSets(Object.assign({ keyword: keyword, grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: ""}, selectedFacets))
    } else {
      setAvailableToggle(true)
      setAvailability(["available"])
      getTeacherSets(Object.assign({ keyword: keyword, grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: ["available"]}, selectedFacets))
    }
  };

  const getGrades = (grades) => {
    const [gradeBeginVal, gradeEndVal] = grades;
    const gradeBegin = gradeBeginVal === -1? 'Pre-K' : gradeBeginVal === 0 ? 'K' : gradeBeginVal;
    const gradeEnd = gradeEndVal === -1? 'Pre-K' :  gradeEndVal === 0 ? 'K' : gradeEndVal;
    setGradeBegin(gradeBegin)
    setGradeEnd(gradeEnd)
    getTeacherSets(Object.assign({ keyword: keyword, sort_order: sortTitleValue, availability: availability, grade_begin: gradeBeginVal, grade_end: gradeEndVal}, selectedFacets))
  };


  const TeacherSetGradesSlider = () => {
    const g_begin = grade_begin === -1? 'Pre-K' :  grade_begin;
      return <Slider marginTop="s" marginBottom="l"
        id="ts-slider-range"
        isRangeSlider
        labelText={"Grades Range  " + g_begin + " To " + grade_end}
        max={12}
        min={-1}
        onChange={getGrades}
        showBoxes={false}
        showHelperInvalidText
        showLabel
        showValues={false}
        step={1}
    />
  }

  const RefineResults = () => {
    if (isLargerThanMedium) {
      return <div>{teacherSetSideBarResults()}</div>
    } else {
      return <>
        <Text noSpace isBold size="caption">{resultsFoundMessage()}</Text>
        <Accordion backgroundColor="var(--nypl-colors-ui-white)" marginTop="m" id="mobile-ts-facet-label" accordionData={ [
          {
            label: <Text isCapitalized noSpace>Refine Results</Text>,
            panel: <div>{teacherSetSideBarResults()}</div>
          } ]}
        />
      </>
    }
  }

  const tsRefineResultsHeading = () => {
    if (isLargerThanMedium) {
      return <Heading id="refine-results" size="tertiary" level="three" > Refine Results </Heading>
    }
  }

  const teacherSetSideBarResults = () => {
    const bgColor = isLargerThanMedium ? "var(--nypl-colors-ui-gray-x-light-cool)" : ""
    if (facets && facets.length >= 1) {
      return <Box id="ts-all-facets" bg={bgColor} padding="var(--nypl-space-s)">
          <div>{tsRefineResultsHeading()}</div>
          <Toggle
            id="toggle"
            isChecked={availableToggle}
            labelText="Available Now"
            onChange={availableResults}
            size="small"
            marginBottom="m"
          />
          <div>{TeacherSetGradesSlider()}</div>
          <div>{TeacherSetFacets()}</div>
      </Box>
    }
  }

  const sortTeacherSetTitle = (e) => {
    setSortTitleValue(e.target.value)
    getTeacherSets(Object.assign({ keyword: keyword, grade_begin: grade_begin, grade_end: grade_end, sort_order: e.target.value, availability: availability}, selectedFacets));
  };

  const tsSelectedFacets = (field, label) => {
    if (field === 'area of study') {
      selectedFacets[field] = label
    } else if (field === 'availability') {
      selectedFacets[field] = label
    } else if (field === 'set type') {
      selectedFacets[field] = label
    } else if (field === 'language') {
      selectedFacets[field] = label
    } else if (field === 'subjects') {
      selectedFacets[field] = label
    }
    setSelectedFacets(selectedFacets)
    if (keyword !==null) {
      getTeacherSets(Object.assign({ keyword: keyword, grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: availability}, selectedFacets))
    } else {
      getTeacherSets(Object.assign({ grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: availability}, selectedFacets))
    }
  }

  const skeletonLoader = () => {
    if (noTsResultsFound === "" && teacherSets.length <= 0) {
      return <SkeletonLoader className="teacher-set-skeleton-loader"
        contentSize={4}
        headingSize={2}
        imageAspectRatio="portrait"
        layout="row"
        showImage
        width="900px"
      />
    }
  }

  const displayAccordionData = (ts) => {
    const tsItems = ts.items;
    if (tsItems.length >= 1) {
      return <CheckboxGroup isFullWidth id={"ts-checkbox-group"} defaultValue={[]} isRequired={false}  layout="column" name={ts.label} onChange={tsSelectedFacets.bind(this, ts.label)}>
        { tsItems.map((item, index) =>
            <Checkbox id={"ts-checkbox-"+ index} value={item["value"].toString()} 
               labelText={
                 <Flex>
                    <span>{item["label"]}</span>
                    <Spacer />
                    <Text noSpace id={"ts-count-"+ index} size="caption">{item["count"] || 0}</Text>
                </Flex>
              }
           />
        )}
      </CheckboxGroup>
    } else {
      return <Text isItalic size="caption" id="accordion-no-results-found">No options available</Text>
    }
  }

  const TeacherSetFacets = () => {
    return facets.map((ts, i) => {
      return <Accordion backgroundColor="var(--nypl-colors-ui-white)" marginTop="m" id={"ts-facet-label-" + i} accordionData={ [
        {
          label: <Text isCapitalized noSpace>{ts.label}</Text>,
          panel: displayAccordionData(ts)
        } ]}
      />
    })
  }

  const mobileSupport = () => {
    return isLargerThanMedium ? "block" : "none"
  }

  return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentTop={<>
              {<SignedInMsg signInDetails={props} />}
              <Heading id="search-and-find-teacher-sets-header" size="secondary" level="two" text="Search and Find Teacher Sets"  />
              <HorizontalRule id="ts-horizontal-rule" className="teacherSetHorizontal" />
              <SearchBar id="ts-search" noBrandButtonType labelText="Teacher-Set SearchBar" onSubmit={(event)=>handleSubmit(event)} 
                textInputProps={{
                  id: "search-teacher-set",
                  labelText: "Enter a teacher set name",
                  name: "TeacherSetInputName",
                  onChange: handleSearchKeyword,
                  placeholder: "Enter a teacher set name",
                  value: keyword
                }}
              />     
            </>
          }
          contentPrimary={
              <>
                <Text style={{display: mobileSupport()}} isItalic size="caption">{resultsFoundMessage()}</Text>
                <div>{teacherSetTitleOrder()}</div>
                <div id="teacher-set-results">{teacherSetDetails()}</div>
                <div style={{ display: pagination }} >
                  <Flex alignItems="baseline">
                    <ButtonGroup>
                      <Button id="teacher-sets-scroll-to-top" buttonType="secondary" className="backToTop"
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
                      <Pagination id="ts-pagination" className="teacher_set_pagination" currentPage={1} onPageChange={onPageChange}  pageCount={totalPages} />
                    </div>
                  </Flex>
                </div>
              </>
            }
          contentSidebar={<><div>{skeletonLoader()}</div><div>{RefineResults()}</div></>}
          sidebar="left" 
        />
    )
}