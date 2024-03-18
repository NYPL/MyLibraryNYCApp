import React, { useState, useEffect } from "react";
import HaveQuestions from "./../HaveQuestions/HaveQuestions";
import { Link as ReactRouterLink, useParams } from "react-router-dom";
import axios from "axios";
import { titleCase } from "title-case";
import {
  Card,
  CardHeading,
  CardContent,
  Heading,
  Image,
  List,
  TemplateAppContainer,
  HorizontalRule,
  StatusBadge,
  Flex,
  Link,
  Icon,
  Breadcrumbs,
  Box,
  SkeletonLoader,
  useColorMode,
  Hero,
  useColorModeValue,
} from "@nypl/design-system-react-components";

import ShowBookImage from "./../ShowBookImage";
import mlnImage from "./../../images/mln.svg";

export default function TeacherSetBooks() {
  const params = useParams();
  const [book, setBook] = useState("");
  const [teacherSets, setTeacherSets] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const { colorMode } = useColorMode();
  const heroBgColor = useColorModeValue(
    "var(--nypl-colors-brand-primary)",
    "var(--nypl-colors-dark-ui-bg-hover)"
  );

  useEffect(() => {
    setIsLoading(true);
  }, [book.cover_uri]);

  useEffect(() => {
    let timeoutId = "";
    if (isLoading) {
      timeoutId = setInterval(() => {
        setIsLoading(false);
      }, 500);
    }
    return () => {
      clearInterval(timeoutId);
    };
  }, [isLoading]);

  useEffect(() => {
    if (env.RAILS_ENV !== "test") {
      window.scrollTo(0, 0);
    }
    axios
      .get("/books/" + params["id"])
      .then((res) => {
        setTeacherSets(res.data.teacher_sets);
        setBook(res.data.book);
        if (res.data.book.title !== null) {
          document.title = "Book Details | " + res.data.book.title + " | MyLibraryNYC";
        } else {
          document.title = "Book Details | MyLibraryNYC";
        }
      })
      .catch(function (error) {
        console.log(error);
      });
  }, []);

  const IsBookSubTitlePresent = () => {
    return book["sub_title"] === null ? false : true;
  };

  const IsBookDescriptionPresent = () => {
    return book["description"] === null ? false : true;
  };

  const IsBookStatementOfResponsibilityPresent = () => {
    return book["statement_of_responsibility"] == null ? false : true;
  };

  const truncateTitle = (str, n, useWordBoundary) => {
    if (str.length <= n) {
      return str;
    }
    const subString = str.substr(0, n - 1); // the original check
    return (
      (useWordBoundary
        ? subString.substr(0, subString.lastIndexOf(" "))
        : subString) + "..."
    );
  };

  const breadcrumbTitle = (title) => {
    if (title.length >= 60) {
      return truncateTitle(title, 60, true);
    } else {
      return truncateTitle(title, 60, false);
    }
  };

  const tsHorizontalRule = (index, arr) => {
    if (index === arr.length - 1) {
      <></>;
    } else {
      return (
        <HorizontalRule id={"ts-book-horizontal-rule-" + index} marginTop="l" />
      );
    }
  };

  const TeacherSetDetails = () => {
    if (teacherSets) {
      return teacherSets.map((ts, index, arr) => {
        let availabilityStatusBadge =
          ts.availability === "available" ? "medium" : "low";
        let availability = ts.availability !== undefined ? ts.availability : "";
        return (
          <div key={"ts-books-div-" + index}>
            <Card id="book-page-ts-card-details" layout="row">
              <CardHeading
                level="four"
                id="book-page-ts-title"
                marginBottom="xs"
              >
                <ReactRouterLink to={"/teacher_set_details/" + ts.id}>
                  {ts.title}
                </ReactRouterLink>
              </CardHeading>
              <CardContent id="book-page-ts-suitabilities" marginBottom="xs">
                {" "}
                {ts.suitabilities_string}{" "}
              </CardContent>
              <CardContent id="book-page-ts-availability" marginBottom="s">
                <StatusBadge level={availabilityStatusBadge}>
                  {titleCase(availability)}
                </StatusBadge>
              </CardContent>
              <CardContent id="book-page-ts-description">
                {" "}
                {ts.description}{" "}
              </CardContent>
            </Card>
            {tsHorizontalRule(index, arr)}
          </div>
        );
      });
    }
  };

  const fallBackImageData = (book, fallbackImg) => {
    return (
      <ShowBookImage
        book={book}
        src={book.cover_uri}
        fallbackImage={fallbackImg}
      />
    );
  };

  const fallbackImg = (book) => {
    return (
      <Box
        bg="var(--nypl-colors-ui-gray-x-light-cool)"
        width="189px"
        height="189px"
      >
        {book.title}
      </Box>
    );
  };

  const BookImage = (data) => {
    if (isLoading) {
      return (
        <SkeletonLoader
          className="teacher-set-details-skeleton-loader"
          contentSize={0}
          headingSize={0}
          imageAspectRatio="square"
          layout="column"
          showImage
          width="189px"
        />
      );
    } else {
      if (data.cover_uri) {
        return fallBackImageData(data, fallbackImg(data));
      } else {
        return (
          <Image
            title={data.title}
            id={"ts-books-" + data.id}
            src={mlnImage}
            aspectRatio="original"
            size="medium"
            alt={data.title}
          />
        );
      }
    }
  };

  let bookTitle = book.title ? book.title : "Book Title";
  let legacyDetailUrl =
    "http://legacycatalog.nypl.org/record=" + book.bnumber + "~S1";

  return (
    <TemplateAppContainer
      breakout={
      <>
        <Breadcrumbs
          id={"mln-breadcrumbs-ts-details"}
          breadcrumbsData={[
            { url: "//" + env.MLN_INFO_SITE_HOSTNAME, text: "Home" },
            {
              url: "//" + window.location.hostname + window.location.pathname,
              text: "Book Details",
            },
            {
              url: "//" + window.location.hostname + window.location.pathname,
              text: breadcrumbTitle(bookTitle),
            },
          ]}
          breadcrumbsType="booksAndMore"
        />
        <Hero
            heroType="tertiary"
            backgroundColor={heroBgColor}
            heading={
              <Heading
                level="h1"
                color="ui.white"
                id={
                  "hero-" + window.location.pathname.split(/\/|\?|&|=|\./g)[1]
                }
                text="Book Details"
              />
            }
          />
        </>
      }
      contentPrimary={
        <>
          <Flex alignItems="baseline">
            <Heading
              id="book-title-heading-id"
              noSpace
              level="h2"
              size="heading3"
              text={bookTitle}
            />
          </Flex>

          <HorizontalRule
            id="ts-book-details-horizontal-rule"
            marginTop="s"
            className={`${colorMode} teacherSetHorizontal`}
          />

          <Card
            id="book-page-card-details"
            layout="row"
            imageProps={{ component: BookImage(book) }}
          >
            {IsBookSubTitlePresent() ? (
              <CardHeading
                id="book-page-sub_title"
                marginBottom="s"
                level="three"
              >
                {book.sub_title}
              </CardHeading>
            ) : (
              <></>
            )}

            {IsBookStatementOfResponsibilityPresent() ? (
              <CardContent
                id="book-page-statement_of_responsibility"
                level="three"
              >
                {book.statement_of_responsibility}
              </CardContent>
            ) : (
              <></>
            )}

            {IsBookDescriptionPresent() ? (
              <CardContent id="book-page-desc">{book.description}</CardContent>
            ) : (
              <></>
            )}
          </Card>

          <List
            id="book-page-list-details"
            key="book-page-list-details-key"
            type="dl"
            title={<Heading level="h3" size="heading5">Order Details</Heading>}
            marginTop="l"
          >
            {book.publication_date ? (
              <>
                <dt id="book-page-publication-date-text">Publication Date</dt>
                <dd id="book-page-publication-date">
                  {book.publication_date}
                </dd>{" "}
              </>
            ) : (
              <></>
            )}

            {book.call_number ? (
              <>
                <dt id="book-page-call-number-text">Call Number</dt>
                <dd id="book-page-call-number">{book.call_number}</dd>{" "}
              </>
            ) : (
              <></>
            )}

            {book.physical_description ? (
              <>
                <dt id="book-page-physical-desc-text">Physical Description</dt>
                <dd id="book-page-physical-desc">
                  {book.physical_description}
                </dd>
              </>
            ) : (
              <></>
            )}

            {book.primary_language ? (
              <>
                <dt id="book-page-primary-language-text">Primary Language</dt>
                <dd id="book-page-primary-language">{book.primary_language}</dd>
              </>
            ) : (
              <></>
            )}

            {book.isbn ? (
              <>
                <dt id="book-page-isbn-text">ISBN</dt>
                <dd id="book-page-isbn">{book.isbn}</dd>
              </>
            ) : (
              <></>
            )}

            {book.notes ? (
              <>
                <dt id="book-page-notes-text">Notes</dt>
                <dd id="book-page-notes">{book.notes}]</dd>
              </>
            ) : (
              <></>
            )}
          </List>

          <Link
            className="tsDetailUrl"
            href={legacyDetailUrl}
            id="ts-book-page-details_url"
            type="action"
            target="_blank"
          >
            View in catalog
            <Icon
              name="actionLaunch"
              iconRotation="rotate0"
              size="medium"
              align="left"
            />
          </Link>
          <Heading
            marginTop="l"
            marginBottom="l"
            id="appears-in-ts-text"
            size="heading5"
            level="h3"
          >
            Appears in These Sets
          </Heading>
          {TeacherSetDetails()}
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
