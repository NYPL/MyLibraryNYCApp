import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import SignedInMsg from "./SignedInMsg";
import axios from "axios";
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
  Pagination,
  Checkbox,
  TemplateAppContainer,
  Slider,
  CheckboxGroup,
  Flex,
  Spacer,
  Text,
  Box,
  Toggle,
  StatusBadge,
  Accordion,
  SkeletonLoader,
  useNYPLBreakpoints,
  TagSet,
  Notification,
  useColorModeValue,
} from "@nypl/design-system-react-components";

import {
  Link as ReactRouterLink,
  useSearchParams,
  useLocation,
} from "react-router-dom";

export default function SearchTeacherSets(props) {
  const [searchParams, setSearchParams] = useSearchParams();
  const queryParams = [];

  for (let entry of searchParams.entries()) {
    const queryParamsHash = {};
    queryParamsHash[entry[0]] = entry[1];
    queryParams.push(queryParamsHash);
  }

  const facetBoxColor = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );

  const [teacherSets, setTeacherSets] = useState([]);
  const [facets, setFacets] = useState([]);
  // const [tagSets, setTagSets] = useState([]);
  const [teacherSetArr, setTeacherSetArr] = useState([]);
  const [tsTotalCount, setTsTotalCount] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [displayPagination, setDisplayPagination] = useState("none");
  const [keyword, setKeyWord] = useState(searchParams.get("keyword") || "");
  const [selectedFacets, setSelectedFacets] = useState({});
  const [grade_begin, setGradeBegin] = useState(-1);
  const [grade_end, setGradeEnd] = useState(12);
  const [availableToggle, setAvailableToggle] = useState(false);
  const [availability, setAvailability] = useState("");
  const [sortTitleValue, setSortTitleValue] = useState(0);
  const [noTsResultsFound, setNoTsResultsFound] = useState("");
  const [computedCurrentPage, setComputedCurrentPage] = useState(1);
  // const initialPage = 1;
  const { isLargerThanMedium, isLargerThanMobile } = useNYPLBreakpoints();
  // const [selectedPage, setSelectedPage] = useState(initialPage);
  const [rangeValues, setRangevalues] = useState([-1, 12]);
  const [isLoading, setIsLoading] = useState(true);
  const [tsSubjects, setTsSubjects] = useState({});
  const [resetPageNumber, setResetPageNumber] = useState("");
  const [teacherSetDataNotRetrievedMsg, setTeacherSetDataNotRetrievedMsg] =
    useState("");
  const location = useLocation();

  useEffect(() => {
    setIsLoading(true);
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

  useEffect(() => {
    if (resetPageNumber !== "") {
      setComputedCurrentPage(1);
    }
  });

  const setGrades = (g_begin, g_end) => {
    if (g_begin && g_end) {
      setGradeBegin(parseInt(g_begin));
      setGradeEnd(parseInt(g_end));
      setRangevalues([parseInt(g_begin), parseInt(g_end)]);
    }
  };

  useEffect(() => {
    const queryValue = new URLSearchParams(location.search);
    const tsfacets = {};
    const tagSetsArr = [];
    setTsSubjects({});

    queryParams.map((ts) => {
      const tagSets = {};

      if (ts.subjects) {
        tsfacets["subjects"] = ts.subjects.split(",");
        ts.subjects.split(",").map((value) => {
          if (tsSubjects[value] !== undefined) {
            const subjectsHash = {};
            subjectsHash["label"] = tsSubjects[value];
            subjectsHash["subjects"] = [tsSubjects[value]];
            tagSetsArr.push(subjectsHash);
          }
        });
      } else if (ts["area of study"]) {
        tsfacets["area of study"] = [ts["area of study"]];
        tagSets["label"] = ts["area of study"];
        tagSets["area of study"] = [ts["area of study"]];
      } else if (ts["set type"]) {
        tsfacets["set type"] = [ts["set type"]];
        tagSets["label"] = ts["set type"];
        tagSets["set type"] = [ts["set type"]];
      } else if (ts["availability"]) {
        setAvailableToggle(true);
        tsfacets["availability"] = [ts["availability"]];
        tagSets["label"] = "Available Now";
        tagSets["availability"] = [ts["availability"]];
      } else if (ts["language"]) {
        tsfacets["language"] = [ts["language"]];
        tagSets["label"] = ts["language"];
        tagSets["language"] = [ts["language"]];
      } else if (ts.keyword) {
        tagSets["label"] = ts["keyword"];
        tagSets["keyword"] = [ts["language"]];
      }
      tagSetsArr.push(tagSets);
    });

    const keywordValue = queryValue.get("keyword")
      ? queryValue.get("keyword")
      : "";
    const g_begin = queryValue.get("grade_begin")
      ? queryValue.get("grade_begin")
      : -1;
    const g_end = queryValue.get("grade_end")
      ? queryValue.get("grade_end")
      : 12;
    const availabilityval = queryValue.get("availability")
      ? [queryValue.get("availability")]
      : [];
    const availableToggleVal = queryValue.get("availability") ? true : false;
    const sortOrderVal = queryValue.get("sort_order")
      ? queryValue.get("sort_order")
      : "";

    const pageNumber = queryValue.get("page")
      ? parseInt(queryValue.get("page"))
      : 1;

    if (queryValue.get("grade_begin") && queryValue.get("grade_end")) {
      const tagSetGradeBegin =
        parseInt(g_begin) === -1
          ? "Pre-K"
          : parseInt(g_begin) === 0
          ? "K"
          : parseInt(g_begin);

      const tagSetGradeEnd =
        parseInt(g_end) === -1
          ? "Pre-K"
          : parseInt(g_end) === 0
          ? "K"
          : parseInt(g_end);

      const tagSetGrades = {
        label: tagSetGradeBegin + " to " + tagSetGradeEnd,
        grade_begin: [queryValue.get("grade_begin")],
        grade_end: [queryValue.get("grade_end")],
      };
      tagSetsArr.push(tagSetGrades);
    }

    setSelectedFacets(tsfacets);
    setGrades(queryValue.get("grade_begin"), queryValue.get("grade_end"));
    setKeyWord(keywordValue);
    setAvailability(availabilityval);
    setAvailableToggle(availableToggleVal);
    setSortTitleValue(sortOrderVal);
    setComputedCurrentPage(pageNumber);
    setTeacherSetArr(tagSetsArr);

    const params = Object.assign(
      {
        keyword: keywordValue,
        grade_begin: g_begin,
        grade_end: g_end,
        availability: availabilityval,
        sort_order: sortOrderVal,
        page: pageNumber,
      },
      tsfacets
    );
    getTeacherSets(params);
  }, [location.search]);

  const getTeacherSets = (params) => {
    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    axios
      .get("/teacher_sets", { params: params })
      .then((res) => {
        setTeacherSets(res.data.teacher_sets);
        setFacets(res.data.facets);
        setTsTotalCount(res.data.total_count);
        setTotalPages(res.data.total_pages);
        setNoTsResultsFound(res.data.no_results_found_msg);
        setTsSubjects(res.data.tsSubjectsHash);
        setResetPageNumber(res.data.resetPageNumber);
        setTeacherSetDataNotRetrievedMsg(res.data.errrorMessage);
        if (res.data.teacher_sets.length > 0 && res.data.total_count > 10) {
          setDisplayPagination("block");
        } else {
          setDisplayPagination("none");
        }
      })
      .catch(function (error) {
        console.log(error);
        console.error(error);
      });
  };

  const handleSubmit = (event) => {
    event.preventDefault();

    if (keyword === "") {
      searchParams.delete("keyword");
    } else {
      searchParams.set("keyword", keyword);
      setSearchParams(searchParams);
      setComputedCurrentPage(1);
      searchParams.set("page", 1);
      setSearchParams(searchParams);
    }

    const params = Object.assign(
      {
        keyword: keyword,
        grade_begin: grade_begin,
        grade_end: grade_end,
        sort_order: sortTitleValue,
        availability: availability,
        page: computedCurrentPage,
      },
      selectedFacets
    );
    getTeacherSets(params);
  };

  const handleSearchKeyword = (event) => {
    setKeyWord(event.target.value);
    if (event.target.value === "") {
      setKeyWord("");
      searchParams.delete("keyword");
      searchParams.delete("page");
      setSearchParams(searchParams);
      getTeacherSets(
        Object.assign(
          {
            keyword: "",
            grade_begin: grade_begin,
            grade_end: grade_end,
            sort_order: sortTitleValue,
            availability: availability,
            page: computedCurrentPage,
          },
          selectedFacets
        )
      );
    }
  };

  const toResults = (
    pageCount,
    tsTotalCount,
    paginationData,
    resetpage_number
  ) => {
    if (resetpage_number !== "") {
      return pageCount * resetpage_number;
    } else {
      return tsTotalCount < pageCount || tsTotalCount < paginationData
        ? tsTotalCount
        : paginationData;
    }
  };

  const resultsFoundMessage = () => {
    if (noTsResultsFound !== "" && tsTotalCount === 0) {
      return (
        <Heading
          id="no-results-found-id"
          marginBottom="s"
          style={{ fontStyle: "italic" }}
          level="three"
          size="callout"
          text="No results found"
        />
      );
    } else if (tsTotalCount === 1) {
      const pageCount = 10;
      const paginationData = parseInt(computedCurrentPage * pageCount);
      const test =
        tsTotalCount < parseInt(paginationData) - 10
          ? 1
          : parseInt(paginationData) + 1 - 10;
      const perPageNumbers =
        tsTotalCount < pageCount || tsTotalCount < paginationData
          ? tsTotalCount
          : paginationData;

      return (
        <Text
          marginTop="m"
          id="ts-result-found-id"
          fontWeight="heading.callout"
          aria-live="polite"
        >
          {"Showing " +
            test +
            "-" +
            perPageNumbers +
            " of " +
            tsTotalCount +
            " result"}
        </Text>
      );
    } else if (tsTotalCount >= 1) {
      const pageCount = 10;
      const paginationData = parseInt(computedCurrentPage * pageCount);

      const fromResults =
        tsTotalCount < parseInt(paginationData) - 10
          ? 1
          : parseInt(paginationData) + 1 - 10;

      const toresults = toResults(
        pageCount,
        tsTotalCount,
        paginationData,
        resetPageNumber
      );

      return (
        <Text
          marginTop="m"
          id="ts-results-found-id"
          fontWeight="heading.callout"
          aria-live="polite"
        >
          {"Showing " +
            fromResults +
            "-" +
            toresults +
            " of " +
            tsTotalCount +
            " results"}
        </Text>
      );
    }
  };

  const teacherSetTitleOrder = () => {
    if (teacherSets.length >= 1) {
      let sortByOptions = [
        { sort_order: "Date Added: Newest to Oldest", value: 0 },
        { sort_order: "Date Added: Oldest to Newest", value: 1 },
        { sort_order: "Title: A-Z", value: 2 },
        { sort_order: "Title: Z-A", value: 3 },
      ];
      return (
        <Select
          id="ts-sort-by-select"
          name="sortBy"
          selectType="default"
          value={sortTitleValue}
          onChange={sortTeacherSetTitle.bind(this)}
          labelText="Sort By"
          labelPosition="inline"
          className="selectSortOrder"
          //marginTop="xs"
        >
          {sortByOptions.map((s) => (
            <option
              id={"ts-sort-by-options-" + s.value}
              key={s.value}
              value={s.value}
            >
              {s.sort_order}
            </option>
          ))}
        </Select>
      );
    }
  };

  const teacherSetAvailability = (ts) => {
    if (ts.availability !== undefined) {
      return (
        <StatusBadge level={availabilityStatusBadge(ts)}>
          {titleCase(ts.availability)}
        </StatusBadge>
      );
    } else {
      return null;
    }
  };

  const availabilityStatusBadge = (ts) => {
    return ts.availability === "available" ? "medium" : "low";
  };

  const teacherSetDetails = () => {
    if (teacherSets.length >= 0) {
      return teacherSets.map((ts, i) => {
        return (
          <div
            key={"teacher-set-results-key-" + i}
            id={"teacher-set-results-" + i}
          >
            <Card
              id={"ts-details-" + i}
              layout="row"
              aspectratio="square"
              size="xxsmall"
              marginTop="l"
            >
              <CardHeading
                marginBottom="xs"
                level="three"
                id={"ts-order-details-" + i}
              >
                <ReactRouterLink
                  to={"/teacher_set_details/" + ts.id}
                  onClick={() => window.scrollTo(0, 0)}
                >
                  {ts.title}
                </ReactRouterLink>
              </CardHeading>
              <CardContent marginBottom="xs" id={"ts-suitabilities-" + i}>
                {ts.suitabilities_string}
              </CardContent>
              <CardContent marginBottom="s" id={"ts-availability-" + i}>
                {teacherSetAvailability(ts)}
              </CardContent>
              <CardContent id={"ts-description-" + i}>
                {ts.description}
              </CardContent>
            </Card>
            <HorizontalRule
              marginTop="l"
              marginBottom="l"
              id={"ts-horizontal-rule-" + i}
              align="left"
              className="tsDetailHorizontalLine"
            />
          </div>
        );
      });
    } else {
      return <></>;
    }
  };

  const onPageChange = (page) => {
    setComputedCurrentPage(page);
    searchParams.set("page", page);
    setSearchParams(searchParams);

    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    axios
      .get("/teacher_sets", {
        params: Object.assign(
          {
            keyword: keyword,
            page: page,
            sort_order: sortTitleValue,
            availability: availability,
            grade_begin: grade_begin,
            grade_end: grade_end,
          },
          selectedFacets
        ),
      })
      .then((res) => {
        setKeyWord(keyword);
        setTeacherSets(res.data.teacher_sets);
        setFacets(res.data.facets);
        setTotalPages(res.data.total_pages);
        setTsTotalCount(res.data.total_count);
        setSortTitleValue(sortTitleValue);
        setAvailability(availability);
        setGradeBegin(grade_begin);
        setGradeEnd(grade_end);
        setNoTsResultsFound(res.data.no_results_found_msg);
        setComputedCurrentPage(page);
        setTsSubjects(res.data.tsSubjectsHash);
      })
      .catch(function (error) {
        console.log(error);
      });
  };

  const availableResults = () => {
    window.scrollTo(428, 428);
    if (availableToggle === true) {
      setAvailableToggle(false);
      setAvailability("");
      searchParams.delete("availability");
      setSearchParams(searchParams);
    } else {
      setAvailableToggle(true);
      setComputedCurrentPage(1);
      searchParams.delete("page");
      setSearchParams(searchParams);
      searchParams.set("availability", ["available"]);
      setSearchParams(searchParams);
      setAvailability(["available"]);
    }
  };

  const getGrades = (grades) => {
    const [gradeBeginVal, gradeEndVal] = grades;
    if (rangeValues[0] !== gradeBeginVal || rangeValues[1] !== gradeEndVal) {
      setRangevalues([gradeBeginVal, gradeEndVal]);
      setGradeBegin(parseInt(gradeBeginVal));
      setGradeEnd(parseInt(gradeEndVal));
      searchParams.set("grade_begin", gradeBeginVal);
      searchParams.set("grade_end", gradeEndVal);
      setSearchParams(searchParams);
      window.scrollTo(428, 428);
    }
  };

  const TeacherSetGradesSlider = () => {
    const g_begin =
      parseInt(grade_begin) === -1
        ? "Pre-K"
        : parseInt(grade_begin) === 0
        ? "K"
        : parseInt(grade_begin);
    const g_end =
      parseInt(grade_end) === -1
        ? "Pre-K"
        : parseInt(grade_end) === 0
        ? "K"
        : parseInt(grade_end);
    return (
      <Slider
        marginTop="s"
        marginBottom="l"
        id="ts-slider-range"
        isRangeSlider
        labelText={"Grades " + g_begin + " to " + g_end}
        min={-1}
        max={12}
        defaultValue={[parseInt(grade_begin), parseInt(grade_end)]}
        onChange={getGrades}
        //onChangeEnd={getGrades}
        showBoxes={false}
        showHelperInvalidText
        showLabel
        showValues={false}
        value={[parseInt(grade_begin), parseInt(grade_end)]}
      />
    );
  };

  const RefineResults = () => {
    if (facets && facets.length >= 1) {
      if (isLargerThanMedium) {
        return <div>{teacherSetSideBarResults()}</div>;
      } else {
        return (
          <>
            {resultsFoundMessage()}
            <Accordion
              backgroundColor="var(--nypl-colors-ui-white)"
              marginTop="m"
              id="mobile-ts-facet-label"
              accordionData={[
                {
                  label: (
                    <Text isCapitalized noSpace>
                      Refine Results
                    </Text>
                  ),
                  panel: <div>{teacherSetSideBarResults()}</div>,
                },
              ]}
            />
          </>
        );
      }
    } else {
      return null;
    }
  };

  const tsRefineResultsHeading = () => {
    if (isLargerThanMedium) {
      return (
        <Heading
          id="refine-results"
          size="tertiary"
          level="three"
          text={" " + "Refine Results" + " "}
        />
      );
    }
  };

  const clearFilters = () => {
    searchParams.delete("language");
    searchParams.delete("area of study");
    searchParams.delete("set type");
    searchParams.delete("availability");
    searchParams.delete("subjects");
    searchParams.delete("grade_begin");
    searchParams.delete("grade_end");
    setSearchParams(searchParams);
    setGradeBegin(-1);
    setGradeEnd(12);
    setRangevalues([-1, 12]);
    window.scrollTo({ top: 428, behavior: "smooth" });
  };

  const teacherSetSideBarResults = () => {
    const bgColor = isLargerThanMedium ? { facetBoxColor } : "";
    const clearFilteMargin = isLargerThanMobile ? "xl" : "84px";
    return (
      <Box id="ts-all-facets" bg={bgColor} padding="var(--nypl-space-s)">
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
        {/* <div>
          <Button
            buttonType="text"
            id="clear-filters-button-id"
            size="medium"
            type="button"
            marginTop="m"
            marginLeft={clearFilteMargin}
            onClick={clearFilters}
          >
            Clear Filters
          </Button>
        </div> */}
      </Box>
    );
  };

  const sortTeacherSetTitle = (e) => {
    searchParams.set("sort_order", [e.target.value]);
    setSearchParams(searchParams);
    setSortTitleValue(e.target.value);
    getTeacherSets(
      Object.assign(
        {
          keyword: keyword,
          grade_begin: grade_begin,
          grade_end: grade_end,
          sort_order: e.target.value,
          availability: availability,
          page: computedCurrentPage,
        },
        selectedFacets
      )
    );
  };

  const tsSelectedFacets = (field, value) => {
    if (field === "area of study") {
      searchParams.delete("page");
      setSearchParams(searchParams);
      setComputedCurrentPage(1);
      selectedFacets[field] = value;
    } else if (field === "availability") {
      searchParams.delete("page");
      setSearchParams(searchParams);
      setComputedCurrentPage(1);
      selectedFacets[field] = value;
    } else if (field === "set type") {
      searchParams.delete("page");
      setSearchParams(searchParams);
      setComputedCurrentPage(1);
      selectedFacets[field] = value;
    } else if (field === "language") {
      searchParams.delete("page");
      setSearchParams(searchParams);
      setComputedCurrentPage(1);
      selectedFacets[field] = value;
    } else if (field === "subjects") {
      searchParams.delete("page");
      setSearchParams(searchParams);
      setComputedCurrentPage(1);
      selectedFacets[field] = value;
    }

    if (value.length > 0) {
      searchParams.set(field, value);
    } else {
      searchParams.delete(field);
    }

    setSelectedFacets(selectedFacets);
    setSearchParams(searchParams);
    if (keyword !== null) {
      getTeacherSets(
        Object.assign(
          {
            keyword: keyword,
            grade_begin: grade_begin,
            grade_end: grade_end,
            sort_order: sortTitleValue,
            availability: availability,
            page: computedCurrentPage,
          },
          selectedFacets
        )
      );
    } else {
      getTeacherSets(
        Object.assign(
          {
            grade_begin: grade_begin,
            grade_end: grade_end,
            sort_order: sortTitleValue,
            availability: availability,
            page: computedCurrentPage,
          },
          selectedFacets
        )
      );
    }
  };

  const skeletonLoader = () => {
    if (noTsResultsFound === "" && teacherSets.length <= 0) {
      return (
        <SkeletonLoader
          className="teacher-set-skeleton-loader"
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
      );
    }
  };

  const closeTeacherSetTag = (value) => {
    if (value === "clearFilters") {
      setTeacherSetArr([]);
      searchParams.delete("language");
      searchParams.delete("area of study");
      searchParams.delete("set type");
      searchParams.delete("availability");
      searchParams.delete("subjects");
      searchParams.delete("grade_begin");
      searchParams.delete("grade_end");
      searchParams.delete("keyword");
      setSearchParams(searchParams);
      //const data = teacherSetArr.filter((element) => element.label !== value);
    } else {
      //const subjects = new URLSearchParams(location.search).get("subjects")
      //console.log(subjects)

      const data = teacherSetArr.filter((element) => element.label !== value);
      const deleteQueryParams = teacherSetArr
        .filter((element) => element.label === value)
        .flatMap(Object.keys);

      deleteQueryParams.map((item) => {
        if (item === "language") {
          searchParams.delete("language");
          setSearchParams(searchParams);
        } else if (item === "area of study") {
          searchParams.delete("area of study");
          setSearchParams(searchParams);
        } else if (item === "availability") {
          searchParams.delete("availability");
          setSearchParams(searchParams);
        } else if (item === "keyword") {
          searchParams.delete("keyword");
          setSearchParams(searchParams);
        } else if (item === "set type") {
          searchParams.delete("set type");
          setSearchParams(searchParams);
        } else if (item === "subjects") {
          const subjects = new URLSearchParams(location.search).get("subjects");
          const subArr = [];

          if (subjects !== null) {
            subjects.split(",").map((subId) => {
              if (
                tsSubjects[subId] !== undefined &&
                tsSubjects[subId] !== value
              ) {
                subArr.push(subId);
              }
            });

            searchParams.set("subjects", subArr);
            setSearchParams(searchParams);

            if (subjects.split(",").length === 1) {
              searchParams.delete("subjects");
              setSearchParams(searchParams);
            }
          }
        } else if (item === "grade_begin") {
          searchParams.delete("grade_begin");
          setSearchParams(searchParams);
          setGradeBegin(-1);
          setRangevalues([-1, grade_end]);
        } else if (item === "grade_end") {
          searchParams.delete("grade_end");
          setGradeEnd(12);
          setRangevalues([grade_begin, 12]);
          setSearchParams(searchParams);
        }
      });
      setTeacherSetArr(data);
    }
  };

  // const teacherSetFilterTags = () => {
  //   const subjects = new URLSearchParams(location.search).get("subjects");

  //   if (subjects !== null) {
  //     subjects.split(",").map((value) => {
  //       if (tsSubjects[value] !== undefined) {
  //         const subjectsHash = {};
  //         subjectsHash["label"] ||= tsSubjects[value];
  //         subjectsHash["subjects"] ||= [tsSubjects[value]];
  //         teacherSetArr.push(subjectsHash);
  //       }
  //     });
  //   }

    // teacherSetArr.map((value) => {
    //   //console.log(value["grade_begin"])

    //   if (
    //     value["grade_begin"] !== undefined ||
    //     value["grade_end"] !== undefined
    //   ) {
    //     if (value["grade_begin"] !== undefined) {
    //       const g_begin = value["label"];
    //     }

    //     if (value["grade_end"] !== undefined) {
    //       const g_end = value["label"];
    //     }
    //   }

    //   teacherSetArr.push(value);
    // });

    //console.log(teacherSetArr)

    let result = teacherSetArr.filter(
      (person, index) =>
        index ===
        teacherSetArr.findIndex((other) => person.label === other.label)
    );

    return (
      <TagSet
        id="tagSet-id-filter"
        isDismissible
        onClick={closeTeacherSetTag}
        tagSetData={result.filter((value) => Object.keys(value).length !== 0)}
        type="filter"
        marginBottom="m"
      />
    );
  };

  // This code is useful when tagSet enabled.
  // const tagSetsData = () => {
  //   const queryValue = new URLSearchParams(location.search);
  //   const areaOfStudy = queryValue.get("area of study");
  //   const availability = queryValue.get("availability");
  //   const language = queryValue.get("language");
  //   const keyword = queryValue.get("keyword");
  //   const subjects = queryValue.get("subjects");
  //   const setType = queryValue.get("set type");
  //   const gradeBegin = queryValue.get("grade_begin");
  //   const gradeEnd = queryValue.get("grade_end");

  //   if (
  //     areaOfStudy !== null ||
  //     availability !== null ||
  //     language !== null ||
  //     keyword !== null ||
  //     subjects !== null ||
  //     setType !== null ||
  //     gradeBegin !== null ||
  //     gradeEnd !== null
  //   ) {
  //     return (
  //       <VStack align="stretch">
  //         <div>
  //           <HorizontalRule align="left" marginTop="0px" />
  //         </div>
  //         <div>
  //           <HStack mb="s" data-testid="tagSetResultsDisplay">
  //             <span>Fiters Applied</span>
  //             {teacherSetFilterTags()}
  //           </HStack>
  //         </div>
  //         <div>
  //           <HorizontalRule align="left" className="paginationHR" />
  //         </div>
  //       </VStack>
  //     );
  //   }
  // };

  const tsDetails = () => {
    if (isLoading && teacherSetDataNotRetrievedMsg === "") {
      return (
        <SkeletonLoader
          className="teacher-set-details-skeleton-loader"
          contentSize={4}
          headingSize={2}
          imageAspectRatio="portrait"
          layout="row"
          showImage={false}
          width="900px"
        />
      );
    } else {
      return (
        <>
          <div id="teacher-set-results">{teacherSetDetails()}</div>
          <div style={{ display: displayPagination }}>
            <Flex alignItems="baseline">
              <ButtonGroup>
                <Button
                  id="teacher-sets-scroll-to-top"
                  buttonType="secondary"
                  className="backToTop"
                  onClick={() =>
                    window.scrollTo({
                      top: 10,
                      behavior: "smooth",
                    })
                  }
                >
                  Back to Top
                  <Icon
                    name="arrow"
                    iconRotation="rotate180"
                    size="small"
                    className="backToTopIcon"
                    align="right"
                  />
                </Button>
              </ButtonGroup>
              <Spacer />
              <div>
                <Pagination
                  id="ts-pagination"
                  onClick={() => window.scrollTo(0, 0)}
                  className="teacher_set_pagination"
                  onPageChange={onPageChange}
                  pageCount={totalPages}
                  initialPage={computedCurrentPage}
                  currentPage={computedCurrentPage}
                />
              </div>
            </Flex>
          </div>
        </>
      );
    }
  };

  const accordionDataScrolltoTop = () => {
    if (window.pageYOffset > 0) {
      window.scrollTo({ top: 428, behavior: "smooth" });
    } else {
      window.scrollTo({ top: 10, behavior: "smooth" });
    }
  };

  const displayAccordionData = (ts) => {
    const tsItems = ts.items;

    if (tsItems.length >= 1) {
      if (selectedFacets[ts.label] === undefined) {
        selectedFacets[ts.label] = [];
      }

      return (
        <CheckboxGroup
          isFullWidth
          id="ts-checkbox-group"
          isRequired={false}
          layout="column"
          name={ts.label}
          onChange={tsSelectedFacets.bind(this, ts.label)}
          value={selectedFacets[ts.label]}
          onClick={accordionDataScrolltoTop}
        >
          {tsItems.map((item, index) => (
            <Checkbox
              key={"ts-checkbox-key-" + index}
              id={"ts-checkbox-" + index}
              value={item["value"].toString()}
              //onChange={checkedValue(item["label"])}
              labelText={
                <Flex>
                  <span>{item["label"]}</span>
                  <Spacer />
                  <Text noSpace id={"ts-count-" + index} size="caption">
                    {item["count"] || 0}
                  </Text>
                </Flex>
              }
            />
          ))}
        </CheckboxGroup>
      );
    } else {
      // console.log(selectedFacets)
      // if (selectedFacets[ts.label] == "subjects") {
      //searchParams.delete("subjects");
      //setSearchParams(searchParams);
      // } else if (selectedFacets[ts.label] == "area of study") {

      //   searchParams.delete("area of study");
      //   setSearchParams(searchParams);
      // } else if (selectedFacets[ts.label] == "language") {
      //   searchParams.delete("language");
      //   setSearchParams(searchParams);
      // } else if (selectedFacets[ts.label] == "set type") {
      //   searchParams.delete("set type");
      //   setSearchParams(searchParams);
      // }

      return (
        <Text isItalic noSpace size="caption" id="accordion-no-results-found">
          No options available
        </Text>
      );
    }
  };

  const TeacherSetFacets = () => {
    return facets.map((ts, i) => {
      return (
        <Accordion
          key={"ts-facets-key-" + i}
          id={"ts-facets-accordian-" + i}
          backgroundColor="var(--nypl-colors-ui-white)"
          marginTop="m"
          panelMaxHeight="400px"
          accordionData={[
            {
              label: (
                <Text isCapitalized noSpace>
                  {ts.label}
                </Text>
              ),
              panel: displayAccordionData(ts),
            },
          ]}
          isDefaultOpen={isAccordionOpen(ts)}
        />
      );
    });
  };

  const isAccordionOpen = (ts) => {
    return selectedFacets[ts.label] && selectedFacets[ts.label].length > 0
      ? true
      : false;
  };

  const mobileSupport = () => {
    return isLargerThanMedium ? "block" : "none";
  };

  const clearSearchKeyword = () => {
    setKeyWord("");
    searchParams.delete("keyword");
    setSearchParams(searchParams);
  };

  // {tagSetsData()}

  const tsDataNotRetrievedMsg = () => {
    if (teacherSetDataNotRetrievedMsg !== "") {
      return (
        <Notification
          marginTop="l"
          icon={<Icon name="alertWarningFilled" color="ui.warning.primary" />}
          ariaLabel="SignOut Notification"
          id="sign-out-notification"
          notificationType="announcement"
          notificationContent={teacherSetDataNotRetrievedMsg}
        />
      );
    } else {
      return null;
    }
  };

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentTop={
        <>
          {<SignedInMsg signInDetails={props} />}
          <Heading
            id="search-and-find-teacher-sets-header"
            size="secondary"
            level="two"
            text="Search and Find Teacher Sets"
          />
          <HorizontalRule
            id="ts-horizontal-rule"
            className="teacherSetHorizontal"
          />
          <SearchBar
            id="ts-search"
            noBrandButtonType
            labelText="Teacher-Set SearchBar"
            onSubmit={(event) => handleSubmit(event)}
            textInputProps={{
              id: "search-teacher-set",
              labelText: "Enter a teacher set name",
              name: "TeacherSetInputName",
              onChange: handleSearchKeyword,
              placeholder: "Enter a teacher set name",
              value: keyword,
              isClearable: "true",
              isClearableCallback: clearSearchKeyword,
            }}
          />
          <div>{tsDataNotRetrievedMsg()}</div>
        </>
      }
      contentPrimary={
        <>
          <div style={{ display: mobileSupport() }}>
            <Flex alignItems="baseline">
              {resultsFoundMessage()}
              <Spacer />
              {teacherSetTitleOrder()}
            </Flex>
          </div>
          {tsDetails()}
        </>
      }
      contentSidebar={
        <>
          {skeletonLoader()}
          {RefineResults()}
        </>
      }
      sidebar="left"
    />
  );
}
