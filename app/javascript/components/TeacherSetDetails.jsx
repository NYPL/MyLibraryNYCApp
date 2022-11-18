import React, { useState, useEffect } from "react";
import HaveQuestions from "./HaveQuestions";
import {
  Link as ReactRouterLink,
  useParams,
  useNavigate,
} from "react-router-dom";
import { titleCase } from "title-case";
import AnchorLink from "react-anchor-link-smooth-scroll";

import axios from "axios";
import {
  Button,
  Select,
  Heading,
  Image,
  Flex,
  Spacer,
  List,
  Link,
  TemplateAppContainer,
  Text,
  Form,
  FormField,
  SimpleGrid,
  ButtonGroup,
  Box,
  HorizontalRule,
  StatusBadge,
  VStack,
  Icon,
  Breadcrumbs,
  Hero,
  Notification,
  useNYPLBreakpoints,
  Accordion,
} from "@nypl/design-system-react-components";

import mlnImage from "../images/mln.svg";

export default function TeacherSetDetails(props) {
  const params = useParams();
  const navigate = useNavigate();
  const [allowedQuantities, setAllowedQuantities] = useState([]);
  const [teacherSet, setTeacherSet] = useState("");
  const [books, setBooks] = useState([]);
  const [quantity, setQuantity] = useState("1");
  const [teacherSetNotes, setTeacherSetNotes] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");
  const [bookImageHeight, setBookImageHeight] = useState("");
  const [bookImageWidth, setbookImageWidth] = useState("");
  const { isLargerThanMobile } = useNYPLBreakpoints();

  useEffect(() => {
    window.scrollTo(0, 0);
    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    axios
      .get("/teacher_sets/" + params["id"])
      .then((res) => {
        setAllowedQuantities(res.data.allowed_quantities);
        setTeacherSet(res.data.teacher_set);
        setBooks(res.data.books);
        setTeacherSetNotes(res.data.teacher_set_notes);
      })
      .catch(function (error) {
        console.log(error);
        console.error(error);
      });
  }, []);

  const handleQuantity = (event) => {
    setQuantity(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    axios
      .post("/holds", {
        teacher_set_id: params["id"],
        query_params: { quantity: quantity },
      })
      .then((res) => {
        if (res.request.responseURL.includes("/signin")) {
          window.location = res.request.responseURL;
          return false;
        } else {
          if (res.data.status === "created") {
            props.handleTeacherSetOrderedData(res.data.hold, teacherSet);
            navigate("/ordered_holds/" + res.data.hold["access_key"]);
          } else {
            setErrorMessage(res.data.message);
          }
        }
      })
      .catch(function (error) {
        console.log(error);
      });
  };

  const teacherSetTitle = () => {
    return <>{teacherSet["title"]}</>;
  };

  const TeacherSetDescription = () => {
    return (
      <Text noSpace marginTop="xs" id="ts-page-desc">
        {teacherSet["description"]}
      </Text>
    );
  };

  const AvailableCopies = () => {
    return (
      <div color="var(--nypl-colors-ui-black)">
        {teacherSet["available_copies"]} of {teacherSet["total_copies"]}{" "}
        Available
      </div>
    );
  };

  const BooksCount = () => {
    return (
      <div>
        {books.length > 1
          ? books.length + " Titles"
          : books.length >= 1
          ? books.length + " Title"
          : ""}
      </div>
    );
  };

  const TeacherSetBooks = () => {
    return books.map((data, i) => {
      return (
        <>
          <ReactRouterLink
            onClick={() => window.scrollTo(0, 0)}
            id={"ts-books-" + i}
            to={"/book_details/" + data.id}
          >
            {BookImage(data)}
          </ReactRouterLink>
        </>
      );
    });
  };

  const bookImageDimensions = ({ target: img }) => {
    if (img.offsetHeight === 1 || img.offsetWidth === 1) {
      setBookImageHeight(img.offsetHeight);
      setbookImageWidth(img.offsetWidth);
    } else {
      setBookImageHeight(189);
      setbookImageWidth(189);
    }
  };

  const BookImage = (data) => {
    if (data.cover_uri) {
      if (bookImageHeight === 1 && bookImageWidth === 1) {
        return (
          <Image
            title={data.title}
            src={mlnImage}
            aspectRatio="square"
            size="default"
            alt={data.title}
            className="bookImageTop"
          />
        );
      } else if (bookImageHeight === 189 && bookImageWidth === 189) {
        return (
          <Image
            title={data.title}
            id={"ts-books-" + data.id}
            src={data.cover_uri}
            className="bookImageTop"
            aspectRatio="square"
            size="default"
            alt={data.title}
          />
        );
      } else {
        return <img onLoad={bookImageDimensions} src={data.cover_uri} />;
      }
    } else {
      return (
        <Image
          title={data.title}
          id={"ts-books-" + data.id}
          src={mlnImage}
          className="bookImageTop"
          aspectRatio="square"
          size="default"
          alt={data.title}
        />
      );
    }
  };

  const TeacherSetNotesContent = () => {
    return teacherSetNotes.map((note, i) => {
      return (
        <div key={i} id={"ts-notes-content-" + i}>
          {note.content}
        </div>
      );
    });
  };

  const teacherSetUnAvailableMsg = () => {
    return (
      <Text width="m" size="caption">
        <b>This Teacher Set is unavailable.</b>{" "}
        <i>
          As it is currently being used by other educators, please allow 60 days
          or more for availability. If you would like to be placed on the wait
          list for this Teacher Set, contact us at
        </i>{" "}
        <Link
          type="action"
          target="_blank"
          className="hrefBlackColor"
          href="mailto:help@mylibrarynyc.org"
        >
          help@mylibrarynyc.org.
        </Link>
      </Text>
    );
  };

  const UnableToOrderAdditionalTeacherSetsMsg = () => {
    return (
      <Text width="m" size="caption">
        <b>Unable to order additional Teacher Sets.</b>{" "}
        <i>
          You have{" "}
          <Link
            className="hrefBlackColor"
            href="/account_details"
            id="ts-page-account-details-link"
            type="action"
            target="_blank"
          >
            requested
          </Link>{" "}
          the maximum allowed quantity of this Teacher Set. If you need more
          copies of this Teacher Set, contact us at
        </i>
        <Link
          type="action"
          target="_blank"
          href="mailto:help@mylibrarynyc.org"
          className="hrefBlackColor"
        >
          help@mylibrarynyc.org.
        </Link>
      </Text>
    );
  };

  const OrderTeacherSets = () => {
    if (teacherSet && teacherSet.available_copies <= 0) {
      return teacherSetUnAvailableMsg();
    } else if (allowedQuantities.length <= 0) {
      return UnableToOrderAdditionalTeacherSetsMsg();
    } else {
      return (
        <div>
          <Form gap="grid.xs" id="ts-order-form">
            <FormField id="ts-order-field">
              <Select
                id="ts-order-allowed-quantities"
                labelText=""
                onChange={handleQuantity}
                value={quantity}
              >
                {allowedQuantities.map((item, i) => {
                  return (
                    <option id={"ts-quantity-" + i} key={i} value={item}>
                      {item}
                    </option>
                  );
                }, this)}
              </Select>
              <Button
                id="ts-order-submit"
                buttonType="noBrand"
                onClick={handleSubmit}
              >
                {" "}
                Place Order{" "}
              </Button>
            </FormField>
          </Form>
          <Text isItalic size="caption" marginTop="s">
            Note: Available Teacher Sets will deliver to your school within 2
            weeks. For Teacher Sets that are currently in use by other
            educators, please allow 60 days or more for delivery. If you need
            materials right away, contact us at{" "}
            <a
              className="hrefBlackColor"
              target="_blank"
              href="mailto:help@mylibrarynyc.org"
              rel="noreferrer"
            >
              help@mylibrarynyc.org.
            </a>
          </Text>
        </div>
      );
    }
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

  const errorMsg = () => {
    if (errorMessage) {
      return (
        <Notification
          ariaLabel="Hold creation error"
          id="hold-error-message"
          notificationType="warning"
          notificationContent={errorMessage}
        />
      );
    } else {
      return <></>;
    }
  };

  const teacherSetAvailability = () => {
    if (isLargerThanMobile && teacherSet.availability !== undefined) {
      return (
        <StatusBadge level={availabilityStatusBadge()}>
          {titleCase(teacherSet.availability)}
        </StatusBadge>
      );
    } else {
      return null;
    }
  };

  const mobileteacherSetAvailability = () => {
    if (!isLargerThanMobile && teacherSet.availability !== undefined) {
      return (
        <StatusBadge level={availabilityStatusBadge()}>
          {titleCase(teacherSet.availability)}
        </StatusBadge>
      );
    } else {
      return null;
    }
  };

  const availabilityStatusBadge = () => {
    return teacherSet.availability === "available" ? "medium" : "low";
  };

  const legacyDetailUrl = () => {
    return "http://legacycatalog.nypl.org/record=" + teacherSet.bnumber + "~S1";
  };

  const tsTitle = () => {
    return teacherSet.title ? teacherSet.title : "";
  };

  const orderTeacherSetsInfo = () => {
    if (
      isLargerThanMobile ||
      (!isLargerThanMobile &&
        teacherSet &&
        teacherSet.available_copies > 0 &&
        allowedQuantities.length > 0)
    ) {
      return (
        <VStack align="left">
          <Box
            id="teacher-set-details-order-page"
            bg="var(--nypl-colors-ui-gray-x-light-cool)"
            color="var(--nypl-colors-ui-black)"
            padding="m"
            borderWidth="1px"
            borderRadius="sm"
            overflow="hidden"
            marginBottom="l"
          >
            <Heading
              id="ts-order-set"
              textAlign="center"
              noSpace
              level="two"
              size="secondary"
              text="Order Set!"
            />
            <Heading
              id="ts-available-copies"
              textAlign="center"
              size="callout"
              level="four"
              text={AvailableCopies()}
            />
            {OrderTeacherSets()}
          </Box>
          <HaveQuestions />
        </VStack>
      );
    }
  };

  const mobileTeacherSetOrderButton = () => {
    if (!isLargerThanMobile) {
      if (teacherSet && teacherSet.available_copies <= 0) {
        return (
          <Box
            marginTop="l"
            marginBottom="l"
            id="mobile-teacher-set-details-order-page"
            bg="var(--nypl-colors-ui-gray-x-light-cool)"
            color="var(--nypl-colors-ui-black)"
            padding="m"
            borderWidth="1px"
            borderRadius="sm"
            overflow="hidden"
          >
            <Heading
              id="mobile-ts-order-set"
              textAlign="center"
              noSpace
              level="two"
              size="secondary"
              text="Set Unavailable"
            />
            {teacherSetUnAvailableMsg()}
          </Box>
        );
      } else if (allowedQuantities.length <= 0) {
        return (
          <Box
            marginTop="l"
            marginBottom="l"
            id="mobile-teacher-set-details-order-page"
            bg="var(--nypl-colors-ui-gray-x-light-cool)"
            color="var(--nypl-colors-ui-black)"
            padding="m"
            borderWidth="1px"
            borderRadius="sm"
            overflow="hidden"
          >
            <Heading
              id="mobile-ts-order-set"
              textAlign="center"
              noSpace
              level="two"
              size="secondary"
              text="Set Unavailable"
            />
            {UnableToOrderAdditionalTeacherSetsMsg()}
          </Box>
        );
      } else {
        return (
          <AnchorLink href="#teacher-set-details-order-page">
            <ButtonGroup marginTop="l" marginBottom="l">
              <Button
                buttonType="noBrand"
                size="small"
                id="mobile-teacher-set-order-button"
              >
                Order This Set
              </Button>
            </ButtonGroup>
          </AnchorLink>
        );
      }
    }
  };

  const displayTeacherSetBooks = () => {
    if (isLargerThanMobile) {
      return (
        <>
          <Heading
            id="ts-page-books-count"
            marginTop="s"
            size="callout"
            level="four"
            text={BooksCount()}
          />
          <SimpleGrid
            id="ts-page-books-panel"
            marginTop="xs"
            columns={5}
            gap="xxs"
          >
            {" "}
            {TeacherSetBooks()}{" "}
          </SimpleGrid>
        </>
      );
    } else if (books.length > 0) {
      return (
        <Accordion
          accordionData={[
            {
              accordionType: "default",
              label: (
                <div id="mobile-ts-page-books-count"> {BooksCount()} </div>
              ),
              panel: TeacherSetBooks(),
            },
          ]}
          id="mobile-ts-page-books-panel"
          panelMaxHeight="500px"
          isDefaultOpen
        />
      );
    }
  };

  return (
    <TemplateAppContainer
      breakout={
        <>
          <Breadcrumbs
            id={"mln-breadcrumbs-ts-details"}
            breadcrumbsData={[
              { url: "//" + process.env.MLN_INFO_SITE_HOSTNAME, text: "Home" },
              {
                url: "//" + window.location.hostname + "/teacher_set_data",
                text: "Teacher Sets",
              },
              {
                url: "//" + window.location.hostname + window.location.pathname,
                text: breadcrumbTitle(tsTitle()),
              },
            ]}
            breadcrumbsType="booksAndMore"
          />
          <Hero
            heroType="tertiary"
            backgroundColor="var(--nypl-colors-brand-primary)"
            heading={
              <Heading
                level="one"
                id={
                  "hero-" + window.location.pathname.split(/\/|\?|&|=|\./g)[1]
                }
                text="Teacher Sets"
              />
            }
          />
        </>
      }
      contentTop={errorMsg()}
      contentPrimary={
        <>
          <Flex alignItems="baseline">
            <Heading
              id="ts-title-id"
              noSpace
              level="two"
              size="secondary"
              text={teacherSetTitle()}
            />
            <Spacer />
            {teacherSetAvailability()}
          </Flex>
          <HorizontalRule
            marginTop="s"
            id="ts-detail-page-horizontal-rule-id"
            className="teacherSetHorizontal"
          />

          <Flex alignItems="baseline">
            <Spacer />
            {mobileteacherSetAvailability()}
          </Flex>

          {mobileTeacherSetOrderButton()}

          <Heading
            marginTop="l"
            noSpace
            id="ts-header-desc-text"
            level="three"
            size="tertiary"
            text="What is in the box"
          />
          {TeacherSetDescription()}
          {displayTeacherSetBooks()}

          <List id="ts-list-details" type="dl" title="Details" marginTop="l">
            <dt id="ts-suggested-grade-range-text">Suggested Grade Range</dt>
            <dd id="ts-page-suitabilities">
              {teacherSet.suitabilities_string}
            </dd>

            <dt id="ts-page-primary-language-text">Primary Language</dt>
            <dd id="ts-page-primary-language">{teacherSet.primary_language}</dd>

            <dt id="ts-page-set-type-text">Type</dt>
            <dd id="ts-page-set-type">{teacherSet.set_type}</dd>

            <dt id="ts-page-physical-desc-text">Physical Description</dt>
            <dd id="ts-page-physical-desc">
              {teacherSet.physical_description}
            </dd>

            <dt id="ts-page-notes-content-text">Notes</dt>
            <dd id="ts-page-notes-content">{TeacherSetNotesContent()}</dd>

            <dt id="ts-page-call-number-text">Call Number</dt>
            <dd id="ts-page-call-number">{teacherSet.call_number}</dd>
          </List>
          <Link
            href={legacyDetailUrl()}
            id="ts-page-details_url"
            type="action"
            target="_blank"
            marginTop="l"
          >
            View in catalog
            <Icon
              name="actionLaunch"
              iconRotation="rotate0"
              size="medium"
              align="left"
            />
          </Link>
        </>
      }
      contentSidebar={orderTeacherSetsInfo()}
      sidebar="right"
    />
  );
}
