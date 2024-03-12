import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./../AppBreadcrumbs";
import HaveQuestions from "./../HaveQuestions/HaveQuestions";
import SignedInMsg from "./../SignedInMsg";
import axios from "axios";
import {
  TextInput,
  List,
  TemplateAppContainer,
  Text,
  Heading,
  HorizontalRule,
  Link,
  SkeletonLoader,
  Icon,
  Button,
  useColorMode,
} from "@nypl/design-system-react-components";

export default function ParticipatingSchools(props) {
  const [schools, setSchools] = useState([]);
  const [search_school, setSearchSchool] = useState("");
  const [anchor_tags, setAnchorTags] = useState([]);
  const [schoolNotFound, setSchoolNotFound] = useState("");
  const { colorMode } = useColorMode();

  useEffect(() => {
    document.title = "Participating Schools | MyLibraryNYC";
    if (env.RAILS_ENV !== "test") {
      window.scrollTo(0, 0);
    }
    axios
      .get("/schools")
      .then((res) => {
        setSchools(res.data.schools);
        setAnchorTags(res.data.anchor_tags);
        setSchoolNotFound(res.data.school_not_found);
      })
      .catch(function (error) {
        console.log(error);
      });
  }, []);

  const AnchorTags = () => {
    let school_anchors = schools.map((school) => {
      return school["alphabet_anchor"];
    });

    return anchor_tags.map((anchor, index) => {
      if (school_anchors.includes(anchor)) {
        return (
          <Link
            id={"ps-school-link-id-" + index}
            key={"ps-school-link-key-" + index}
            marginRight="xs"
            style={{ textDecoration: "none" }}
            fontWeight="bold"
            href={"#" + anchor}
          >
            {" "}
            {anchor}{" "}
          </Link>
        );
      } else {
        if (anchor !== "#") {
          return (
            <span
              key={"ps-school-link-key-" + index}
              style={{
                textDecoration: "none",
                fontWeight: "bold",
                color: "var(--nypl-colors-ui-gray-medium)",
                marginRight: "8px",
              }}
            >
              {anchor}
            </span>
          );
        }
      }
    });
  };

  const schoolSkeletonLoader = () => {
    if (schoolNotFound === "" && schools.length <= 0) {
      return (
        <SkeletonLoader
          marginTop="s"
          layout="row"
          showImage={false}
          showContent={5}
          contentSize={4}
          showHeading={1}
          key="not-found-key"
        />
      );
    }
  };

  const Schools = () => {
    let schoolsCount = 0;

    let schoolsData = schools.map((data, i) => {
      let filteredSchools = [];
      data["school_names"].filter((school) => {
        let value = search_school.trim().toLowerCase();

        if (school.toLowerCase().indexOf(value) > -1) {
          schoolsCount++;
          filteredSchools.push(school)
        }
      });
      
      if (filteredSchools.length > 0) {
        return (
          <div key={"participating-schools-list-div-key-" + data["alphabet_anchor"] + '-' + i}>
            <List
              key={"participating-schools-list-key-" + data["alphabet_anchor"] + '-' + i}
              id={"participating-schools-list-" + data["alphabet_anchor"] + '-' + i}
              noStyling
            >
              <li
                id={"ps-name-" + data["alphabet_anchor"] + '-' + i}
                key={"ps-name-key-" + data["alphabet_anchor"] + '-' + i}
                className="schoolList alphabet_anchor"
              >
                <a
                  id={"ps-name-link-" + data["alphabet_anchor"] + '-' + i}
                  key={"ps-name-link-key" + data["alphabet_anchor"] + '-' + i}
                  className="alphabet_anchor"
                  name={data["alphabet_anchor"]}
                >
                  <Heading level="h3" size="heading5">
                    {data["alphabet_anchor"]}
                  </Heading>
                </a>
              </li>
              {filteredSchools.map((school, index) => (
                <li
                  fontWeight="heading.callout"
                  id={"ps-name-" + data["alphabet_anchor"] + "-" + index}
                  key={"ps-name-" + data["alphabet_anchor"] + "-key-" + index}
                >
                  {school}
                  <br />
                </li>
              ))}
            </List>
            <Button
              id={"ps-scroll-to-top-" + i}
              key={"ps-scroll-to-top-key-" + i}
              buttonType="text"
              className="backToTop backToTopButton"
              marginLeft="s"
              onClick={() =>
                window.scrollTo({
                  top: 10,
                  behavior: "smooth",
                })
              }
            >
              <Icon
                name="arrow"
                iconRotation="rotate180"
                size="small"
                className="backToTopIcon"
                align="right"
                marginRight="xs"
              />
              Back to Top
            </Button>
          </div>
        );
      }
    });

    if (schoolsCount === 0) {
      return (
        <Text
          marginTop="m"
          isItalic
          size="default"
          color="var(--nypl-colors-ui-error-primary)"
          key="no-results-found-key"
        >
          There are no results that match your search criteria.
        </Text>
      );
    } else {
      return schoolsData;
    }
  };

  const handleChange = (event) => {
    setSearchSchool(event.target.value);
  };

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentTop={<SignedInMsg signInDetails={props} />}
      contentPrimary={
        <>
          <Heading
            id="find-your-school"
            level="h2"
            size="heading3"
            text="Find Your School"
          />
          <HorizontalRule
            id="ts-detail-page-horizontal-rulel"
            className={`${colorMode} tsDetailHorizontalLine`}
          />
          <Heading
            marginTop="l"
            id="your-school-participate-in-mln"
            level="h3"
            size="heading5"
            text="Does your school participate in MyLibraryNYC?"
          />
          <TextInput
            fontWeight="text.tag"
            helperText="Start typing the name of your school."
            attributes={{
              "aria-describedby": "Choose wisely.",
              "aria-label": "Enter school name",
              pattern: "[a-z0-9]",
              tabIndex: 0,
            }}
            onChange={handleChange}
            id="participating-school"
            labelText="Search by Name"
            placeholder="School name"
            showLabel
          />
          <Text marginTop="l" size="default" fontWeight="medium">
            Filter by Name
          </Text>
          {AnchorTags()}
          <div id="participating-schools-list">
            {schoolSkeletonLoader()}
            {Schools()}
          </div>
        </>
      }
      contentSidebar={
        <div>
          <HaveQuestions />
        </div>
      }
      sidebar="right"
    />
  );
}
