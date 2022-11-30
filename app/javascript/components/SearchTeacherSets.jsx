import React, { useState, useEffect } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import SignedInMsg from "./SignedInMsg";
import axios from 'axios';
import { titleCase } from "title-case";
import { Button, ButtonGroup, SearchBar, Select, Icon, HorizontalRule, Heading, Card, CardHeading, CardContent, Pagination, Checkbox, TemplateAppContainer, Slider, CheckboxGroup, Flex, Spacer, Text, Box, Toggle, StatusBadge, Accordion, SkeletonLoader, useNYPLBreakpoints
} from '@nypl/design-system-react-components';

import { Link as ReactRouterLink, useSearchParams, useNavigate, useLocation } from "react-router-dom";


export default function SearchTeacherSets(props) {
  const [searchParams, setSearchParams] = useSearchParams();
  const queryParams = [];

  for(let entry of searchParams.entries()) {
    const queryParamsHash = {}
    queryParamsHash[entry[0]] = entry[1]
    queryParams.push(queryParamsHash)
  }

  const [teacherSets, setTeacherSets] = useState([])
  const [facets, setFacets] = useState([])
  const [tsTotalCount, setTsTotalCount] = useState(0)
  const [totalPages, setTotalPages] = useState(0)
  const [displayPagination, setDisplayPagination] = useState("none")
  const [keyword, setKeyWord] =  useState(searchParams.get("keyword") || "")
  const [selectedFacets, setSelectedFacets] = useState({})
  const [grade_begin, setGradeBegin] = useState(-1)
  const [grade_end, setGradeEnd] = useState(12)
  const [availableToggle, setAvailableToggle] = useState(false)
  const [availability, setAvailability] = useState("")
  const [sortTitleValue, setSortTitleValue] = useState(0)
  const [noTsResultsFound, setNoTsResultsFound] = useState("")
  const [sort_order, setSortOrder] = useState("")
  const [computedCurrentPage, setComputedCurrentPage] = useState(1)
  const initialPage = 1;
  const { isLargerThanSmall, isLargerThanMedium, isLargerThanMobile } = useNYPLBreakpoints();
  const [selectedPage, setSelectedPage] =  useState(initialPage);
  const [rangeValues, setRangevalues] = useState([-1, 12])
  const [isLoading, setIsLoading] = useState(true);
  const location = useLocation();

  useEffect(() => {
    setIsLoading(true);
    setSelectedPage(1);
  }, [facets, teacherSets, tsTotalCount, noTsResultsFound]);


  useEffect(() => {
    let timeoutId = "";
    if (isLoading) {
      timeoutId = setTimeout(() => {
        setIsLoading(false);
      }, 500);
    }
    return () => {
      clearInterval(timeoutId);
    };
  }, [isLoading]);

  const setGrades = (g_begin, g_end) => {
    if (g_begin && g_end) {
      setGradeBegin(parseInt(g_begin))
      setGradeEnd(parseInt(g_end))
      setRangevalues([parseInt(g_begin), parseInt(g_end)])
    }
  }

  useEffect(() => {
    window.scrollTo(0, 0);
    const queryValue = new URLSearchParams(location.search)
    const values = []
    const tsfacets = {}

    let facetsdata = queryParams.map((ts, i) => {
      if (ts.subjects) {
        tsfacets['subjects'] = ts.subjects.split(',');
      } else if (ts['area of study']) {
        tsfacets['area of study'] = [ts['area of study']]
      } else if (ts['set type']) {
        tsfacets['set type'] = [ts['set type']]
      } else if (ts['availability']) {
        setAvailableToggle(true)
        tsfacets['availability'] = [ts['availability']]
      } else if (ts['language']) {
        tsfacets['language'] = [ts['language']]
      }
    })

    const keywordValue = queryValue.get('keyword')? queryValue.get('keyword') : ""
    const g_begin = queryValue.get('grade_begin')? queryValue.get('grade_begin') : -1
    const g_end = queryValue.get('grade_end')? queryValue.get('grade_end') : 12
    const availabilityval = queryValue.get('availability')?  [queryValue.get('availability')] : []
    const availableToggleVal = queryValue.get('availability')?  true : false
    const sortOrderVal = queryValue.get('sort_order')?  queryValue.get('sort_order') : ""
    const pageNumber = queryValue.get('page')?  parseInt(queryValue.get('page')) : 1
    
    setSelectedFacets(tsfacets)
    setGrades(queryValue.get('grade_begin'), queryValue.get('grade_end'))
    setKeyWord(keywordValue)
    setAvailability(availabilityval)
    setAvailableToggle(availableToggleVal)
    setSortTitleValue(sortOrderVal)
    setComputedCurrentPage(pageNumber)

    const params = Object.assign({ keyword: keywordValue, grade_begin: g_begin, grade_end: g_end, availability: availabilityval, sort_order: sortOrderVal, page: pageNumber}, tsfacets)
    getTeacherSets(params)
   }, [location.search]);

  const getTeacherSets = (params) => {
    axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector("meta[name='csrf-token']").getAttribute("content")
    axios.get('/teacher_sets', {params: params}).then(res => {
      setTeacherSets(res.data.teacher_sets)
      setFacets(res.data.facets)
      setTsTotalCount(res.data.total_count)
      setTotalPages(res.data.total_pages)
      setNoTsResultsFound(res.data.no_results_found_msg)

      if (res.data.teacher_sets.length > 0 && res.data.total_count > 20 ) {
        setDisplayPagination("block")
      } else {
        setDisplayPagination("none")
      }
    })
    .catch(function (error) {
       console.log(error)
    })
  }

  const handleSubmit = (event) => {
    event.preventDefault()

    if (keyword === "") {
      searchParams.delete('keyword');
    } else {
      searchParams.set('keyword', keyword);
      setSearchParams(searchParams);
    }
    
    const params = Object.assign({ keyword: keyword, grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: availability, page: computedCurrentPage}, selectedFacets)
    getTeacherSets(params)
  }

  const handleSearchKeyword = (event) => {
    setKeyWord(event.target.value)
    if (event.target.value === "") {
      setKeyWord("")
      searchParams.delete('keyword');
      setSearchParams(searchParams);
      getTeacherSets(Object.assign({ keyword: "", grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: availability, page: computedCurrentPage}, selectedFacets));
    }
  }

  const resultsFoundMessage = () => {
    if (noTsResultsFound !== "" && tsTotalCount === 0) {
      return <Heading id="no-results-found-id" marginBottom="s" style={{fontStyle: "italic"}} level="three" size="callout" text="No results found" />
    } else if (tsTotalCount === 1) {
      return <Heading id="ts-result-found-id" marginBottom="s" level="three" size="callout" text={tsTotalCount + ' result found'} />
    } else if (tsTotalCount >= 1) {
      return <Heading id="ts-results-found-id" marginBottom="s" level="three" size="callout" text={tsTotalCount + ' results found'} />
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
            marginBottom="l"
          >
            {sortByOptions.map((s) => <option id={"ts-sort-by-options-" + s.value} key={s.value} value={s.value}>{s.sort_order}</option>)}
          </Select>
      </Flex>
    }
  }

  const teacherSetAvailability = (ts) => {
    if (ts.availability !== undefined)  {
      return <StatusBadge level={availabilityStatusBadge(ts)}>{titleCase(ts.availability)}</StatusBadge>
    } else {
      return null
    }
  }

  const availabilityStatusBadge = (ts) => {
    return (ts.availability === "available") ? "medium" : "low"
  }

  const tsHorizontalRule = (index, arr) =>  {
    if (index === arr.length - 1) {
       <></>
    } else {
      return <HorizontalRule marginTop="l" marginBottom="l" id={"ts-horizontal-rule-"+ index} align="left"  className="tsDetailHorizontalLine"/>
    }
  }


  const teacherSetDetails = () => {
    return teacherSets.map((ts, i, arr) => {
      let availability_status_badge =  (ts.availability === "available") ? "medium" : "low"
      return <div id={"teacher-set-results-" + i}>
          <Card id={"ts-details-" + i} layout="row" aspectratio="square" size="xxsmall">
            <CardHeading marginBottom="xs" level="three" id={"ts-order-details-" + i}>
              <ReactRouterLink to={"/teacher_set_details/" + ts.id} onClick={ () => window.scrollTo(0, 0)} >{ts.title}</ReactRouterLink>
            </CardHeading>
            <CardContent marginBottom="xs" id={"ts-suitabilities-"+ i}>{ts.suitabilities_string}</CardContent>
            <CardContent marginBottom="s" id={"ts-availability-"+ i}>
              {teacherSetAvailability(ts)}
            </CardContent>
            <CardContent id={"ts-description-"+ i}>{ts.description}</CardContent>
          </Card>
          <HorizontalRule marginTop="l" marginBottom="l" id={"ts-horizontal-rule-"+ i} align="left"  className="tsDetailHorizontalLine"/>
      </div>
    })
  }

  const onPageChange = (page) => {
    setComputedCurrentPage(page)
    searchParams.set('page', page);
    setSearchParams(searchParams);

    axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector("meta[name='csrf-token']").getAttribute("content")
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
        setKeyWord(keyword)
        setTeacherSets(res.data.teacher_sets)
        setFacets(res.data.facets)
        setTotalPages(res.data.total_pages)
        setTsTotalCount(res.data.total_count)
        setSortTitleValue(sortTitleValue)
        setAvailability(availability)
        setGradeBegin(grade_begin)
        setGradeEnd(grade_end)
        setNoTsResultsFound(res.data.no_results_found_msg)
        setComputedCurrentPage(page)
      })
      .catch(function (error) {
       console.log(error)
    })
  };

  const availableResults = () => {
    if (availableToggle === true) {
      setAvailableToggle(false)
      setAvailability("")
      searchParams.delete('availability')
      setSearchParams(searchParams);
      //getTeacherSets(Object.assign({ keyword: keyword, grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: "", page: computedCurrentPage}, selectedFacets))
    } else {
      setAvailableToggle(true)
      searchParams.set('availability', ['available']);
      setSearchParams(searchParams);
      setAvailability(["available"])
      //getTeacherSets(Object.assign({ keyword: keyword, grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: ["available"], page: computedCurrentPage}, selectedFacets))
    }
  };

  const getGrades = (grades) => {

    const [gradeBeginVal, gradeEndVal] = grades;
    searchParams.set('grade_begin', gradeBeginVal);
    searchParams.set('grade_end', gradeEndVal);
    setSearchParams(searchParams);
    //getTeacherSets(Object.assign({ keyword: keyword, sort_order: sortTitleValue, availability: availability, grade_begin: gradeBeginVal, grade_end: gradeEndVal, page: computedCurrentPage}, selectedFacets))
  };

  const TeacherSetGradesSlider = () => {
    const g_begin = parseInt(grade_begin) === -1? 'Pre-K' : parseInt(grade_begin) === 0? 'K' : parseInt(grade_begin);
    const g_end = parseInt(grade_end) === -1? 'Pre-K' : parseInt(grade_end) === 0? 'K' : parseInt(grade_end);
      return <Slider marginTop="s" marginBottom="l"
        id="ts-slider-range"
        isRangeSlider
        labelText={"Grades " + g_begin + " to " + g_end}
        min={-1}
        max={12}
        defaultValue={[parseInt(grade_begin), parseInt(grade_end)]}
        onChange={getGrades}
        showBoxes={false}
        showHelperInvalidText
        showLabel
        showValues={false}
        value={rangeValues}
    />
  }

  const RefineResults = () => {
    if (facets && facets.length >= 1) {
      if (isLargerThanMedium) {
        return <div>{teacherSetSideBarResults()}</div>
      } else {
        return <>
          {resultsFoundMessage()}
          <Accordion backgroundColor="var(--nypl-colors-ui-white)" marginTop="m" id="mobile-ts-facet-label" accordionData={ [
            {
              label: <Text isCapitalized noSpace>Refine Results</Text>,
              panel: <div>{teacherSetSideBarResults()}</div>
            } ]}
            // isAlwaysRendered
          />
        </>
      }
    } else {
      return null
    }
  }

  const tsRefineResultsHeading = () => {
    if (isLargerThanMedium) {
      return <Heading id="refine-results" size="tertiary" level="three" > Refine Results </Heading>
    }
  }

  const teacherSetSideBarResults = () => {
    const bgColor = isLargerThanMedium ? "var(--nypl-colors-ui-gray-x-light-cool)" : ""
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

  const sortTeacherSetTitle = (e) => {
    searchParams.set('sort_order', [e.target.value]);
    setSearchParams(searchParams);
    setSortTitleValue(e.target.value)
    getTeacherSets(Object.assign({ keyword: keyword, grade_begin: grade_begin, grade_end: grade_end, sort_order: e.target.value, availability: availability, page: computedCurrentPage}, selectedFacets));
  };

  const tsSelectedFacets = (field, value) => {
    if (field === 'area of study') {
      selectedFacets[field] = value
    } else if (field === 'availability') {
      selectedFacets[field] = value
    } else if (field === 'set type') {
      selectedFacets[field] = value
    } else if (field === 'language') {
      selectedFacets[field] = value
    } else if (field === 'subjects') {
      selectedFacets[field] = value
    }

    if (value.length > 0){
      searchParams.set(field, value)
    } else {
      searchParams.delete(field)
    }
    setSelectedFacets(selectedFacets)
    setSearchParams(searchParams);
    if (keyword !==null) {
      getTeacherSets(Object.assign({ keyword: keyword, grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: availability, page: computedCurrentPage}, selectedFacets))
    } else {
      getTeacherSets(Object.assign({ grade_begin: grade_begin, grade_end: grade_end, sort_order: sortTitleValue, availability: availability, page: computedCurrentPage}, selectedFacets))
    }
  }

  const skeletonLoader = () => {
    if (noTsResultsFound === "" && teacherSets.length <= 0) {
      return <SkeletonLoader className="teacher-set-skeleton-loader"
        contentSize={1}
        headingSize={1}
        imageAspectRatio="portrait"
        layout="row"
        showImage
        showHeading={false}
        showContent={false}
        showButton={false}
        width="300px"
      />
    }
  }

  const tsDetails = () =>{
    if (isLoading) {
      return <SkeletonLoader className="teacher-set-details-skeleton-loader"
        contentSize={4}
        headingSize={2}
        imageAspectRatio="portrait"
        layout="row"
        showImage={false}
        width="900px"
      />
    } else {
      return <>
        <div style={{display: mobileSupport()}}>{resultsFoundMessage()}</div>
          <div>{teacherSetTitleOrder()}</div>
          <div id="teacher-set-results">{teacherSetDetails()}</div>
          <div style={{ display: displayPagination }} >
            <Flex alignItems="baseline">
              <ButtonGroup>
                <Button id="teacher-sets-scroll-to-top" buttonType="secondary" className="backToTop"
                  onClick={() =>
                    window.scrollTo({
                      top: 10,
                      behavior: "smooth",
                    })
                  }
                >
                  Back to Top
                  <Icon name="arrow" iconRotation="rotate180" size="small" className="backToTopIcon" align="right" />
                </Button>
              </ButtonGroup>
              <Spacer />
              <div><Pagination id="ts-pagination" onClick={ () => window.scrollTo(0, 0) } className="teacher_set_pagination" onPageChange={onPageChange} initialPage={computedCurrentPage} currentPage={computedCurrentPage} pageCount={totalPages} /></div>
            </Flex>
          </div>
      </>
    }
  }

  const displayAccordionData = (ts) => {
    const tsItems = ts.items;
    if (tsItems.length >= 1) {

      if (selectedFacets[ts.label] === undefined) {
        selectedFacets[ts.label] = []
      }

      return <CheckboxGroup isFullWidth id="ts-checkbox-group" isRequired={false}  layout="column" name={ts.label} onChange={tsSelectedFacets.bind(this, ts.label)} value={selectedFacets[ts.label]}>
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
      return <Text isItalic noSpace size="caption" id="accordion-no-results-found">No options available</Text>
    }
  }

  const TeacherSetFacets = () => {
     return facets.map((ts, i) => {
      return <Accordion id={"ts-facets-accordian-"+ i} backgroundColor="var(--nypl-colors-ui-white)" marginTop="m" id={"ts-facet-label-" + i} panelMaxHeight="400px" 
      accordionData={ [
        {
          label: <Text isCapitalized noSpace>{ts.label}</Text>,
          panel: displayAccordionData(ts)
        } ]}
        isDefaultOpen={isAccordionOpen(ts)}
        //isAlwaysRendered
      />
    })
  }

  const isAccordionOpen = (ts) => {
    return selectedFacets[ts.label] && selectedFacets[ts.label].length > 0 ? true : false
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
          contentPrimary={tsDetails()}
          contentSidebar={<>{skeletonLoader()}{RefineResults()}</>}
          sidebar="left" 
        />
    )
}