import React, { useState, useEffect, useRef } from "react";
import AppBreadcrumbs from "../AppBreadcrumbs";
import SignedInMsg from "../SignedInMsg";
import SignUpMsg from "../SignUp/SignUpMsg";
import axios from "axios";
import { titleCase } from "title-case";
import { capitalizeFirstLetter } from "../Utils/Utils";
import { renderInactiveSchoolMessage } from '../Utils/SchoolStatusMessage';

import {
  Button,
  ButtonGroup,
  SearchBar,
  Icon,
  HorizontalRule,
  Heading,
  Card,
  CardHeading,
  CardContent,
  CardActions,
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
  Banner,
  useColorModeValue,
  useColorMode,
  VStack,
  HStack,
  Menu,
  FilterBarInline,
  MultiSelect,
  useMultiSelect,
  MultiSelectGroup,
} from "@nypl/design-system-react-components";

import {
  Link as ReactRouterLink,
  useSearchParams,
  useLocation,
} from "react-router-dom";

export default function SearchTeacherSets(props) {
  const [searchParams, setSearchParams] = useSearchParams();
  const queryParams = [];
  const searchResultsTextRef = useRef(null)

  for (let entry of searchParams.entries()) {
    const queryParamsHash = {};
    queryParamsHash[entry[0]] = entry[1];
    queryParams.push(queryParamsHash);
  }

  const facetBoxColor = useColorModeValue(
    "var(--nypl-colors-ui-gray-x-light-cool)",
    "var(--nypl-colors-dark-ui-bg-page)"
  );

  const { colorMode } = useColorMode();
  const [teacherSets, setTeacherSets] = useState([]);
  const [facets, setFacets] = useState([]);
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
  const { isLargerThanMedium, isLargerThanMobile } = useNYPLBreakpoints();
  const [rangeValues, setRangevalues] = useState([-1, 12]);
  const [isLoading, setIsLoading] = useState(true);
  const [tsSubjects, setTsSubjects] = useState({});
  const [resetPageNumber, setResetPageNumber] = useState("");
  const [teacherSetDataNotRetrievedMsg, setTeacherSetDataNotRetrievedMsg] =
    useState("");
  const [showKeyword, setShowKeyWord] = useState(false);
  const [updateKeyword, setUpdateKeyword] = useState("");
  const location = useLocation();
  const [isSchoolActive, setIsSchoolActive] = useState("");
  const [selectedSortOption, setSelectedSortOption] = useState("Newest to oldest");
  const [firstSelectedItem, setFirstSelectedItem] = useState({});
  const [isDefaultOpen, setIsDefaultOpen] = useState(false);

  const { onChange, onMixedStateChange, selectedItems, onClear, onClearAll, setSelectedItems } =
    useMultiSelect();

  const tagSetDetails = (label) => ({ label, id: label.toLowerCase() });

  useEffect(() => {
    let newSelectedItems = { ...selectedItems }; // Clone to avoid mutation
    let hasChanges = false; // Track if changes occur

    if (getSelectedCategoriesCount(selectedItems) > 0) {
      tsSelectedFacets(selectedItems, availability);
    } else {
      let availability_val = "";

      queryParams.forEach((ts) => {
        Object.keys(ts).forEach((key) => {
          if (ts[key]) {
            if (key === "availability") {
              setAvailability([ts[key]]);
              availability_val = [ts[key]];
              setAvailableToggle(true);
            } else {
              newSelectedItems[key] = newSelectedItems[key] || { items: [] };

              // Toggle selection (remove if exists, add if not)
              const valuesArray = ts[key].split(",");
              const prevLength = newSelectedItems[key]["items"].length;
              newSelectedItems[key]["items"] = newSelectedItems[key]["items"].filter(
                (item) => !valuesArray.includes(item)
              );

              // If items are empty, remove the facet
              if (newSelectedItems[key]["items"].length === 0) {
                delete newSelectedItems[key];
              }

              // Check if change happened
              if (prevLength !== newSelectedItems && newSelectedItems[key] && newSelectedItems[key]["items"].length) {
                hasChanges = true;
              }
            }
          }
        });
      });

      tsSelectedFacets(newSelectedItems, availability_val);
    }

    if (getSelectedCategoriesCount(newSelectedItems) > 0) {
      setIsDefaultOpen(true);
    }

    // Only update state if changes happened
    if (hasChanges) {
      setSelectedItems(newSelectedItems);
    }

  }, [selectedItems, location.search]); // Keep dependencies as needed


  useEffect(() => {
    document.title = "Search Teacher Sets | MyLibraryNYC";
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

  // useEffect(() => {
  //   const queryValue = new URLSearchParams(location.search);
  //   const tsfacets = {};
  //   const tagSetsDataArr = [];
  //   const selectedItemsData = {}
  //   setTsSubjects({});
  //   queryParams.map((ts) => {
  //     const tagSets = {};
  //     if (ts.subjects) {
  //       tsfacets["subjects"] = ts.subjects.split(",");
  //       selectedItemsData['subjects']['items'] = ts.subjects.split(",");
  //       ts.subjects.split(",").map((value) => {
  //         if (tsSubjects[value] !== undefined) {
  //           const subjectsHash = {};
  //           subjectsHash["label"] = tsSubjects[value];
  //           subjectsHash["subjects"] = [tsSubjects[value]];
  //           tagSetsDataArr.push(subjectsHash);
  //         }
  //       });
  //     } else if (ts["area of study"]) {
  //       selectedItemsData['area of study']['items'] = ts["area of study"].split(",");
  //       tsfacets["area of study"] = ts["area of study"].split(",");
  //       tagSets["label"] = ts["area of study"];
  //       tagSets["area of study"] = [ts["area of study"]];
  //     } 
  //     else if (ts["set type"]) {
  //       selectedItemsData['set type']['items'] = ts["set type"].split(",");
  //       tsfacets["set type"] = ts["set type"].split(",");
  //       tagSets["label"] = ts["set type"];
  //       tagSets["set type"] = [ts["set type"]];
  //     } else if (ts["availability"]) {
  //       selectedItemsData['availability']['items'] = ts["availability"].split(",");
  //       setAvailableToggle(true);
  //       tsfacets["availability"] = [ts["availability"]];
  //       // DON'T SHOW IN TAGSET FOR A WHILE
  //       // tagSets["label"] = "Available Now";
  //       // tagSets["availability"] = [ts["availability"]];
  //     } else if (ts["language"]) {
  //       selectedItemsData['language']['items'] = ts["language"].split(",");
  //       tsfacets["language"] = ts["language"].split(",");
  //       tagSets["label"] = ts["language"];
  //       tagSets["language"] = [ts["language"]];
  //     }

  //     // // else if (ts.keyword) {
  //     // //   tagSets["label"] = ts["keyword"];
  //     // //   tagSets["keyword"] = [ts["language"]];
  //     // // }
  //     // tagSetsDataArr.push(tagSets);
  //    //console.log(tsfacets)
  //   });

  //   let keywordValue;
  //   if (queryValue.get("keyword")) {
  //     keywordValue = queryValue.get("keyword");
  //     setUpdateKeyword(keywordValue);
  //     setShowKeyWord(true);
  //   } else {
  //     keywordValue = "";
  //   }
  //   const g_begin = queryValue.get("grade_begin")
  //     ? queryValue.get("grade_begin")
  //     : -1;
  //   const g_end = queryValue.get("grade_end")
  //     ? queryValue.get("grade_end")
  //     : 12;
  //   const availabilityval = queryValue.get("availability")
  //     ? [queryValue.get("availability")]
  //     : [];
  //   const availableToggleVal = queryValue.get("availability") ? true : false;
  //   const sortOrderVal = queryValue.get("sort_order")
  //     ? queryValue.get("sort_order")
  //     : "";
  //   const pageNumber = queryValue.get("page")
  //     ? parseInt(queryValue.get("page"))
  //     : 1;
  //   // FOR A WHILE DONT SHOW IN TAGSET
  //   // if (queryValue.get("grade_begin") && queryValue.get("grade_end")) {
  //   //   const tagSetGradeBegin =
  //   //     parseInt(g_begin) === -1
  //   //       ? "Pre-K"
  //   //       : parseInt(g_begin) === 0
  //   //       ? "K"
  //   //       : parseInt(g_begin);

  //   //   const tagSetGradeEnd =
  //   //     parseInt(g_end) === -1
  //   //       ? "Pre-K"
  //   //       : parseInt(g_end) === 0
  //   //       ? "K"
  //   //       : parseInt(g_end);

  //   //   const tagSetGrades = {
  //   //     label: "Grades " + tagSetGradeBegin + " to " + tagSetGradeEnd,
  //   //     grade_begin: [queryValue.get("grade_begin")],
  //   //     grade_end: [queryValue.get("grade_end")],
  //   //   };

  //   //   tagSetsArr.push(tagSetGrades);
  //   // }
  //   setSelectedFacets(tsfacets);
  //   setGrades(queryValue.get("grade_begin"), queryValue.get("grade_end"));
  //   setKeyWord(keywordValue);
  //   setAvailability(availabilityval);
  //   setAvailableToggle(availableToggleVal);
  //   setSortTitleValue(sortOrderVal);
  //   setComputedCurrentPage(pageNumber);
  //   //setTeacherSetArr(tagSetsDataArr);

  //   getTeacherSets(
  //     Object.assign(
  //       {
  //         keyword: keywordValue,
  //         grade_begin: g_begin,
  //         grade_end: g_end,
  //         sort_order: sortOrderVal,
  //         availability: availabilityval,
  //         page: pageNumber,
  //         firstFacetSelectedItem: Object.keys(tsfacets)[0],
  //         selectedItemCount: getSelectedCategoriesCount(tsfacets)
  //       },
  //       tsfacets
  //     )
  //   );
  // }, [location.search]);

  const getTeacherSets = (params) => {
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
        setIsSchoolActive(res.data.is_school_active)
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
    searchResultsTextRef.current.focus();
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
    setShowKeyWord(true);
    setUpdateKeyword(keyword)
  };

  const handleSearchKeyword = (event) => {
    setKeyWord(event.target.value);
    if (event.target.value === "") {
      setKeyWord("");
      searchParams.delete("keyword");
      searchParams.delete("page");
      setUpdateKeyword("");
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

  /**
   * Generates a message based on the number of search results found.
   * This function should be called after performing a search operation
   * and can be used to dynamically update the UI with appropriate feedback
   * to the user regarding the search outcome.
   */
  const resultsFoundMessage = () => {
    const searchKeyword =
      updateKeyword !== null && updateKeyword !== "" ? ` for "${updateKeyword}"` : "";
    const appendKeyword = showKeyword ? searchKeyword : ""

    if (noTsResultsFound !== "" && tsTotalCount === 0) {
      return (
        <Heading
          id="no-results-found-id"
          marginBottom="s"
          style={{ fontStyle: "italic" }}
          level="h3"
          size="heading6"
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
        <Heading
          id="ts-result-found-id"
          aria-live="polite"
          ref={searchResultsTextRef}
          tabIndex={-1}
          size="heading6"
          marginBottom="m"
        >
          {"Showing " +
            test +
            "-" +
            perPageNumbers +
            " of " +
            tsTotalCount +
            " result" +
            appendKeyword}
        </Heading>
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
        <Heading
          id="ts-results-found-id"
          aria-live="polite"
          ref={searchResultsTextRef}
          tabIndex={-1}
          size="heading6"
          marginBottom="m"
        >
          {"Showing " +
            fromResults +
            "-" +
            toresults +
            " of " +
            tsTotalCount +
            " results" +
            appendKeyword}
        </Heading>
      );
    }
  };

  const teacherSetTitleOrder = () => {
    if (teacherSets.length >= 1) {
      return (
        <Menu
          id='menu-button-ts-sort-by-menu'
          labelText={selectedSortOption !== "" ? `Sort by: ${selectedSortOption}` : 'Sort by'}
          listAlignment="left"
          showBorder
          selectedItem='sort-by-item-title-1'
          showLabel={true}
          listItemsData={[
            {
              id: 'sort-by-item-title-1',
              label: "Newest to oldest",
              onClick: () => sortTeacherSetTitle("Newest to oldest", 0),
              type: 'action'
            },
            {
              id: 'sort-by-item-title-2',
              label: "Oldest to newest",
              onClick: () => sortTeacherSetTitle("Oldest to newest", 1),
              type: 'action'
            },
            {
              id: 'sort-by-item-title-3',
              label: "Title A-Z",
              onClick: () => sortTeacherSetTitle("Title A-Z", 2),
              type: 'action'
            },
            {
              id: 'sort-by-item-title-4',
              label: "Title Z-A",
              onClick: () => sortTeacherSetTitle("Title Z-A", 3),
              type: 'action'
            }
          ]}
        />
      );
    }
  };

  const teacherSetAvailability = (ts) => {
    if (ts.availability !== undefined) {
      return (
        <StatusBadge type={availabilityStatusBadge(ts)}>
          {titleCase(ts.availability)}
        </StatusBadge>
      );
    } else {
      return null;
    }
  };

  const availabilityStatusBadge = (ts) => {
    return ts.availability === "available" ? "informative" : "neutral";
  };

  const displayAvailableCopies = (ts) => {
    const copyLabel = ts.total_copies > 1 ? "copies" : "copy";
    return ts.total_copies ? (
      <>
        {availableCopies(ts)} of {totalCopies(ts)} {copyLabel} available
      </>
    ) : (
      <></>
    );
  };

  const availableCopies = (ts) => {
    if (ts.available_copies !== undefined) {
      return ts.available_copies;
    } else {
      return "";
    }
  };

  const totalCopies = (ts) => {
    if (ts.total_copies !== undefined) {
      return ts.total_copies;
    } else {
      return "";
    }
  };

  const teacherSetDetails = () => {
    const availabilityStatusStyle = isLargerThanMedium ? "end" : "";

    if (teacherSets.length >= 0) {
      return teacherSets.map((ts, i) => {
        return (
          <div
            key={"teacher-set-results-key-" + i}
            id={"teacher-set-results-" + i}
          >
            <Card
              id={"ts-details-" + i}
              isAlignedRightActions
              layout="row"
              marginBottom="m"
            >
              <CardHeading
                level="h3"
                size="heading5"
                id={"ts-order-details-" + i}
                overline={ts.suitabilities_string}
                subtitle={displayAvailableCopies(ts)}
              >
                <ReactRouterLink
                  to={"/teacher_set_details/" + ts.id}
                  onClick={() => window.scrollTo(0, 0)}
                  style={{ "text-decoration": "none", "font-size": "22px" }}
                >
                  {ts.title}
                </ReactRouterLink>
              </CardHeading>
              <CardContent id={"ts-description-" + i}>
                {ts.description}
              </CardContent>
              <CardActions id={"ts-availability-" + i} marginTop="m" justifyContent={isLargerThanMedium ? "end" : "start"}>
                {teacherSetAvailability(ts)}
              </CardActions>
            </Card>
            <HorizontalRule
              marginTop="m"
              marginBottom="m"
              id={"ts-horizontal-rule-" + i}
              align="left"
              className={`${colorMode} tsDetailHorizontalLine`}
            />
          </div>
        );
      });
    } else {
      return <></>;
    }
  };

  const onPageChange = (page) => {
    searchResultsTextRef.current.focus();
    setComputedCurrentPage(page);
    searchParams.set("page", page);
    setSearchParams(searchParams);
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
    windowScroll();
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

  const windowScroll = () => {
    if (window.scrollY <= 10) {
      window.scrollTo({ top: 10, behavior: "smooth" });
    } else {
      window.scrollTo({ top: 400, behavior: "smooth" });
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
      if (window.scrollY <= 10) {
        window.scrollTo(10, 10);
      } else {
        window.scrollTo(400, 400);
      }
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


  const filterBarMultiSelect = () => {
    return (
      <FilterBarInline
        heading="Refine Results"
        layout="column"
        // bg={sidebarBg}
        // border={sidebarBorder}
        // borderColor={sidebarBorderColor}
        onClear={clearFilters}
        selectedItems={selectedItems}
        renderChildren={renderFilterComponents}
        display={{ base: "none", md: "block" }}
        padding="xs"
      />
    )
  }

  const renderFilterComponents = () => {
    return (
      <MultiSelectGroup
        id="multiselect-group"
        labelText=""
        layout="column"
        renderMultiSelect={renderMultiSelect.bind(this)}
      />
    );
  };

  const tsLabel = (ts) => {
    return ts.label === "area of study"
      ? "Area of Study"
      : ts.label.replace(
        /\w\S*/g,
        (txt) =>
          txt.charAt(0).toUpperCase() + txt.slice(1).toLowerCase()
      )
  }

  const formattedItems = (items) => {
    return items.map(item => {
      return {
        id: String(item.value),
        name: item.label,
        isDisabled: item.count > 0 ? false : true,
        itemCount: item.count,
      };
    });
  };

  const renderMultiSelect = () => {
    if (!facets || facets.length === 0) return null;

    return facets.map((ts, i) => (
      <MultiSelect
        buttonText={tsLabel(ts)}
        key={`ts-facets-key-${i}`}
        id={ts.label}
        items={formattedItems(ts.items)}
        isBlockElement
        onChange={(e) => onChangeMultiSelect(e.target.id, ts.label)}
        onMixedStateChange={(e) => {
          onMixedStateChange(e.target.id, id, formattedItems(ts.items));
        }}
        onClear={() => onClearItems(ts.label)}
        selectedItems={selectedItems}
        width="full"
        listOverflow="expand"
        isDefaultOpen={isDefaultOpen}
      />
    ));
  };

  const onClearItems = (label) => {
    onClear(label);
    if (label === "area of study") {
      selectedFacets["area of study"] = [];
      searchParams.delete("area of study");
    } else if (label === "set type") {
      selectedFacets["set type"] = [];
      searchParams.delete("set type");
    } else if (label === "subjects") {
      searchParams.delete("subjects");
      selectedFacets["subjects"] = [];
    } else if (label === "language") {
      selectedFacets["language"] = [];
      searchParams.delete("language");
    }
    setSelectedFacets(selectedFacets);
    const params = {
      ...selectedFacets,  // Add selected facets to the params
      keyword: keyword,
      grade_begin: -1,
      grade_end: 12,
      sort_order: sortTitleValue,
      availability: availability,
      page: computedCurrentPage,
      firstFacetSelectedItem: Object.keys(selectedItems)[0],
      selectedItemCount: getSelectedCategoriesCount(selectedItems),
    };

    // // Make the API call with the updated params
    getTeacherSets(params);
  }

  // const RefineResults = () => {
  //   if (facets && facets.length >= 1) {
  //     if (isLargerThanMedium) {
  //       return <div>{teacherSetSideBarResults()}</div>;
  //     } else {
  //       return (
  //         <>
  //           {resultsFoundMessage()}
  //           <Accordion
  //             backgroundColor="var(--nypl-colors-ui-white)"
  //             marginTop="m"
  //             id="mobile-ts-facet-label"
  //             accordionData={[
  //               {
  //                 label: (
  //                   <Text isCapitalized noSpace>
  //                     Refine results
  //                   </Text>
  //                 ),
  //                 panel: <div>{teacherSetSideBarResults()}</div>,
  //               },
  //             ]}
  //           />
  //         </>
  //       );
  //     }
  //   } else {
  //     return null;
  //   }
  // };

  const tsRefineResultsHeading = () => {
    if (isLargerThanMedium) {
      return (
        <Heading
          id="refine-results"
          size="heading5"
          level="h3"
          text={" " + "Refine results" + " "}
        />
      );
    }
  };

  const clearFilters = () => {
    onClearAll();
    searchResultsTextRef.current.focus();
    searchParams.delete("language");
    searchParams.delete("area of study");
    searchParams.delete("set type");
    searchParams.delete("subjects");
    searchParams.delete("availability");
    searchParams.delete("grade_begin");
    searchParams.delete("grade_end");
    searchParams.delete("keyword");
    setGradeBegin(-1);
    setGradeEnd(12);
    setRangevalues([-1, 12]);
    windowScroll();
    setAvailability("");
    setSelectedFacets({})
    setKeyWord("")
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
  };

  const clearFiltersButton = () => {
    const clearFilteMargin = isLargerThanMobile ? "xl" : "84px";
    const disableClearFilterButton = !(
      (selectedFacets["area of study"] &&
        selectedFacets["area of study"].length > 0) ||
      (selectedFacets["language"] && selectedFacets["language"].length > 0) ||
      (selectedFacets["set type"] && selectedFacets["set type"].length > 0) ||
      (selectedFacets["subjects"] && selectedFacets["subjects"].length > 0)
    );

    if (isLargerThanMedium) {
      return (
        <div>
          <Button
            buttonType="text"
            id="clear-filters-button-id"
            size="medium"
            type="button"
            marginTop="xs"
            marginLeft={clearFilteMargin}
            onClick={clearFilters}
            isDisabled={disableClearFilterButton}
          >
            Clear Filters
          </Button>
        </div>
      );
    }
  };

  const teacherSetSideBarResults = () => {
    const bgColor = isLargerThanMedium ? facetBoxColor : "";
    return (
      <Box
        id="ts-all-facets"
        bg={bgColor}
        padding="var(--nypl-space-s)"
        className={`${colorMode} tsFacetsBorderColor`}
      >
        <div>{tsRefineResultsHeading()}</div>
        <Toggle
          id="toggle"
          isChecked={availableToggle}
          labelText="Available now"
          onChange={availableResults}
          size="small"
          marginBottom="m"
        />
        <div>{TeacherSetGradesSlider()}</div>
        <Heading
          id="facet-filters"
          size="heading6"
          marginBottom="xs"
          fontSize={{
            base: "mobile.subtitle.subtitle1",
            md: "desktop.subtitle.subtitle1",
          }}
          level="h4"
          text="Filters"
        />
        <div>{filterBarMultiSelect()}</div>
        {/* {clearFiltersButton()} */}
      </Box>
    );
  };


  const sortTeacherSetTitle = (sortOption = "Newest to oldest", value = 0) => {
    searchParams.set("sort_order", [value]);
    setSearchParams(searchParams);
    setSortTitleValue(value);
    setSelectedSortOption(sortOption);
    getTeacherSets(
      Object.assign(
        {
          keyword: keyword,
          grade_begin: grade_begin,
          grade_end: grade_end,
          sort_order: value,
          availability: availability,
          page: computedCurrentPage,
        },
        selectedFacets
      )
    );
  };

  const getSelectedCategoriesCount = (selected_items) => {
    return Object.values(selected_items).filter(category =>
      Array.isArray(category.items) && category.items.length > 0
    ).length;
  };

  const onChangeMultiSelect = (id, category) => {
    onChange(id, category)
  }

  // useEffect(() => {
  //   console.log("iii");
  //   console.log(selectedFacets["area of study"]);

  //   let newSearchParams = new URLSearchParams(searchParams); // Create a new instance

  //   if (selectedFacets["area of study"]) {
  //     newSearchParams.set("area of study", selectedFacets["area of study"]);
  //   } else {
  //     newSearchParams.delete("area of study"); // Remove if unchecked
  //   }

  //   if (selectedFacets["set type"]) {
  //     newSearchParams.set("set type", selectedFacets["set type"]);
  //   } else {
  //     newSearchParams.delete("set type");
  //   }

  //   if (selectedFacets["subjects"]) {
  //     selectedFacets["subjects"] = []; // ⚠️ Avoid direct state mutation
  //   }

  //   if (selectedFacets["language"]) {
  //     newSearchParams.set("language", selectedFacets["language"]);
  //   } else {
  //     newSearchParams.delete("language");
  //   }

  //   setSearchParams(newSearchParams); // Update state with the new object
  // }, [selectedFacets, location.search]);


  const tsSelectedFacets = (selected_items, availability_val = "") => {

    const queryValue = new URLSearchParams(location.search);
    let keywordValue;

    if (queryValue.get("keyword")) {
      keywordValue = queryValue.get("keyword");
      setUpdateKeyword(keywordValue);
      setShowKeyWord(true);
    } else {
      keywordValue = "";
    }
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
    setFirstSelectedItem(Object.keys(selected_items)[0])
    // Initialize selectedFacetItems to either selected_items or an empty object
    const selectedFacetItems = selected_items ? { ...selected_items } : {};

    // Clear page parameter before making any updates
    searchParams.delete("page");
    setComputedCurrentPage(1);

    // Iterate over selected_items in the same order
    Object.keys(selected_items).forEach((facet) => {
      const facetItems = selected_items[facet]['items'];
      // Handle each facet based on its existence and items
      if (facetItems && facetItems.length > 0) {
        searchParams.set(facet, facetItems);
        facetItems.forEach((value) => {
          teacherSetArr.push(tagSetDetails(value));
        });
        selectedFacetItems[facet] = [...new Set([...facetItems])];
      } else {
        searchParams.delete(facet);
        selectedFacetItems[facet] = [];
      }
    });

    if (availability_val.length > 0) {
      availability_val.map((value) => {
        teacherSetArr.push(tagSetDetails('Available Now'));
      });
      searchParams.set("availability", availability_val);
      setAvailability(availability_val)
    } else {
      searchParams.delete("availability");
      setAvailability("")
    }


    // Update the search params and selected facets state
    setSearchParams(searchParams);
    setSelectedFacets(selectedFacetItems);
    setGrades(g_begin, g_end);
    setKeyWord(keywordValue);
    setAvailability(availabilityval);
    setAvailableToggle(availableToggleVal);
    setSortTitleValue(sortOrderVal);
    setComputedCurrentPage(pageNumber);
    setTeacherSetArr(teacherSetArr);

    // Prepare the parameters for the API call
    const params = {
      ...selectedFacetItems,  // Add selected facets to the params
      keyword: keyword,
      grade_begin: grade_begin,
      grade_end: grade_end,
      sort_order: sortTitleValue,
      availability: availability_val,
      page: computedCurrentPage,
      firstFacetSelectedItem: Object.keys(selected_items)[0],
      selectedItemCount: getSelectedCategoriesCount(selectedItems),
    };

    if (selected_items['subjects'] && selected_items['subjects']['items'].length > 0) {
      selected_items['subjects']['items'].map((value) => {
        teacherSetArr.push(tagSetDetails(tsSubjects[value]));
      });
    }
    // Make the API call with the updated params
    getTeacherSets(params);
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

  const closeTeacherSetTag = (tagSet) => {
    searchResultsTextRef.current.focus();

    if (tagSet.id === "clear-filters") {
      onClearAll();
      setAvailability("");
      setRangevalues([-1, 12]);
    } else if (tagSet.label === "Available now") {
      setAvailability("");
    } else {
      let updatedCategory = "";
      let updatedFilters = [];
      for (const category in selectedFacets) {
        if (selectedFacets[category].includes(tagSet.label)) {
          updatedCategory = category;
          updatedFilters = selectedFacets[category].filter(
            (filter) => filter !== tagSet.label
          );
        }
      }
      const updatedSelectedItems = {
        ...selectedFacets,
        [updatedCategory]: { items: updatedFilters },
      };
      setSelectedItems(updatedSelectedItems);
    }

    const data = teacherSetArr.filter(
      (element) => element.label !== tagSet.label
    );

    const deleteQueryParams = teacherSetArr
      .filter((element) => element.label === tagSet.label)
      .flatMap(Object.keys);

    deleteQueryParams.map((item) => {
      if (item === "language") {
        searchParams.delete("language");
        setSearchParams(searchParams);
        onClearItems("language")
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
              tsSubjects[subId] !== tagSet.label
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
  };

  const teacherSetFilterTags = () => {
    // const subjects = new URLSearchParams(location.search).get("subjects");
    // if (subjects !== null) {
    //   subjects.split(",").map((value) => {
    //     if (tsSubjects[value] !== undefined) {
    //       const subjectsHash = {};
    //       subjectsHash["label"] ||= tsSubjects[value];
    //       subjectsHash["subjects"] ||= [tsSubjects[value]];
    //       teacherSetArr.push(subjectsHash);
    //     }
    //   });
    // }

    // teacherSetArr.map((value) => {
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

    // let result = teacherSetArr.filter(
    //   (tset, index) =>
    //     index === teacherSetArr.findIndex((other) => tset.label === other.label)
    // );

    return (
      <TagSet
        id="tagSet-id-filter"
        isDismissible
        onClick={closeTeacherSetTag}
        tagSetData={Array.from(
          new Map(teacherSetArr
            .filter((value) => Object.keys(value).length !== 0) // Remove empty objects
            .map(obj => [JSON.stringify(obj), obj]) // Convert objects to strings for uniqueness
          ).values()
        )}
        type="filter"
      />
    );
  };

  const tagSetsData = () => {
    const queryValue = new URLSearchParams(location.search);
    const areaOfStudy = queryValue.get("area of study");
    const language = queryValue.get("language");
    const subjects = queryValue.get("subjects");
    const setType = queryValue.get("set type");
    // DON'T SHOW IN TAGSET FOR A WHILE
    // const keyword = queryValue.get("keyword");
    // const availability = queryValue.get("availability");
    // const gradeBegin = queryValue.get("grade_begin");
    // const gradeEnd = queryValue.get("grade_end");

    if (
      // gradeBegin !== null ||
      // gradeEnd !== null
      // availability !== null ||
      // keyword !== null ||
      areaOfStudy !== null ||
      language !== null ||
      subjects !== null ||
      setType !== null
    ) {
      return (
        <VStack align="stretch">
          <div>
            <HorizontalRule align="left" marginTop="0px" marginBottom="xs" />
          </div>
          <div>
            <HStack
              data-testid="tagSetResultsDisplay"
              gap="1rem"
              marginBottom="xs"
            >
              <span>Filters applied</span>
              {teacherSetFilterTags()}
            </HStack>
          </div>
          <div>
            <HorizontalRule align="left" marginTop="0px" />
          </div>
        </VStack>
      );
    }
  };

  const tsDetails = () => {
    if (isLoading && teacherSetDataNotRetrievedMsg === "") {
      return (
        <>
          <SkeletonLoader
            className="teacher-set-details-skeleton-loader-1"
            contentSize={4}
            headingSize={2}
            imageAspectRatio="portrait"
            layout="row"
            showContent
            showImage={false}
            isBordered={false}
            marginTop="m"
          />
          <SkeletonLoader
            className="teacher-set-details-skeleton-loader-2"
            contentSize={4}
            headingSize={2}
            imageAspectRatio="portrait"
            layout="row"
            showContent
            showImage={false}
            isBordered={false}
            marginTop="l"
          />
          <SkeletonLoader
            className="teacher-set-details-skeleton-loader-3"
            contentSize={4}
            headingSize={2}
            imageAspectRatio="portrait"
            layout="row"
            showContent
            showImage={false}
            isBordered={false}
            marginTop="l"
          />
        </>
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
                  buttonType="text"
                  className="backToTop"
                  onClick={() =>
                    window.scrollTo({
                      top: 10,
                      behavior: "smooth",
                    })
                  }
                >
                  Back to top
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

  const TeacherSetFacets1 = () => {
    return facets.map((ts, i) => {
      return (
        <Accordion
          key={"ts-facets-key-" + i}
          id={"ts-facets-accordian-" + i}
          backgroundColor="var(--nypl-colors-ui-white)"
          marginTop="xs"
          panelMaxHeight="400px"
          accordionData={[
            {
              label: (
                <Text size="default" noSpace>
                  {capitalizeFirstLetter(ts.label)}
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
    setShowKeyWord(false);
    searchParams.delete("keyword");
    setSearchParams(searchParams);
  };

  const tsDataNotRetrievedMsg = () => {
    if (teacherSetDataNotRetrievedMsg !== "") {
      return (
        <Banner
          marginTop="l"
          id="sign-up-notification"
          ariaLabel="Teacher sets not found"
          content={teacherSetDataNotRetrievedMsg}
          type="warning"
        />
      );
    } else {
      return null;
    }
  };

  const formatNumberRange = (num1, num2) => {
    // Helper function to format a number with commas
    const formatNumber = (num) => {
      return num.toLocaleString(); // Formats the number with commas (e.g., 4382 -> "4,382")
    };

    // Case 1: Only one number is provided
    if (num2 === undefined) {
      return formatNumber(num1); // Simply return the formatted number
    }

    // Case 2: Two numbers are provided, create a range
    const [start, end] = num1 < num2 ? [num1, num2] : [num2, num1]; // Ensure start is smaller

    // If the numbers are the same, return one formatted number
    if (start === end) {
      return formatNumber(start);
    }

    // If the range is between two consecutive numbers, display both
    if (end - start === 1) {
      return `${formatNumber(start)}&ndash;${formatNumber(end)}`;  // Correct string return
    }

    // For a larger range, simply return the full formatted range with commas
    return `${formatNumber(start)}&ndash;${formatNumber(end)}`;
  };

  const formattedRange = formatNumberRange(10, 100);
  const htmlContent = `Audio Player helper text. ${formattedRange}`;

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentTop={
        <>
          {<SignedInMsg signInDetails={props} />}
          {<SignUpMsg signUpDetails={props} />}
          {renderInactiveSchoolMessage(isSchoolActive)}
          <Heading
            id="search-and-find-teacher-sets-header"
            size="heading3"
            level="h2"
            text="Search and find Teacher Sets"
            marginTop="l"
          />
          <HorizontalRule
            id="ts-horizontal-rule"
            className={`${colorMode} teacherSetHorizontal`}
          />
          <SearchBar
            id="ts-search"
            noBrandButtonType
            labelText="Teacher-Set SearchBar"
            onSubmit={(event) => handleSubmit(event)}
            textInputProps={{
              id: "search-teacher-set",
              labelText: "Enter search terms",
              name: "TeacherSetInputName",
              onChange: handleSearchKeyword,
              placeholder: "Enter search terms",
              value: keyword,
              isClearable: "true",
              isClearableCallback: clearSearchKeyword,
            }}
          />
          <span dangerouslySetInnerHTML={{ "__html": htmlContent }} />

          <div>{tsDataNotRetrievedMsg()}</div>
        </>
      }
      contentPrimary={
        <>
          {tagSetsData()}
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
          {teacherSetSideBarResults()}
        </>
      }
      sidebar="left"
    />
  );
}